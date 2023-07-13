

import 'package:equatable/equatable.dart';

import '../../models/hive/story.dart';

abstract class StoryEvent extends Equatable {
  const StoryEvent();
}




class LoadAllStoryLocalEvent extends StoryEvent{
  @override
  List<Object?> get props => [];
}

class AddStoryLocalEvent extends StoryEvent{
  final List<Story> stories;

  const AddStoryLocalEvent(this.stories);

  @override
  List<Object?> get props => [stories];
}

class RemoveAllStoryLocalEvent extends StoryEvent{
  @override
  List<Object?> get props => [];
}


