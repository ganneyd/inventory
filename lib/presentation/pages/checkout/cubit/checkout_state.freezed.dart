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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CheckoutState {
  List<CartCheckoutEntity> get cartItems => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  bool get isCheckoutCompleted => throw _privateConstructorUsedError;
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
      {List<CartCheckoutEntity> cartItems,
      String error,
      bool isCheckoutCompleted,
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
    Object? cartItems = null,
    Object? error = null,
    Object? isCheckoutCompleted = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      cartItems: null == cartItems
          ? _value.cartItems
          : cartItems // ignore: cast_nullable_to_non_nullable
              as List<CartCheckoutEntity>,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      isCheckoutCompleted: null == isCheckoutCompleted
          ? _value.isCheckoutCompleted
          : isCheckoutCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
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
      {List<CartCheckoutEntity> cartItems,
      String error,
      bool isCheckoutCompleted,
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
    Object? cartItems = null,
    Object? error = null,
    Object? isCheckoutCompleted = null,
    Object? status = null,
  }) {
    return _then(_$AddPartStateImpl(
      cartItems: null == cartItems
          ? _value._cartItems
          : cartItems // ignore: cast_nullable_to_non_nullable
              as List<CartCheckoutEntity>,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      isCheckoutCompleted: null == isCheckoutCompleted
          ? _value.isCheckoutCompleted
          : isCheckoutCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
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
      {final List<CartCheckoutEntity> cartItems = const <CartCheckoutEntity>[],
      this.error = '',
      this.isCheckoutCompleted = false,
      this.status = CheckoutStateStatus.loading})
      : _cartItems = cartItems;

  final List<CartCheckoutEntity> _cartItems;
  @override
  @JsonKey()
  List<CartCheckoutEntity> get cartItems {
    if (_cartItems is EqualUnmodifiableListView) return _cartItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cartItems);
  }

  @override
  @JsonKey()
  final String error;
  @override
  @JsonKey()
  final bool isCheckoutCompleted;
  @override
  @JsonKey()
  final CheckoutStateStatus status;

  @override
  String toString() {
    return 'CheckoutState(cartItems: $cartItems, error: $error, isCheckoutCompleted: $isCheckoutCompleted, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddPartStateImpl &&
            const DeepCollectionEquality()
                .equals(other._cartItems, _cartItems) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isCheckoutCompleted, isCheckoutCompleted) ||
                other.isCheckoutCompleted == isCheckoutCompleted) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_cartItems),
      error,
      isCheckoutCompleted,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddPartStateImplCopyWith<_$AddPartStateImpl> get copyWith =>
      __$$AddPartStateImplCopyWithImpl<_$AddPartStateImpl>(this, _$identity);
}

abstract class _AddPartState implements CheckoutState {
  factory _AddPartState(
      {final List<CartCheckoutEntity> cartItems,
      final String error,
      final bool isCheckoutCompleted,
      final CheckoutStateStatus status}) = _$AddPartStateImpl;

  @override
  List<CartCheckoutEntity> get cartItems;
  @override
  String get error;
  @override
  bool get isCheckoutCompleted;
  @override
  CheckoutStateStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$AddPartStateImplCopyWith<_$AddPartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
