import 'package:equatable/equatable.dart';

enum AsyncStatus { init, inProgress, success, failure }

extension AsyncStatusExtension on AsyncStatus {
  bool get isInit => this == AsyncStatus.init;
  bool get isInProgress => this == AsyncStatus.inProgress;
  bool get isSuccess => this == AsyncStatus.success;
  bool get isFailure => this == AsyncStatus.failure;
}

class AsyncState extends Equatable {
  const AsyncState({
    this.status = AsyncStatus.init,
    this.errorMessage,
  });

  final AsyncStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];

  static const AsyncState init = AsyncState();

  static AsyncState inProgress() =>
      const AsyncState(status: AsyncStatus.inProgress);

  static AsyncState success() => const AsyncState(status: AsyncStatus.success);

  static AsyncState failure({String? errorMessage}) =>
      AsyncState(status: AsyncStatus.failure, errorMessage: errorMessage);

  AsyncState copyWith({
    AsyncStatus? status,
    String? errorMessage,
  }) {
    return AsyncState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
