// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manage_inventory_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ManageInventoryState {
  int get fetchPartAmount => throw _privateConstructorUsedError;
  int get databaseLength => throw _privateConstructorUsedError;
  List<PartEntity> get parts => throw _privateConstructorUsedError;
  List<PartEntity> get lowQuantityParts => throw _privateConstructorUsedError;
  List<CheckedOutEntity> get unverifiedParts =>
      throw _privateConstructorUsedError;
  List<CheckedOutEntity> get newlyVerifiedParts =>
      throw _privateConstructorUsedError;
  List<CheckedOutEntity> get checkedOutParts =>
      throw _privateConstructorUsedError;
  List<OrderEntity> get allPartOrders => throw _privateConstructorUsedError;
  List<OrderEntity> get allUnfulfilledPartOrders =>
      throw _privateConstructorUsedError;
  List<OrderEntity> get newlyFulfilledPartOrders =>
      throw _privateConstructorUsedError;
  dynamic get error => throw _privateConstructorUsedError;
  ManageInventoryStateStatus get status => throw _privateConstructorUsedError;
>>>>>>> 9594ee4 (added state control to manage inventory page)

  @JsonKey(ignore: true)
  $ManageInventoryStateCopyWith<ManageInventoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManageInventoryStateCopyWith<$Res> {
  factory $ManageInventoryStateCopyWith(ManageInventoryState value,
          $Res Function(ManageInventoryState) then) =
      _$ManageInventoryStateCopyWithImpl<$Res, ManageInventoryState>;
  @useResult
  $Res call(
      {int fetchPartAmount,
      int databaseLength,
      List<PartEntity> parts,
      List<PartEntity> lowQuantityParts,
      List<CheckedOutEntity> unverifiedParts,
      List<CheckedOutEntity> newlyVerifiedParts,
      List<CheckedOutEntity> checkedOutParts,
      List<OrderEntity> allPartOrders,
      List<OrderEntity> allUnfulfilledPartOrders,
      List<OrderEntity> newlyFulfilledPartOrders,
      dynamic error,
      ManageInventoryStateStatus status});
>>>>>>> 9594ee4 (added state control to manage inventory page)
}

/// @nodoc
class _$ManageInventoryStateCopyWithImpl<$Res,
        $Val extends ManageInventoryState>
    implements $ManageInventoryStateCopyWith<$Res> {
  _$ManageInventoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fetchPartAmount = null,
    Object? databaseLength = null,
    Object? parts = null,
    Object? lowQuantityParts = null,
    Object? unverifiedParts = null,
    Object? newlyVerifiedParts = null,
    Object? checkedOutParts = null,
    Object? allPartOrders = null,
    Object? allUnfulfilledPartOrders = null,
    Object? newlyFulfilledPartOrders = null,
    Object? error = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      fetchPartAmount: null == fetchPartAmount
          ? _value.fetchPartAmount
          : fetchPartAmount // ignore: cast_nullable_to_non_nullable
              as int,
      databaseLength: null == databaseLength
          ? _value.databaseLength
          : databaseLength // ignore: cast_nullable_to_non_nullable
              as int,
      parts: null == parts
          ? _value.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<PartEntity>,
      lowQuantityParts: null == lowQuantityParts
          ? _value.lowQuantityParts
          : lowQuantityParts // ignore: cast_nullable_to_non_nullable
              as List<PartEntity>,
      unverifiedParts: null == unverifiedParts
          ? _value.unverifiedParts
          : unverifiedParts // ignore: cast_nullable_to_non_nullable
              as List<CheckedOutEntity>,
      newlyVerifiedParts: null == newlyVerifiedParts
          ? _value.newlyVerifiedParts
          : newlyVerifiedParts // ignore: cast_nullable_to_non_nullable
              as List<CheckedOutEntity>,
      checkedOutParts: null == checkedOutParts
          ? _value.checkedOutParts
          : checkedOutParts // ignore: cast_nullable_to_non_nullable
              as List<CheckedOutEntity>,
      allPartOrders: null == allPartOrders
          ? _value.allPartOrders
          : allPartOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      allUnfulfilledPartOrders: null == allUnfulfilledPartOrders
          ? _value.allUnfulfilledPartOrders
          : allUnfulfilledPartOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      newlyFulfilledPartOrders: null == newlyFulfilledPartOrders
          ? _value.newlyFulfilledPartOrders
          : newlyFulfilledPartOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ManageInventoryStateStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManageInventoryStateImplCopyWith<$Res>
    implements $ManageInventoryStateCopyWith<$Res> {
  factory _$$ManageInventoryStateImplCopyWith(_$ManageInventoryStateImpl value,
          $Res Function(_$ManageInventoryStateImpl) then) =
      __$$ManageInventoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int fetchPartAmount,
      int databaseLength,
      List<PartEntity> parts,
      List<PartEntity> lowQuantityParts,
      List<CheckedOutEntity> unverifiedParts,
      List<CheckedOutEntity> newlyVerifiedParts,
      List<CheckedOutEntity> checkedOutParts,
      List<OrderEntity> allPartOrders,
      List<OrderEntity> allUnfulfilledPartOrders,
      List<OrderEntity> newlyFulfilledPartOrders,
      dynamic error,
      ManageInventoryStateStatus status});
>>>>>>> 9594ee4 (added state control to manage inventory page)
}

/// @nodoc
class __$$ManageInventoryStateImplCopyWithImpl<$Res>
    extends _$ManageInventoryStateCopyWithImpl<$Res, _$ManageInventoryStateImpl>
    implements _$$ManageInventoryStateImplCopyWith<$Res> {
  __$$ManageInventoryStateImplCopyWithImpl(_$ManageInventoryStateImpl _value,
      $Res Function(_$ManageInventoryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fetchPartAmount = null,
    Object? databaseLength = null,
    Object? parts = null,
    Object? lowQuantityParts = null,
    Object? unverifiedParts = null,
    Object? newlyVerifiedParts = null,
    Object? checkedOutParts = null,
    Object? allPartOrders = null,
    Object? allUnfulfilledPartOrders = null,
    Object? newlyFulfilledPartOrders = null,
    Object? error = freezed,
    Object? status = null,
  }) {
    return _then(_$ManageInventoryStateImpl(
      fetchPartAmount: null == fetchPartAmount
          ? _value.fetchPartAmount
          : fetchPartAmount // ignore: cast_nullable_to_non_nullable
              as int,
      databaseLength: null == databaseLength
          ? _value.databaseLength
          : databaseLength // ignore: cast_nullable_to_non_nullable
              as int,
      parts: null == parts
          ? _value._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<PartEntity>,
      lowQuantityParts: null == lowQuantityParts
          ? _value._lowQuantityParts
          : lowQuantityParts // ignore: cast_nullable_to_non_nullable
              as List<PartEntity>,
      unverifiedParts: null == unverifiedParts
          ? _value._unverifiedParts
          : unverifiedParts // ignore: cast_nullable_to_non_nullable
              as List<CheckedOutEntity>,
      newlyVerifiedParts: null == newlyVerifiedParts
          ? _value._newlyVerifiedParts
          : newlyVerifiedParts // ignore: cast_nullable_to_non_nullable
              as List<CheckedOutEntity>,
      checkedOutParts: null == checkedOutParts
          ? _value._checkedOutParts
          : checkedOutParts // ignore: cast_nullable_to_non_nullable
              as List<CheckedOutEntity>,
      allPartOrders: null == allPartOrders
          ? _value._allPartOrders
          : allPartOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      allUnfulfilledPartOrders: null == allUnfulfilledPartOrders
          ? _value._allUnfulfilledPartOrders
          : allUnfulfilledPartOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      newlyFulfilledPartOrders: null == newlyFulfilledPartOrders
          ? _value._newlyFulfilledPartOrders
          : newlyFulfilledPartOrders // ignore: cast_nullable_to_non_nullable
              as List<OrderEntity>,
      error: freezed == error ? _value.error! : error,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
>>>>>>> 9594ee4 (added state control to manage inventory page)
              as ManageInventoryStateStatus,
    ));
  }
}

/// @nodoc

class _$ManageInventoryStateImpl implements _ManageInventoryState {
  _$ManageInventoryStateImpl(
      {this.fetchPartAmount = 20,
      this.databaseLength = 0,
      final List<PartEntity> parts = const <PartEntity>[],
      final List<PartEntity> lowQuantityParts = const <PartEntity>[],
      final List<CheckedOutEntity> unverifiedParts = const <CheckedOutEntity>[],
      final List<CheckedOutEntity> newlyVerifiedParts =
          const <CheckedOutEntity>[],
      final List<CheckedOutEntity> checkedOutParts = const <CheckedOutEntity>[],
      final List<OrderEntity> allPartOrders = const <OrderEntity>[],
      final List<OrderEntity> allUnfulfilledPartOrders = const <OrderEntity>[],
      final List<OrderEntity> newlyFulfilledPartOrders = const <OrderEntity>[],
      this.error = 'no error',
      this.status = ManageInventoryStateStatus.loading})
      : _parts = parts,
        _lowQuantityParts = lowQuantityParts,
        _unverifiedParts = unverifiedParts,
        _newlyVerifiedParts = newlyVerifiedParts,
        _checkedOutParts = checkedOutParts,
        _allPartOrders = allPartOrders,
        _allUnfulfilledPartOrders = allUnfulfilledPartOrders,
        _newlyFulfilledPartOrders = newlyFulfilledPartOrders;

  @override
  @JsonKey()
  final int fetchPartAmount;
  @override
  @JsonKey()
  final int databaseLength;
  final List<PartEntity> _parts;
  @override
  @JsonKey()
  List<PartEntity> get parts {
    if (_parts is EqualUnmodifiableListView) return _parts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parts);
  }

  final List<PartEntity> _lowQuantityParts;
  @override
  @JsonKey()
  List<PartEntity> get lowQuantityParts {
    if (_lowQuantityParts is EqualUnmodifiableListView)
      return _lowQuantityParts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lowQuantityParts);
  }

  final List<CheckedOutEntity> _unverifiedParts;
  @override
  @JsonKey()
  List<CheckedOutEntity> get unverifiedParts {
    if (_unverifiedParts is EqualUnmodifiableListView) return _unverifiedParts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unverifiedParts);
  }

  final List<CheckedOutEntity> _newlyVerifiedParts;
  @override
  @JsonKey()
  List<CheckedOutEntity> get newlyVerifiedParts {
    if (_newlyVerifiedParts is EqualUnmodifiableListView)
      return _newlyVerifiedParts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newlyVerifiedParts);
  }

  final List<CheckedOutEntity> _checkedOutParts;
  @override
  @JsonKey()
  List<CheckedOutEntity> get checkedOutParts {
    if (_checkedOutParts is EqualUnmodifiableListView) return _checkedOutParts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checkedOutParts);
  }

  final List<OrderEntity> _allPartOrders;
  @override
  @JsonKey()
  List<OrderEntity> get allPartOrders {
    if (_allPartOrders is EqualUnmodifiableListView) return _allPartOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allPartOrders);
  }

  final List<OrderEntity> _allUnfulfilledPartOrders;
  @override
  @JsonKey()
  List<OrderEntity> get allUnfulfilledPartOrders {
    if (_allUnfulfilledPartOrders is EqualUnmodifiableListView)
      return _allUnfulfilledPartOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allUnfulfilledPartOrders);
  }

  final List<OrderEntity> _newlyFulfilledPartOrders;
  @override
  @JsonKey()
  List<OrderEntity> get newlyFulfilledPartOrders {
    if (_newlyFulfilledPartOrders is EqualUnmodifiableListView)
      return _newlyFulfilledPartOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newlyFulfilledPartOrders);
  }

  @override
  @JsonKey()
  final dynamic error;
  @override
  @JsonKey()
  final ManageInventoryStateStatus status;

  @override
  String toString() {
    return 'ManageInventoryState(fetchPartAmount: $fetchPartAmount, databaseLength: $databaseLength, parts: $parts, lowQuantityParts: $lowQuantityParts, unverifiedParts: $unverifiedParts, newlyVerifiedParts: $newlyVerifiedParts, checkedOutParts: $checkedOutParts, allPartOrders: $allPartOrders, allUnfulfilledPartOrders: $allUnfulfilledPartOrders, newlyFulfilledPartOrders: $newlyFulfilledPartOrders, error: $error, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManageInventoryStateImpl &&
            (identical(other.fetchPartAmount, fetchPartAmount) ||
                other.fetchPartAmount == fetchPartAmount) &&
            (identical(other.databaseLength, databaseLength) ||
                other.databaseLength == databaseLength) &&
            const DeepCollectionEquality().equals(other._parts, _parts) &&
            const DeepCollectionEquality()
                .equals(other._lowQuantityParts, _lowQuantityParts) &&
            const DeepCollectionEquality()
                .equals(other._unverifiedParts, _unverifiedParts) &&
            const DeepCollectionEquality()
                .equals(other._newlyVerifiedParts, _newlyVerifiedParts) &&
            const DeepCollectionEquality()
                .equals(other._checkedOutParts, _checkedOutParts) &&
            const DeepCollectionEquality()
                .equals(other._allPartOrders, _allPartOrders) &&
            const DeepCollectionEquality().equals(
                other._allUnfulfilledPartOrders, _allUnfulfilledPartOrders) &&
            const DeepCollectionEquality().equals(
                other._newlyFulfilledPartOrders, _newlyFulfilledPartOrders) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.status, status) || other.status == status));
>>>>>>> 9594ee4 (added state control to manage inventory page)
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      fetchPartAmount,
      databaseLength,
      const DeepCollectionEquality().hash(_parts),
      const DeepCollectionEquality().hash(_lowQuantityParts),
      const DeepCollectionEquality().hash(_unverifiedParts),
      const DeepCollectionEquality().hash(_newlyVerifiedParts),
      const DeepCollectionEquality().hash(_checkedOutParts),
      const DeepCollectionEquality().hash(_allPartOrders),
      const DeepCollectionEquality().hash(_allUnfulfilledPartOrders),
      const DeepCollectionEquality().hash(_newlyFulfilledPartOrders),
      const DeepCollectionEquality().hash(error),
      status);
>>>>>>> 9594ee4 (added state control to manage inventory page)

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ManageInventoryStateImplCopyWith<_$ManageInventoryStateImpl>
      get copyWith =>
          __$$ManageInventoryStateImplCopyWithImpl<_$ManageInventoryStateImpl>(
              this, _$identity);
}

abstract class _ManageInventoryState implements ManageInventoryState {
  factory _ManageInventoryState(
      {final int fetchPartAmount,
      final int databaseLength,
      final List<PartEntity> parts,
      final List<PartEntity> lowQuantityParts,
      final List<CheckedOutEntity> unverifiedParts,
      final List<CheckedOutEntity> newlyVerifiedParts,
      final List<CheckedOutEntity> checkedOutParts,
      final List<OrderEntity> allPartOrders,
      final List<OrderEntity> allUnfulfilledPartOrders,
      final List<OrderEntity> newlyFulfilledPartOrders,
      final dynamic error,
      final ManageInventoryStateStatus status}) = _$ManageInventoryStateImpl;

  @override
  int get fetchPartAmount;
  @override
  int get databaseLength;
  @override
  List<PartEntity> get parts;
  @override
  List<PartEntity> get lowQuantityParts;
  @override
  List<CheckedOutEntity> get unverifiedParts;
  @override
  List<CheckedOutEntity> get newlyVerifiedParts;
  @override
  List<CheckedOutEntity> get checkedOutParts;
  @override
  List<OrderEntity> get allPartOrders;
  @override
  List<OrderEntity> get allUnfulfilledPartOrders;
  @override
  List<OrderEntity> get newlyFulfilledPartOrders;
  @override
  dynamic get error;
  @override
  ManageInventoryStateStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$ManageInventoryStateImplCopyWith<_$ManageInventoryStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
