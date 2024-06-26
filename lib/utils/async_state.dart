enum AsyncStatus { init, inProgress, success, failure }

extension AsyncStatusExtension on AsyncStatus {
  bool get isInit => this == AsyncStatus.init;
  bool get isInProgress => this == AsyncStatus.inProgress;
  bool get isSuccess => this == AsyncStatus.success;
  bool get isFailure => this == AsyncStatus.failure;
}

class AsyncState {
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

  AsyncState init() => const AsyncState();

  AsyncState inProgress() => copyWith(status: AsyncStatus.inProgress);

  AsyncState success() => copyWith(status: AsyncStatus.success);

  AsyncState failure({String? errorMessage}) =>
      copyWith(status: AsyncStatus.failure, errorMessage: errorMessage);

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
