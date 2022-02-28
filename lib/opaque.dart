export 'api/opaque_api.dart' hide OpaqueInterface;

export ''
    if (dart.library.ffi) 'ffi/opaque_ffi.dart'
    if (dart.library.js) 'js/opaque_js.dart';
