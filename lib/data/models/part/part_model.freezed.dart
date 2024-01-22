// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'part_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Part _$PartFromJson(Map<String, dynamic> json) {
  return _PartModel.fromJson(json);
}

/// @nodoc
mixin _$Part {
  String get name => throw _privateConstructorUsedError;
  String get nsn => throw _privateConstructorUsedError;
  String get partNumber => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get requisitionPoint => throw _privateConstructorUsedError;
  int get requisitionQuantity => throw _privateConstructorUsedError;
  String get serialNumber => throw _privateConstructorUsedError;
  UnitOfIssue get unitOfIssue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PartCopyWith<Part> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartCopyWith<$Res> {
  factory $PartCopyWith(Part value, $Res Function(Part) then) =
      _$PartCopyWithImpl<$Res, Part>;
  @useResult
  $Res call(
      {String name,
      String nsn,
      String partNumber,
      String location,
      int quantity,
      int requisitionPoint,
      int requisitionQuantity,
      String serialNumber,
      UnitOfIssue unitOfIssue});
}

/// @nodoc
class _$PartCopyWithImpl<$Res, $Val extends Part>
    implements $PartCopyWith<$Res> {
  _$PartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? nsn = null,
    Object? partNumber = null,
    Object? location = null,
    Object? quantity = null,
    Object? requisitionPoint = null,
    Object? requisitionQuantity = null,
    Object? serialNumber = null,
    Object? unitOfIssue = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nsn: null == nsn
          ? _value.nsn
          : nsn // ignore: cast_nullable_to_non_nullable
              as String,
      partNumber: null == partNumber
          ? _value.partNumber
          : partNumber // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      requisitionPoint: null == requisitionPoint
          ? _value.requisitionPoint
          : requisitionPoint // ignore: cast_nullable_to_non_nullable
              as int,
      requisitionQuantity: null == requisitionQuantity
          ? _value.requisitionQuantity
          : requisitionQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      serialNumber: null == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String,
      unitOfIssue: null == unitOfIssue
          ? _value.unitOfIssue
          : unitOfIssue // ignore: cast_nullable_to_non_nullable
              as UnitOfIssue,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartModelImplCopyWith<$Res> implements $PartCopyWith<$Res> {
  factory _$$PartModelImplCopyWith(
          _$PartModelImpl value, $Res Function(_$PartModelImpl) then) =
      __$$PartModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String nsn,
      String partNumber,
      String location,
      int quantity,
      int requisitionPoint,
      int requisitionQuantity,
      String serialNumber,
      UnitOfIssue unitOfIssue});
}

/// @nodoc
class __$$PartModelImplCopyWithImpl<$Res>
    extends _$PartCopyWithImpl<$Res, _$PartModelImpl>
    implements _$$PartModelImplCopyWith<$Res> {
  __$$PartModelImplCopyWithImpl(
      _$PartModelImpl _value, $Res Function(_$PartModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? nsn = null,
    Object? partNumber = null,
    Object? location = null,
    Object? quantity = null,
    Object? requisitionPoint = null,
    Object? requisitionQuantity = null,
    Object? serialNumber = null,
    Object? unitOfIssue = null,
  }) {
    return _then(_$PartModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nsn: null == nsn
          ? _value.nsn
          : nsn // ignore: cast_nullable_to_non_nullable
              as String,
      partNumber: null == partNumber
          ? _value.partNumber
          : partNumber // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      requisitionPoint: null == requisitionPoint
          ? _value.requisitionPoint
          : requisitionPoint // ignore: cast_nullable_to_non_nullable
              as int,
      requisitionQuantity: null == requisitionQuantity
          ? _value.requisitionQuantity
          : requisitionQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      serialNumber: null == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String,
      unitOfIssue: null == unitOfIssue
          ? _value.unitOfIssue
          : unitOfIssue // ignore: cast_nullable_to_non_nullable
              as UnitOfIssue,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartModelImpl implements _PartModel {
  _$PartModelImpl(
      {required this.name,
      required this.nsn,
      required this.partNumber,
      required this.location,
      required this.quantity,
      required this.requisitionPoint,
      required this.requisitionQuantity,
      required this.serialNumber,
      required this.unitOfIssue});

  factory _$PartModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartModelImplFromJson(json);

  @override
  final String name;
  @override
  final String nsn;
  @override
  final String partNumber;
  @override
  final String location;
  @override
  final int quantity;
  @override
  final int requisitionPoint;
  @override
  final int requisitionQuantity;
  @override
  final String serialNumber;
  @override
  final UnitOfIssue unitOfIssue;

  @override
  String toString() {
    return 'Part(name: $name, nsn: $nsn, partNumber: $partNumber, location: $location, quantity: $quantity, requisitionPoint: $requisitionPoint, requisitionQuantity: $requisitionQuantity, serialNumber: $serialNumber, unitOfIssue: $unitOfIssue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nsn, nsn) || other.nsn == nsn) &&
            (identical(other.partNumber, partNumber) ||
                other.partNumber == partNumber) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.requisitionPoint, requisitionPoint) ||
                other.requisitionPoint == requisitionPoint) &&
            (identical(other.requisitionQuantity, requisitionQuantity) ||
                other.requisitionQuantity == requisitionQuantity) &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.unitOfIssue, unitOfIssue) ||
                other.unitOfIssue == unitOfIssue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      nsn,
      partNumber,
      location,
      quantity,
      requisitionPoint,
      requisitionQuantity,
      serialNumber,
      unitOfIssue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PartModelImplCopyWith<_$PartModelImpl> get copyWith =>
      __$$PartModelImplCopyWithImpl<_$PartModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartModelImplToJson(
      this,
    );
  }
}

abstract class _PartModel implements Part {
  factory _PartModel(
      {required final String name,
      required final String nsn,
      required final String partNumber,
      required final String location,
      required final int quantity,
      required final int requisitionPoint,
      required final int requisitionQuantity,
      required final String serialNumber,
      required final UnitOfIssue unitOfIssue}) = _$PartModelImpl;

  factory _PartModel.fromJson(Map<String, dynamic> json) =
      _$PartModelImpl.fromJson;

  @override
  String get name;
  @override
  String get nsn;
  @override
  String get partNumber;
  @override
  String get location;
  @override
  int get quantity;
  @override
  int get requisitionPoint;
  @override
  int get requisitionQuantity;
  @override
  String get serialNumber;
  @override
  UnitOfIssue get unitOfIssue;
  @override
  @JsonKey(ignore: true)
  _$$PartModelImplCopyWith<_$PartModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
