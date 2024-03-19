import 'package:hive/hive.dart';
part 'rank_enum.g.dart';

@HiveType(typeId: 6)
enum RankEnum {
  @HiveField(0)
  pv1,
  @HiveField(1)
  pv2,
  @HiveField(2)
  pfc,
  @HiveField(3)
  spc,
  @HiveField(4)
  cpl,
  @HiveField(5)
  sgt,
  @HiveField(6)
  ssgt,
  @HiveField(7)
  sfc,
  @HiveField(8)
  msg,
  @HiveField(9)
  fsgt,
  @HiveField(10)
  sgm,
  @HiveField(11)
  csm,
  @HiveField(12)
  unknown,
}

extension RankExtension on RankEnum {
  String enumToString() {
    switch (this) {
      case RankEnum.pv1:
        return 'PV1';
      case RankEnum.pv2:
        return 'PV2';
      case RankEnum.pfc:
        return 'PFC';
      case RankEnum.spc:
        return 'SPC';
      case RankEnum.cpl:
        return 'CPL';
      case RankEnum.sgt:
        return 'SGT';
      case RankEnum.ssgt:
        return 'SSGT';
      case RankEnum.sfc:
        return 'SFC';
      case RankEnum.msg:
        return 'MSG';
      case RankEnum.fsgt:
        return '1SGT';
      case RankEnum.sgm:
        return 'SGM';
      case RankEnum.csm:
        return 'CSM';
      default:
        return 'Unknown';
    }
  }

  static RankEnum fromDisplayValue(String displayValue) {
    switch (displayValue.toLowerCase()) {
      case 'pv1':
        return RankEnum.pv1;
      case 'pv2':
        return RankEnum.pv2;
      case 'pfc':
        return RankEnum.pfc;
      case 'spc':
        return RankEnum.spc;
      case 'cpl':
        return RankEnum.cpl;
      case 'sgt':
        return RankEnum.sgt;
      case 'ssgt':
        return RankEnum.ssgt;
      case 'sfc':
        return RankEnum.sfc;
      case 'msg':
        return RankEnum.msg;
      case '1sgt':
        return RankEnum.fsgt;
      case 'sgm':
        return RankEnum.sgm;
      case 'csm':
        return RankEnum.csm;
      default:
        return RankEnum.unknown;
    }
  }
}
