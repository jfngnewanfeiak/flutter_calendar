import 'package:calendar_app/table_calendar_event_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'event.dart';

class EventDetailViewer extends HookConsumerWidget{
  final List<Event> event_info;
  const EventDetailViewer({super.key, required this.event_info});
  
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init_events = ref.read(tableCalendarEventControllerProvider);
    // TODO: implement build
    final Event value;
    
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
          child: Row(
            children: [
              Text("イベント"),
              Text("詳細"),
              Text("時間"),
              Text("イベントカテゴリ")
            ],
          ),
        ),
      )
      
    );
  }
}