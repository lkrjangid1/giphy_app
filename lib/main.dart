import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_challange/Bloc/search/search_bloc.dart';
import 'package:giphy_challange/Bloc/trending/trending_bloc.dart';
import 'package:giphy_challange/Data/theme_provider.dart';
import 'package:giphy_challange/Presentation/Screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TrendingGifsBloc(),
        ),
        BlocProvider(
          create: (context) => SearchGifsBloc(),
        ),
      ],
      child: ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'Giphy Search',
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
