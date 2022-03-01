@JS("libopaque")
library libopaque.js;

import 'dart:typed_data';
import 'package:js/js.dart';

@JS()
@anonymous
class JSOpaqueIds {
  external String get idU;
  external String get idS;

  external factory JSOpaqueIds({String idU, String idS});
}

@JS()
@anonymous
class JSGenServerKeyPairResult {
  external Uint8List get pkS;
  external Uint8List get skS;

  external factory JSGenServerKeyPairResult({Uint8List pkS, Uint8List skS});
}

@JS()
@anonymous
class JSRegisterResult {
  external Uint8List get rec;
  external Uint8List get export_key;

  external factory JSRegisterResult({Uint8List rec, Uint8List export_key});
}

@JS()
@anonymous
class JSRegisterInputs {
  external String get pwdU;
  external JSOpaqueIds get ids;
  external Uint8List? get skS;

  external factory JSRegisterInputs(
      {String pwdU, JSOpaqueIds ids, Uint8List? skS});
}

@JS()
@anonymous
class JSCreateCredentialRequestResult {
  external Uint8List get sec;
  external Uint8List get pub;

  external factory JSCreateCredentialRequestResult(
      {Uint8List sec, Uint8List pub});
}

@JS()
@anonymous
class JSCreateCredentialRequestInputs {
  external String get pwdU;

  external factory JSCreateCredentialRequestInputs({String pwdU});
}

@JS()
@anonymous
class JSCreateCredentialResponseResult {
  external Uint8List get resp;
  external Uint8List get sk;
  external Uint8List get sec;

  external factory JSCreateCredentialResponseResult(
      {Uint8List resp, Uint8List sk, Uint8List sec});
}

@JS()
@anonymous
class JSCreateCredentialResponseInputs {
  external Uint8List get pub;
  external Uint8List get rec;
  external JSOpaqueIds get ids;
  external String get context;

  external factory JSCreateCredentialResponseInputs(
      {Uint8List pub, Uint8List rec, JSOpaqueIds ids, String context});
}

@JS()
@anonymous
class JSRecoverCredentialsResult {
  external Uint8List get sk;
  external Uint8List get authU;
  external Uint8List get export_key;

  external factory JSRecoverCredentialsResult(
      {Uint8List sk, Uint8List authU, Uint8List export_key});
}

@JS()
@anonymous
class JSRecoverCredentialsInputs {
  external Uint8List get resp;
  external Uint8List get sec;
  external String get context;
  external JSOpaqueIds? get ids;

  external factory JSRecoverCredentialsInputs(
      {Uint8List resp, Uint8List sec, String context, JSOpaqueIds? ids});
}

@JS()
@anonymous
class JSUserAuthInputs {
  external Uint8List get sec;
  external Uint8List get authU;

  external factory JSUserAuthInputs({Uint8List sec, Uint8List authU});
}

@JS()
@anonymous
class JSCreateRegistrationRequestResult {
  external Uint8List get sec;
  external Uint8List get M;

  external factory JSCreateRegistrationRequestResult(
      {required Uint8List sec, Uint8List M});
}

@JS()
@anonymous
class JSCreateRegistrationRequestInputs {
  external String get pwdU;

  external factory JSCreateRegistrationRequestInputs({String pwdU});
}

@JS()
@anonymous
class JSCreateRegistrationResponseResult {
  external Uint8List get sec;
  external Uint8List get pub;

  external factory JSCreateRegistrationResponseResult(
      {required Uint8List sec, Uint8List pub});
}

@JS()
@anonymous
class JSCreateRegistrationResponseInputs {
  external Uint8List get M;
  external Uint8List? get skS;

  external factory JSCreateRegistrationResponseInputs(
      {Uint8List M, Uint8List? skS});
}

@JS()
@anonymous
class JSFinalizeRequestResult {
  external Uint8List get rec;
  external Uint8List get export_key;

  external factory JSFinalizeRequestResult(
      {required Uint8List rec, Uint8List export_key});
}

@JS()
@anonymous
class JSFinalizeRequestInputs {
  external Uint8List get sec;
  external Uint8List get pub;
  external JSOpaqueIds? get ids;

  external factory JSFinalizeRequestInputs(
      {Uint8List sec, Uint8List pub, JSOpaqueIds? ids});
}

@JS()
@anonymous
class JSStoreUserRecordResult {
  external Uint8List get rec;

  external factory JSStoreUserRecordResult({Uint8List rec});
}

@JS()
@anonymous
class JSStoreUserRecordInputs {
  external Uint8List get sec;
  external Uint8List get rec;

  external factory JSStoreUserRecordInputs({Uint8List sec, Uint8List rec});
}

external int OPAQUE_REGISTER_PUBLIC_LEN;
external int OPAQUE_REGISTER_SECRET_LEN;
external int OPAQUE_REGISTER_USER_SEC_LEN;
external int OPAQUE_REGISTRATION_RECORD_LEN;
external int OPAQUE_SERVER_SESSION_LEN;
external int OPAQUE_SHARED_SECRETBYTES;
external int OPAQUE_USER_RECORD_LEN;
external int OPAQUE_USER_SESSION_PUBLIC_LEN;
external int OPAQUE_USER_SESSION_SECRET_LEN;

@JS("genServerKeyPair")
external JSGenServerKeyPairResult js_genServerKeyPair();

@JS("register")
external JSRegisterResult js_register(JSRegisterInputs);

@JS("createCredentialRequest")
external JSCreateCredentialRequestResult js_createCredentialRequest(
    JSCreateCredentialRequestInputs);

@JS("createCredentialResponse")
external JSCreateCredentialResponseResult js_createCredentialResponse(
    JSCreateCredentialResponseInputs);

@JS("recoverCredentials")
external JSRecoverCredentialsResult js_recoverCredentials(
    JSRecoverCredentialsInputs);

@JS("userAuth")
external bool js_userAuth(JSUserAuthInputs);

@JS("createRegistrationRequest")
external JSCreateRegistrationRequestResult js_createRegistrationRequest(
    JSCreateRegistrationRequestInputs);

@JS("createRegistrationResponse")
external JSCreateRegistrationResponseResult js_createRegistrationResponse(
    JSCreateRegistrationResponseInputs);

@JS("finalizeRequest")
external JSFinalizeRequestResult js_finalizeRequest(JSFinalizeRequestInputs);

@JS("storeUserRecord")
external JSStoreUserRecordResult js_storeUserRecord(JSStoreUserRecordInputs);
