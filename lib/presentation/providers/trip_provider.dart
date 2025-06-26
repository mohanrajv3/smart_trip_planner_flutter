import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/storage_service.dart';
import '../../data/datasources/trip_local_datasource.dart';
import '../../domain/entities/trip.dart';

class TripState {
  final List<Trip> trips;
  final bool isLoading;
  final String? error;

  TripState({
    this.trips = const [],
    this.isLoading = false,
    this.error,
  });

  TripState copyWith({
    List<Trip>? trips,
    bool? isLoading,
    String? error,
  }) {
    return TripState(
      trips: trips ?? this.trips,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TripNotifier extends StateNotifier<TripState> {
  final StorageService _storageService;

  TripNotifier(this._storageService) : super(TripState());

  Future<void> loadTrips() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final trips = await _storageService.getTrips();
      state = state.copyWith(trips: trips, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadTripById(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final trip = await _storageService.getTripById(id);
      if (trip != null) {
        final updatedTrips = List<Trip>.from(state.trips)
          ..removeWhere((t) => t.id == id)
          ..add(trip);
        state = state.copyWith(trips: updatedTrips, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: 'Trip not found');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> saveTrip(Trip trip) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _storageService.saveTrip(trip);
      final updatedTrips = List<Trip>.from(state.trips)
        ..removeWhere((t) => t.id == trip.id)
        ..add(trip);
      state = state.copyWith(trips: updatedTrips, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteTrip(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _storageService.deleteTrip(id);
      final updatedTrips = List<Trip>.from(state.trips)..removeWhere((t) => t.id == id);
      state = state.copyWith(trips: updatedTrips, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final tripsProvider = StateNotifierProvider<TripNotifier, TripState>((ref) {
  final storageService = StorageService(TripLocalDataSourceImpl());
  return TripNotifier(storageService);
});
