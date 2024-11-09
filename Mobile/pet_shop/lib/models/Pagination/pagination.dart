import 'dart:convert';

class PaginatedList {
  // final List<T> items;
  final int totalDocs;
  final int limit;
  final int totalPages;
  final int page;
  final int pagingCounter;
  final bool hasPrevPage;
  final bool hasNextPage;
  final int? prevPage;
  final int? nextPage;

  PaginatedList({
    // required this.items,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });
  @override
  String toString() {
    return 'PaginatedList{'
        'totalDocs: $totalDocs, '
        'limit: $limit, '
        'totalPages: $totalPages, '
        'page: $page, '
        'pagingCounter: $pagingCounter, '
        'hasPrevPage: $hasPrevPage, '
        'hasNextPage: $hasNextPage, '
        'prevPage: $prevPage, '
        'nextPage: $nextPage}';
  }
}

PaginatedList paginatedListFromJson<T>(String val) {
  final data = jsonDecode(val);
  // final docs = data['data']['docs'] as List<dynamic>;
  // final items = List<T>.from(docs.map((item) => fromJson(item)));
  final totalDocs = data['data']['totalDocs'] as int;
  final limit = data['data']['limit'] as int;
  final totalPages = data['data']['totalPages'] as int;
  final page = data['data']['page'] as int;
  final pagingCounter = data['data']['pagingCounter'] as int;
  final hasPrevPage = data['data']['hasPrevPage'] as bool;
  final hasNextPage = data['data']['hasNextPage'] as bool;
  final prevPage = data['data']['prevPage'] as int?;
  final nextPage = data['data']['nextPage'] as int?;

  return PaginatedList(
    // items: items,
    totalDocs: totalDocs,
    limit: limit,
    totalPages: totalPages,
    page: page,
    pagingCounter: pagingCounter,
    hasPrevPage: hasPrevPage,
    hasNextPage: hasNextPage,
    prevPage: prevPage,
    nextPage: nextPage,
  );
}
