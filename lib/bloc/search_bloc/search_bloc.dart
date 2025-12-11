import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:gmail_clone/data/repository/mail_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MailRepository repo;
  final String userId;
  final String userEmail;

  SearchBloc({
    required this.repo,
    required this.userId,
    required this.userEmail,
  }) : super(const SearchState()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 350)),
    );

    on<SearchSubmitted>(_onSearchSubmitted);
    on<ClearSearch>((e, emit) => emit(const SearchState()));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (Stream<T> events, Stream<T> Function(T) mapper) {
      return events.debounceTime(duration).switchMap(mapper);
    };
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final q = event.query.trim();
    emit(state.copyWith(status: SearchStatus.loading, query: q));

    if (q.isEmpty) {
      emit(const SearchState());
      return;
    }

    try {
      final results = await repo.searchMails(
        q,
        userId: userId,
        userEmail: userEmail, // <-- pass email too
      );
      emit(state.copyWith(status: SearchStatus.success, results: results));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure));
      // optionally: add logging of e/st
    }
  }

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    final q = event.query.trim();
    if (q.isEmpty) return;

    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final results = await repo.searchMails(
        q,
        userId: userId,
        userEmail: userEmail, // <-- pass email too
      );
      emit(state.copyWith(status: SearchStatus.success, results: results));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }
}
