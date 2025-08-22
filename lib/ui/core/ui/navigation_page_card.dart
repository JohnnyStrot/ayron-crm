import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationPageCard extends StatelessWidget {
  const NavigationPageCard({
    super.key,
    required String route,
    required String label,
    required IconData icon,
  }) : _route = route,
       _label = label,
       _icon = icon;

  final String _route;
  final String _label;
  final IconData _icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(_route);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: Dimens.hgap / 2),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: Dimens.vgap,
            horizontal: Dimens.paddingHorizontal,
          ),
          child: Column(
            spacing: Dimens.vgap,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: Icon(_icon)),
              Text(
                _label,
                style: TextTheme.of(
                  context,
                ).headlineSmall!.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
