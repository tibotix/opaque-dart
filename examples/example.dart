import 'package:opaque/opaque.dart';
import 'dart:typed_data';
import 'dart:ffi' as ffi;
import 'dart:io' show Directory;

var library_path = Directory.current.path + "\\libopaque.dll";
var sodium_library_path = Directory.current.path + "\\libsodium.dll";

final opaquelib = ffi.DynamicLibrary.open(library_path);
final sodiumlib = ffi.DynamicLibrary.open(sodium_library_path);

void main(List<String> args) {
  final opaque = Opaque.init(opaquelib, sodiumlib);

  final idU = Uint8List(5);
  final idS = Uint8List(5);
  final ids = Ids(idU, idS);

  final pwd = Uint8List.fromList([64, 65, 66, 67]);
  final skS = Uint8List(opaque.crypto_scalarmult_SCALARBYTES);

  print("Register Result: " + opaque.Register(pwd, skS, ids).toString());
}
