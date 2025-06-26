import '../entities/trip.dart';
import '../repositories/ai_agent_repository.dart';

class AIAgentUseCases {
  final AIAgentRepository repository;

  AIAgentUseCases(this.repository);

  Stream<Trip> generateItinerary(String prompt, String? tripId) {
    return repository.generateItinerary(prompt, tripId);
  }

  Stream<String> sendMessage(String message, String? tripId) {
    return repository.sendMessage(message, tripId);
  }
}
