import '../../data/datasources/trip_local_datasource.dart';
import '../../domain/entities/trip.dart';
import '../models/trip_model.dart';

class StorageService {
  final TripLocalDataSource dataSource;

  StorageService(this.dataSource);

  Future<void> saveTrip(Trip trip) async {
    final model = TripModel.fromEntity(trip);
    await dataSource.saveTrip(model);
  }

  Future<List<Trip>> getTrips() async {
    final models = await dataSource.getTrips();
    return models.map((model) => model.toEntity()).toList();
  }

  Future<Trip?> getTripById(String id) async {
    final model = await dataSource.getTripById(id);
    return model?.toEntity();
  }

  Future<void> deleteTrip(String id) async {
    await dataSource.deleteTrip(id);
  }
}
