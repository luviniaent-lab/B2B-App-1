import 'common.dart';


class EventItem {
  final String id;
  final String title;
  final String date; // ISO
  final String? startTime;
  final String? price;
  final int? bookingLimit;
  final String? description;
  final String? image;
  final String? video;
  final bool published;
  final String status; // active|past|deactivated
  final int? bookingsCount;
  final List<String> propertyIds; // linked properties (required ≥1)
  const EventItem({
    required this.id,
    required this.title,
    required this.date,
    this.startTime,
    this.price,
    this.bookingLimit,
    this.description,
    this.image,
    this.video,
    required this.published,
    required this.status,
    this.bookingsCount,
    required this.propertyIds,
  });
}
extension EventItemX on EventItem {
  EventTimeline get timeline => EventTimelineX.fromString(status);
}


