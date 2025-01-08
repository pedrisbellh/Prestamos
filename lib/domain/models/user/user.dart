import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserData with _$UserData {
  const UserData._();
  const factory UserData({
    String? id,
    required int clientCount,
    required int loanCount,
    required int completedLoans,
    required int renewedLoans,
    required String companyName,
  }) = _UserData;
  factory UserData.fromJson(Map<String, Object?> json) =>
      _$UserDataFromJson(json);
}
