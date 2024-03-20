import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/data/models/user/user_model.dart';

class UserEntity {
  UserEntity(
      {required this.firstName,
      required this.lastName,
      required this.rank,
      required this.username,
      required this.password,
      required this.viewRights});

  final String firstName;
  final String lastName;
  final RankEnum rank;
  final String username;
  final String password;
  final List<ViewRightsEnum> viewRights;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEntity &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.rank == rank &&
        other.username == username;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        rank.hashCode ^
        username.hashCode;
  }
}

extension UserEntityExtension on UserEntity {
  UserEntity copyWith({
    String? firstName,
    String? lastName,
    RankEnum? rank,
    String? username,
    String? password,
    List<ViewRightsEnum>? viewRights,
  }) {
    return UserEntity(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        rank: rank ?? this.rank,
        username: username ?? this.username,
        password: password ?? this.password,
        viewRights: viewRights ?? this.viewRights);
  }

  UserModel toModel() {
    return UserModel(
        firstNameModel: firstName,
        lastNameModel: lastName,
        rankModel: rank,
        usernameModel: username,
        passwordModel: password,
        viewRightsList: viewRights);
  }
}
