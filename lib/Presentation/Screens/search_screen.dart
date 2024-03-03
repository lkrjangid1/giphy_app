import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_challange/Bloc/search/search_bloc.dart';
import 'package:giphy_challange/Data/models/search_gif_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int limit = 16;
  int offset = 0;
  final TextEditingController searchController = TextEditingController();
  List<Data> gifsData = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_isBottom) {
      offset += limit;
      BlocProvider.of<SearchGifsBloc>(context).add(GetSearchGifsEvent(
        q: searchController.text,
        limit: limit,
        offset: offset,
      ));
    }
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            hintText: "Search gif",
          ),
          onSubmitted: (value) {
            BlocProvider.of<SearchGifsBloc>(context).add(GetSearchGifsEvent(
              q: searchController.text,
              limit: limit,
              offset: offset,
            ));
          },
        ),
      ),
      body: BlocBuilder<SearchGifsBloc, SearchGifsState>(
        builder: (context, state) {
          if (state is InitialSearchGifsState) {
            return Center(
              child: Text("Search your favourate gif"),
            );
          } else if (state is LoadingSearchGifsState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SuccessSearchGifsState) {
            SearchGifModel trendingGifModel = state.output;
            if (offset == 0) {
              gifsData.clear();
            }
            gifsData.addAll(trendingGifModel.data!);
            return GridView.builder(
              controller: scrollController,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: gifsData.length,
              itemBuilder: (context, index) {
                return Image.network(
                  gifsData[index].images!.previewWebp!.url!,
                  fit: BoxFit.cover,
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Something went wrong"),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<SearchGifsBloc>(context)
                          .add(GetSearchGifsEvent(
                        q: searchController.text,
                        limit: limit,
                        offset: offset,
                      ));
                    },
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
