class Validator {
  static String? nonEmpty(String? value) {
    if (value == null || value.isEmpty) return 'This field is required';
    return null;
  }
}
