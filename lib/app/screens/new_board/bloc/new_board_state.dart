import 'package:meta/meta.dart';

@immutable
class NewBoardState {
  final bool isValidName;
  final bool isValidType;
  final bool isValidLable;
  final bool isDescriptionValid;
  final bool isValidVisitedTime;
  final bool isValidCreatedTime;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isValidName && isValidType && isValidLable && isDescriptionValid;

  NewBoardState(
      {@required this.isValidName,
      @required this.isValidType,
      @required this.isValidLable,
      @required this.isValidCreatedTime,
      @required this.isValidVisitedTime,
      @required this.isDescriptionValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure});

  factory NewBoardState.empty() {
    return NewBoardState(
        isValidName: true,
        isValidType: true,
        isValidLable: true,
        isDescriptionValid: true,
        isValidCreatedTime: true,
        isValidVisitedTime: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  factory NewBoardState.loading() {
    return NewBoardState(
        isValidName: true,
        isValidType: true,
        isValidLable: true,
        isDescriptionValid: true,
        isValidCreatedTime: true,
        isValidVisitedTime: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }

  factory NewBoardState.success() {
    return NewBoardState(
        isValidName: true,
        isValidType: true,
        isValidLable: true,
        isDescriptionValid: true,
        isValidCreatedTime: true,
        isValidVisitedTime: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }

  factory NewBoardState.failure() {
    return NewBoardState(
        isValidName: true,
        isValidType: true,
        isValidLable: true,
        isDescriptionValid: true,
        isValidCreatedTime: true,
        isValidVisitedTime: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }

  NewBoardState update({
    bool isValidName,
    bool isValidType,
    bool isValidLable,
    bool isDescriptionValid,
    bool isValidVisitedTime,
    bool isValidCreatedTime,
  }) {
    return copyWith(
        isValidName: isValidName,
        isValidType: isValidType,
        isValidLable: isValidLable,
        isDescriptionValid: isDescriptionValid,
        isValidCreatedTime: isValidCreatedTime,
        isValidVisitedTime: isValidVisitedTime,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  NewBoardState copyWith(
      {bool isValidName,
      bool isValidType,
      bool isValidLable,
      bool isDescriptionValid,
      bool isValidVisitedTime,
      bool isValidCreatedTime,
      bool isSubmitEnabled,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure}) {
    return NewBoardState(
        isValidName: isValidName ?? this.isValidName,
        isValidType: isValidType ?? this.isValidType,
        isValidLable: isValidType ?? this.isValidLable,
        isDescriptionValid: isDescriptionValid ?? this.isDescriptionValid,
        isValidCreatedTime: isValidCreatedTime ?? this.isValidCreatedTime,
        isValidVisitedTime: isValidVisitedTime ?? this.isValidVisitedTime,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }

  @override
  String toString() {
    return '''NewBoardState  {
      isValidName: $isValidName,
      isValidType: $isValidType,
      isValidLable: $isValidLable,
      isDescriptionValid: $isDescriptionValid,
      isValidCreatedTime: $isValidCreatedTime,
      isValidVisitedTime: $isValidVisitedTime,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure
    }''';
  }
}
