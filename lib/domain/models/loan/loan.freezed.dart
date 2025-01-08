// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Loan _$LoanFromJson(Map<String, dynamic> json) {
  return _Loan.fromJson(json);
}

/// @nodoc
mixin _$Loan {
  String? get id => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get interestRate => throw _privateConstructorUsedError;
  int get numberOfInstallments => throw _privateConstructorUsedError;
  String get paymentFrequency => throw _privateConstructorUsedError;
  String? get clientId => throw _privateConstructorUsedError;
  int? get installmentsPaid => throw _privateConstructorUsedError;
  int? get cuotasRestantes => throw _privateConstructorUsedError;
  bool get completado => throw _privateConstructorUsedError;
  bool get renovado => throw _privateConstructorUsedError;

  /// Serializes this Loan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Loan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoanCopyWith<Loan> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoanCopyWith<$Res> {
  factory $LoanCopyWith(Loan value, $Res Function(Loan) then) =
      _$LoanCopyWithImpl<$Res, Loan>;
  @useResult
  $Res call(
      {String? id,
      double amount,
      double interestRate,
      int numberOfInstallments,
      String paymentFrequency,
      String? clientId,
      int? installmentsPaid,
      int? cuotasRestantes,
      bool completado,
      bool renovado});
}

/// @nodoc
class _$LoanCopyWithImpl<$Res, $Val extends Loan>
    implements $LoanCopyWith<$Res> {
  _$LoanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Loan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? amount = null,
    Object? interestRate = null,
    Object? numberOfInstallments = null,
    Object? paymentFrequency = null,
    Object? clientId = freezed,
    Object? installmentsPaid = freezed,
    Object? cuotasRestantes = freezed,
    Object? completado = null,
    Object? renovado = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      interestRate: null == interestRate
          ? _value.interestRate
          : interestRate // ignore: cast_nullable_to_non_nullable
              as double,
      numberOfInstallments: null == numberOfInstallments
          ? _value.numberOfInstallments
          : numberOfInstallments // ignore: cast_nullable_to_non_nullable
              as int,
      paymentFrequency: null == paymentFrequency
          ? _value.paymentFrequency
          : paymentFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      installmentsPaid: freezed == installmentsPaid
          ? _value.installmentsPaid
          : installmentsPaid // ignore: cast_nullable_to_non_nullable
              as int?,
      cuotasRestantes: freezed == cuotasRestantes
          ? _value.cuotasRestantes
          : cuotasRestantes // ignore: cast_nullable_to_non_nullable
              as int?,
      completado: null == completado
          ? _value.completado
          : completado // ignore: cast_nullable_to_non_nullable
              as bool,
      renovado: null == renovado
          ? _value.renovado
          : renovado // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoanImplCopyWith<$Res> implements $LoanCopyWith<$Res> {
  factory _$$LoanImplCopyWith(
          _$LoanImpl value, $Res Function(_$LoanImpl) then) =
      __$$LoanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      double amount,
      double interestRate,
      int numberOfInstallments,
      String paymentFrequency,
      String? clientId,
      int? installmentsPaid,
      int? cuotasRestantes,
      bool completado,
      bool renovado});
}

/// @nodoc
class __$$LoanImplCopyWithImpl<$Res>
    extends _$LoanCopyWithImpl<$Res, _$LoanImpl>
    implements _$$LoanImplCopyWith<$Res> {
  __$$LoanImplCopyWithImpl(_$LoanImpl _value, $Res Function(_$LoanImpl) _then)
      : super(_value, _then);

  /// Create a copy of Loan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? amount = null,
    Object? interestRate = null,
    Object? numberOfInstallments = null,
    Object? paymentFrequency = null,
    Object? clientId = freezed,
    Object? installmentsPaid = freezed,
    Object? cuotasRestantes = freezed,
    Object? completado = null,
    Object? renovado = null,
  }) {
    return _then(_$LoanImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      interestRate: null == interestRate
          ? _value.interestRate
          : interestRate // ignore: cast_nullable_to_non_nullable
              as double,
      numberOfInstallments: null == numberOfInstallments
          ? _value.numberOfInstallments
          : numberOfInstallments // ignore: cast_nullable_to_non_nullable
              as int,
      paymentFrequency: null == paymentFrequency
          ? _value.paymentFrequency
          : paymentFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      installmentsPaid: freezed == installmentsPaid
          ? _value.installmentsPaid
          : installmentsPaid // ignore: cast_nullable_to_non_nullable
              as int?,
      cuotasRestantes: freezed == cuotasRestantes
          ? _value.cuotasRestantes
          : cuotasRestantes // ignore: cast_nullable_to_non_nullable
              as int?,
      completado: null == completado
          ? _value.completado
          : completado // ignore: cast_nullable_to_non_nullable
              as bool,
      renovado: null == renovado
          ? _value.renovado
          : renovado // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoanImpl extends _Loan {
  const _$LoanImpl(
      {this.id,
      required this.amount,
      required this.interestRate,
      required this.numberOfInstallments,
      required this.paymentFrequency,
      required this.clientId,
      this.installmentsPaid,
      this.cuotasRestantes,
      this.completado = false,
      this.renovado = false})
      : super._();

  factory _$LoanImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoanImplFromJson(json);

  @override
  final String? id;
  @override
  final double amount;
  @override
  final double interestRate;
  @override
  final int numberOfInstallments;
  @override
  final String paymentFrequency;
  @override
  final String? clientId;
  @override
  final int? installmentsPaid;
  @override
  final int? cuotasRestantes;
  @override
  @JsonKey()
  final bool completado;
  @override
  @JsonKey()
  final bool renovado;

  @override
  String toString() {
    return 'Loan(id: $id, amount: $amount, interestRate: $interestRate, numberOfInstallments: $numberOfInstallments, paymentFrequency: $paymentFrequency, clientId: $clientId, installmentsPaid: $installmentsPaid, cuotasRestantes: $cuotasRestantes, completado: $completado, renovado: $renovado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.interestRate, interestRate) ||
                other.interestRate == interestRate) &&
            (identical(other.numberOfInstallments, numberOfInstallments) ||
                other.numberOfInstallments == numberOfInstallments) &&
            (identical(other.paymentFrequency, paymentFrequency) ||
                other.paymentFrequency == paymentFrequency) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.installmentsPaid, installmentsPaid) ||
                other.installmentsPaid == installmentsPaid) &&
            (identical(other.cuotasRestantes, cuotasRestantes) ||
                other.cuotasRestantes == cuotasRestantes) &&
            (identical(other.completado, completado) ||
                other.completado == completado) &&
            (identical(other.renovado, renovado) ||
                other.renovado == renovado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      amount,
      interestRate,
      numberOfInstallments,
      paymentFrequency,
      clientId,
      installmentsPaid,
      cuotasRestantes,
      completado,
      renovado);

  /// Create a copy of Loan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoanImplCopyWith<_$LoanImpl> get copyWith =>
      __$$LoanImplCopyWithImpl<_$LoanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoanImplToJson(
      this,
    );
  }
}

abstract class _Loan extends Loan {
  const factory _Loan(
      {final String? id,
      required final double amount,
      required final double interestRate,
      required final int numberOfInstallments,
      required final String paymentFrequency,
      required final String? clientId,
      final int? installmentsPaid,
      final int? cuotasRestantes,
      final bool completado,
      final bool renovado}) = _$LoanImpl;
  const _Loan._() : super._();

  factory _Loan.fromJson(Map<String, dynamic> json) = _$LoanImpl.fromJson;

  @override
  String? get id;
  @override
  double get amount;
  @override
  double get interestRate;
  @override
  int get numberOfInstallments;
  @override
  String get paymentFrequency;
  @override
  String? get clientId;
  @override
  int? get installmentsPaid;
  @override
  int? get cuotasRestantes;
  @override
  bool get completado;
  @override
  bool get renovado;

  /// Create a copy of Loan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoanImplCopyWith<_$LoanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
