import 'package:ayron_crm/data/model/entity.dart';
import 'package:ayron_crm/data/repositories/data_repository.dart';
import 'package:ayron_crm/utils/result.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

abstract class DataListViewmodel<T extends StrongEntity> {
  DataListViewmodel({required DataRepository<T> repository})
    : _repository = repository {
    deleteEntity = Command.createAsync((entity) async {
      var l = await _repository.deleteEntity(entity.id);
      pagingController.refresh();
      return l;
    }, initialValue: Result.ok(null));
  }

  final int take = 20;

  late final pagingController = PagingController<int, T>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => _repository
        .getEntities(
          filter: searchValues(),
          take: 20,
          skip: (pageKey - 1) * take,
        )
        .then((v) {
          switch (v) {
            case Ok<ResultList<T>>():
              return v.value.entities;
            case Error<ResultList<T>>():
              return [];
          }
        }),
  );

  void exLoadEntities() {
    pagingController.refresh();
  }

  final DataRepository<T> _repository;

  late final Command<T, Result<void>> deleteEntity;

  Map<String, dynamic> searchValues();
}
