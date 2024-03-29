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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddPartState {
  PartEntity? get part => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get isFormValid => throw _privateConstructorUsedError;
  UnitOfIssue get unitOfIssue => throw _privateConstructorUsedError;
  List<PartEntity> get existingParts => throw _privateConstructorUsedError;
  dynamic get addPartStateStatus => throw _privateConstructorUsedError;

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
  $Res call(
      {PartEntity? part,
      String? error,
      bool isFormValid,
      UnitOfIssue unitOfIssue,
      List<PartEntity> existingParts,
      dynamic addPartStateStatus});
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
    Object? isFormValid = null,
    Object? unitOfIssue = null,
    Object? existingParts = null,
    Object? addPartStateStatus = freezed,
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
      isFormValid: null == isFormValid
          ? _value.isFormValid
          : isFormValid // ignore: cast_nullable_to_non_nullable
              as bool,
      unitOfIssue: null == unitOfIssue
          ? _value.unitOfIssue
          : unitOfIssue // ignore: cast_nullable_to_non_nullable
              as UnitOfIssue,
      existingParts: null == existingParts
          ? _value.existingParts
          : existingParts // ignore: cast_nullable_to_non_nullable
              as List<PartEntity>,
      addPartStateStatus: freezed == addPartStateStatus
          ? _value.addPartStateStatus
          : addPartStateStatus // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
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
  $Res call(
      {PartEntity? part,
      String? error,
      bool isFormValid,
      UnitOfIssue unitOfIssue,
      List<PartEntity> existingParts,
      dynamic addPartStateStatus});
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
    Object? isFormValid = null,
    Object? unitOfIssue = null,
    Object? existingParts = null,
    Object? addPartStateStatus = freezed,
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
      isFormValid: null == isFormValid
          ? _value.isFormValid
          : isFormValid // ignore: cast_nullable_to_non_nullable
              as bool,
      unitOfIssue: null == unitOfIssue
          ? _value.unitOfIssue
          : unitOfIssue // ignore: cast_nullable_to_non_nullable
              as UnitOfIssue,
      existingParts: null == existingParts
          ? _value._existingParts
          : existingParts // ignore: cast_nullable_to_non_nullable
              as List<PartEntity>,
      addPartStateStatus: freezed == addPartStateStatus
          ? _value.addPartStateStatus!
          : addPartStateStatus,
    ));
  }
}

/// @nodoc

class _$AddPartStateImpl implements _AddPartState {
  _$AddPartStateImpl(
      {this.part,
      this.error,
      this.isFormValid = false,
      this.unitOfIssue = UnitOfIssue.EA,
      final List<PartEntity> existingParts = const <PartEntity>[],
      this.addPartStateStatus = AddPartStateStatus.loading})
      : _existingParts = existingParts;

  @override
  final PartEntity? part;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool isFormValid;
  @override
  @JsonKey()
  final UnitOfIssue unitOfIssue;
  final List<PartEntity> _existingParts;
  @override
  @JsonKey()
  List<PartEntity> get existingParts {
    if (_existingParts is EqualUnmodifiableListView) return _existingParts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_existingParts);
  }

  @override
  @JsonKey()
  final dynamic addPartStateStatus;

  @override
  String toString() {
    return 'AddPartState(part: $part, error: $error, isFormValid: $isFormValid, unitOfIssue: $unitOfIssue, existingParts: $existingParts, addPartStateStatus: $addPartStateStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddPartStateImpl &&
            (identical(other.part, part) || other.part == part) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isFormValid, isFormValid) ||
                other.isFormValid == isFormValid) &&
            (identical(other.unitOfIssue, unitOfIssue) ||
                other.unitOfIssue == unitOfIssue) &&
            const DeepCollectionEquality()
                .equals(other._existingParts, _existingParts) &&
            const DeepCollectionEquality()
                .equals(other.addPartStateStatus, addPartStateStatus));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      part,
      error,
      isFormValid,
      unitOfIssue,
      const DeepCollectionEquality().hash(_existingParts),
      const DeepCollectionEquality().hash(addPartStateStatus));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddPartStateImplCopyWith<_$AddPartStateImpl> get copyWith =>
      __$$AddPartStateImplCopyWithImpl<_$AddPartStateImpl>(this, _$identity);
}

abstract class _AddPartState implements AddPartState {
  factory _AddPartState(
      {final PartEntity? part,
      final String? error,
      final bool isFormValid,
      final UnitOfIssue unitOfIssue,
      final List<PartEntity> existingParts,
      final dynamic addPartStateStatus}) = _$AddPartStateImpl;

  @override
  PartEntity? get part;
  @override
  String? get error;
  @override
  bool get isFormValid;
  @override
  UnitOfIssue get unitOfIssue;
  @override
  List<PartEntity> get existingParts;
  @override
  dynamic get addPartStateStatus;
  @override
  @JsonKey(ignore: true)
  _$$AddPartStateImplCopyWith<_$AddPartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
