import 'package:calendar_app/table_calendar_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'event.dart';
import 'dart:async';
import 'package:textfield_tags/textfield_tags.dart';
import 'search_events.dart';
class TableCalendarSample extends HookConsumerWidget {
  const TableCalendarSample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedDayState = useState(DateTime.now());
    final selectedDayState = useState(DateTime.now());
    final selectedEventsState = useState([]);
    final tagSelectListState = useState<List<String>>([]);
    final eventProvider = ref.watch(tableCalendarEventControllerProvider);
    final selectedTags = useState<List<String>>([]);
    final isSelected = useState<bool>(false);
    
    
    // useEffect(() {
    //   final timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //     final allEvents = ref.read(tableCalendarEventControllerProvider);
    //     selectedEventsState.value = allEvents.where((event) {
    //       return isSameDay(event.dateTime, selectedDayState.value);
    //     }).toList();
    //   });
    //   return timer.cancel;
    // }, []);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            const Text('カレンダー'),
            TextButton(
              onPressed: (){
                print("牡丹が押された");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context) => SearchEventsPage())
                  );
              },
              child: const SelectableText("イベントを検索",selectionColor: Color(0xFF000000)),
            )
          ]
        )
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            focusedDay: DateTime.now(),
            locale: 'ja_JP',
            selectedDayPredicate: (day) {
              return isSameDay(selectedDayState.value, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              List<Event> selectedEventList = [];
              for (var event in eventProvider) {
                if (isSameDay(event.dateTime, selectedDay)) {
                  selectedEventList.add(event);
                }
              }
              selectedDayState.value = selectedDay;
              focusedDayState.value = focusedDay;
              selectedEventsState.value = selectedEventList;
            },
            onDayLongPressed: (selectedDay, focusedDay) async {
              await showAddEventDialog(context, selectedDay, ref,selectedTags,isSelected);
            },
            eventLoader: (date) {
              return eventProvider.where((event) {
                return isSameDay(event.dateTime, date);
              }).toList();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedEventsState.value.length,
              itemBuilder: (context, index) {
                final event = selectedEventsState.value[index];
                return Card(
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: event.description == null
                        ? null
                        : Text(event.description!),
                    trailing: IconButton(
                      onPressed: () {
                        ref
                            .read(tableCalendarEventControllerProvider.notifier)
                            .deleteEvent(event: event);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String listToString(List<String> list) {
    return list.map<String>((String value) => value.toString()).join(',');
  }
  
  Future<void> showAddEventDialog(
      BuildContext context, DateTime selectedDay, WidgetRef ref, ValueNotifier<List<String>> selectedTags, ValueNotifier<bool> isSelected) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final _stringTagController = StringTagController();
    List<String> tag_strings = ["seasonalevents","sports","cleanup","childrenevents","community","disaster"];
    List<String> view_select_tags_list = [];
    String select_tags = "";
    // var selectedTags = <String>[];
    
    await showDialog(
      
      context: context,
      builder: (context) {
        List<String> tags_selected = [];
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'イベントの追加',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'タイトル'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 3,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                      border: OutlineInputBorder(),
                      hintText: '詳細',
                    ),
                  ),
                ),
                Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: tag_strings.map((tag){
                    // final selectedTags = useState<List<String>>([])
                                      

                    return InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      onTap: (){
                        // var isSelected = selectedTags.contains(tag);
                        //tap処理
                        if (isSelected.value){
                          // selectedTags.remove(tag);
                          selectedTags.value.remove(tag);
                          tags_selected.remove(tag);
                        }else{
                          selectedTags.value.add(tag);
                          tags_selected.add(tag);
                        }
                        // view_select_tags = selectedTags.value.map<String>((String value) => value).join(', ');
                        // setState(() {});
                        useState((){});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(32)),
                          border: Border.all(
                            width: 2,
                            color: Colors.pink,
                          ),
                          color: isSelected.value ? Colors.pink :null,
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: isSelected.value ? Colors.white : Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );

                    return Text(tag);
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(selectedTags.value.map<String>((String value) => value).join(', ') ?? "No selected..."),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue){
                      if (textEditingValue.text.isEmpty){
                        return const Iterable<String>.empty();
                      }
                      final selectedTags = _stringTagController.getTags ?? [];
                      return tag_strings.where((String option){
                        return !selectedTags.contains(option) &&
                               option
                               .toLowerCase()
                               .startsWith(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selectedTag){
                      // _stringTagController.addTag(selectedTag);
                      tags_selected.add(selectedTag);
                    },
                    fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted){
                      return TextField(
                        controller: ttec,
                        focusNode: tfn,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'タグを入力（候補を選択可能)',
                        ),
                      );
                    },
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('キャンセル'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(tableCalendarEventControllerProvider
                                  .notifier)
                              .addEvent(
                                dateTime: selectedDay,
                                title: titleController.text,
                                description: descriptionController.text,
                                eventCategory: tags_selected,
                              );
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '追加',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
