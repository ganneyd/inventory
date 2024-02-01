// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_part_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EditPartState {
  PartEntity get partEntity => throw _privateConstructorUsedError;
  String get errorMsg => throw _privateConstructorUsedError;
  EditPartStateStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditPartStateCopyWith<EditPartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditPartStateCopyWith<$Res> {
  factory $EditPartStateCopyWith(
          EditPartState value, $Res Function(EditPartState) then) =
      _$EditPartStateCopyWithImpl<$Res, EditPartState>;
  @useResult
  $Res call(
      {PartEntity partEntity, String errorMsg, EditPartStateStatus status});
}

/// @nodoc
class _$EditPartStateCopyWithImpl<$Res, $Val extends EditPartState>
    implements $EditPartStateCopyWith<$Res> {
  _$EditPartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partEntity = null,
    Object? errorMsg = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      partEntity: null == partEntity
          ? _value.partEntity
          : partEntity // ignore: cast_nullable_to_non_nullable
              as PartEntity,
      errorMsg: null == errorMsg
          ? _value.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EditPartStateStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditPartStateImplCopyWith<$Res>
    implements $EditPartStateCopyWith<$Res> {
  factory _$$EditPartStateImplCopyWith(
          _$EditPartStateImpl value, $Res Function(_$EditPartStateImpl) then) =
      __$$EditPartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PartEntity partEntity, String errorMsg, EditPartStateStatus status});
}

/// @nodoc
class __$$EditPartStateImplCopyWithImpl<$Res>
    extends _$EditPartStateCopyWithImpl<$Res, _$EditPartStateImpl>
    implements _$$EditPartStateImplCopyWith<$Res> {
  __$$EditPartStateImplCopyWithImpl(
      _$EditPartStateImpl _value, $Res Function(_$EditPartStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partEntity = null,
    Object? errorMsg = null,
    Object? status = null,
  }) {
    return _then(_$EditPartStateImpl(
      partEntity: null == partEntity
          ? _value.partEntity
          : partEntity // ignore: cast_nullable_to_non_nullable
              as PartEntity,
      errorMsg: null == errorMsg
          ? _value.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EditPartStateStatus,
    ));
  }
}

/// @nodoc

class _$EditPartStateImpl implements _EditPartState {
  _$EditPartStateImpl(
      {required this.partEntity,
      this.errorMsg = '',
      this.status = EditPartStateStatus.loading});

  @override
  final PartEntity partEntity;
  @override
  @JsonKey()
  final String errorMsg;
  @override
  @JsonKey()
  final EditPartStateStatus status;

  @override
  String toString() {
    return 'EditPartState(partEntity: $partEntity, errorMsg: $errorMsg, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditPartStateImpl &&
            (identical(other.partEntity, partEntity) ||
                other.partEntity == partEntity) &&
            (identical(other.errorMsg, errorMsg) ||
                other.errorMsg == errorMsg) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, partEntity, errorMsg, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditPartStateImplCopyWith<_$EditPartStateImpl> get copyWith =>
      __$$EditPartStateImplCopyWithImpl<_$EditPartStateImpl>(this, _$identity);
}

abstract class _EditPartState implements EditPartState {
  factory _EditPartState(
      {required final PartEntity partEntity,
      final String errorMsg,
      final EditPartStateStatus status}) = _$EditPartStateImpl;

  @override
  PartEntity get partEntity;
  @override
  String get errorMsg;
  @override
  EditPartStateStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$EditPartStateImplCopyWith<_$EditPartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
