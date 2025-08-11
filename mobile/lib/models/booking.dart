import 'common.dart';


class Booking {
  final String id;
  final String eventName;
  final String date; // ISO
  final int people;
  final String contact;
  final String status; // Confirmed|Cancelled|Pending
  final String? customerName;
  final String? customerEmail;
  final String? price;
  final String? specialRequests;
  final bool? isVerified;
  const Booking({
    required this.id,
    required this.eventName,
    required this.date,
    required this.people,
    required this.contact,
    required this.status,
    this.customerName,
    this.customerEmail,
    this.price,
    this.specialRequests,
    this.isVerified,
  });
}


extension BookingX on Booking {
  BookingStatus get statusEnum => BookingStatusX.fromString(status);
}
