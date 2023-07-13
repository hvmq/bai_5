import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:bai_5_/widgets/list_story_item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../blocs/story_bloc/story_bloc.dart';
import '../blocs/story_bloc/story_event.dart';
import '../blocs/story_bloc/story_state.dart';
import '../models/hive/story.dart';
import '../repositories/repositories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConnectivityResult result;
  late StreamSubscription subscription;
  ScrollController scrollController = ScrollController();
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      startStreaming();

      // var pageBox = await Hive.openBox("pageBox");
      // var box = await Hive.openBox<Story>("storyBox");
      // pageBox.clear();
      // box.clear();
    });
  }

  checkInternet() async {
    result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      final storyBloc = BlocProvider.of<StoryBloc>(context);
      await getAPIandSaveLocal(storyBloc);
    } else {
      var pageBox = await Hive.openBox("pageBox");
      print(pageBox.get("pageLocal"));
    }
  }

  startStreaming() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      await checkInternet();
    });
  }

  getAPIandSaveLocal(StoryBloc storyBloc) async {
    var pageBox = await Hive.openBox("pageBox");
    bool loadSuccess = true;
    List<Story> stories = await StoryRepository().getAllStoryLocal();
    print(stories);
    if (stories.isEmpty) {
      List<Story> newData = await StoryRepository().getStoryAPI(1);
      if (newData.isNotEmpty) {
        storyBloc.add(AddStoryLocalEvent(newData));
        pageBox.put("pageLocal", 1);
      }
    } else {
      page = pageBox.get("pageLocal");
      final List<Story> listAll = [];
      for (int i = 0; i < page + 1; i++) {
        List<Story> newData = await StoryRepository().getStoryAPI(i);
        listAll.addAll(newData);
        if (newData.isEmpty) {
          loadSuccess = false;
        }
      }
      if (loadSuccess) {
        storyBloc.add(RemoveAllStoryLocalEvent());
        // await Future.delayed(Duration(seconds: 5));
        storyBloc.add(AddStoryLocalEvent(listAll));
        pageBox.put("pageLocal", page + 1);
      }
    }
    print(pageBox.get("pageLocal"));
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF1D1A61), Color(0xFF18DAB8)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("My News"),
          ),
          centerTitle: true,
        ),
      ),
      body: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, state) {
          if (state is LoadAllStoryLocalState) {
            List<Story> stories = state.stories;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  child: Text(
                    'News',
                    style: TextStyle(
                        color: Color(0xFF1D1A61),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount:
                          isLoading ? stories.length + 1 : stories.length,
                      itemBuilder: (context, index) {
                        return index < stories.length
                            ? ListStoryItem(
                                story: stories[index],
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      }),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: SizedBox(
        height: 40,
        width: 40,
        child: FloatingActionButton(
          onPressed: () {
            scrollToItem();
          },
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.keyboard_capslock),
        ),
      ),
    );
  }

  Future scrollToItem() async {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollListener() async {
    result = await Connectivity().checkConnectivity();
    if (scrollController.hasClients) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (result != ConnectivityResult.none) {
          setState(() {
            isLoading = true;
          });

          await Future.delayed(Duration(seconds: 2));
          final storyBloc = BlocProvider.of<StoryBloc>(context);
          var pageBox = await Hive.openBox("pageBox");
          int page = pageBox.get("pageLocal");
          List<Story> newData = await StoryRepository().getStoryAPI(page + 1);
          storyBloc.add(AddStoryLocalEvent(newData));
          var box = await Hive.openBox<Story>("storyBox");
          print("box ${box.values.toList()}");
          setState(() {
            isLoading = false;
          });
        } else {
          snackbarFail();
        }
      }
    }
  }

  void snackbarFail() {
    Flushbar(
      message: 'No internet',
      duration: Duration(seconds: 2),
      borderRadius: BorderRadius.circular(10),
      margin: EdgeInsets.all(10),
      backgroundColor: Colors.red,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
