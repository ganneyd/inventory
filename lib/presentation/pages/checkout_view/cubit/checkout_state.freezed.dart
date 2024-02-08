// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CheckoutState {
  PartEntity? get part => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  CheckoutStateStatus get checkoutStateStatus =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CheckoutStateCopyWith<CheckoutState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutStateCopyWith<$Res> {
  factory $CheckoutStateCopyWith(
          CheckoutState value, $Res Function(CheckoutState) then) =
      _$CheckoutStateCopyWithImpl<$Res, CheckoutState>;
  @useResult
  $Res call(
      {PartEntity? part,
      String? error,
      CheckoutStateStatus checkoutStateStatus});
}

/// @nodoc
class _$CheckoutStateCopyWithImpl<$Res, $Val extends CheckoutState>
    implements $CheckoutStateCopyWith<$Res> {
  _$CheckoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? part = freezed,
    Object? error = freezed,
    Object? checkoutStateStatus = null,
  }) {
    return _then(_value.copyWith(
      part: freezed == part
          ? _value.part
          : part // ignore: cast_nullable_to_non_nullable
              as PartEntity?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      checkoutStateStatus: null == checkoutStateStatus
          ? _value.checkoutStateStatus
          : checkoutStateStatus // ignore: cast_nullable_to_non_nullable
              as CheckoutStateStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddPartStateImplCopyWith<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  factory _$$AddPartStateImplCopyWith(
          _$AddPartStateImpl value, $Res Function(_$AddPartStateImpl) then) =
      __$$AddPartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PartEntity? part,
      String? error,
      CheckoutStateStatus checkoutStateStatus});
}

/// @nodoc
class __$$AddPartStateImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$AddPartStateImpl>
    implements _$$AddPartStateImplCopyWith<$Res> {
  __$$AddPartStateImplCopyWithImpl(
      _$AddPartStateImpl _value, $Res Function(_$AddPartStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? part = freezed,
    Object? error = freezed,
    Object? checkoutStateStatus = null,
  }) {
    return _then(_$AddPartStateImpl(
      part: freezed == part
          ? _value.part
          : part // ignore: cast_nullable_to_non_nullable
              as PartEntity?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      checkoutStateStatus: null == checkoutStateStatus
          ? _value.checkoutStateStatus
          : checkoutStateStatus // ignore: cast_nullable_to_non_nullable
              as CheckoutStateStatus,
    ));
  }
}

/// @nodoc

class _$AddPartStateImpl implements _AddPartState {
  _$AddPartStateImpl(
      {this.part,
      this.error,
      this.checkoutStateStatus = CheckoutStateStatus.loading});

  @override
  final PartEntity? part;
  @override
  final String? error;
  @override
  @JsonKey()
  final CheckoutStateStatus checkoutStateStatus;

  @override
  String toString() {
    return 'CheckoutState(part: $part, error: $error, checkoutStateStatus: $checkoutStateStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddPartStateImpl &&
            (identical(other.part, part) || other.part == part) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.checkoutStateStatus, checkoutStateStatus) ||
                other.checkoutStateStatus == checkoutStateStatus));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, part, error, checkoutStateStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddPartStateImplCopyWith<_$AddPartStateImpl> get copyWith =>
      __$$AddPartStateImplCopyWithImpl<_$AddPartStateImpl>(this, _$identity);
}

abstract class _AddPartState implements CheckoutState {
  factory _AddPartState(
      {final PartEntity? part,
      final String? error,
      final CheckoutStateStatus checkoutStateStatus}) = _$AddPartStateImpl;

  @override
  PartEntity? get part;
  @override
  String? get error;
  @override
  CheckoutStateStatus get checkoutStateStatus;
  @override
  @JsonKey(ignore: true)
  _$$AddPartStateImplCopyWith<_$AddPartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
