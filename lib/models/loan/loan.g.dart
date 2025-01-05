// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanImpl _$$LoanImplFromJson(Map<String, dynamic> json) => _$LoanImpl(
      id: json['id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      numberOfInstallments: (json['numberOfInstallments'] as num).toInt(),
      paymentFrequency: json['paymentFrequency'] as String,
      clientId: json['clientId'] as String?,
      installmentsPaid: (json['installmentsPaid'] as num?)?.toInt(),
      cuotasRestantes: (json['cuotasRestantes'] as num?)?.toInt(),
      completado: json['completado'] as bool? ?? false,
      renovado: json['renovado'] as bool? ?? false,
    );

Map<String, dynamic> _$$LoanImplToJson(_$LoanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'interestRate': instance.interestRate,
      'numberOfInstallments': instance.numberOfInstallments,
      'paymentFrequency': instance.paymentFrequency,
      'clientId': instance.clientId,
      'installmentsPaid': instance.installmentsPaid,
      'cuotasRestantes': instance.cuotasRestantes,
      'completado': instance.completado,
      'renovado': instance.renovado,
    };
