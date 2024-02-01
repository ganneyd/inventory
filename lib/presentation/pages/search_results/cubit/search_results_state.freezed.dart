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
  ScrollController get scrollController => throw _privateConstructorUsedError;
  List<Part> get parts => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  SearchResultsStateStatus get status => throw _privateConstructorUsedError;

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
      {ScrollController scrollController,
      List<Part> parts,
      String error,
      SearchResultsStateStatus status});
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
    Object? scrollController = null,
    Object? parts = null,
    Object? error = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      scrollController: null == scrollController
          ? _value.scrollController
          : scrollController // ignore: cast_nullable_to_non_nullable
              as ScrollController,
      parts: null == parts
          ? _value.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<Part>,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SearchResultsStateStatus,
    ) as $Val);
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
      {ScrollController scrollController,
      List<Part> parts,
      String error,
      SearchResultsStateStatus status});
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
    Object? scrollController = null,
    Object? parts = null,
    Object? error = null,
    Object? status = null,
  }) {
    return _then(_$SearchResultsStateImpl(
      scrollController: null == scrollController
          ? _value.scrollController
          : scrollController // ignore: cast_nullable_to_non_nullable
              as ScrollController,
      parts: null == parts
          ? _value._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<Part>,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SearchResultsStateStatus,
    ));
  }
}

/// @nodoc

class _$SearchResultsStateImpl implements _SearchResultsState {
  _$SearchResultsStateImpl(
      {required this.scrollController,
      final List<Part> parts = const <Part>[],
      this.error = 'no-error',
      this.status = SearchResultsStateStatus.loading})
      : _parts = parts;

  @override
  final ScrollController scrollController;
  final List<Part> _parts;
  @override
  @JsonKey()
  List<Part> get parts {
    if (_parts is EqualUnmodifiableListView) return _parts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parts);
  }

  @override
  @JsonKey()
  final String error;
  @override
  @JsonKey()
  final SearchResultsStateStatus status;

  @override
  String toString() {
    return 'SearchResultsState(scrollController: $scrollController, parts: $parts, error: $error, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultsStateImpl &&
            (identical(other.scrollController, scrollController) ||
                other.scrollController == scrollController) &&
            const DeepCollectionEquality().equals(other._parts, _parts) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, scrollController,
      const DeepCollectionEquality().hash(_parts), error, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultsStateImplCopyWith<_$SearchResultsStateImpl> get copyWith =>
      __$$SearchResultsStateImplCopyWithImpl<_$SearchResultsStateImpl>(
          this, _$identity);
}

abstract class _SearchResultsState implements SearchResultsState {
  factory _SearchResultsState(
      {required final ScrollController scrollController,
      final List<Part> parts,
      final String error,
      final SearchResultsStateStatus status}) = _$SearchResultsStateImpl;

  @override
  ScrollController get scrollController;
  @override
  List<Part> get parts;
  @override
  String get error;
  @override
  SearchResultsStateStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$SearchResultsStateImplCopyWith<_$SearchResultsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
