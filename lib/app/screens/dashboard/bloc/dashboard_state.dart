import 'package:meta/meta.dart';

@immutable
class DashboardState {
  final bool isValidSearchInput;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isValidSearchInput;

  DashboardState(
      {@required this.isValidSearchInput,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure});

  factory DashboardState.empty() {
    return DashboardState(
        isValidSearchInput: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  factory DashboardState.loading() {
    return DashboardState(
        isValidSearchInput: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }

  factory DashboardState.success() {
    return DashboardState(
        isValidSearchInput: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }

  factory DashboardState.failure() {
    return DashboardState(
        isValidSearchInput: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }

  DashboardState update({bool isValidSearchInput}) {
    return copyWith(
        isValidSearchInput: isValidSearchInput,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  DashboardState copyWith(
      {bool isValidSearchInput,
      bool isSubmitEnabled,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure}) {
    return DashboardState(
        isValidSearchInput: isValidSearchInput ?? this.isValidSearchInput,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }

  @override
  String toString() {
    return '''DashboardState {
      isValidSearchInput: $isValidSearchInput,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure
    }''';
  }
}
