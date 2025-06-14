import 'package:calendar_app/event_detail_viewer.dart';
import 'package:calendar_app/table_calendar_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'event.dart';
class SearchEventsPage extends HookConsumerWidget {
  const SearchEventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventProvider = ref.watch(tableCalendarEventControllerProvider);
    final init_events = ref.read(tableCalendarEventControllerProvider);
    // タグとイベントデータ
    final tags = ["seasonalevents", "sports", "cleanup", "childrenevents", "community", "disaster","clear select all"];
    final events = [
      {"title": "Community Cleanup", "tags": ["cleanup", "community"]},
      {"title": "Local Sports Day", "tags": ["sports", "childrenevents"]},
      {"title": "Disaster Relief Training", "tags": ["disaster"]},
      {"title": "Spring Festival", "tags": ["seasonalevents", "community"]},
    ];

    // 状態管理
    final selectedTag = useState<String?>(null);
    // final filteredEvents = useState<List<Map<String, dynamic>>>(events);
    // final filteredEvents = useState(List<Event>);
    final filteredEvents = useState<List<Event?>?>(init_events);

    // イベントフィルタリング
    void filterEvents(String tag) {
      final events_info = ref.read(tableCalendarEventControllerProvider);
      selectedTag.value = tag;
      if (tag == "clear select all"){
        // filteredEvents.value = events_info.EventCategory;
        filteredEvents.value = events_info;

      }else{
          filteredEvents.value = events_info.where((event_info){
        return event_info.eventCategory.contains(tag);
      }).toList();
      }
      
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("イベント検索"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // タグ選択ボタン
            Wrap(
              spacing: 8.0,
              children: tags.map((tag) {
                return ElevatedButton(
                  onPressed: () {
                    filterEvents(tag);
                  },
                  child: Text(tag),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // 選択中のタグ表示
            if (selectedTag.value != null)
              Text(
                "選択中のタグ: ${selectedTag.value}",
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 10),
            // イベントリスト表示
            Expanded(
              child: filteredEvents.value!.isEmpty
                  ? const Center(
                      child: Text("選択されたタグに一致するイベントはありません。"),
                    )
                  : ListView.builder(
                      itemCount: filteredEvents.value!.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents?.value?[index];
                        return Container(
                          margin: EdgeInsets.fromLTRB(0,0,0,10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                          ),
                          child: ListTile(
                            title: Text(event?.title ?? "no data title..."),
                            subtitle: Text("詳細:${event?.description ?? 'no data desctiprion...'}"),
                            
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:[
                            ElevatedButton(
                              child: Text("詳細"),
                              onPressed: () {
                                print("詳細が押された");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EventDetailViewer(event_info: init_events[index]))
                                );
                              },
                            ),
                            ElevatedButton(
                              child: Text("マップ詳細"),
                              onPressed: () {
                                print("マップ詳細が押された");
                                print(index.toString());
                              },
                            )
                          ]),
                          )
                        );
                        // return Card(
                        //   child: ListTile(
                        //     title: Text(event?.title ?? "no data title..."),
                        //     subtitle: Text("詳細:${event?.description ?? 'no data desctiprion...'}"),
                        //   ),
                        //                             // child: ListTile(
                        //   //   title: Text(event?.title ?? "no data title..."),
                        //   //   subtitle: Text("詳細:${event?.description ?? 'no data desctiprion...'}"),
                          
                        //   // ),
                        // );
                        
                      },
                      
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
