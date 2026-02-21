class PaginationModel {
  final int currentPage;
  final int perPage;
  final int lastPage;
  final int total;

  const PaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.lastPage,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
      lastPage: json['last_page'] as int? ?? 1,
      total: json['total'] as int? ?? 0,
    );
  }

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;
}

class PaginatedResponse<T> {
  final List<T> items;
  final PaginationModel pagination;

  const PaginatedResponse({
    required this.items,
    required this.pagination,
  });
}
