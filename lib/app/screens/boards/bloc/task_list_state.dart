import 'package:meta/meta.dart';

@immutable
class TaskListState {
  final bool isValidTaskTitle;
  final bool isValidCardTitle;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isTaskFormValid => isValidTaskTitle;
  bool get isCardFormValid => isValidCardTitle;

  TaskListState(
      {this.isValidTaskTitle,
      this.isValidCardTitle,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure});

  factory TaskListState.empty() {
    return TaskListState(
        isValidTaskTitle: true,
        isValidCardTitle: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }
  factory TaskListState.loading() {
    return TaskListState(
        isValidTaskTitle: true,
        isValidCardTitle: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }
  factory TaskListState.success() {
    return TaskListState(
        isValidTaskTitle: true,
        isValidCardTitle: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }
  factory TaskListState.failure() {
    return TaskListState(
        isValidTaskTitle: true,
        isValidCardTitle: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }

  TaskListState update({
    bool isValidTaskTitle,
    bool isValidCardTitle,
  }) {
    return TaskListState(
        isValidTaskTitle: isValidTaskTitle,
        isValidCardTitle: isValidCardTitle,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  TaskListState copyWith(
      {bool isValidTaskTitle,
      bool isValidCardTitle,
      bool isSubmitEnabled,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure}) {
    return TaskListState(
        isValidTaskTitle: isValidTaskTitle ?? this.isValidTaskTitle,
        isValidCardTitle: isValidCardTitle ?? this.isValidCardTitle,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }

  @override
  String toString() {
    return '''TaskListState {
      isValidTaskTitle: $isValidTaskTitle,
      isValidCardTitle: $isValidCardTitle,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure
    }''';
  }
}
