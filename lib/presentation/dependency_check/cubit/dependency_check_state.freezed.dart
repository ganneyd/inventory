// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dependency_check_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DependencyCheckState {
  String? get error => throw _privateConstructorUsedError;
  DependencyCheckStateStatus get dependencyCheckStateStatus =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DependencyCheckStateCopyWith<DependencyCheckState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DependencyCheckStateCopyWith<$Res> {
  factory $DependencyCheckStateCopyWith(DependencyCheckState value,
          $Res Function(DependencyCheckState) then) =
      _$DependencyCheckStateCopyWithImpl<$Res, DependencyCheckState>;
  @useResult
  $Res call(
      {String? error, DependencyCheckStateStatus dependencyCheckStateStatus});
}

/// @nodoc
class _$DependencyCheckStateCopyWithImpl<$Res,
        $Val extends DependencyCheckState>
    implements $DependencyCheckStateCopyWith<$Res> {
  _$DependencyCheckStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? dependencyCheckStateStatus = null,
  }) {
    return _then(_value.copyWith(
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      dependencyCheckStateStatus: null == dependencyCheckStateStatus
          ? _value.dependencyCheckStateStatus
          : dependencyCheckStateStatus // ignore: cast_nullable_to_non_nullable
              as DependencyCheckStateStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DependencyCheckStateImplCopyWith<$Res>
    implements $DependencyCheckStateCopyWith<$Res> {
  factory _$$DependencyCheckStateImplCopyWith(_$DependencyCheckStateImpl value,
          $Res Function(_$DependencyCheckStateImpl) then) =
      __$$DependencyCheckStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? error, DependencyCheckStateStatus dependencyCheckStateStatus});
}

/// @nodoc
class __$$DependencyCheckStateImplCopyWithImpl<$Res>
    extends _$DependencyCheckStateCopyWithImpl<$Res, _$DependencyCheckStateImpl>
    implements _$$DependencyCheckStateImplCopyWith<$Res> {
  __$$DependencyCheckStateImplCopyWithImpl(_$DependencyCheckStateImpl _value,
      $Res Function(_$DependencyCheckStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? dependencyCheckStateStatus = null,
  }) {
    return _then(_$DependencyCheckStateImpl(
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      dependencyCheckStateStatus: null == dependencyCheckStateStatus
          ? _value.dependencyCheckStateStatus
          : dependencyCheckStateStatus // ignore: cast_nullable_to_non_nullable
              as DependencyCheckStateStatus,
    ));
  }
}

/// @nodoc

class _$DependencyCheckStateImpl implements _DependencyCheckState {
  _$DependencyCheckStateImpl(
      {this.error,
      this.dependencyCheckStateStatus = DependencyCheckStateStatus.loading});

  @override
  final String? error;
  @override
  @JsonKey()
  final DependencyCheckStateStatus dependencyCheckStateStatus;

  @override
  String toString() {
    return 'DependencyCheckState(error: $error, dependencyCheckStateStatus: $dependencyCheckStateStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DependencyCheckStateImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.dependencyCheckStateStatus,
                    dependencyCheckStateStatus) ||
                other.dependencyCheckStateStatus ==
                    dependencyCheckStateStatus));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, error, dependencyCheckStateStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DependencyCheckStateImplCopyWith<_$DependencyCheckStateImpl>
      get copyWith =>
          __$$DependencyCheckStateImplCopyWithImpl<_$DependencyCheckStateImpl>(
              this, _$identity);
}

abstract class _DependencyCheckState implements DependencyCheckState {
  factory _DependencyCheckState(
          {final String? error,
          final DependencyCheckStateStatus dependencyCheckStateStatus}) =
      _$DependencyCheckStateImpl;

  @override
  String? get error;
  @override
  DependencyCheckStateStatus get dependencyCheckStateStatus;
  @override
  @JsonKey(ignore: true)
  _$$DependencyCheckStateImplCopyWith<_$DependencyCheckStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
