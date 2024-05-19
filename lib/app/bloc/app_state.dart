part of 'app_bloc.dart';

@immutable
sealed class AppState extends Equatable {}

class AppInitial extends AppState {
  @override
  List<Object?> get props => [];
}

class AppLoading extends AppState {
  AppLoading({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

class AppLoaded extends AppState {
  AppLoaded();

  @override
  List<Object?> get props => [];
}
