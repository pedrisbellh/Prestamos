// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  String? get id => throw _privateConstructorUsedError;
  int get clientCount => throw _privateConstructorUsedError;
  int get loanCount => throw _privateConstructorUsedError;
  int get completedLoans => throw _privateConstructorUsedError;
  int get renewedLoans => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;

  /// Serializes this UserData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {String? id,
      int clientCount,
      int loanCount,
      int completedLoans,
      int renewedLoans,
      String companyName});
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? clientCount = null,
    Object? loanCount = null,
    Object? completedLoans = null,
    Object? renewedLoans = null,
    Object? companyName = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      clientCount: null == clientCount
          ? _value.clientCount
          : clientCount // ignore: cast_nullable_to_non_nullable
              as int,
      loanCount: null == loanCount
          ? _value.loanCount
          : loanCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedLoans: null == completedLoans
          ? _value.completedLoans
          : completedLoans // ignore: cast_nullable_to_non_nullable
              as int,
      renewedLoans: null == renewedLoans
          ? _value.renewedLoans
          : renewedLoans // ignore: cast_nullable_to_non_nullable
              as int,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDataImplCopyWith<$Res>
    implements $UserDataCopyWith<$Res> {
  factory _$$UserDataImplCopyWith(
          _$UserDataImpl value, $Res Function(_$UserDataImpl) then) =
      __$$UserDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      int clientCount,
      int loanCount,
      int completedLoans,
      int renewedLoans,
      String companyName});
}

/// @nodoc
class __$$UserDataImplCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$UserDataImpl>
    implements _$$UserDataImplCopyWith<$Res> {
  __$$UserDataImplCopyWithImpl(
      _$UserDataImpl _value, $Res Function(_$UserDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? clientCount = null,
    Object? loanCount = null,
    Object? completedLoans = null,
    Object? renewedLoans = null,
    Object? companyName = null,
  }) {
    return _then(_$UserDataImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      clientCount: null == clientCount
          ? _value.clientCount
          : clientCount // ignore: cast_nullable_to_non_nullable
              as int,
      loanCount: null == loanCount
          ? _value.loanCount
          : loanCount // ignore: cast_nullable_to_non_nullable
              as int,
      completedLoans: null == completedLoans
          ? _value.completedLoans
          : completedLoans // ignore: cast_nullable_to_non_nullable
              as int,
      renewedLoans: null == renewedLoans
          ? _value.renewedLoans
          : renewedLoans // ignore: cast_nullable_to_non_nullable
              as int,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDataImpl extends _UserData {
  const _$UserDataImpl(
      {this.id,
      required this.clientCount,
      required this.loanCount,
      required this.completedLoans,
      required this.renewedLoans,
      required this.companyName})
      : super._();

  factory _$UserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataImplFromJson(json);

  @override
  final String? id;
  @override
  final int clientCount;
  @override
  final int loanCount;
  @override
  final int completedLoans;
  @override
  final int renewedLoans;
  @override
  final String companyName;

  @override
  String toString() {
    return 'UserData(id: $id, clientCount: $clientCount, loanCount: $loanCount, completedLoans: $completedLoans, renewedLoans: $renewedLoans, companyName: $companyName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientCount, clientCount) ||
                other.clientCount == clientCount) &&
            (identical(other.loanCount, loanCount) ||
                other.loanCount == loanCount) &&
            (identical(other.completedLoans, completedLoans) ||
                other.completedLoans == completedLoans) &&
            (identical(other.renewedLoans, renewedLoans) ||
                other.renewedLoans == renewedLoans) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clientCount, loanCount,
      completedLoans, renewedLoans, companyName);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      __$$UserDataImplCopyWithImpl<_$UserDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataImplToJson(
      this,
    );
  }
}

abstract class _UserData extends UserData {
  const factory _UserData(
      {final String? id,
      required final int clientCount,
      required final int loanCount,
      required final int completedLoans,
      required final int renewedLoans,
      required final String companyName}) = _$UserDataImpl;
  const _UserData._() : super._();

  factory _UserData.fromJson(Map<String, dynamic> json) =
      _$UserDataImpl.fromJson;

  @override
  String? get id;
  @override
  int get clientCount;
  @override
  int get loanCount;
  @override
  int get completedLoans;
  @override
  int get renewedLoans;
  @override
  String get companyName;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
