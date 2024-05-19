part of 'pogo_scaffold_bloc.dart';

sealed class PogoScaffoldEvent extends Equatable {
  const PogoScaffoldEvent({required this.currentView});
  final AppViews currentView;

  @override
  List<Object> get props => [currentView];
}

class DestinationSelected extends PogoScaffoldEvent {
  const DestinationSelected({required super.currentView});
}
