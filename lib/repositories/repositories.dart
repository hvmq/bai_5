import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/hive/story.dart';

class StoryRepository {
  static const String _boxName = "storyBox";
  final dio = Dio();
  final List<Story> list = [];
  Future<List<Story>> getStoryAPI(int page) async {
    final result = await Connectivity().checkConnectivity();
    if(result != ConnectivityResult.none){
      try {
      String endpoint = "http://54.226.141.124/intern/news?page=$page";
      var response = await dio.get(endpoint);
      List<dynamic> data = response.data as List<dynamic>;
      return data.map((story) => Story.fromJson(story)).toList();
    } on SocketException catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return list;
    } on DioError catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return list;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return list;
    }
    }else {
      return list;
    }
    
  }

  Future<List<Story>> getAllStoryLocal() async {
    var box = await Hive.openBox<Story>(_boxName);
    return box.values.toList();
  }
}
