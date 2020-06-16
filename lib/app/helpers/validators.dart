class Validators {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp _passwordRegex = RegExp(
      r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$');

  static final RegExp _fullNameRegex = RegExp(
    r'^[a-z A-Z,.\-]+$',
  );

  static final RegExp _mobileRegex = RegExp(
    r'^(?:[+0]9)?[0-9]{10}$',
  );

  static final RegExp _zipCodeRegex = RegExp(
    r'^\d{5}(?:[-\s]\d{4})?$',
  );

  static final RegExp _expiryDateRegex = RegExp(
    r'^\d{2}\/\d{2}$',
  );

  static final RegExp _cvvRegex = RegExp(
    r'^\d{4}$',
  );

  static final RegExp _urlRegex = RegExp(
      r'(https?|http?|file)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?');

  static isValidFullName(String fullname) {
    return _fullNameRegex.hasMatch(fullname);
  }

  static isValidEmail(String email) {
    return _emailRegex.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegex.hasMatch(password);
  }

  static isValidMobile(String mobile) {
    return _mobileRegex.hasMatch(mobile);
  }

  static isValidZipCode(String zipCode) {
    return _zipCodeRegex.hasMatch(zipCode);
  }

  static isValidConfirmPassword(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static isValidExpiryDate(String date) {
    return _expiryDateRegex.hasMatch(date);
  }

  static isValidCvv(String date) {
    return _cvvRegex.hasMatch(date);
  }

  static isValidImagePath(String path) {
    return _urlRegex.hasMatch(path);
  }
}
