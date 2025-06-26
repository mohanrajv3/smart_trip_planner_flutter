import 'package:freezed_annotation/freezed_annotation.dart';

part 'itinerary.freezed.dart';
part 'itinerary.g.dart';

@freezed
class Itinerary with _$Itinerary {
  const factory Itinerary({
    required String id,
    required DateTime date,
    required List<ActivityItem> activities,
    String? notes,
  }) = _Itinerary;

  factory Itinerary.fromJson(Map<String, dynamic> json) => _$ItineraryFromJson(json);
}

@freezed
class ActivityItem with _$ActivityItem {
  const factory ActivityItem({
    required String id,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    String? description,
  }) = _ActivityItem;

  factory ActivityItem.fromJson(Map<String, dynamic> json) => _$ActivityItemFromJson(json);
}