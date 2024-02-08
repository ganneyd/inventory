// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'part_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PartViewState {
  PartEntity? get part => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  PartViewStateStatus get partViewStateStatuse =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PartViewStateCopyWith<PartViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartViewStateCopyWith<$Res> {
  factory $PartViewStateCopyWith(
          PartViewState value, $Res Function(PartViewState) then) =
      _$PartViewStateCopyWithImpl<$Res, PartViewState>;
  @useResult
  $Res call(
      {PartEntity? part,
      String? error,
      PartViewStateStatus partViewStateStatuse});
}

/// @nodoc
class _$PartViewStateCopyWithImpl<$Res, $Val extends PartViewState>
    implements $PartViewStateCopyWith<$Res> {
  _$PartViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? part = freezed,
    Object? error = freezed,
    Object? partViewStateStatuse = null,
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
      partViewStateStatuse: null == partViewStateStatuse
          ? _value.partViewStateStatuse
          : partViewStateStatuse // ignore: cast_nullable_to_non_nullable
              as PartViewStateStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartViewStateImplCopyWith<$Res>
    implements $PartViewStateCopyWith<$Res> {
  factory _$$PartViewStateImplCopyWith(
          _$PartViewStateImpl value, $Res Function(_$PartViewStateImpl) then) =
      __$$PartViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PartEntity? part,
      String? error,
      PartViewStateStatus partViewStateStatuse});
}

/// @nodoc
class __$$PartViewStateImplCopyWithImpl<$Res>
    extends _$PartViewStateCopyWithImpl<$Res, _$PartViewStateImpl>
    implements _$$PartViewStateImplCopyWith<$Res> {
  __$$PartViewStateImplCopyWithImpl(
      _$PartViewStateImpl _value, $Res Function(_$PartViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? part = freezed,
    Object? error = freezed,
    Object? partViewStateStatuse = null,
  }) {
    return _then(_$PartViewStateImpl(
      part: freezed == part
          ? _value.part
          : part // ignore: cast_nullable_to_non_nullable
              as PartEntity?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      partViewStateStatuse: null == partViewStateStatuse
          ? _value.partViewStateStatuse
          : partViewStateStatuse // ignore: cast_nullable_to_non_nullable
              as PartViewStateStatus,
    ));
  }
}

/// @nodoc

class _$PartViewStateImpl implements _PartViewState {
  _$PartViewStateImpl(
      {this.part,
      this.error,
      this.partViewStateStatuse = PartViewStateStatus.loading});

  @override
  final PartEntity? part;
  @override
  final String? error;
  @override
  @JsonKey()
  final PartViewStateStatus partViewStateStatuse;

  @override
  String toString() {
    return 'PartViewState(part: $part, error: $error, partViewStateStatuse: $partViewStateStatuse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartViewStateImpl &&
            (identical(other.part, part) || other.part == part) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.partViewStateStatuse, partViewStateStatuse) ||
                other.partViewStateStatuse == partViewStateStatuse));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, part, error, partViewStateStatuse);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PartViewStateImplCopyWith<_$PartViewStateImpl> get copyWith =>
      __$$PartViewStateImplCopyWithImpl<_$PartViewStateImpl>(this, _$identity);
}

abstract class _PartViewState implements PartViewState {
  factory _PartViewState(
      {final PartEntity? part,
      final String? error,
      final PartViewStateStatus partViewStateStatuse}) = _$PartViewStateImpl;

  @override
  PartEntity? get part;
  @override
  String? get error;
  @override
  PartViewStateStatus get partViewStateStatuse;
  @override
  @JsonKey(ignore: true)
  _$$PartViewStateImplCopyWith<_$PartViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
