part of 'pogo_scaffold_bloc.dart';

class PogoScaffoldState extends Equatable {
  const PogoScaffoldState({required this.currentView});

  final AppViews currentView;

  @override
  List<Object> get props => [currentView];
}
