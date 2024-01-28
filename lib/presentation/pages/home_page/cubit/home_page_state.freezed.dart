// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomePageState {
  Part? get part => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  HomePageStateStatus get addPartStateStatus =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomePageStateCopyWith<HomePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageStateCopyWith<$Res> {
  factory $HomePageStateCopyWith(
          HomePageState value, $Res Function(HomePageState) then) =
      _$HomePageStateCopyWithImpl<$Res, HomePageState>;
  @useResult
  $Res call(
      {Part? part, String? error, HomePageStateStatus addPartStateStatus});

  $PartCopyWith<$Res>? get part;
}

/// @nodoc
class _$HomePageStateCopyWithImpl<$Res, $Val extends HomePageState>
    implements $HomePageStateCopyWith<$Res> {
  _$HomePageStateCopyWithImpl(this._value, this._then);

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
              as HomePageStateStatus,
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
abstract class _$$HomePageStateImplCopyWith<$Res>
    implements $HomePageStateCopyWith<$Res> {
  factory _$$HomePageStateImplCopyWith(
          _$HomePageStateImpl value, $Res Function(_$HomePageStateImpl) then) =
      __$$HomePageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Part? part, String? error, HomePageStateStatus addPartStateStatus});

  @override
  $PartCopyWith<$Res>? get part;
}

/// @nodoc
class __$$HomePageStateImplCopyWithImpl<$Res>
    extends _$HomePageStateCopyWithImpl<$Res, _$HomePageStateImpl>
    implements _$$HomePageStateImplCopyWith<$Res> {
  __$$HomePageStateImplCopyWithImpl(
      _$HomePageStateImpl _value, $Res Function(_$HomePageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? part = freezed,
    Object? error = freezed,
    Object? addPartStateStatus = null,
  }) {
    return _then(_$HomePageStateImpl(
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
              as HomePageStateStatus,
    ));
  }
}

/// @nodoc

class _$HomePageStateImpl implements _HomePageState {
  _$HomePageStateImpl(
      {this.part,
      this.error,
      this.addPartStateStatus = HomePageStateStatus.loading});

  @override
  final Part? part;
  @override
  final String? error;
  @override
  @JsonKey()
  final HomePageStateStatus addPartStateStatus;

  @override
  String toString() {
    return 'HomePageState(part: $part, error: $error, addPartStateStatus: $addPartStateStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomePageStateImpl &&
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
  _$$HomePageStateImplCopyWith<_$HomePageStateImpl> get copyWith =>
      __$$HomePageStateImplCopyWithImpl<_$HomePageStateImpl>(this, _$identity);
}

abstract class _HomePageState implements HomePageState {
  factory _HomePageState(
      {final Part? part,
      final String? error,
      final HomePageStateStatus addPartStateStatus}) = _$HomePageStateImpl;

  @override
  Part? get part;
  @override
  String? get error;
  @override
  HomePageStateStatus get addPartStateStatus;
  @override
  @JsonKey(ignore: true)
  _$$HomePageStateImplCopyWith<_$HomePageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
