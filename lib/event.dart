enum EventCategory{
  seasonalevents,
  sports,
  cleanup,
  childrenevents,
  community,
  disaster
}

class Event {
  final String title;
  final String? description;
  final DateTime dateTime;
  final List<String> eventCategory;

  Event(
    {required this.title,this.description,required this.dateTime, required this.eventCategory}
  );
}