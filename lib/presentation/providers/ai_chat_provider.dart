import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/ai_agent_service.dart';
import '../../data/datasources/ai_agent_datasource.dart';
import '../../core/network/dio_client.dart';
import '../../domain/entities/trip.dart';

class Message {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

class AIChatState {
  final List<Message> messages;
  final bool isLoading;
  final String? error;

  AIChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  AIChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    String? error,
  }) {
    return AIChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AIChatNotifier extends StateNotifier<AIChatState> {
  final AIAgentService _aiAgentService;

  AIChatNotifier(this._aiAgentService) : super(AIChatState());

  Future<void> loadChatHistory(String tripId) async {
    state = state.copyWith(isLoading: true, error: null);
    // Implement chat history loading (e.g., from local storage or server)
    state = state.copyWith(isLoading: false);
  }

  Future<Trip?> generateItinerary(String prompt) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final stream = _aiAgentService.generateItinerary(prompt, null);
      Trip? result;
      await for (final trip in stream) {
        result = trip;
      }
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  Future<void> sendMessage(String message, {String? tripId}) async {
    final userMessage = Message(
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      final stream = _aiAgentService.sendMessage(message, tripId);
      String response = '';
      await for (final chunk in stream) {
        response += chunk;
        state = state.copyWith(
            messages: [
            ...state.messages,
            Message(
            content: response,
            isUser: false,
            timestamp: DateTime.now(),
    ),
    ],
