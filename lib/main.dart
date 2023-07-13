import 'package:bai_5_/models/hive/story.dart';
import 'package:bai_5_/pages/home_page.dart';
import 'package:bai_5_/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/story_bloc/story_bloc.dart';
import 'blocs/story_bloc/story_event.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StoryAdapter());
  await Hive.openBox<Story>("storyBox");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<StoryRepository>(
      create: (context) => StoryRepository(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) => StoryBloc(
            RepositoryProvider.of<StoryRepository>(context),
          )..add(LoadAllStoryLocalEvent()),
          child: HomePage(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
