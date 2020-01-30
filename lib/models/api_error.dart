class ApiError {
  final dynamic message;

  ApiError({
    this.message,
  });

  factory ApiError.fromJson(Map<String, dynamic> jsonMap) {
    return new ApiError(
      message: jsonMap["message"],
    );
  }
}