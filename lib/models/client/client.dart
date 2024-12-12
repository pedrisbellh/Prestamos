import 'package:freezed_annotation/freezed_annotation.dart';
part 'client.freezed.dart';
part 'client.g.dart';

@freezed
class Client with _$Client {
  const Client._();
  const factory Client({
    String? id,
    required String name,
    required String phone,
    required String emergencyContactName,
    required String emergencyContactPhone,
    required String address,
    required String identityCard,
    required String? userId,
  }) = _Client;
  factory Client.fromJson(Map<String, Object?> json) => _$ClientFromJson(json);
}
