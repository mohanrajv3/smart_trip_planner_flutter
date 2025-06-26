import '../entities/trip.dart';

abstract class AIAgentRepository {
  Stream<Trip> generateItinerary(String prompt, String? tripId);
  Stream<String> sendMessage(String message, String? tripId);
}
