import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../app_views/app_views.dart';

part 'pogo_scaffold_event.dart';
part 'pogo_scaffold_state.dart';

class PogoScaffoldBloc extends Bloc<PogoScaffoldEvent, PogoScaffoldState> {
  PogoScaffoldBloc()
      : super(
          const PogoScaffoldState(
            currentView: AppViews.defaultView,
            drawerIsCompact: false,
          ),
        ) {
    on<DestinationSelected>(_onDestinationSelected);
    on<DrawerCompactToggled>(_onDrawerCompactToggled);
  }

  void _onDestinationSelected(
      DestinationSelected event, Emitter<PogoScaffoldState> emit) {
    emit(
      state.copyWith(
        currentView: event.currentView,
      ),
    );
  }

  void _onDrawerCompactToggled(
      DrawerCompactToggled event, Emitter<PogoScaffoldState> emit) {
    emit(
      state.copyWith(
        drawerIsCompact: !state.drawerIsCompact,
      ),
    );
  }
}
