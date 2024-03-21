import 'package:flutter/material.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/users/delete_user_dialog.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/users/reset_user_password.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/users/update_rights_dialog.dart';

class UsersView extends StatefulWidget {
  final List<UserEntity> users;

  const UsersView(
      {super.key,
      required this.users,
      required this.currentUser,
      required this.resetUserPassword,
      required this.updateViewRights,
      required this.deleteUser,
      required this.reauthenticateUser});
  final UserEntity currentUser;
  final Function(UserEntity user, String password) resetUserPassword;
  final Function(UserEntity user, List<ViewRightsEnum> newRights)
      updateViewRights;
  final Function(UserEntity user, String password) deleteUser;
  final Future<bool> Function(String password) reauthenticateUser;

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: Container(),
              pinned: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                              onPressed: () => setState(() {}),
                              child: const Text('Sort by Rank')),
                          TextButton(
                              onPressed: () => setState(() {}),
                              child: const Text('Sort by Rights')),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ];
        },
        scrollDirection: Axis.vertical,
        body: ListView.builder(
            itemCount: widget.users.length,
            itemBuilder: (context, index) {
              return _getUserTile(widget.users[index]);
            }));
  }

  Card _getUserTile(UserEntity user) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
            " ${user.rank.enumToString()} ${user.lastName.toUpperCase()},${user.firstName.toUpperCase()}"),
        subtitle: Text(
            "Username: ${user.username}\nRights: ${user.viewRights.map((e) => e.enumToString()).join(', ')}"),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 12, // space between two icons
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.replay,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => ResetPasswordDialog(
                          usernameToReset: user.username,
                          isUserCredentialsValid: widget.reauthenticateUser,
                          onCredentialsValid: (password) =>
                              widget.resetUserPassword(user, password),
                        ));
              },
              tooltip: "Reset Password",
            ),
            if (widget.currentUser.username != user.username)
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: ((context) => DeleteUserDialog(
                          onCredentialsValid: (password) =>
                              widget.deleteUser(user, password),
                          userToDelete: user.username,
                          isUserCredentialsValid: ((password) =>
                              widget.reauthenticateUser(password)))));
                },
                tooltip: "Delete User",
              ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return UpdateViewRightsDialog(
                          usernameToUpdate: user.username,
                          currentUserRights: user.viewRights,
                          isUserCredentialsValid: (password) =>
                              widget.reauthenticateUser(password),
                          onRightsUpdated: (newRights, password) =>
                              widget.updateViewRights(user, newRights));
                    });
              },
              tooltip: "Edit User",
            ),
          ],
        ),
        onTap: () {
          // Maybe show user details or edit options
        },
      ),
    );
  }
}
