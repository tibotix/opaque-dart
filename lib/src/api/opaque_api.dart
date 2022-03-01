import 'dart:typed_data';

class OpaqueException implements Exception {
  final String message;
  OpaqueException(this.message);
}

class OpaqueIds {
  Uint8List idU;
  Uint8List idS;

  OpaqueIds(this.idU, this.idS);

  OpaqueIds.fromStrings(String idU, String idS)
      : idU = Uint8List.fromList(idU.codeUnits),
        idS = Uint8List.fromList(idS.codeUnits);
}

class GenServerKeyPairResult {
  final Uint8List pkS;
  final Uint8List skS;

  GenServerKeyPairResult(this.pkS, this.skS);
}

class RegisterResult {
  final Uint8List rec;
  final Uint8List export_key;

  RegisterResult(this.rec, this.export_key);
}

class CreateCredentialRequestResult {
  final Uint8List sec;
  final Uint8List pub;

  CreateCredentialRequestResult(this.sec, this.pub);
}

class CreateCredentialResponseResult {
  final Uint8List resp;
  final Uint8List sk;
  final Uint8List sec;

  CreateCredentialResponseResult(this.resp, this.sk, this.sec);
}

class RecoverCredentialsResult {
  final Uint8List sk;
  final Uint8List authU;
  final Uint8List export_key;

  RecoverCredentialsResult(this.sk, this.authU, this.export_key);
}

class CreateRegistrationRequestResult {
  final Uint8List sec;
  final Uint8List M;

  CreateRegistrationRequestResult(this.sec, this.M);
}

class CreateRegistrationResponseResult {
  final Uint8List sec;
  final Uint8List pub;

  CreateRegistrationResponseResult(this.sec, this.pub);
}

class FinalizeRequestResult {
  final Uint8List rec;
  final Uint8List export_key;

  FinalizeRequestResult(this.rec, this.export_key);
}

class StoreUserRecordResult {
  final Uint8List rec;

  StoreUserRecordResult(this.rec);
}

abstract class OpaqueInterface {
  RegisterResult Register(Uint8List pwd, OpaqueIds ids, {Uint8List? skS});
  CreateCredentialRequestResult CreateCredentialRequest(Uint8List pwd);
  CreateCredentialResponseResult CreateCredentialResponse(
      Uint8List pub, Uint8List rec, OpaqueIds ids, Uint8List ctx);
  RecoverCredentialsResult RecoverCredentials(
      Uint8List resp, Uint8List sec, Uint8List ctx,
      {OpaqueIds? ids = null});
  void UserAuth(Uint8List authU0, Uint8List authU);
  CreateRegistrationRequestResult CreateRegistrationRequest(Uint8List pwd);
  CreateRegistrationResponseResult CreateRegistrationResponse(Uint8List request,
      {Uint8List? skS});
  FinalizeRequestResult FinalizeRequest(
      Uint8List sec, Uint8List pub, OpaqueIds ids);
  StoreUserRecordResult StoreUserRecord(Uint8List sec, Uint8List recU);
}
