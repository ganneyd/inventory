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
  Part? get part => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  ManageInventoryStateStatus get manageInventoryStateStatus =>
      throw _privateConstructorUsedError;

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
      {Part? part,
      String? error,
      ManageInventoryStateStatus manageInventoryStateStatus});

  $PartCopyWith<$Res>? get part;
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
    Object? part = freezed,
    Object? error = freezed,
    Object? manageInventoryStateStatus = null,
  }) {
    return _then(_value.copyWith(
      part: freezed == part
          ? _value.part
          : part // ignore: cast_nullable_to_non_nullable
              as Part?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      manageInventoryStateStatus: null == manageInventoryStateStatus
          ? _value.manageInventoryStateStatus
          : manageInventoryStateStatus // ignore: cast_nullable_to_non_nullable
              as ManageInventoryStateStatus,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PartCopyWith<$Res>? get part {
    if (_value.part == null) {
      return null;
    }

    return $PartCopyWith<$Res>(_value.part!, (value) {
      return _then(_value.copyWith(part: value) as $Val);
    });
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
      {Part? part,
      String? error,
      ManageInventoryStateStatus manageInventoryStateStatus});

  @override
  $PartCopyWith<$Res>? get part;
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
    Object? part = freezed,
    Object? error = freezed,
    Object? manageInventoryStateStatus = null,
  }) {
    return _then(_$ManageInventoryStateImpl(
      part: freezed == part
          ? _value.part
          : part // ignore: cast_nullable_to_non_nullable
              as Part?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      manageInventoryStateStatus: null == manageInventoryStateStatus
          ? _value.manageInventoryStateStatus
          : manageInventoryStateStatus // ignore: cast_nullable_to_non_nullable
              as ManageInventoryStateStatus,
    ));
  }
}

/// @nodoc

class _$ManageInventoryStateImpl implements _ManageInventoryState {
  _$ManageInventoryStateImpl(
      {this.part,
      this.error,
      this.manageInventoryStateStatus = ManageInventoryStateStatus.loading});

  @override
  final Part? part;
  @override
  final String? error;
  @override
  @JsonKey()
  final ManageInventoryStateStatus manageInventoryStateStatus;

  @override
  String toString() {
    return 'ManageInventoryState(part: $part, error: $error, manageInventoryStateStatus: $manageInventoryStateStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManageInventoryStateImpl &&
            (identical(other.part, part) || other.part == part) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.manageInventoryStateStatus,
                    manageInventoryStateStatus) ||
                other.manageInventoryStateStatus ==
                    manageInventoryStateStatus));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, part, error, manageInventoryStateStatus);

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
          {final Part? part,
          final String? error,
          final ManageInventoryStateStatus manageInventoryStateStatus}) =
      _$ManageInventoryStateImpl;

  @override
  Part? get part;
  @override
  String? get error;
  @override
  ManageInventoryStateStatus get manageInventoryStateStatus;
  @override
  @JsonKey(ignore: true)
  _$$ManageInventoryStateImplCopyWith<_$ManageInventoryStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
