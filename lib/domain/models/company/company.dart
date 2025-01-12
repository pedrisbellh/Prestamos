import 'package:freezed_annotation/freezed_annotation.dart';
part 'company.freezed.dart';
part 'company.g.dart';

@freezed
class Company with _$Company {
  const Company._();
  const factory Company({
    String? id,
    required String name,
    required String address,
    required String phone,
    required String? rcn,
    required String? userId,
  }) = _Company;
  factory Company.fromJson(Map<String, Object?> json) =>
      _$CompanyFromJson(json);
}
