import 'package:opaque/opaque.dart';
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
  var res = opaque.CreateRegistrationRequest(pwd);
  final request = res["request"]!;
  final secU = res["sec"]!;

  res = opaque.CreateRegistrationResponse(request);
  final secS = res["sec"]!;
  final pub = res["pub"]!;

  res = opaque.FinalizeRequest(secU, pub, ids);
  final reg_rec = res["reg_rec"]!;
  final export_key = res["export_key"]!;

  res = opaque.StoreUserRecord(secS, reg_rec);
  final rec = res["rec"]!;
  return {"export_key": export_key, "rec": rec};
}

Map<String, Uint8List> login(Uint8List username, Uint8List pwd, Uint8List rec) {
  final ids = make_ids(username);
  var res = opaque.CreateCredentialRequest(pwd);
  final log_pub = res["pub"]!;
  final log_secU = res["sec"]!;

  res = opaque.CreateCredentialResponse(log_pub, rec, ids, context);
  final log_resp = res["resp"]!;
  final log_sk = res["sk"]!;
  final log_authU = res["authU"]!;

  res = opaque.RecoverCredentials(log_resp, log_secU, context, ids: ids);
  final log_sk1 = res["sk"]!;
  final log_authU1 = res["authU"]!;
  final log_export_key = res["export_key"]!;

  opaque.UserAuth(log_authU, log_authU1);
  assert(log_sk == log_sk1);

  return {"export_key": log_export_key};
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
  } on ArgumentError {
    print("login failed");
  }
}
