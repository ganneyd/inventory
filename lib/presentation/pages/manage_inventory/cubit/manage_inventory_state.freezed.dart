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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ManageInventoryState {
  int get fetchPartAmount => throw _privateConstructorUsedError;
  int get databaseLength => throw _privateConstructorUsedError;
  ScrollController get scrollController => throw _privateConstructorUsedError;
  List<PartEntity> get parts => throw _privateConstructorUsedError;
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
      ScrollController scrollController,
      List<PartEntity> parts,
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
    Object? scrollController = null,
<<<<<<< HEAD
    Object? part = null,
=======
    Object? parts = null,
>>>>>>> 9594ee4 (added state control to manage inventory page)
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
      scrollController: null == scrollController
          ? _value.scrollController
          : scrollController // ignore: cast_nullable_to_non_nullable
              as ScrollController,
<<<<<<< HEAD
      part: null == part
          ? _value.part
          : part // ignore: cast_nullable_to_non_nullable
=======
      parts: null == parts
          ? _value.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<PartEntity>,
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
      ScrollController scrollController,
      List<PartEntity> parts,
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
    Object? scrollController = null,
<<<<<<< HEAD
    Object? part = null,
=======
    Object? parts = null,
>>>>>>> 9594ee4 (added state control to manage inventory page)
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
      scrollController: null == scrollController
          ? _value.scrollController
          : scrollController // ignore: cast_nullable_to_non_nullable
              as ScrollController,
<<<<<<< HEAD
      part: null == part
          ? _value._part
          : part // ignore: cast_nullable_to_non_nullable
              as List<Part>,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      manageInventoryStateStatus: null == manageInventoryStateStatus
          ? _value.manageInventoryStateStatus
          : manageInventoryStateStatus // ignore: cast_nullable_to_non_nullable
=======
      parts: null == parts
          ? _value._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<PartEntity>,
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
      required this.scrollController,
      final List<PartEntity> parts = const <PartEntity>[],
      this.error = 'no error',
      this.status = ManageInventoryStateStatus.loading})
      : _parts = parts;

  @override
  @JsonKey()
  final int fetchPartAmount;
  @override
  @JsonKey()
  final int databaseLength;
  @override
  final ScrollController scrollController;
  final List<PartEntity> _parts;
  @override
  @JsonKey()
  List<PartEntity> get parts {
    if (_parts is EqualUnmodifiableListView) return _parts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parts);
  }

  @override
  @JsonKey()
  final dynamic error;
  @override
  @JsonKey()
  final ManageInventoryStateStatus status;

  @override
  String toString() {
    return 'ManageInventoryState(fetchPartAmount: $fetchPartAmount, databaseLength: $databaseLength, scrollController: $scrollController, parts: $parts, error: $error, status: $status)';
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
            (identical(other.scrollController, scrollController) ||
                other.scrollController == scrollController) &&
<<<<<<< HEAD
            const DeepCollectionEquality().equals(other._part, _part) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.manageInventoryStateStatus,
                    manageInventoryStateStatus) ||
                other.manageInventoryStateStatus ==
                    manageInventoryStateStatus));
=======
            const DeepCollectionEquality().equals(other._parts, _parts) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.status, status) || other.status == status));
>>>>>>> 9594ee4 (added state control to manage inventory page)
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      fetchPartAmount,
      databaseLength,
      scrollController,
<<<<<<< HEAD
      const DeepCollectionEquality().hash(_part),
      error,
      manageInventoryStateStatus);
=======
      const DeepCollectionEquality().hash(_parts),
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
      required final ScrollController scrollController,
      final List<PartEntity> parts,
      final dynamic error,
      final ManageInventoryStateStatus status}) = _$ManageInventoryStateImpl;

  @override
  int get fetchPartAmount;
  @override
  int get databaseLength;
  @override
  ScrollController get scrollController;
>>>>>>> 9594ee4 (added state control to manage inventory page)
  @override
  List<PartEntity> get parts;
  @override
  dynamic get error;
  @override
  ManageInventoryStateStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$ManageInventoryStateImplCopyWith<_$ManageInventoryStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
