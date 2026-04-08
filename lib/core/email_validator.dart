bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w.+-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$');
  return email.isNotEmpty && emailRegex.hasMatch(email);
}
