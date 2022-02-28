import 'package:opaque/opaque.ffi.dart';
import 'dart:typed_data';
import 'dart:ffi' as ffi;
import 'dart:io' show Directory, stdout, stdin;

var opaque_library_path = Directory.current.path + "\\libopaque.dll";
var sodium_library_path = Directory.current.path + "\\libsodium.dll";

final libopaque = ffi.DynamicLibrary.open(opaque_library_path);
final libsodium = ffi.DynamicLibrary.open(sodium_library_path);

final opaque = Opaque.init(libopaque, libsodium);

final Uint8List context = Uint8List.fromList("opaque-dart-v0.0.1".codeUnits);

OpaqueIds make_ids(Uint8List username) {
  return OpaqueIds(username, Uint8List.fromList("idS".codeUnits));
}

Map<String, Uint8List> register(Uint8List username, Uint8List pwd) {
  final ids = make_ids(username);
  final reg_req = opaque.CreateRegistrationRequest(pwd);
  final reg_resp = opaque.CreateRegistrationResponse(reg_req.M);
  final fin_req = opaque.FinalizeRequest(reg_req.sec, reg_resp.pub, ids);
  final usr_rec = opaque.StoreUserRecord(reg_resp.sec, fin_req.rec);
  return {"export_key": fin_req.export_key, "rec": usr_rec.rec};
}

Map<String, Uint8List> login(Uint8List username, Uint8List pwd, Uint8List rec) {
  final ids = make_ids(username);
  final cred_req = opaque.CreateCredentialRequest(pwd);
  final cred_resp =
      opaque.CreateCredentialResponse(cred_req.pub, rec, ids, context);
  final rec_cred = opaque.RecoverCredentials(
      cred_resp.resp, cred_req.sec, context,
      ids: ids);

  opaque.UserAuth(cred_resp.sec, rec_cred.authU);
  assert(cred_resp.sk == rec_cred.sk);

  return {"export_key": rec_cred.export_key};
}

class Credentials {
  final Uint8List username;
  final Uint8List password;

  Credentials.from_strings(String username, String password)
      : username = Uint8List.fromList(username.codeUnits),
        password = Uint8List.fromList(password.codeUnits);
}

Credentials get_credentials() {
  stdout.write("Username: ");
  String? user = stdin.readLineSync();
  stdout.write("Password: ");
  String? pwd = stdin.readLineSync();
  return Credentials.from_strings(user!, pwd!);
}

void main(List<String> args) {
  print("Registration:");
  final reg_creds = get_credentials();

  final reg = register(reg_creds.username, reg_creds.password);

  print("Login:");
  final log_creds = get_credentials();

  try {
    final log = login(log_creds.username, log_creds.password, reg["rec"]!);

    assert(reg["export_key"] == log["export_key"]);

    print("authenticated");
  } on OpaqueException {
    print("login failed");
  }
}
