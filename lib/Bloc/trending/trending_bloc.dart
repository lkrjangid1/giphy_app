import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_challange/Data/models/trending_gif_model.dart';
import 'package:giphy_challange/Data/repo/trending_repo.dart';

class TrendingGifsEvent {}

class GetTrendingGifsEvent extends TrendingGifsEvent {
  final int limit;
  final int offset;
  GetTrendingGifsEvent({required this.limit, required this.offset});
}

class TrendingGifsState {}

class InitialTrendingGifsState extends TrendingGifsState {}

class LoadingTrendingGifsState extends TrendingGifsState {}

class SuccessTrendingGifsState extends TrendingGifsState {
  final TrendingGifModel output;
  SuccessTrendingGifsState({required this.output});
}

class FailedTrendingGifsState extends TrendingGifsState {}

class TrendingGifsBloc extends Bloc<TrendingGifsEvent, TrendingGifsState> {
  TrendingGifsBloc() : super(InitialTrendingGifsState()) {
    on<TrendingGifsEvent>(
        (TrendingGifsEvent event, Emitter<TrendingGifsState> emit) async {
      if (event is GetTrendingGifsEvent) {
        if (event.offset == 0) emit(LoadingTrendingGifsState());
        TrendingGifModel? trending =
            await TrendingRepo.getTrendingGif(event.limit, event.offset);
        if (trending != null) {
          emit(SuccessTrendingGifsState(output: trending));
        } else {
          emit(FailedTrendingGifsState());
        }
      }
    });
  }
}
