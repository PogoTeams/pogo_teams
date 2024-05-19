part of 'pogo_scaffold_bloc.dart';

sealed class PogoScaffoldEvent extends Equatable {
  const PogoScaffoldEvent();
}

class DestinationSelected extends PogoScaffoldEvent {
  const DestinationSelected({required this.currentView});
  final AppViews currentView;

  @override
  List<Object> get props => [currentView];
}

class DrawerCompactToggled extends PogoScaffoldEvent {
  @override
  List<Object> get props => [];
}
