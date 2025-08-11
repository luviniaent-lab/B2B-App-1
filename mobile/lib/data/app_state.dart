import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/property.dart';
import '../models/event.dart';
import '../models/offer.dart';
import '../models/booking.dart';
import '../models/profile.dart';
import '../models/agent.dart';

class AppState {
  final List<Property> properties;
  final List<EventItem> events;
  final List<Offer> offers;
  final List<Booking> bookings;
  final ProfileInfo profile;
  final List<Agent> agents;
  const AppState({required this.properties, required this.events, required this.offers, required this.bookings, required this.profile, required this.agents});

  AppState copyWith({List<Property>? properties, List<EventItem>? events, List<Offer>? offers, List<Booking>? bookings, ProfileInfo? profile, List<Agent>? agents}) =>
      AppState(properties: properties ?? this.properties, events: events ?? this.events, offers: offers ?? this.offers, bookings: bookings ?? this.bookings, profile: profile ?? this.profile, agents: agents ?? this.agents);

  factory AppState.initial() => AppState(
    properties: [
      Property(
        id: 'p1',
        name: 'Neon Night Club',
        location: 'DLF CyberHub, Gurugram',
        type: 'Club',
        occupancy: 320,
        image: null,
        media: const [],
        verified: true,
        totalBookings: 1284,
      ),
    ],
    events: const [],
    offers: const [],
    bookings: const [
      Booking(id: 'b1', eventName: 'DJ Night', date: '2025-08-09', people: 4, contact: '+91 98765 43210', status: 'Confirmed'),
      Booking(id: 'b2', eventName: 'Open Mic', date: '2025-08-11', people: 2, contact: '+91 99999 11111', status: 'Pending'),
      Booking(id: 'b3', eventName: 'Sufi Evening', date: '2025-08-03', people: 3, contact: '+91 90000 22222', status: 'Cancelled'),
    ],
    profile: const ProfileInfo(
      name: 'Your Name',
      email: 'you@example.com',
      phone: '+91 90000 00000',
      aadhaar: 'XXXX-XXXX-XXXX',
      businessId: 'BIZ-123456',
      address: 'Address line, City, State',
      companyVerified: true,
    ),
      agents: const [],
  );
}

final appStateProvider = StateNotifierProvider<AppCtrl, AppState>((ref) => AppCtrl());

class AppCtrl extends StateNotifier<AppState> {
  AppCtrl() : super(AppState.initial());

  void addProperty(Property p) => state = state.copyWith(properties: [...state.properties, p]);
  void updateProperty(String id, Property p) => state = state.copyWith(
        properties: state.properties.map((x) => x.id == id ? p : x).toList(),
      );
  void deleteProperty(String id) => state = state.copyWith(
        properties: state.properties.where((x) => x.id != id).toList(),
      );

  void addEvent(EventItem e) => state = state.copyWith(events: [...state.events, e]);
  void updateEvent(String id, EventItem e) => state = state.copyWith(
        events: state.events.map((x) => x.id == id ? e : x).toList(),
      );
  void deleteEvent(String id) => state = state.copyWith(
        events: state.events.where((x) => x.id != id).toList(),
      );

  void addOffer(Offer o) => state = state.copyWith(offers: [...state.offers, o]);
  void updateOffer(String id, Offer o) => state = state.copyWith(
        offers: state.offers.map((x) => x.id == id ? o : x).toList(),
      );
  void deleteOffer(String id) => state = state.copyWith(
        offers: state.offers.where((x) => x.id != id).toList(),
      );

  // Bookings
  void updateBooking(String id, Booking b) => state = state.copyWith(
        bookings: state.bookings.map((x) => x.id == id ? b : x).toList(),
      );

  // Agents
  void addAgent(Agent a) => state = state.copyWith(agents: [...state.agents, a]);
  void updateAgent(String id, Agent a) => state = state.copyWith(
        agents: state.agents.map((x) => x.id == id ? a : x).toList(),
      );
  void deleteAgent(String id) => state = state.copyWith(
        agents: state.agents.where((x) => x.id != id).toList(),
      );
  void setBookingStatus(String id, String status) => state = state.copyWith(
        bookings: state.bookings.map((x) => x.id == id ? Booking(id: x.id, eventName: x.eventName, date: x.date, people: x.people, contact: x.contact, status: status) : x).toList(),
      );

  void updateProfile({String? phone, String? businessId, String? aadhaar}) {
    final p = state.profile;
    state = state.copyWith(
      profile: ProfileInfo(
        name: p.name,
        email: p.email,
        phone: phone ?? p.phone,
        aadhaar: aadhaar ?? p.aadhaar,
        businessId: businessId ?? p.businessId,
        address: p.address,
        companyVerified: p.companyVerified,
      ),
    );
  }
}

