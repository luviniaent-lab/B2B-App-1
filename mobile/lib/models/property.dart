class Property {

  final String id;
  final String name;
  final String location;
  final String type; // Club|Bar|Restaurant|Farmhouse|Banquet
  final int? occupancy;
  final String? agentName; // deprecated in favor of agentIds
  final List<String>? agentIds; // references to Agent.id
  final List<String>? themes;
  final List<String>? amenities;
  final String? image;
  final List<String>? media; // base64 or file refs
  final String? price24h;
  final String? priceWeekend;
  final int? eventPriceDelta;
  final String? entryFee;
  final String? entryFee24h;
  final String? entryFeePerHour;
  final String? weekendPrice24h;
  final String? weekendPricePerHour;
  final String? priceRangeHours;
  final String? priceRangeDays;
  final int? discountPercent;
  final bool? verified;
  final int? totalBookings;

  const Property({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    this.occupancy,
    this.agentName,
    this.agentIds,
    this.themes,
    this.amenities,
    this.image,
    this.media,
    this.price24h,
    this.priceWeekend,
    this.eventPriceDelta,
    this.entryFee,
    this.entryFee24h,
    this.entryFeePerHour,
    this.weekendPrice24h,
    this.weekendPricePerHour,
    this.priceRangeHours,
    this.priceRangeDays,
    this.discountPercent,
    this.verified,
    this.totalBookings,
  });
}

