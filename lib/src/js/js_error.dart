@JS()
library js_error;

import 'package:js/js.dart';
import '../api/opaque_api.dart';

@JS("Error")
class JsError {
  external String get message;

  external factory JsError([String? message]);
}

T wrap_js_error<T>(T Function() callback) {
  try {
    return callback();
  } on JsError catch (e) {
    throw OpaqueException(e.message);
  }
}
