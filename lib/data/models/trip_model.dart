import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import '../../domain/entities/trip.dart';
import 'itinerary.dart';
part 'trip_model.freezed.dart';
part 'trip_model.g.dart';


@freezed
class TripModel with _$TripModel {
  const factory TripModel({
    required String id,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required List<Itinerary> days,
    String? destination,
    String? description,
  }) = _TripModel;

  factory TripModel.fromJson(Map<String, dynamic> json) => _$TripModelFromJson(json);

  factory TripModel.fromEntity(Trip trip) => TripModel(
    id: trip.id,
    title: trip.title,
    startDate: trip.startDate,
    endDate: trip.endDate,
    days: trip.days,
    destination: trip.destination,
    description: trip.description,
  );

  Trip toEntity() => Trip(
    id: id,
    title: title,
    startDate: startDate,
    endDate: endDate,
    days: days,
    destination: destination,
    description: description,
  );
}

@freezed
@Embedded(ignore: {'copyWith'})
class DayItineraryModel with _$DayItineraryModel {
  const factory DayItineraryModel({
    required String date,
    required String summary,
    required List<ActivityItemModel> items,
  }) = _DayItineraryModel;

  factory DayItineraryModel.fromJson(Map<String, dynamic> json) => _$DayItineraryModelFromJson(json);

  factory DayItineraryModel.fromEntity(DayItinerary day) => DayItineraryModel(
    date: day.date,
    summary: day.summary,
    items: day.items.map((item) => ActivityItemModel.fromEntity(item)).toList(),
  );

  DayItinerary toEntity() => DayItinerary(
    date: date,
    summary: summary,
    items: items.map((item) => item.toEntity()).toList(),
  );
}

@freezed
@Embedded(ignore: {'copyWith'})
class ActivityItemModel with _$ActivityItemModel {
  const factory ActivityItemModel({
    required String time,
    required String activity,
    required String location,
    String? description,
    String? category,
    String? imageUrl,
  }) = _ActivityItemModel;

  factory ActivityItemModel.fromJson(Map<String, dynamic> json) => _$ActivityItemModelFromJson(json);

  factory ActivityItemModel.fromEntity(ActivityItem item) => ActivityItemModel(
    time: item.time,
    activity: item.activity,
    location: item.location,
    description: item.description,
    category: item.category,
    imageUrl: item.imageUrl,
  );

  ActivityItem toEntity() => ActivityItem(
    time: time,
    activity: activity,
    location: location,
    description: description,
    category: category,
    imageUrl: imageUrl,
  );
}


