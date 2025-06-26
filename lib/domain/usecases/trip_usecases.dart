import '../entities/trip.dart';
import '../repositories/trip_repository.dart';

class TripUseCases {
  final TripRepository repository;

  TripUseCases(this.repository);

  Future<void> saveTrip(Trip trip) {
    return repository.saveTrip(trip);
  }

  Future<List<Trip>> getTrips() {
    return repository.getTrips();
  }

  Future<Trip?> getTripById(String id) {
    return repository.getTripById(id);
  }

  Future<void> deleteTrip(String id) {
    return repository.deleteTrip(id);
  }
}
