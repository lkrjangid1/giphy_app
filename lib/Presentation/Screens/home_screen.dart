import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_challange/Bloc/trending/trending_bloc.dart';
import 'package:giphy_challange/Data/models/trending_gif_model.dart';
import 'package:giphy_challange/Data/theme_provider.dart';
import 'package:giphy_challange/Presentation/Screens/search_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int limit = 16;
  int offset = 0;
  List<Data> gifsData = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<TrendingGifsBloc>(context).add(GetTrendingGifsEvent(
      limit: limit,
      offset: offset,
    ));
    scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_isBottom) {
      offset += limit;
      BlocProvider.of<TrendingGifsBloc>(context).add(GetTrendingGifsEvent(
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
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Giphy"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              final provider =
                  Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme(themeProvider.isDarkMode ? true : false);
            },
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
        ],
      ),
      body: BlocBuilder<TrendingGifsBloc, TrendingGifsState>(
        builder: (context, state) {
          if (state is InitialTrendingGifsState ||
              state is LoadingTrendingGifsState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SuccessTrendingGifsState) {
            TrendingGifModel trendingGifModel = state.output;
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
                      BlocProvider.of<TrendingGifsBloc>(context)
                          .add(GetTrendingGifsEvent(
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
