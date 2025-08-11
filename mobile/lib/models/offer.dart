import 'common.dart';


class Offer {
  final String id;
  final String name;
  final String? description;
  final String startDate;
  final String endDate;
  final String? discountType; // Flat|%|BuyXGetY
  final String? amount;
  final String? image;
  final String status; // active|deactivated
  final int? bookingsCount;
  final List<String> propertyIds;
  const Offer({
    required this.id,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    this.discountType,
    this.amount,
    this.image,
    required this.status,
    this.bookingsCount,
    required this.propertyIds,
  });
}
extension OfferX on Offer {
  OfferStatus get statusEnum => OfferStatusX.fromString(status);
}


