import 'package:calendar_app/table_calendar_event_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'event.dart';

class EventDetailViewer extends HookConsumerWidget{
  final Event event_info;
  const EventDetailViewer({super.key, required this.event_info});
  
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init_events = ref.read(tableCalendarEventControllerProvider);
    // TODO: implement build
    final selectedEventInfo = event_info;
    print("Selected Event Info: $selectedEventInfo"); 
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("イベント詳細ページ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1),
          ),
          child: Center(
            child: Column(
              spacing: 16,
              children: [
              Text(
                "イベント: ${selectedEventInfo?.title  ??  'no data...'}",
                style:TextStyle(
                  fontSize: 64
                )),
              Text(
                "詳細",
                style: TextStyle(
                  fontSize: 32
                ),),
              Text(
                selectedEventInfo?.description ?? 'no data...',
                style: TextStyle(
                  fontSize: 32
                ),),
              Text("時間",
              style: TextStyle(
                fontSize: 16
              ),),
              Text(selectedEventInfo?.dateTime.toString() ?? 'no data...',
              style: TextStyle(
                fontSize: 16
              ),),
              Text("イベントカテゴリ",
              style: TextStyle(
                fontSize: 16
              ),),
              //ここは後でCSV形式みたいな感じにする
              Text(selectedEventInfo?.eventCategory[0] ?? 'no data...',
              style: TextStyle(
                fontSize: 16
              ),),
            ],
            ) 
          ),
        ),
      )
      
    );
  }
}