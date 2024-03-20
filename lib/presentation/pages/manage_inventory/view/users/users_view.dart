import 'package:flutter/material.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';

class UsersTableWidget extends StatelessWidget {
  final List<UserEntity> users;

  const UsersTableWidget({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('First Name')),
          DataColumn(label: Text('Last Name')),
          DataColumn(label: Text('Rank')),
          DataColumn(label: Text('Username')),
          DataColumn(label: Text('View Rights')),
          DataColumn(label: Text('Actions')),
        ],
        rows: users
            .map(
              (user) => DataRow(cells: [
                DataCell(Text(user.firstName)),
                DataCell(Text(user.lastName)),
                DataCell(Text(user.rank
                    .toString()
                    .split('.')
                    .last)), // Assuming RankEnum is an enum
                DataCell(Text(user.username)),
                DataCell(Text(user.viewRights
                    .map((e) => e.toString().split('.').last)
                    .join(', '))),
                DataCell(ElevatedButton(
                  onPressed: () {
                    // Implement the reset password functionality
                    print('Resetting password for ${user.username}');
                  },
                  child: const Text('Reset Password'),
                )),
              ]),
            )
            .toList(),
      ),
    );
  }
}
