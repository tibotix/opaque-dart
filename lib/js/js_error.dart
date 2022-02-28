@JS()
library js_error;

import 'package:js/js.dart';

@JS("Error")
class JsError {
  external String get message;

  external factory JsError([String? message]);
}
