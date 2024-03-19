import 'package:hive/hive.dart';
part 'view_right_enum.g.dart';

@HiveType(typeId: 7)
enum ViewRightsEnum {
  @HiveField(0)
  all,
  @HiveField(1)
  admin,
  @HiveField(2)
  pol,
  @HiveField(3)
  parts,
  @HiveField(4)
  orders,
  @HiveField(5)
  verify,
  @HiveField(6)
  none
}

extension ViewRightsExtension on ViewRightsEnum {
  String enumToString() {
    switch (this) {
      case ViewRightsEnum.all:
        return 'All';
      case ViewRightsEnum.admin:
        return 'Admin';
      case ViewRightsEnum.pol:
        return 'POL';
      case ViewRightsEnum.parts:
        return 'Parts';
      case ViewRightsEnum.orders:
        return 'Orders';
      case ViewRightsEnum.verify:
        return 'Verify';
      default:
        return 'None';
    }
  }

  static ViewRightsEnum fromDisplayValue(String displayValue) {
    switch (displayValue.toLowerCase()) {
      case 'all':
        return ViewRightsEnum.all;
      case 'admin':
        return ViewRightsEnum.admin;
      case 'pol':
        return ViewRightsEnum.pol;
      case 'parts':
        return ViewRightsEnum.parts;
      case 'orders':
        return ViewRightsEnum.orders;
      case 'verify':
        return ViewRightsEnum.verify;
      default:
        return ViewRightsEnum.none;
    }
  }
}
