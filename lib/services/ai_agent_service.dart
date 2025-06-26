import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../data/datasources/ai_agent_datasource.dart';
import '../../domain/entities/trip.dart';

class AIAgentService {
  final AIAgentDataSource dataSource;

  AIAgentService(this.dataSource);

  Stream<Trip> generateItinerary(String prompt, String? tripId) async* {
    final stream = dataSource.generateItinerary(prompt, tripId);
    await for (final response in stream) {
      // Mock itinerary generation (replace with actual AI processing)
      yield Trip(
        id: tripId ?? const Uuid().v4(),
        title: response.content['title'] ?? 'New Trip',
        startDate: response.content['startDate'] ?? DateTime.now().toIso8601String(),
        endDate: response.content['endDate'] ?? DateTime.now().add(Duration(days: 5)).toIso8601String(),
        days: (response.content['days'] as List<dynamic>?)?.map((day) => DayItinerary.fromJson(day)).toList() ?? [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tokenUsage: response.tokenUsage,
        estimatedCost: response.estimatedCost,
      );
    }
  }

  Stream<String> sendMessage(String message, String? tripId) async* {
    final stream = dataSource.sendMessage(message, tripId);
    await for (final response in stream) {
      yield response.content['message'] ?? '';
    }
  }
}