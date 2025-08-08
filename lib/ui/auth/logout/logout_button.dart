import 'package:ayron_crm/ui/auth/logout/logout_viewmodel.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required LogoutViewModel viewModel})
    : _viewModel = viewModel;

  final LogoutViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(Icons.logout),
      onPressed: () {
        _viewModel.logout.execute();
      },
      label: Text("Logout", style: TextTheme.of(context).bodyLarge),
    );
  }
}
