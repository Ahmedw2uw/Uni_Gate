import 'package:flutter/material.dart';
import 'package:nuigate/features/auth/data/models/user_model.dart';
import 'package:nuigate/features/dashboard/presentation/widgets/dashboard_menu_grid.dart';
import 'package:nuigate/features/dashboard/presentation/widgets/dashboard_user_header.dart';

class DashboardSuccessView extends StatelessWidget {
  final UserModel user;

  const DashboardSuccessView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardUserHeader(user: user),
        Expanded(child: DashboardMenuGrid(user: user)),
      ],
    );
  }
}
