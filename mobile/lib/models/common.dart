import 'package:flutter/foundation.dart';

// Value objects
@immutable
class Money {
  final String currency; // ISO 4217
  final double amount;
  const Money({required this.currency, required this.amount});

  factory Money.parse(String? raw, {String defaultCurrency = 'INR'}) {
    if (raw == null || raw.trim().isEmpty) return Money(currency: defaultCurrency, amount: 0);
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.-]'), '');
    final value = double.tryParse(cleaned) ?? 0.0;
    return Money(currency: defaultCurrency, amount: value);
  }
}

@immutable
class DateRangeVO {
  final DateTime start;
  final DateTime end;
  const DateRangeVO({required this.start, required this.end});

  bool get isActive => DateTime.now().isAfter(start) && DateTime.now().isBefore(end);
}

// Property type
enum PropertyType { club, bar, restaurant, farmhouse, banquet, other }

extension PropertyTypeX on PropertyType {
  static PropertyType fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'club':
        return PropertyType.club;
      case 'bar':
        return PropertyType.bar;
      case 'restaurant':
        return PropertyType.restaurant;
      case 'farmhouse':
        return PropertyType.farmhouse;
      case 'banquet':
        return PropertyType.banquet;
      default:
        return PropertyType.other;
    }
  }

  String get label => name.replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase());
}

// Booking status
enum BookingStatus { pending, confirmed, cancelled }

extension BookingStatusX on BookingStatus {
  static BookingStatus fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }

  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

// Event timeline/status used in current UI (active|past|deactivated)
enum EventTimeline { active, past, deactivated }

extension EventTimelineX on EventTimeline {
  static EventTimeline fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'active':
        return EventTimeline.active;
      case 'past':
        return EventTimeline.past;
      default:
        return EventTimeline.deactivated;
    }
  }

  String get label {
    switch (this) {
      case EventTimeline.active:
        return 'Active';
      case EventTimeline.past:
        return 'Past';
      case EventTimeline.deactivated:
        return 'Deactivated';
    }
  }
}

// Offer status (current UI: active|deactivated), future-proof: scheduled/expired
enum OfferStatus { active, deactivated, scheduled, expired }

extension OfferStatusX on OfferStatus {
  static OfferStatus fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'active':
        return OfferStatus.active;
      case 'deactivated':
        return OfferStatus.deactivated;
      case 'scheduled':
        return OfferStatus.scheduled;
      case 'expired':
        return OfferStatus.expired;
      default:
        return OfferStatus.deactivated;
    }
  }

  String get label {
    switch (this) {
      case OfferStatus.active:
        return 'Active';
      case OfferStatus.deactivated:
        return 'Deactivated';
      case OfferStatus.scheduled:
        return 'Scheduled';
      case OfferStatus.expired:
        return 'Expired';
    }
  }
}

