class ResponseDataMap {
  bool status;
  String message;
  Map? data;

  // Constructor with required named parameters
  ResponseDataMap({
    required this.status,
    required this.message,
    this.data,
  });
}
