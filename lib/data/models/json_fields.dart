String? optionalString(Map<Object?, Object?> json, String key) {
  return switch (json[key]) {
    null => null,
    final String value when value.isEmpty => null,
    final String value => value,
    final Object other => throw FormatException(
      'Campo "$key" deveria ser texto',
      other,
    ),
  };
}