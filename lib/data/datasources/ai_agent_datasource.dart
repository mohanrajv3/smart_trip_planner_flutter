import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/ai_response_model.dart';

abstract class AIAgentDataSource {
  Stream<AIResponseModel> generateItinerary(String prompt, String? tripId);
  Stream<AIResponseModel> sendMessage(String message, String? tripId);
}

class AIAgentDataSourceImpl implements AIAgentDataSource {
  final DioClient _dioClient;

  AIAgentDataSourceImpl(this._dioClient);

  @override
  Stream<AIResponseModel> generateItinerary(String prompt, String? tripId) async* {
    try {
      final response = await _dioClient.dio.post(
        '/api/itinerary',
        data: {
          'prompt': prompt,
          'tripId': tripId,
        },
      );

      // Simulate streaming for demo (replace with actual streaming API)
      final data = response.data as Map<String, dynamic>;
      yield AIResponseModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to generate itinerary: $e');
    }
  }

  @override
  Stream<AIResponseModel> sendMessage(String message, String? tripId) async* {
    try {
      final response = await _dioClient.dio.post(
        '/api/chat',
        data: {
          'message': message,
          'tripId': tripId,
        },
      );

      // Simulate streaming for demo
      final data = response.data as Map<String, dynamic>;
      yield AIResponseModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}