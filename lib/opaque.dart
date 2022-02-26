import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';
//import 'package:path/path.dart' as path;

extension Uint8ListBlobConversion on Uint8List {
  /// Allocates a pointer filled with the Uint8List data.
  ffi.Pointer<ffi.Uint8> allocatePointer() {
    final blob = calloc<ffi.Uint8>(length);
    final blobBytes = blob.asTypedList(length);
    blobBytes.setAll(0, this);
    return blob;
  }
}

class _Opaque_Ids extends ffi.Struct {
  @ffi.Uint16()
  external int idU_len;

  external ffi.Pointer<ffi.Uint8> idU;

  @ffi.Uint16()
  external int idS_len;

  external ffi.Pointer<ffi.Uint8> idS;
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
    ffi.Pointer<_Opaque_Ids>,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<ffi.Uint8>);
typedef _RegisterDartWrapper = int Function(
    ffi.Pointer<ffi.Uint8>,
    int,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<_Opaque_Ids>,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<ffi.Uint8>);

typedef size_t = ffi.IntPtr;

class Opaque {
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _sodium_lookup;
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  late final crypto_scalarmult_SCALARBYTES =
      _sodium_lookup<ffi.NativeFunction<size_t Function()>>(
              'crypto_scalarmult_scalarbytes')
          .asFunction<int Function()>()();
  late final crypto_hash_sha512_BYTES =
      _sodium_lookup<ffi.NativeFunction<size_t Function()>>(
              'crypto_hash_sha512_bytes')
          .asFunction<int Function()>()();
  late final crypto_core_ristretto255_SCALARBYTES =
      _sodium_lookup<ffi.NativeFunction<size_t Function()>>(
              'crypto_core_ristretto255_scalarbytes')
          .asFunction<int Function()>()();
  late final crypto_scalarmult_BYTES =
      _sodium_lookup<ffi.NativeFunction<size_t Function()>>(
              'crypto_scalarmult_bytes')
          .asFunction<int Function()>()();
  late final crypto_auth_hmacsha512_BYTES =
      _sodium_lookup<ffi.NativeFunction<size_t Function()>>(
              'crypto_auth_hmacsha512_bytes')
          .asFunction<int Function()>()();

  final OPAQUE_SHARED_SECRETBYTES = 64;
  final OPAQUE_ENVELOPE_NONCEBYTES = 32;
  final OPAQUE_NONCE_BYTES = 32;

  late final OPAQUE_REGISTRATION_RECORD_LEN = (crypto_scalarmult_BYTES +
      crypto_hash_sha512_BYTES +
      OPAQUE_ENVELOPE_NONCEBYTES +
      crypto_auth_hmacsha512_BYTES);

  late final OPAQUE_USER_RECORD_LEN = (crypto_core_ristretto255_SCALARBYTES +
      crypto_scalarmult_SCALARBYTES +
      OPAQUE_REGISTRATION_RECORD_LEN);

  Opaque._(ffi.DynamicLibrary opaquelib, ffi.DynamicLibrary sodium)
      : _sodium_lookup = sodium.lookup,
        _lookup = opaquelib.lookup;

  static Opaque init(
      ffi.DynamicLibrary opaquelib, ffi.DynamicLibrary sodiumlib) {
    return Opaque._(opaquelib, sodiumlib);
  }

  late final _RegisterDartWrapper register_function =
      _lookup<ffi.NativeFunction<_RegisterNative>>("opaque_Register")
          .asFunction<_RegisterDartWrapper>();

  int Register(Uint8List pwd, Uint8List sks, Ids ids) {
    final c = malloc<_Opaque_Ids>();
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
}
