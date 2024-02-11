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
  List<CheckedOutEntity> get checkoutParts =>
      throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  CheckoutStateStatus get status => throw _privateConstructorUsedError;

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
      {List<CheckedOutEntity> checkoutParts,
      String error,
      CheckoutStateStatus status});
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
    Object? checkoutParts = null,
    Object? error = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      checkoutParts: null == checkoutParts
          ? _value.checkoutParts
          : checkoutParts // ignore: cast_nullable_to_non_nullable
              as List<CheckedOutEntity>,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
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
      {List<CheckedOutEntity> checkoutParts,
      String error,
      CheckoutStateStatus status});
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
    Object? checkoutParts = null,
    Object? error = null,
    Object? status = null,
  }) {
    return _then(_$AddPartStateImpl(
      checkoutParts: null == checkoutParts
          ? _value._checkoutParts
          : checkoutParts // ignore: cast_nullable_to_non_nullable
              as List<CheckedOutEntity>,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CheckoutStateStatus,
    ));
  }
}

/// @nodoc

class _$AddPartStateImpl implements _AddPartState {
  _$AddPartStateImpl(
      {final List<CheckedOutEntity> checkoutParts = const <CheckedOutEntity>[],
      this.error = '',
      this.status = CheckoutStateStatus.loading})
      : _checkoutParts = checkoutParts;

  final List<CheckedOutEntity> _checkoutParts;
  @override
  @JsonKey()
  List<CheckedOutEntity> get checkoutParts {
    if (_checkoutParts is EqualUnmodifiableListView) return _checkoutParts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checkoutParts);
  }

  @override
  @JsonKey()
  final String error;
  @override
  @JsonKey()
  final CheckoutStateStatus status;

  @override
  String toString() {
    return 'CheckoutState(checkoutParts: $checkoutParts, error: $error, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddPartStateImpl &&
            const DeepCollectionEquality()
                .equals(other._checkoutParts, _checkoutParts) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_checkoutParts), error, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddPartStateImplCopyWith<_$AddPartStateImpl> get copyWith =>
      __$$AddPartStateImplCopyWithImpl<_$AddPartStateImpl>(this, _$identity);
}

abstract class _AddPartState implements CheckoutState {
  factory _AddPartState(
      {final List<CheckedOutEntity> checkoutParts,
      final String error,
      final CheckoutStateStatus status}) = _$AddPartStateImpl;

  @override
  List<CheckedOutEntity> get checkoutParts;
  @override
  String get error;
  @override
  CheckoutStateStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$AddPartStateImplCopyWith<_$AddPartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
