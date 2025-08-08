import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/routing/routes.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/list_widgets/data_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class DataListView<
  T extends StrongEntity,
  M extends DataListViewmodel<T>,
  V extends DataListView<T, M, V>
>
    extends StatefulWidget {
  const DataListView({super.key, required this.viewmodel});

  final M viewmodel;

  @override
  State<V> createState();
}

abstract class DataListViewState<
  T extends StrongEntity,
  M extends DataListViewmodel<T>,
  V extends DataListView<T, M, V>
>
    extends State<V> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildEntry(BuildContext context, T entity);
  Widget buildSearch(BuildContext context);

  String get entityDisplay;
  String get route;

  @override
  Widget build(BuildContext context) {
    var builder = ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewmodel.loadEntities,
        widget.viewmodel.loadEntities.isExecuting,
        widget.viewmodel.deleteEntity,
      ]),
      builder: (context, child) {
        final entities = widget.viewmodel.entities;
        final scrollView = CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(bottom: Dimens.paddingVertical),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final entity = entities[index];
                  return Padding(
                    padding: EdgeInsets.only(top: index > 0 ? 10 : 0),
                    child: buildEntry(context, entity),
                  );
                }, childCount: entities.length),
              ),
            ),
          ],
        );
        return Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              minHeight: 5,
              backgroundColor: ColorScheme.of(context).surfaceContainer,
              value: widget.viewmodel.loadEntities.isExecuting.value ? null : 0,
            ),
            Expanded(child: scrollView),
          ],
        );
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("$route${Routes.create}");
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.of(context).paddingScreenHorizontal,
          vertical: Dimens.of(context).paddingScreenVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: Dimens.paddingVertical,
          children: [
            Text(entityDisplay, style: TextTheme.of(context).headlineSmall),
            buildSearch(context),
            Expanded(child: builder),
          ],
        ),
      ),
    );
  }

  void delete(T entity) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Wirklich löschen?'),
          content: Text(
            'Willst du wirklich $entityDisplay ${entity.displayShort} löschen?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                widget.viewmodel.deleteEntity(entity);

                ctx.pop();
              },
              child: const Text('Ja'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                ctx.pop();
              },
              child: const Text('Nein'),
            ),
          ],
        );
      },
    );
  }
}
