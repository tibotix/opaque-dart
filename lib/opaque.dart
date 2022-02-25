import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;
import 'package:ffi/ffi.dart';

import 'dart:typed_data';
//import 'package:path/path.dart' as path;

var library_path = Directory.current.path + "\\libopaque.dll";

final opaquelib = ffi.DynamicLibrary.open(library_path);

final crypto_scalarmult_SCALARBYTES = 32;
final crypto_hash_sha512_BYTES = 64;
final crypto_core_ristretto255_SCALARBYTES = 32;
final crypto_scalarmult_BYTES = 32;
final crypto_auth_hmacsha512_BYTES = 64;

final OPAQUE_SHARED_SECRETBYTES = 64;
final OPAQUE_ENVELOPE_NONCEBYTES = 32;
final OPAQUE_NONCE_BYTES = 32;

final OPAQUE_REGISTRATION_RECORD_LEN = (crypto_scalarmult_BYTES +
    crypto_hash_sha512_BYTES +
    OPAQUE_ENVELOPE_NONCEBYTES +
    crypto_auth_hmacsha512_BYTES);

final OPAQUE_USER_RECORD_LEN = (crypto_core_ristretto255_SCALARBYTES +
    crypto_scalarmult_SCALARBYTES +
    OPAQUE_REGISTRATION_RECORD_LEN);

extension Uint8ListBlobConversion on Uint8List {
  /// Allocates a pointer filled with the Uint8List data.
  ffi.Pointer<ffi.Uint8> allocatePointer() {
    final blob = calloc<ffi.Uint8>(length);
    final blobBytes = blob.asTypedList(length);
    blobBytes.setAll(0, this);
    return blob;
  }
}

class Opaque_Ids extends ffi.Struct {
  @ffi.Uint16()
  int idU_len;

  ffi.Pointer<ffi.Uint8> idU;

  @ffi.Uint16()
  int idS_len;

  ffi.Pointer<ffi.Uint8> idS;
}

class Ids {
  Uint8List idU;
  Uint8List idS;

  Ids(this.idU, this.idS);
}

typedef _RegisterNative = ffi.Int32 Function(
    ffi.Pointer<ffi.Uint8>,
    ffi.Uint16,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<Opaque_Ids>,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<ffi.Uint8>);
typedef _RegisterDartWrapper = int Function(
    ffi.Pointer<ffi.Uint8>,
    int,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<Opaque_Ids>,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<ffi.Uint8>);

final _RegisterDartWrapper register_function = opaquelib
    .lookup<ffi.NativeFunction<_RegisterNative>>("opaque_Register")
    .asFunction();

int Register(Uint8List pwd, Uint8List sks, Ids ids) {
  final c = malloc<Opaque_Ids>();
  c.ref.idS = ids.idS.allocatePointer();
  c.ref.idS_len = ids.idS.lengthInBytes;
  c.ref.idU = ids.idU.allocatePointer();
  c.ref.idU_len = ids.idU.lengthInBytes;

  final rec = malloc<ffi.Uint8>(OPAQUE_USER_RECORD_LEN);
  final exportkey = malloc<ffi.Uint8>(crypto_hash_sha512_BYTES);

  final int ret = register_function(pwd.allocatePointer(), pwd.lengthInBytes,
      sks.allocatePointer(), c, rec, exportkey);

  print(rec.asTypedList(OPAQUE_USER_RECORD_LEN).toString());
  print(exportkey.asTypedList(crypto_hash_sha512_BYTES).toString());

  return ret;
}

void main(List<String> args) {
  final idU = Uint8List(5);
  final idS = Uint8List(5);
  final ids = Ids(idU, idS);

  final pwd = Uint8List.fromList([64, 65, 66, 67]);
  final skS = Uint8List(crypto_scalarmult_SCALARBYTES);
  print(Register(pwd, skS, ids));
}
