import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    String? photoUrl,
    @Default(0) int totalTokensUsed,
    @Default(0.0) double totalCostSpent,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromEntity(User user) => UserModel(
    id: user.id,
    email: user.email,
    name: user.name,
    photoUrl: user.photoUrl,
    totalTokensUsed: user.totalTokensUsed,
    totalCostSpent: user.totalCostSpent,
    createdAt: user.createdAt,
  );

  User toEntity() => User(
    id: id,
    email: email,
    name: name,
    photoUrl: photoUrl,
    totalTokensUsed: totalTokensUsed,
    totalCostSpent: totalCostSpent,
    createdAt: createdAt,
  );
}
