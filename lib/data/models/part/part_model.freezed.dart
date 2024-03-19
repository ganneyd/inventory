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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PartModel _$PartModelFromJson(Map<String, dynamic> json) {
  return _PartModel.fromJson(json);
}

/// @nodoc
mixin _$PartModel {
  @HiveField(0)
  int get index => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get nsn => throw _privateConstructorUsedError;
  @HiveField(3)
  String get partNumber => throw _privateConstructorUsedError;
  @HiveField(4)
  String get location => throw _privateConstructorUsedError;
  @HiveField(5)
  int get quantity => throw _privateConstructorUsedError;
  @HiveField(6)
  int get requisitionPoint => throw _privateConstructorUsedError;
  @HiveField(7)
  int get requisitionQuantity => throw _privateConstructorUsedError;
  @HiveField(8)
  String get serialNumber => throw _privateConstructorUsedError;
  @HiveField(9)
  UnitOfIssue get unitOfIssue => throw _privateConstructorUsedError;
  @HiveField(10)
  int get checksum => throw _privateConstructorUsedError;
  @HiveField(11)
  bool get isDiscontinued => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PartModelCopyWith<PartModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartModelCopyWith<$Res> {
  factory $PartModelCopyWith(PartModel value, $Res Function(PartModel) then) =
      _$PartModelCopyWithImpl<$Res, PartModel>;
  @useResult
  $Res call(
      {@HiveField(0) int index,
      @HiveField(1) String name,
      @HiveField(2) String nsn,
      @HiveField(3) String partNumber,
      @HiveField(4) String location,
      @HiveField(5) int quantity,
      @HiveField(6) int requisitionPoint,
      @HiveField(7) int requisitionQuantity,
      @HiveField(8) String serialNumber,
      @HiveField(9) UnitOfIssue unitOfIssue,
      @HiveField(10) int checksum,
      @HiveField(11) bool isDiscontinued});
}

/// @nodoc
class _$PartModelCopyWithImpl<$Res, $Val extends PartModel>
    implements $PartModelCopyWith<$Res> {
  _$PartModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = null,
    Object? nsn = null,
    Object? partNumber = null,
    Object? location = null,
    Object? quantity = null,
    Object? requisitionPoint = null,
    Object? requisitionQuantity = null,
    Object? serialNumber = null,
    Object? unitOfIssue = null,
    Object? checksum = null,
    Object? isDiscontinued = null,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
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
      checksum: null == checksum
          ? _value.checksum
          : checksum // ignore: cast_nullable_to_non_nullable
              as int,
      isDiscontinued: null == isDiscontinued
          ? _value.isDiscontinued
          : isDiscontinued // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartModelImplCopyWith<$Res>
    implements $PartModelCopyWith<$Res> {
  factory _$$PartModelImplCopyWith(
          _$PartModelImpl value, $Res Function(_$PartModelImpl) then) =
      __$$PartModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int index,
      @HiveField(1) String name,
      @HiveField(2) String nsn,
      @HiveField(3) String partNumber,
      @HiveField(4) String location,
      @HiveField(5) int quantity,
      @HiveField(6) int requisitionPoint,
      @HiveField(7) int requisitionQuantity,
      @HiveField(8) String serialNumber,
      @HiveField(9) UnitOfIssue unitOfIssue,
      @HiveField(10) int checksum,
      @HiveField(11) bool isDiscontinued});
}

/// @nodoc
class __$$PartModelImplCopyWithImpl<$Res>
    extends _$PartModelCopyWithImpl<$Res, _$PartModelImpl>
    implements _$$PartModelImplCopyWith<$Res> {
  __$$PartModelImplCopyWithImpl(
      _$PartModelImpl _value, $Res Function(_$PartModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = null,
    Object? nsn = null,
    Object? partNumber = null,
    Object? location = null,
    Object? quantity = null,
    Object? requisitionPoint = null,
    Object? requisitionQuantity = null,
    Object? serialNumber = null,
    Object? unitOfIssue = null,
    Object? checksum = null,
    Object? isDiscontinued = null,
  }) {
    return _then(_$PartModelImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
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
      checksum: null == checksum
          ? _value.checksum
          : checksum // ignore: cast_nullable_to_non_nullable
              as int,
      isDiscontinued: null == isDiscontinued
          ? _value.isDiscontinued
          : isDiscontinued // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartModelImpl implements _PartModel {
  _$PartModelImpl(
      {@HiveField(0) this.index = 0,
      @HiveField(1) this.name = 'unknown_part',
      @HiveField(2) this.nsn = 'unknown_part',
      @HiveField(3) this.partNumber = 'unknown_part',
      @HiveField(4) this.location = 'unknown_part',
      @HiveField(5) this.quantity = -1,
      @HiveField(6) this.requisitionPoint = -1,
      @HiveField(7) this.requisitionQuantity = -1,
      @HiveField(8) this.serialNumber = 'N/A',
      @HiveField(9) this.unitOfIssue = UnitOfIssue.NOT_SPECIFIED,
      @HiveField(10) this.checksum = 0,
      @HiveField(11) this.isDiscontinued = false});

  factory _$PartModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartModelImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final int index;
  @override
  @JsonKey()
  @HiveField(1)
  final String name;
  @override
  @JsonKey()
  @HiveField(2)
  final String nsn;
  @override
  @JsonKey()
  @HiveField(3)
  final String partNumber;
  @override
  @JsonKey()
  @HiveField(4)
  final String location;
  @override
  @JsonKey()
  @HiveField(5)
  final int quantity;
  @override
  @JsonKey()
  @HiveField(6)
  final int requisitionPoint;
  @override
  @JsonKey()
  @HiveField(7)
  final int requisitionQuantity;
  @override
  @JsonKey()
  @HiveField(8)
  final String serialNumber;
  @override
  @JsonKey()
  @HiveField(9)
  final UnitOfIssue unitOfIssue;
  @override
  @JsonKey()
  @HiveField(10)
  final int checksum;
  @override
  @JsonKey()
  @HiveField(11)
  final bool isDiscontinued;

  @override
  String toString() {
    return 'PartModel(index: $index, name: $name, nsn: $nsn, partNumber: $partNumber, location: $location, quantity: $quantity, requisitionPoint: $requisitionPoint, requisitionQuantity: $requisitionQuantity, serialNumber: $serialNumber, unitOfIssue: $unitOfIssue, checksum: $checksum, isDiscontinued: $isDiscontinued)';
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
                other.unitOfIssue == unitOfIssue) &&
            (identical(other.checksum, checksum) ||
                other.checksum == checksum) &&
            (identical(other.isDiscontinued, isDiscontinued) ||
                other.isDiscontinued == isDiscontinued));
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
      unitOfIssue,
      checksum,
      isDiscontinued);

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

abstract class _PartModel implements PartModel {
  factory _PartModel(
      {@HiveField(0) final int index,
      @HiveField(1) final String name,
      @HiveField(2) final String nsn,
      @HiveField(3) final String partNumber,
      @HiveField(4) final String location,
      @HiveField(5) final int quantity,
      @HiveField(6) final int requisitionPoint,
      @HiveField(7) final int requisitionQuantity,
      @HiveField(8) final String serialNumber,
      @HiveField(9) final UnitOfIssue unitOfIssue,
      @HiveField(10) final int checksum,
      @HiveField(11) final bool isDiscontinued}) = _$PartModelImpl;

  factory _PartModel.fromJson(Map<String, dynamic> json) =
      _$PartModelImpl.fromJson;

  @override
  @HiveField(0)
  int get index;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get nsn;
  @override
  @HiveField(3)
  String get partNumber;
  @override
  @HiveField(4)
  String get location;
  @override
  @HiveField(5)
  int get quantity;
  @override
  @HiveField(6)
  int get requisitionPoint;
  @override
  @HiveField(7)
  int get requisitionQuantity;
  @override
  @HiveField(8)
  String get serialNumber;
  @override
  @HiveField(9)
  UnitOfIssue get unitOfIssue;
  @override
  @HiveField(10)
  int get checksum;
  @override
  @HiveField(11)
  bool get isDiscontinued;
  @override
  @JsonKey(ignore: true)
  _$$PartModelImplCopyWith<_$PartModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
