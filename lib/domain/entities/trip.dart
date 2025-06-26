import 'package:freezed_annotation/freezed_annotation.dart';
import 'itinerary.dart';
part 'trip.freezed.dart';
part 'trip.g.dart';

@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required List<Itinerary> days,
    String? destination,
    String? description,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}

@freezed
class DayItinerary with _$DayItinerary {
  const factory DayItinerary({
    required String date,
    required String summary,
    required List<ActivityItem> items,
  }) = _DayItinerary;

  factory DayItinerary.fromJson(Map<String, dynamic> json) =>
      _$DayItineraryFromJson(json);
}

@freezed
class ActivityItem with _$ActivityItem {
  const factory ActivityItem({
    required String time,
    required String activity,
    required String location,
    String? description,
    String? category,
    String? imageUrl,
  }) = _ActivityItem;

  factory ActivityItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityItemFromJson(json);
}


