
import 'package:equatable/equatable.dart';

import '../../models/hive/story.dart';

abstract class StoryState extends Equatable {
  const StoryState();
 
}

class StoryInitialState extends StoryState {
   @override
  List<Object?> get props => [];
}

class LoadAllStoryLocalState extends StoryState {
  final List<Story> stories;

  const LoadAllStoryLocalState(this.stories);

  @override
  List<Object?> get props => [stories];
}
