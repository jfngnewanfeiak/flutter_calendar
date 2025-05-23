import 'event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'table_calendar_event_provider.g.dart';

@riverpod
class TableCalendarEventController extends _$TableCalendarEventController {
  final List<Event> sampleEvents = [
    Event(
        title: 'firstEvent', dateTime: DateTime.utc(2025, 5, 15),eventCategory: ["cleanup"]),
    Event(
      title: 'secondEvent',
      description: 'description',
      dateTime: DateTime.utc(2025, 5, 15),
      eventCategory: ["disaster"],
    ),
  ];

  @override
  List<Event> build() {
    state = sampleEvents;
    return state;
  }

  void addEvent(
      {required DateTime dateTime,
      required String title,
      String? description,
      required List<String> eventCategory}) {
    var newData = Event(title: title, description: description, dateTime: dateTime,eventCategory: eventCategory);
    state.add(newData);
  }

  void deleteEvent({required Event event}) {
    state.remove(event);
  }
}