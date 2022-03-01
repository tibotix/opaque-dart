export 'src/api/opaque_api.dart' hide OpaqueInterface;

export ''
    if (dart.library.ffi) 'src/ffi/opaque_ffi.dart'
    if (dart.library.js) 'src/js/opaque_js.dart';
