import './js_error.dart';
import '../api/opaque_api.dart';
import './opaque_js_bindings.dart';

import 'dart:typed_data';

extension _Uint8ListToString on Uint8List {
  String toStringType() {
    return String.fromCharCodes(this.toList());
  }
}

JSOpaqueIds? _js_ids(OpaqueIds? ids) {
  if (ids == null) {
    return null;
  }
  return JSOpaqueIds(idU: ids.idU.toStringType(), idS: ids.idS.toStringType());
}

class Opaque extends OpaqueInterface {
  Opaque._();

  static Opaque init() {
    return Opaque._();
  }

  @override
  RegisterResult Register(Uint8List pwd, OpaqueIds ids,
      {Uint8List? skS = null}) {
    final JSRegisterResult result = wrap_js_error(() => js_register(
        JSRegisterInputs(
            pwdU: pwd.toStringType(), ids: _js_ids(ids)!, skS: skS)));
    return RegisterResult(result.rec, result.export_key);
  }

  @override
  CreateCredentialRequestResult CreateCredentialRequest(Uint8List pwd) {
    final JSCreateCredentialRequestResult result = wrap_js_error(() =>
        js_createCredentialRequest(
            JSCreateCredentialRequestInputs(pwdU: pwd.toStringType())));
    return CreateCredentialRequestResult(result.sec, result.pub);
  }

  @override
  CreateCredentialResponseResult CreateCredentialResponse(
      Uint8List pub, Uint8List rec, OpaqueIds ids, Uint8List ctx) {
    final JSCreateCredentialResponseResult result = wrap_js_error(() =>
        js_createCredentialResponse(JSCreateCredentialResponseInputs(
            pub: pub,
            rec: rec,
            ids: _js_ids(ids)!,
            context: ctx.toStringType())));
    return CreateCredentialResponseResult(result.resp, result.sk, result.sec);
  }

  @override
  CreateRegistrationRequestResult CreateRegistrationRequest(Uint8List pwd) {
    final result = wrap_js_error(() => js_createRegistrationRequest(
        JSCreateRegistrationRequestInputs(pwdU: pwd.toStringType())));
    return CreateRegistrationRequestResult(result.sec, result.M);
  }

  @override
  CreateRegistrationResponseResult CreateRegistrationResponse(Uint8List request,
      {Uint8List? skS}) {
    final result = wrap_js_error(() => js_createRegistrationResponse(
        JSCreateRegistrationResponseInputs(M: request, skS: skS)));
    return CreateRegistrationResponseResult(result.sec, result.pub);
  }

  @override
  FinalizeRequestResult FinalizeRequest(
      Uint8List sec, Uint8List pub, OpaqueIds ids) {
    final result = wrap_js_error(() => js_finalizeRequest(
        JSFinalizeRequestInputs(sec: sec, pub: pub, ids: _js_ids(ids))));
    return FinalizeRequestResult(result.rec, result.export_key);
  }

  @override
  RecoverCredentialsResult RecoverCredentials(
      Uint8List resp, Uint8List sec, Uint8List ctx,
      {OpaqueIds? ids = null}) {
    final result = wrap_js_error(() => js_recoverCredentials(
        JSRecoverCredentialsInputs(
            resp: resp,
            sec: sec,
            context: ctx.toStringType(),
            ids: _js_ids(ids))));
    return RecoverCredentialsResult(result.sk, result.authU, result.export_key);
  }

  @override
  StoreUserRecordResult StoreUserRecord(Uint8List sec, Uint8List recU) {
    final result = wrap_js_error(
        () => js_storeUserRecord(JSStoreUserRecordInputs(sec: sec, rec: recU)));
    return StoreUserRecordResult(result.rec);
  }

  @override
  void UserAuth(Uint8List authU0, Uint8List authU) {
    wrap_js_error(
        () => js_userAuth(JSUserAuthInputs(sec: authU0, authU: authU)));
  }
}
