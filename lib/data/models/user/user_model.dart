import 'package:hive/hive.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 8)
class UserModel extends UserEntity {
  UserModel(
      {required this.firstNameModel,
      required this.lastNameModel,
      required this.rankModel,
      required this.usernameModel,
      required this.passwordModel,
      required this.viewRightsList})
      : super(
            firstName: firstNameModel,
            lastName: lastNameModel,
            rank: rankModel,
            username: usernameModel,
            password: passwordModel,
            viewRights: viewRightsList);
  @HiveField(0)
  final String firstNameModel;
  @HiveField(1)
  final String lastNameModel;
  @HiveField(2)
  final RankEnum rankModel;
  @HiveField(3)
  final String usernameModel;
  @HiveField(4)
  final String passwordModel;
  @HiveField(5)
  final List<ViewRightsEnum> viewRightsList;
}
