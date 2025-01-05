// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      id: json['id'] as String?,
      clientCount: (json['clientCount'] as num).toInt(),
      loanCount: (json['loanCount'] as num).toInt(),
      completedLoans: (json['completedLoans'] as num).toInt(),
      renewedLoans: (json['renewedLoans'] as num).toInt(),
      companyName: json['companyName'] as String,
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientCount': instance.clientCount,
      'loanCount': instance.loanCount,
      'completedLoans': instance.completedLoans,
      'renewedLoans': instance.renewedLoans,
      'companyName': instance.companyName,
    };
