import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../views/app_views.dart';

part 'pogo_scaffold_event.dart';
part 'pogo_scaffold_state.dart';

class PogoScaffoldBloc extends Bloc<PogoScaffoldEvent, PogoScaffoldState> {
  PogoScaffoldBloc()
      : super(
          const PogoScaffoldState(
            currentView: AppViews.defaultView,
          ),
        ) {
    on<DestinationSelected>(_onDestinationSelected);
  }

  void _onDestinationSelected(
      DestinationSelected event, Emitter<PogoScaffoldState> emit) {
    emit(
      PogoScaffoldState(
        currentView: event.currentView,
      ),
    );
  }
}
