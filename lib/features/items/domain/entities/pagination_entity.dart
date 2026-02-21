class PaginationEntity {
  final int currentPage;
  final int perPage;
  final int lastPage;
  final int total;

  const PaginationEntity({
    required this.currentPage,
    required this.perPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;
}
