import 'package:ayron_crm/data/model/contact.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/data/repositories/contact/contact_repository.dart';
import 'package:ayron_crm/ui/core/themes/dimens.dart';
import 'package:ayron_crm/ui/contact/contact_details.dart';
import 'package:ayron_crm/ui/contact/contact_details_viewmodel.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ContactPicker extends StatefulWidget {
  const ContactPicker({
    super.key,
    required this.repository,
    required this.onSelect,
    this.label,
    this.initialValue,
    this.buttonOnly = false,
  });

  final ContactRepository repository;

  final void Function(Contact? l) onSelect;

  final Contact? initialValue;

  final String? label;

  final bool buttonOnly;

  Future<Result<List<Contact>>> getEntities(
    String filterName,
    LoadProps? loadProps,
  ) {
    return repository
        .getEntities(
          filter: {"filter": filterName},
          skip: loadProps?.skip,
          take: loadProps?.take,
          order: "name",
          orderDesc: false,
        )
        .then((v) {
          switch (v) {
            case Ok<ResultList<Contact>>():
              return Result.ok(v.value.entities);
            case Error<ResultList<Contact>>():
              return Result.error(v.error);
          }
        });
  }

  @override
  State<ContactPicker> createState() => ContactPickerState();
}

class ContactPickerState extends State<ContactPicker> {
  Contact? currentValue;

  final int take = 25;

  late TextEditingController nameController;
  late PagingController<int, Contact> pagingController;

  @override
  void initState() {
    pagingController = PagingController(
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) => getData(
        nameController.text,
        LoadProps(skip: (pageKey - 1) * take, take: take),
      ),
    );
    nameController = TextEditingController();
    nameController.debounce(Durations.medium4).addListener(() {
      pagingController.refresh();
    });
    currentValue = widget.initialValue;
    super.initState();
  }

  void select(Contact? l) {
    widget.onSelect(l);
    if (context.mounted) {
      setState(() {
        currentValue = l;
      });
    }
  }

  Future<List<Contact>> getData(String filterName, LoadProps? loadProps) {
    return widget.getEntities(filterName, loadProps).then((result) {
      switch (result) {
        case Ok<List<Contact>>():
          return result.value;
        case Error<List<Contact>>():
          return Future.value([]);
      }
    });
  }

  void addContact(BuildContext context) async {
    ContactDetailsViewmodel vm = ContactDetailsViewmodel(
      contactRepository: context.read(),
    );
    vm.createEntity.execute();

    var p = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.pop(context, vm.entity);
          },
          child: ContactDetails(viewmodel: vm),
        ),
      ),
    );
    if (p != null && p is Contact) {
      select(p);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  String entityAsString(Contact? entity) {
    if (entity == null) {
      return "";
    }
    return entity.displayShort;
  }

  void openBottomSheet(BuildContext context) async {
    final paging = PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<int, Contact>(
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, entity, index) => Padding(
              padding: EdgeInsets.only(top: index > 0 ? 10 : 0),
              child: buildEntry(context, entity),
            ),
          ),
        );
      },
    );

    final scroll = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            bottom: Dimens.fabGap,
            right: Dimens.scrollBarGap,
          ),
          sliver: paging,
        ),
      ],
    );

    await showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.of(context).paddingScreenHorizontal,
              vertical: Dimens.of(context).paddingScreenVertical,
            ),
            child: Row(
              spacing: Dimens.hgap,
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                ),
                IconButton(
                  onPressed: () => addContact(context),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(child: scroll),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buttonOnly) {
      return IconButton(
        onPressed: () => openBottomSheet(context),
        icon: Icon(Icons.add),
      );
    }
    return TextField(
      controller: TextEditingController(text: entityAsString(currentValue)),
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: currentValue != null
            ? IconButton(onPressed: () => select(null), icon: Icon(Icons.clear))
            : null,
      ),
      onTap: () => openBottomSheet(context),
    );
  }

  Widget buildEntry(BuildContext context, Contact entity) {
    return ListTile(
      onTap: () {
        select(entity);
        Navigator.pop(context);
      },
      leading: Icon(Icons.person),
      /*entity.logo?.isNotEmpty ?? false
          ? Image.network(
              entity.logo!,
              width: 32,
              height: 32,
              alignment: AlignmentGeometry.center,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.group, size: 32),
            )
          : Icon(entity.typeIcon, size: 32),*/
      title: Text(
        entity.displayShort,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        [
          if (entity.name.isNotEmpty &&
              entity.email.isNotEmpty &&
              entity.instagram.isNotEmpty)
            entity.tel,
          if (entity.name.isNotEmpty && entity.email.isNotEmpty)
            entity.instagram,
          if (entity.name.isNotEmpty) entity.email,
        ].join(", "),
      ),
    );
  }
}
