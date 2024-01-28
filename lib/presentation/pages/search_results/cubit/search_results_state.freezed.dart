// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_results_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SearchResultsState {
  Part? get part => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  SearchResultsStateStatus get searchResultsStateStatus =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchResultsStateCopyWith<SearchResultsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultsStateCopyWith<$Res> {
  factory $SearchResultsStateCopyWith(
          SearchResultsState value, $Res Function(SearchResultsState) then) =
      _$SearchResultsStateCopyWithImpl<$Res, SearchResultsState>;
  @useResult
  $Res call(
      {Part? part,
      String? error,
      SearchResultsStateStatus searchResultsStateStatus});

  $PartCopyWith<$Res>? get part;
}

/// @nodoc
class _$SearchResultsStateCopyWithImpl<$Res, $Val extends SearchResultsState>
    implements $SearchResultsStateCopyWith<$Res> {
  _$SearchResultsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? part = freezed,
    Object? error = freezed,
    Object? searchResultsStateStatus = null,
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
      searchResultsStateStatus: null == searchResultsStateStatus
          ? _value.searchResultsStateStatus
          : searchResultsStateStatus // ignore: cast_nullable_to_non_nullable
              as SearchResultsStateStatus,
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
abstract class _$$SearchResultsStateImplCopyWith<$Res>
    implements $SearchResultsStateCopyWith<$Res> {
  factory _$$SearchResultsStateImplCopyWith(_$SearchResultsStateImpl value,
          $Res Function(_$SearchResultsStateImpl) then) =
      __$$SearchResultsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Part? part,
      String? error,
      SearchResultsStateStatus searchResultsStateStatus});

  @override
  $PartCopyWith<$Res>? get part;
}

/// @nodoc
class __$$SearchResultsStateImplCopyWithImpl<$Res>
    extends _$SearchResultsStateCopyWithImpl<$Res, _$SearchResultsStateImpl>
    implements _$$SearchResultsStateImplCopyWith<$Res> {
  __$$SearchResultsStateImplCopyWithImpl(_$SearchResultsStateImpl _value,
      $Res Function(_$SearchResultsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? part = freezed,
    Object? error = freezed,
    Object? searchResultsStateStatus = null,
  }) {
    return _then(_$SearchResultsStateImpl(
      part: freezed == part
          ? _value.part
          : part // ignore: cast_nullable_to_non_nullable
              as Part?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      searchResultsStateStatus: null == searchResultsStateStatus
          ? _value.searchResultsStateStatus
          : searchResultsStateStatus // ignore: cast_nullable_to_non_nullable
              as SearchResultsStateStatus,
    ));
  }
}

/// @nodoc

class _$SearchResultsStateImpl implements _SearchResultsState {
  _$SearchResultsStateImpl(
      {this.part,
      this.error,
      this.searchResultsStateStatus = SearchResultsStateStatus.loading});

  @override
  final Part? part;
  @override
  final String? error;
  @override
  @JsonKey()
  final SearchResultsStateStatus searchResultsStateStatus;

  @override
  String toString() {
    return 'SearchResultsState(part: $part, error: $error, searchResultsStateStatus: $searchResultsStateStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultsStateImpl &&
            (identical(other.part, part) || other.part == part) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(
                    other.searchResultsStateStatus, searchResultsStateStatus) ||
                other.searchResultsStateStatus == searchResultsStateStatus));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, part, error, searchResultsStateStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultsStateImplCopyWith<_$SearchResultsStateImpl> get copyWith =>
      __$$SearchResultsStateImplCopyWithImpl<_$SearchResultsStateImpl>(
          this, _$identity);
}

abstract class _SearchResultsState implements SearchResultsState {
  factory _SearchResultsState(
          {final Part? part,
          final String? error,
          final SearchResultsStateStatus searchResultsStateStatus}) =
      _$SearchResultsStateImpl;

  @override
  Part? get part;
  @override
  String? get error;
  @override
  SearchResultsStateStatus get searchResultsStateStatus;
  @override
  @JsonKey(ignore: true)
  _$$SearchResultsStateImplCopyWith<_$SearchResultsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
