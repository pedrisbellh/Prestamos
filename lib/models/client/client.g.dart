// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClientImpl _$$ClientImplFromJson(Map<String, dynamic> json) => _$ClientImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      emergencyContactName: json['emergencyContactName'] as String,
      emergencyContactPhone: json['emergencyContactPhone'] as String,
      address: json['address'] as String,
      identityCard: json['identityCard'] as String,
    );

Map<String, dynamic> _$$ClientImplToJson(_$ClientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'emergencyContactName': instance.emergencyContactName,
      'emergencyContactPhone': instance.emergencyContactPhone,
      'address': instance.address,
      'identityCard': instance.identityCard,
    };
