import 'dart:html';
import 'dart:typed_data';
import 'package:opaque/js/js_error.dart';
import 'package:opaque/opaque.js.dart';

final String pwdU = "pwdU";
final String context = "context";

OpaqueIds make_ids(String username) {
  return OpaqueIds(idU: username, idS: "idS");
}

Map<String, Uint8List> register(String username, String pwd) {
  final ids = make_ids(username);
  final reg_req =
      createRegistrationRequest(CreateRegistrationRequestInputs(pwdU: pwd));
  final reg_resp = createRegistrationResponse(
      CreateRegistrationResponseInputs(M: reg_req.M));
  final fin_req = finalizeRequest(
      FinalizeRequestInputs(sec: reg_req.sec, pub: reg_resp.pub, ids: ids));
  final rec = storeUserRecord(
      StoreUserRecordInputs(sec: reg_resp.sec, rec: fin_req.rec));
  return {"export_key": fin_req.export_key, "rec": rec.rec};
}

Map<String, Uint8List> login(String username, String pwd, Uint8List rec) {
  final ids = make_ids(username);
  final cred_req =
      createCredentialRequest(CreateCredentialRequestInputs(pwdU: pwd));
  final cred_resp = createCredentialResponse(CreateCredentialResponseInputs(
      pub: cred_req.pub, rec: rec, ids: ids, context: context));
  final rec_cred = recoverCredentials(RecoverCredentialsInputs(
      resp: cred_resp.resp, sec: cred_req.sec, context: context, ids: ids));

  userAuth(UserAuthInputs(sec: cred_resp.sec, authU: rec_cred.authU));
  assert(cred_resp.sk.toString() == rec_cred.sk.toString());

  return {"export_key": rec_cred.export_key};
}

class Credentials {
  final String username;
  final String password;

  Credentials.from_strings(String username, String password)
      : username = username,
        password = password;
}

// Credentials get_credentials() {
//   print("Username: ");
//   String? user = stdin.readLineSync();
//   print("Password: ");
//   String? pwd = stdin.readLineSync();
//   return Credentials.from_strings(user!, pwd!);
// }

void main(List<String> args) {
  print("Registration:");
  final reg_creds = Credentials.from_strings("user", "pass");

  final reg = register(reg_creds.username, reg_creds.password);

  print("Login:");
  final log_creds = Credentials.from_strings("user", "pass");

  try {
    final log = login(log_creds.username, log_creds.password, reg["rec"]!);

    assert(reg["export_key"].toString() == log["export_key"].toString());

    print("authenticated");
  } on JsError {
    print("login failed");
  }
}
