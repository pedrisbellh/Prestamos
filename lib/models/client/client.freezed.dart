// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Client _$ClientFromJson(Map<String, dynamic> json) {
  return _Client.fromJson(json);
}

/// @nodoc
mixin _$Client {
  String? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get emergencyContactName => throw _privateConstructorUsedError;
  String get emergencyContactPhone => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get identityCard => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;

  /// Serializes this Client to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Client
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClientCopyWith<Client> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientCopyWith<$Res> {
  factory $ClientCopyWith(Client value, $Res Function(Client) then) =
      _$ClientCopyWithImpl<$Res, Client>;
  @useResult
  $Res call(
      {String? id,
      String name,
      String phone,
      String emergencyContactName,
      String emergencyContactPhone,
      String address,
      String identityCard,
      String? userId});
}

/// @nodoc
class _$ClientCopyWithImpl<$Res, $Val extends Client>
    implements $ClientCopyWith<$Res> {
  _$ClientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Client
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = null,
    Object? emergencyContactName = null,
    Object? emergencyContactPhone = null,
    Object? address = null,
    Object? identityCard = null,
    Object? userId = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      emergencyContactName: null == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String,
      emergencyContactPhone: null == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      identityCard: null == identityCard
          ? _value.identityCard
          : identityCard // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClientImplCopyWith<$Res> implements $ClientCopyWith<$Res> {
  factory _$$ClientImplCopyWith(
          _$ClientImpl value, $Res Function(_$ClientImpl) then) =
      __$$ClientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String name,
      String phone,
      String emergencyContactName,
      String emergencyContactPhone,
      String address,
      String identityCard,
      String? userId});
}

/// @nodoc
class __$$ClientImplCopyWithImpl<$Res>
    extends _$ClientCopyWithImpl<$Res, _$ClientImpl>
    implements _$$ClientImplCopyWith<$Res> {
  __$$ClientImplCopyWithImpl(
      _$ClientImpl _value, $Res Function(_$ClientImpl) _then)
      : super(_value, _then);

  /// Create a copy of Client
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? phone = null,
    Object? emergencyContactName = null,
    Object? emergencyContactPhone = null,
    Object? address = null,
    Object? identityCard = null,
    Object? userId = freezed,
  }) {
    return _then(_$ClientImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      emergencyContactName: null == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String,
      emergencyContactPhone: null == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      identityCard: null == identityCard
          ? _value.identityCard
          : identityCard // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClientImpl extends _Client {
  const _$ClientImpl(
      {this.id,
      required this.name,
      required this.phone,
      required this.emergencyContactName,
      required this.emergencyContactPhone,
      required this.address,
      required this.identityCard,
      required this.userId})
      : super._();

  factory _$ClientImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClientImplFromJson(json);

  @override
  final String? id;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String emergencyContactName;
  @override
  final String emergencyContactPhone;
  @override
  final String address;
  @override
  final String identityCard;
  @override
  final String? userId;

  @override
  String toString() {
    return 'Client(id: $id, name: $name, phone: $phone, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, address: $address, identityCard: $identityCard, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.emergencyContactName, emergencyContactName) ||
                other.emergencyContactName == emergencyContactName) &&
            (identical(other.emergencyContactPhone, emergencyContactPhone) ||
                other.emergencyContactPhone == emergencyContactPhone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.identityCard, identityCard) ||
                other.identityCard == identityCard) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      phone,
      emergencyContactName,
      emergencyContactPhone,
      address,
      identityCard,
      userId);

  /// Create a copy of Client
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClientImplCopyWith<_$ClientImpl> get copyWith =>
      __$$ClientImplCopyWithImpl<_$ClientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClientImplToJson(
      this,
    );
  }
}

abstract class _Client extends Client {
  const factory _Client(
      {final String? id,
      required final String name,
      required final String phone,
      required final String emergencyContactName,
      required final String emergencyContactPhone,
      required final String address,
      required final String identityCard,
      required final String? userId}) = _$ClientImpl;
  const _Client._() : super._();

  factory _Client.fromJson(Map<String, dynamic> json) = _$ClientImpl.fromJson;

  @override
  String? get id;
  @override
  String get name;
  @override
  String get phone;
  @override
  String get emergencyContactName;
  @override
  String get emergencyContactPhone;
  @override
  String get address;
  @override
  String get identityCard;
  @override
  String? get userId;

  /// Create a copy of Client
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClientImplCopyWith<_$ClientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
