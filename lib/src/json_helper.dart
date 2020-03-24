class JsonHelper {
  static List<String> fromList(List<dynamic> l) {
    return l.map((v) => v as String).toList();
  }

  static Map<String, String> fromMap(dynamic m) {
    return (m as Map).map((k, v) => MapEntry(k, v as String));
  }
}