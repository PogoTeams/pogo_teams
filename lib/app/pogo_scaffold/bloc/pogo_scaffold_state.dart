part of 'pogo_scaffold_bloc.dart';

class PogoScaffoldState extends Equatable {
  const PogoScaffoldState(
      {required this.currentView, required this.drawerIsCompact});

  final AppViews currentView;
  final bool drawerIsCompact;

  @override
  List<Object> get props => [currentView, drawerIsCompact];

  PogoScaffoldState copyWith({
    AppViews? currentView,
    bool? drawerIsCompact,
  }) =>
      PogoScaffoldState(
        currentView: currentView ?? this.currentView,
        drawerIsCompact: drawerIsCompact ?? this.drawerIsCompact,
      );
}
