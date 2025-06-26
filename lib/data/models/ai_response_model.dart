import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_response_model.freezed.dart';
part 'ai_response_model.g.dart';

@freezed
class AIResponseModel with _$AIResponseModel {
  const factory AIResponseModel({
    required Map<String, dynamic> content,
    required int tokenUsage,
    @Default(0.0) double estimatedCost,
  }) = _AIResponseModel;

  factory AIResponseModel.fromJson(Map<String, dynamic> json) => _$AIResponseModelFromJson(json);
}
