extension ExtensionsString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this) && length <= 32;
  }

  //bool get isNotNull {
  //  return this != null;
  //}

  bool get isValidPhone {
    // Accept formats like: +1234567890, 01234567890
    final phoneRegExp = RegExp(r'^(\+)?[0-9]{10,12}$');
    return phoneRegExp.hasMatch(this);
  }
}
