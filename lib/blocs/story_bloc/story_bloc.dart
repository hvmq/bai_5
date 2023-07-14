

import 'package:bai_5_/blocs/story_bloc/story_event.dart';
import 'package:bai_5_/blocs/story_bloc/story_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/hive/story.dart';
import '../../repositories/repositories.dart';


class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepository storyRepository;

  StoryBloc(this.storyRepository) : super(StoryInitialState()) {
    var box = Hive.box<Story>("storyBox");
    on<LoadAllStoryLocalEvent>((event, emit) async {
      // emit(StoryInitialState());
      // await Future.delayed(Duration(seconds: 5));
      try {
        final stories = await storyRepository.getAllStoryLocal(); 
        emit(LoadAllStoryLocalState(stories));      
      } catch (e) {
        print(e);
      }  
    });

    on<AddStoryLocalEvent>((event, emit) async {
     
    for(int i = 0; i < event.stories.length; i++){
      box.add(event.stories[i]);
    }
        
    final stories = await storyRepository.getAllStoryLocal();
    emit(LoadAllStoryLocalState(stories));
    });

    on<RemoveAllStoryLocalEvent>((event, emit) async {
    // Remove all local stories
    await box.clear(); 

    final stories = await storyRepository.getAllStoryLocal();
    emit(LoadAllStoryLocalState(stories));   
  });
  
  }
}
