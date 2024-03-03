import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_challange/Data/models/search_gif_model.dart';
import 'package:giphy_challange/Data/repo/Search_repo.dart';

class SearchGifsEvent {}

class GetSearchGifsEvent extends SearchGifsEvent {
  final int limit;
  final int offset;
  final String q;
  GetSearchGifsEvent(
      {required this.q, required this.limit, required this.offset});
}

class SearchGifsState {}

class InitialSearchGifsState extends SearchGifsState {}

class LoadingSearchGifsState extends SearchGifsState {}

class SuccessSearchGifsState extends SearchGifsState {
  final SearchGifModel output;
  SuccessSearchGifsState({required this.output});
}

class FailedSearchGifsState extends SearchGifsState {}

class SearchGifsBloc extends Bloc<SearchGifsEvent, SearchGifsState> {
  SearchGifsBloc() : super(InitialSearchGifsState()) {
    on<SearchGifsEvent>(
        (SearchGifsEvent event, Emitter<SearchGifsState> emit) async {
      if (event is GetSearchGifsEvent) {
        if (event.offset == 0) emit(LoadingSearchGifsState());
        SearchGifModel? search =
            await SearchRepo.searchGif(event.q, event.limit, event.offset);
        if (search != null) {
          emit(SuccessSearchGifsState(output: search));
        } else {
          emit(FailedSearchGifsState());
        }
      }
    });
  }
}
