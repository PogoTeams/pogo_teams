part of 'app_bloc.dart';

@immutable
sealed class AppEvent extends Equatable {}

class PogoDataFetched extends AppEvent {
  PogoDataFetched({
    this.forceUpdate = false,
  });

  final bool forceUpdate;

  @override
  List<Object?> get props => [];
}

class PogoDataLoaded extends AppEvent {
  @override
  List<Object?> get props => [];
}
