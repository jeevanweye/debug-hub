import 'dart:convert';

class JsonFormatter {
  static String format(dynamic json) {
    if (json == null) return '';
    
    try {
      if (json is String) {
        final decoded = jsonDecode(json);
        return JsonEncoder.withIndent('  ').convert(decoded);
      }
      return JsonEncoder.withIndent('  ').convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  static bool isValidJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  static dynamic parseJson(String str) {
    try {
      return jsonDecode(str);
    } catch (e) {
      return null;
    }
  }
}

