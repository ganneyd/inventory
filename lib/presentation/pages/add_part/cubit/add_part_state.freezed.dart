// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_part_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AddPartState {
  Part? get part => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  AddPartStateStatus get addPartStateStatus =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddPartStateCopyWith<AddPartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddPartStateCopyWith<$Res> {
  factory $AddPartStateCopyWith(
          AddPartState value, $Res Function(AddPartState) then) =
      _$AddPartStateCopyWithImpl<$Res, AddPartState>;
  @useResult
  $Res call({Part? part, String? error, AddPartStateStatus addPartStateStatus});

  $PartCopyWith<$Res>? get part;
}

/// @nodoc
class _$AddPartStateCopyWithImpl<$Res, $Val extends AddPartState>
    implements $AddPartStateCopyWith<$Res> {
  _$AddPartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? part = freezed,
    Object? error = freezed,
    Object? addPartStateStatus = null,
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
      addPartStateStatus: null == addPartStateStatus
          ? _value.addPartStateStatus
          : addPartStateStatus // ignore: cast_nullable_to_non_nullable
              as AddPartStateStatus,
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
abstract class _$$AddPartStateImplCopyWith<$Res>
    implements $AddPartStateCopyWith<$Res> {
  factory _$$AddPartStateImplCopyWith(
          _$AddPartStateImpl value, $Res Function(_$AddPartStateImpl) then) =
      __$$AddPartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Part? part, String? error, AddPartStateStatus addPartStateStatus});

  @override
  $PartCopyWith<$Res>? get part;
}

/// @nodoc
class __$$AddPartStateImplCopyWithImpl<$Res>
    extends _$AddPartStateCopyWithImpl<$Res, _$AddPartStateImpl>
    implements _$$AddPartStateImplCopyWith<$Res> {
  __$$AddPartStateImplCopyWithImpl(
      _$AddPartStateImpl _value, $Res Function(_$AddPartStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? part = freezed,
    Object? error = freezed,
    Object? addPartStateStatus = null,
  }) {
    return _then(_$AddPartStateImpl(
      part: freezed == part
          ? _value.part
          : part // ignore: cast_nullable_to_non_nullable
              as Part?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      addPartStateStatus: null == addPartStateStatus
          ? _value.addPartStateStatus
          : addPartStateStatus // ignore: cast_nullable_to_non_nullable
              as AddPartStateStatus,
    ));
  }
}

/// @nodoc

class _$AddPartStateImpl implements _AddPartState {
  _$AddPartStateImpl(
      {this.part,
      this.error,
      this.addPartStateStatus = AddPartStateStatus.loading});

  @override
  final Part? part;
  @override
  final String? error;
  @override
  @JsonKey()
  final AddPartStateStatus addPartStateStatus;

  @override
  String toString() {
    return 'AddPartState(part: $part, error: $error, addPartStateStatus: $addPartStateStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddPartStateImpl &&
            (identical(other.part, part) || other.part == part) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.addPartStateStatus, addPartStateStatus) ||
                other.addPartStateStatus == addPartStateStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, part, error, addPartStateStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddPartStateImplCopyWith<_$AddPartStateImpl> get copyWith =>
      __$$AddPartStateImplCopyWithImpl<_$AddPartStateImpl>(this, _$identity);
}

abstract class _AddPartState implements AddPartState {
  factory _AddPartState(
      {final Part? part,
      final String? error,
      final AddPartStateStatus addPartStateStatus}) = _$AddPartStateImpl;

  @override
  Part? get part;
  @override
  String? get error;
  @override
  AddPartStateStatus get addPartStateStatus;
  @override
  @JsonKey(ignore: true)
  _$$AddPartStateImplCopyWith<_$AddPartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
