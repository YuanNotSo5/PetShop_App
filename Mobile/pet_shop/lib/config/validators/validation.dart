class TValidation {
  //Check whether empty or not
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return "Email không được để trống";
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Địa chỉ email không phù hợp';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }

    if (value.length < 6) {
      return 'Mật khẩu phải có độ dài ít nhất là 6';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Mật khẩu phải chứa ít nhất một ký tự in hoa";
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Mật khẩu phải chứa ít nhất một chữ số";
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Mật khẩu phải chứa ít nhất một ký tự đặc biệt";
    }

    // Kiểm tra nếu có khoảng trắng
    if (value.contains(RegExp(r'\s'))) {
      return "Mật khẩu không được chứa dấu cách";
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    value = value?.trim();

    if (value == null || value.isEmpty) {
      return 'Số điện thoại không được bỏ trống';
    }

    //Regular expression for phone number
    final phoneRegExp = RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }
}
