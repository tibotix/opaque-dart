import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';

//import 'package:path/path.dart' as path;

class _NativeOpaqueIds extends ffi.Struct {
  @ffi.Uint16()
  external int idU_len;

  external ffi.Pointer<ffi.Uint8> idU;

  @ffi.Uint16()
  external int idS_len;

  external ffi.Pointer<ffi.Uint8> idS;
}

class OpaqueIds {
  Uint8List idU;
  Uint8List idS;

  OpaqueIds(this.idU, this.idS);
}

class _CPointerParameter<T extends ffi.NativeType, R> {
  final int length;
  final ffi.Pointer<T> _raw_ptr;

  _CPointerParameter(int length)
      : length = length,
        _raw_ptr = calloc.allocate<T>(length);

  _CPointerParameter.nullptr()
      : length = 0,
        _raw_ptr = ffi.Pointer<T>.fromAddress(0);

  void _internal_free() {}

  void free() {
    if (_raw_ptr.address == 0) {
      return;
    }
    this._internal_free();
    calloc.free(_raw_ptr);
  }

  ffi.Pointer<T> get raw_ptr => _raw_ptr;
}

abstract class _CPointerInputParameter<T extends ffi.NativeType, R>
    extends _CPointerParameter<T, R?> {
  _CPointerInputParameter(int length, R obj) : super(length) {
    this._convert_to_native();
  }
  _CPointerInputParameter.nullptr() : super.nullptr();

  void _convert_to_native();
}

class _Uint8ListCPointerInputParameter
    extends _CPointerInputParameter<ffi.Uint8, Uint8List> {
  final Uint8List? u8list;
  _Uint8ListCPointerInputParameter(Uint8List u8list)
      : u8list = u8list,
        super(u8list.lengthInBytes, u8list);
  _Uint8ListCPointerInputParameter.nullptr()
      : u8list = null,
        super.nullptr();

  factory _Uint8ListCPointerInputParameter.nullable(Uint8List? u8list) {
    if (u8list == null) {
      return _Uint8ListCPointerInputParameter.nullptr();
    }
    return _Uint8ListCPointerInputParameter(u8list);
  }

  void _convert_to_native() {
    if (u8list != null) {
      _raw_ptr.asTypedList(length).setAll(0, u8list!);
    }
  }
}

class _OpaqueIdsCPointerInputParameter
    extends _CPointerInputParameter<_NativeOpaqueIds, OpaqueIds> {
  final _Uint8ListCPointerInputParameter? _internal_idS;
  final _Uint8ListCPointerInputParameter? _internal_idU;
  OpaqueIds? ids;

  _OpaqueIdsCPointerInputParameter(OpaqueIds ids)
      : ids = ids,
        _internal_idS = _Uint8ListCPointerInputParameter(ids.idS),
        _internal_idU = _Uint8ListCPointerInputParameter(ids.idU),
        super(ffi.sizeOf<_NativeOpaqueIds>(), ids);

  _OpaqueIdsCPointerInputParameter.nullptr()
      : ids = null,
        _internal_idS = null,
        _internal_idU = null,
        super.nullptr();

  factory _OpaqueIdsCPointerInputParameter.nullable(OpaqueIds? ids) {
    if (ids == null) {
      return _OpaqueIdsCPointerInputParameter.nullptr();
    }
    return _OpaqueIdsCPointerInputParameter(ids);
  }

  void _convert_to_native() {
    if (ids == null) {
      return;
    }
    this._raw_ptr.ref.idS = _internal_idS!.raw_ptr;
    this._raw_ptr.ref.idS_len = ids!.idS.lengthInBytes;
    this._raw_ptr.ref.idU = _internal_idU!.raw_ptr;
    this._raw_ptr.ref.idU_len = ids!.idU.lengthInBytes;
  }

  void _internal_free() {
    _internal_idS?.free();
    _internal_idU?.free();
  }
}

abstract class _CPointerOutputParameter<T extends ffi.NativeType, R>
    extends _CPointerParameter<T, R> {
  _CPointerOutputParameter(int length) : super(length);

  R copy();

  R release() {
    final R copy = this.copy();
    this.free();
    return copy;
  }
}

class _Uint8ListCPointerOutputParameter
    extends _CPointerOutputParameter<ffi.Uint8, Uint8List> {
  _Uint8ListCPointerOutputParameter(int length) : super(length);

  Uint8List copy() {
    return Uint8List.fromList(this._raw_ptr.asTypedList(this.length));
  }
}

typedef _RegisterNative = ffi.Int32 Function(
    ffi.Pointer<ffi.Uint8>,
    ffi.Uint16,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<_NativeOpaqueIds>,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<ffi.Uint8>);
typedef _RegisterDartWrapper = int Function(
    ffi.Pointer<ffi.Uint8>,
    int,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<_NativeOpaqueIds>,
    ffi.Pointer<ffi.Uint8>,
    ffi.Pointer<ffi.Uint8>);

typedef _CreateCredentialRequestNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Uint16,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);
typedef _CreateCredentialRequestDartWrapper = int Function(
  ffi.Pointer<ffi.Uint8>,
  int,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);

typedef _CreateCredentialResponseNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<_NativeOpaqueIds>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Uint16,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);
typedef _CreateCredentialResponseDartWrapper = int Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<_NativeOpaqueIds>,
  ffi.Pointer<ffi.Uint8>,
  int,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);

typedef _RecoverCredentialsNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Uint16,
  ffi.Pointer<_NativeOpaqueIds>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);
typedef _RecoverCredentialsDartWrapper = int Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  int,
  ffi.Pointer<_NativeOpaqueIds>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);

typedef _UserAuthNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);
typedef _UserAuthDartWrapper = int Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);

typedef _CreateRegistrationRequestNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Uint16,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);
typedef _CreateRegistrationRequestDartWrapper = int Function(
  ffi.Pointer<ffi.Uint8>,
  int,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);

typedef _CreateRegistrationResponseNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);
typedef _CreateRegistrationResponseDartWrapper = int Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);

typedef _FinalizeRequestNative = ffi.Int32 Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<_NativeOpaqueIds>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);
typedef _FinalizeRequestDartWrapper = int Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<_NativeOpaqueIds>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);

typedef _StoreUserRecordNative = ffi.Void Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);
typedef _StoreUserRecordDartWrapper = void Function(
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
  ffi.Pointer<ffi.Uint8>,
);

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
  late final crypto_core_ristretto255_BYTES =
      _sodium_lookup<ffi.NativeFunction<size_t Function()>>(
              'crypto_core_ristretto255_bytes')
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

  late final OPAQUE_USER_SESSION_PUBLIC_LEN = (crypto_core_ristretto255_BYTES +
      crypto_scalarmult_BYTES +
      OPAQUE_NONCE_BYTES);

  late final OPAQUE_USER_SESSION_SECRET_LEN =
      (crypto_core_ristretto255_SCALARBYTES +
          crypto_scalarmult_SCALARBYTES +
          OPAQUE_NONCE_BYTES +
          crypto_core_ristretto255_BYTES +
          OPAQUE_USER_SESSION_PUBLIC_LEN +
          ffi.sizeOf<ffi.Uint16>());

  late final OPAQUE_SERVER_SESSION_LEN = (crypto_core_ristretto255_BYTES +
      32 +
      crypto_scalarmult_BYTES +
      OPAQUE_NONCE_BYTES +
      crypto_scalarmult_BYTES +
      crypto_auth_hmacsha512_BYTES +
      OPAQUE_ENVELOPE_NONCEBYTES +
      crypto_auth_hmacsha512_BYTES);

  late final OPAQUE_REGISTER_USER_SEC_LEN =
      (crypto_core_ristretto255_SCALARBYTES + ffi.sizeOf<ffi.Uint16>());

  late final OPAQUE_REGISTER_PUBLIC_LEN =
      (crypto_core_ristretto255_BYTES + crypto_scalarmult_BYTES);

  late final OPAQUE_REGISTER_SECRET_LEN =
      (crypto_scalarmult_SCALARBYTES + crypto_core_ristretto255_SCALARBYTES);

  Opaque._(ffi.DynamicLibrary opaquelib, ffi.DynamicLibrary sodium)
      : _sodium_lookup = sodium.lookup,
        _lookup = opaquelib.lookup;

  static Opaque init(
      ffi.DynamicLibrary opaquelib, ffi.DynamicLibrary sodiumlib) {
    return Opaque._(opaquelib, sodiumlib);
  }

  late final _RegisterDartWrapper _opaque_Register =
      _lookup<ffi.NativeFunction<_RegisterNative>>("opaque_Register")
          .asFunction<_RegisterDartWrapper>();

  late final _CreateCredentialRequestDartWrapper
      _opaque_CreateCredentialRequest =
      _lookup<ffi.NativeFunction<_CreateCredentialRequestNative>>(
              "opaque_CreateCredentialRequest")
          .asFunction<_CreateCredentialRequestDartWrapper>();

  late final _CreateCredentialResponseDartWrapper
      _opaque_CreateCredentialResponse =
      _lookup<ffi.NativeFunction<_CreateCredentialResponseNative>>(
              "opaque_CreateCredentialResponse")
          .asFunction<_CreateCredentialResponseDartWrapper>();

  late final _RecoverCredentialsDartWrapper _opaque_RecoverCredentials =
      _lookup<ffi.NativeFunction<_RecoverCredentialsNative>>(
              "opaque_RecoverCredentials")
          .asFunction<_RecoverCredentialsDartWrapper>();

  late final _UserAuthDartWrapper _opaque_UserAuth =
      _lookup<ffi.NativeFunction<_UserAuthNative>>("opaque_UserAuth")
          .asFunction<_UserAuthDartWrapper>();

  late final _CreateRegistrationRequestDartWrapper
      _opaque_CreateRegistrationRequest =
      _lookup<ffi.NativeFunction<_CreateRegistrationRequestNative>>(
              "opaque_CreateRegistrationRequest")
          .asFunction<_CreateRegistrationRequestDartWrapper>();

  late final _CreateRegistrationResponseDartWrapper
      _opaque_CreateRegistrationResponse =
      _lookup<ffi.NativeFunction<_CreateRegistrationResponseNative>>(
              "opaque_CreateRegistrationResponse")
          .asFunction<_CreateRegistrationResponseDartWrapper>();

  late final _FinalizeRequestDartWrapper _opaque_FinalizeRequest =
      _lookup<ffi.NativeFunction<_FinalizeRequestNative>>(
              "opaque_FinalizeRequest")
          .asFunction<_FinalizeRequestDartWrapper>();

  late final _StoreUserRecordDartWrapper _opaque_StoreUserRecord =
      _lookup<ffi.NativeFunction<_StoreUserRecordNative>>(
              "opaque_StoreUserRecord")
          .asFunction<_StoreUserRecordDartWrapper>();

  void _check_api_ret(int ret) {
    if (ret != 0) {
      throw ArgumentError();
    }
  }

  Map<String, Uint8List> Register(Uint8List pwd, OpaqueIds ids,
      {Uint8List? skS = null}) {
    final native_pwd = _Uint8ListCPointerInputParameter(pwd);
    final native_skS = _Uint8ListCPointerInputParameter.nullable(skS);
    final native_ids = _OpaqueIdsCPointerInputParameter(ids);

    final rec = _Uint8ListCPointerOutputParameter(OPAQUE_USER_RECORD_LEN);
    final export_key =
        _Uint8ListCPointerOutputParameter(crypto_hash_sha512_BYTES);

    final int ret = _opaque_Register(
        native_pwd.raw_ptr,
        pwd.lengthInBytes,
        native_skS.raw_ptr,
        native_ids.raw_ptr,
        rec.raw_ptr,
        export_key.raw_ptr);

    native_ids.free();
    native_pwd.free();
    native_skS.free();
    final rec_value = rec.release();
    final export_key_value = export_key.release();

    _check_api_ret(ret);
    return {"rec": rec_value, "export_key": export_key_value};
  }

  Map<String, Uint8List> CreateCredentialRequest(Uint8List pwd) {
    final native_pwd = _Uint8ListCPointerInputParameter(pwd);

    final sec = _Uint8ListCPointerOutputParameter(
        OPAQUE_USER_SESSION_SECRET_LEN + pwd.lengthInBytes);
    final pub =
        _Uint8ListCPointerOutputParameter(OPAQUE_USER_SESSION_PUBLIC_LEN);

    final int ret = _opaque_CreateCredentialRequest(
        native_pwd.raw_ptr, pwd.lengthInBytes, sec.raw_ptr, pub.raw_ptr);

    native_pwd.free();
    final sec_value = sec.release();
    final pub_value = pub.release();

    _check_api_ret(ret);
    return {"sec": sec_value, "pub": pub_value};
  }

  Map<String, Uint8List> CreateCredentialResponse(
      Uint8List pub, Uint8List rec, OpaqueIds ids, Uint8List ctx) {
    final native_pub = _Uint8ListCPointerInputParameter(pub);
    final native_rec = _Uint8ListCPointerInputParameter(rec);
    final native_ids = _OpaqueIdsCPointerInputParameter(ids);
    final native_ctx = _Uint8ListCPointerInputParameter(ctx);

    final resp = _Uint8ListCPointerOutputParameter(OPAQUE_SERVER_SESSION_LEN);
    final sk = _Uint8ListCPointerOutputParameter(OPAQUE_SHARED_SECRETBYTES);
    final authU =
        _Uint8ListCPointerOutputParameter(crypto_auth_hmacsha512_BYTES);

    int ret = _opaque_CreateCredentialResponse(
        native_pub.raw_ptr,
        native_rec.raw_ptr,
        native_ids.raw_ptr,
        native_ctx._raw_ptr,
        ctx.lengthInBytes,
        resp.raw_ptr,
        sk.raw_ptr,
        authU.raw_ptr);

    native_pub.free();
    native_rec.free();
    native_ids.free();
    native_ctx.free();
    final resp_value = resp.release();
    final sk_value = sk.release();
    final authU_value = authU.release();

    _check_api_ret(ret);
    return {"resp": resp_value, "sk": sk_value, "authU": authU_value};
  }

  Map<String, Uint8List> RecoverCredentials(
      Uint8List resp, Uint8List sec, Uint8List ctx,
      {OpaqueIds? ids = null}) {
    final native_resp = _Uint8ListCPointerInputParameter(resp);
    final native_sec = _Uint8ListCPointerInputParameter(sec);
    final native_ctx = _Uint8ListCPointerInputParameter(ctx);
    final native_ids = _OpaqueIdsCPointerInputParameter.nullable(ids);

    final sk = _Uint8ListCPointerOutputParameter(OPAQUE_SHARED_SECRETBYTES);
    final authU =
        _Uint8ListCPointerOutputParameter(crypto_auth_hmacsha512_BYTES);
    final export_key =
        _Uint8ListCPointerOutputParameter(crypto_hash_sha512_BYTES);

    int ret = _opaque_RecoverCredentials(
        native_resp.raw_ptr,
        native_sec.raw_ptr,
        native_ctx.raw_ptr,
        ctx.lengthInBytes,
        native_ids.raw_ptr,
        sk.raw_ptr,
        authU.raw_ptr,
        export_key.raw_ptr);

    native_resp.free();
    native_sec.free();
    native_ctx.free();
    native_ids.free();
    final sk_value = sk.release();
    final authU_value = authU.release();
    final export_key_value = export_key.release();

    _check_api_ret(ret);
    return {
      "sk": sk_value,
      "authU": authU_value,
      "export_key": export_key_value
    };
  }

  void UserAuth(Uint8List authU0, Uint8List authU) {
    final native_authU0 = _Uint8ListCPointerInputParameter(authU0);
    final native_authU = _Uint8ListCPointerInputParameter(authU);

    int ret = _opaque_UserAuth(native_authU0.raw_ptr, native_authU.raw_ptr);

    native_authU0.free();
    native_authU.free();

    _check_api_ret(ret);
  }

  Map<String, Uint8List> CreateRegistrationRequest(Uint8List pwd) {
    final native_pwd = _Uint8ListCPointerInputParameter(pwd);
    final sec = _Uint8ListCPointerOutputParameter(
        OPAQUE_REGISTER_USER_SEC_LEN + pwd.lengthInBytes);
    final request =
        _Uint8ListCPointerOutputParameter(crypto_core_ristretto255_BYTES);

    int ret = _opaque_CreateRegistrationRequest(
        native_pwd.raw_ptr, pwd.lengthInBytes, sec.raw_ptr, request.raw_ptr);

    native_pwd.free();
    final sec_value = sec.release();
    final request_value = request.release();

    _check_api_ret(ret);
    return {"sec": sec_value, "request": request_value};
  }

  Map<String, Uint8List> CreateRegistrationResponse(Uint8List request,
      {Uint8List? skS}) {
    final native_request = _Uint8ListCPointerInputParameter(request);
    final native_skS = _Uint8ListCPointerInputParameter.nullable(skS);
    final sec = _Uint8ListCPointerOutputParameter(OPAQUE_REGISTER_SECRET_LEN);
    final pub = _Uint8ListCPointerOutputParameter(OPAQUE_REGISTER_PUBLIC_LEN);

    int ret = _opaque_CreateRegistrationResponse(
        native_request.raw_ptr, native_skS.raw_ptr, sec.raw_ptr, pub.raw_ptr);

    native_request.free();
    native_skS.free();
    final sec_value = sec.release();
    final pub_value = pub.release();

    _check_api_ret(ret);
    return {"sec": sec_value, "pub": pub_value};
  }

  Map<String, Uint8List> FinalizeRequest(
      Uint8List sec, Uint8List pub, OpaqueIds ids) {
    final native_sec = _Uint8ListCPointerInputParameter(sec);
    final native_pub = _Uint8ListCPointerInputParameter(pub);
    final native_ids = _OpaqueIdsCPointerInputParameter(ids);
    final reg_rec =
        _Uint8ListCPointerOutputParameter(OPAQUE_REGISTRATION_RECORD_LEN);
    final export_key =
        _Uint8ListCPointerOutputParameter(crypto_hash_sha512_BYTES);

    int ret = _opaque_FinalizeRequest(native_sec.raw_ptr, native_pub.raw_ptr,
        native_ids.raw_ptr, reg_rec.raw_ptr, export_key.raw_ptr);

    native_sec.free();
    native_pub.free();
    native_ids.free();
    final reg_rec_value = reg_rec.release();
    final export_key_value = export_key.release();

    _check_api_ret(ret);
    // TODO: maybe change reg_rec -> rec
    return {"reg_rec": reg_rec_value, "export_key": export_key_value};
  }

  Map<String, Uint8List> StoreUserRecord(Uint8List sec, Uint8List recU) {
    final native_sec = _Uint8ListCPointerInputParameter(sec);
    final native_recU = _Uint8ListCPointerInputParameter(recU);
    final rec = _Uint8ListCPointerOutputParameter(OPAQUE_USER_RECORD_LEN);

    _opaque_StoreUserRecord(
        native_sec.raw_ptr, native_recU.raw_ptr, rec.raw_ptr);

    native_sec.free();
    native_recU.free();
    final rec_value = rec.release();

    return {"rec": rec_value};
  }
}
