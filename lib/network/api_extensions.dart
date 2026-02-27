extension ResponseExtensions on dynamic {
  int get statusCode => 200;
  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
