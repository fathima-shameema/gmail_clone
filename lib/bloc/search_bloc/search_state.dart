part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final String query;
  final List<MailModel> results;

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
  });

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<MailModel>? results,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [status, query, results];
}
