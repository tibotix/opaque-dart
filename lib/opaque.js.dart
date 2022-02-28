@JS("libopaque")
library libopaque.js;

import 'dart:typed_data';

import 'package:js/js.dart';
//import 'package:opaque/opaque.dart';

@JS()
@anonymous
class OpaqueIds {
  external String get idU;
  external String get idS;

  external factory OpaqueIds({String idU, String idS});
}

@JS()
@anonymous
class GenServerKeyPairResult {
  external Uint8List get pkS;
  external Uint8List get skS;

  external factory GenServerKeyPairResult({Uint8List pkS, Uint8List skS});
}

@JS()
@anonymous
class RegisterResult {
  external Uint8List get rec;
  external Uint8List get export_key;

  external factory RegisterResult({Uint8List rec, Uint8List export_key});
}

@JS()
@anonymous
class RegisterInputs {
  external String get pwdU;
  external OpaqueIds get ids;
  external Uint8List? get skS;

  external factory RegisterInputs({String pwdU, OpaqueIds ids, Uint8List? skS});
}

@JS()
@anonymous
class CreateCredentialRequestResult {
  external Uint8List get sec;
  external Uint8List get pub;

  external factory CreateCredentialRequestResult(
      {Uint8List sec, Uint8List pub});
}

@JS()
@anonymous
class CreateCredentialRequestInputs {
  external String get pwdU;

  external factory CreateCredentialRequestInputs({String pwdU});
}

@JS()
@anonymous
class CreateCredentialResponseResult {
  external Uint8List get resp;
  external Uint8List get sk;
  external Uint8List get sec;

  external factory CreateCredentialResponseResult(
      {Uint8List resp, Uint8List sk, Uint8List sec});
}

@JS()
@anonymous
class CreateCredentialResponseInputs {
  external Uint8List get pub;
  external Uint8List get rec;
  external OpaqueIds get ids;
  external String get context;

  external factory CreateCredentialResponseInputs(
      {Uint8List pub, Uint8List rec, OpaqueIds ids, String context});
}

@JS()
@anonymous
class RecoverCredentialsResult {
  external Uint8List get sk;
  external Uint8List get authU;
  external Uint8List get export_key;

  external factory RecoverCredentialsResult(
      {Uint8List sk, Uint8List authU, Uint8List export_key});
}

@JS()
@anonymous
class RecoverCredentialsInputs {
  external Uint8List get resp;
  external Uint8List get sec;
  external String get context;
  external OpaqueIds? get ids;

  external factory RecoverCredentialsInputs(
      {Uint8List resp, Uint8List sec, String context, OpaqueIds? ids});
}

@JS()
@anonymous
class UserAuthInputs {
  external Uint8List get sec;
  external Uint8List get authU;

  external factory UserAuthInputs({Uint8List sec, Uint8List authU});
}

@JS()
@anonymous
class CreateRegistrationRequestResult {
  external Uint8List get sec;
  external Uint8List get M;

  external factory CreateRegistrationRequestResult(
      {required Uint8List sec, Uint8List M});
}

@JS()
@anonymous
class CreateRegistrationRequestInputs {
  external String get pwdU;

  external factory CreateRegistrationRequestInputs({String pwdU});
}

@JS()
@anonymous
class CreateRegistrationResponseResult {
  external Uint8List get sec;
  external Uint8List get pub;

  external factory CreateRegistrationResponseResult(
      {required Uint8List sec, Uint8List pub});
}

@JS()
@anonymous
class CreateRegistrationResponseInputs {
  external Uint8List get M;
  external Uint8List? get skS;

  external factory CreateRegistrationResponseInputs(
      {Uint8List M, Uint8List? skS});
}

@JS()
@anonymous
class FinalizeRequestResult {
  external Uint8List get rec;
  external Uint8List get export_key;

  external factory FinalizeRequestResult(
      {required Uint8List rec, Uint8List export_key});
}

@JS()
@anonymous
class FinalizeRequestInputs {
  external Uint8List get sec;
  external Uint8List get pub;
  external OpaqueIds? get ids;

  external factory FinalizeRequestInputs(
      {Uint8List sec, Uint8List pub, OpaqueIds? ids});
}

@JS()
@anonymous
class StoreUserRecordResult {
  external Uint8List get rec;

  external factory StoreUserRecordResult({Uint8List rec});
}

@JS()
@anonymous
class StoreUserRecordInputs {
  external Uint8List get sec;
  external Uint8List get rec;

  external factory StoreUserRecordInputs({Uint8List sec, Uint8List rec});
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

external GenServerKeyPairResult genServerKeyPair();
external RegisterResult register(RegisterInputs);
external CreateCredentialRequestResult createCredentialRequest(
    CreateCredentialRequestInputs);
external CreateCredentialResponseResult createCredentialResponse(
    CreateCredentialResponseInputs);
external RecoverCredentialsResult recoverCredentials(RecoverCredentialsInputs);
external bool userAuth(UserAuthInputs);
external CreateRegistrationRequestResult createRegistrationRequest(
    CreateRegistrationRequestInputs);
external CreateRegistrationResponseResult createRegistrationResponse(
    CreateRegistrationResponseInputs);
external FinalizeRequestResult finalizeRequest(FinalizeRequestInputs);
external StoreUserRecordResult storeUserRecord(StoreUserRecordInputs);
