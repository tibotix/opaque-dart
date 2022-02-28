# libopaque dart bindings

These bindings provide access to libopaque which implements the
[IRTF CFRG RFC draft](https://github.com/cfrg/draft-irtf-cfrg-opaque)
or you can read the [original paper](https://eprint.iacr.org/2018/163).

## Dependencies

These bindings depend on the following:
  - libopaque: https://github.com/stef/libopaque
  - libsodium

A compiled library of both libopaque and libsodium must be available to use these bindings.

## Usage

To use the libopaque ffi bindings, your first have to initialize an `Opaque` object
with both libopaque and libsodium libraries. Please refer to the [libopaque](https://github.com/stef/libopaque) and [libsodium](https://libsodium.gitbook.io/doc/installation) documentations on how to install these libraries properly.

To use the libopaque js bindings, you have to include the libopaque.js script in your html tree and then initialize an `Opaque` object.
You will get the libopaque.js script here: https://github.com/stef/libopaque/js .


### VM - loading the dynamic library
In the dart VM, `dart:ffi` is used as a backend to load and interact with the libopaque/libsodium binaries. All you need to do is load such a library and pass it to the `Opaque.init` constructor. This generally looks like this:

```dart
import 'dart:ffi';
import 'package:opaque/opaque.ffi.dart';

// load the dynamic libraries into dart
final libopaque = DynamicLibrary.open('/path/to/libopaque.XXX'); // or DynamicLibrary.process()
final libsodium = DynamicLibrary.open('/path/to/libsodium.XXX'); // or DynamicLibrary.process()

final opaque = Opaque.init(libopaque, libsodium);
// using the opaque.* API
```

### Transpiled JavaScript - loading the JavaScript code
The usage is quite similar to the VM loading usage. You should load the libopaque.js script either in a html file or dynamically in your dart code, and then call `Opaque.init`.
Make sure to name your script exactly `libopaque.js`. In general this will look something like this:

```dart
import 'package:opaque/opaque.js.dart';

final opaque = Opaque.init();
// using the opaque.* API
```

## API

_Note that all `Opaque.*` API calls will throw an `OpaqueException` if the API call failed_.

### `OpaqueIds`
The IDs of the peers are passed around as a class object:
```dart
final OpaqueIds ids = OpaqueIds.fromStrings("user", "server");
```

## 1-step registration

1-step registration is only specified in the original paper. It is not specified by the IRTF
CFRG draft. 1-step registration has the benefit that the supplied password (`pwdU`) can be checked
on the server for password rules (e.g., occurrence in common password
lists). It has the drawback that the password is exposed to the server.

```dart
final result = opaque.Register(pwdU, ids, skS: skS);
final rec = result.rec;
final export_key = result.export_key;
```
 - `pwdU` is the user's password as an `Uint8List` object.
 - `ids` is an `OpaqueIds` struct that contains the IDs of the user and the server.
 - `skS` is an optional server long-term private-key

## 4-step registration

Registration as specified in the IRTF CFRG draft consists of the
following 4 steps:

### Step 1: The user creates a registration request.

```dart
final result = opaque.CreateRegistrationRequest(pwdU);
final M = result.M!;
final secU = result.sec;
```

- `pwdU` is the user's password as an `Uint8List` object.

The user should hold on to `secU` securely until step 3 of the registration process.
`request` needs to be passed to the server running step 2.

### Step 2: The server responds to the registration request.

```dart
final result = opaque.CreateRegistrationResponse(request, skS: skS);
final secS = result.sec;
final pub = result.pub;
```

 - `request` (`M`) comes from the user running the previous step.
 - `skS` is an optional server long-term private-key

The server should hold onto `secS` securely until step 4 of the registration process.
`pub` should be passed to the user running step 3.

### Step 3: The user finalizes the registration using the response from the server.

```dart
final result = opaque.FinalizeRequest(secU, pub, ids);
final rec0 = result.rec;
final export_key = result.export_key;
```

 - `secU` contains sensitive data and should be disposed securely after usage in this step.
 - `pub` comes from the server running the previous step.
 - `ids` is an `Ids` struct that contains the IDs of the user and the server.

 - `rec0` should be passed to the server running step 4.
 - `export_key` is an extra secret that can be used to encrypt
   additional data that you might want to store on the server next to
   your record.

### Step 4: The server finalizes the user's record.

```dart
final result = opaque.StoreUserRecord(secS, rec0);
final rec1 = result.rec;
```

 - `rec0` comes from the user running the previous step.
 - `secS` contains sensitive data and should be disposed securely after usage in this step.

 - `rec1` should be stored by the server associated with the ID of the user.

**Important Note**: Confusingly this function is called `StoreUserRecord`, yet it
does not do any storage. How you want to store the record (`rec1`) is up
to the implementor using this API.

## Establishing an opaque session

After a user has registered with a server, the user can initiate the
AKE and thus request its credentials in the following 3(+1)-step protocol:

### Step 1: The user initiates a credential request.

```dart
final result = opaque.CreateCredentialRequest(pwdU);
final pub = result.pub;
final secU = result.sec;
```

 - `pwdU` is the user's password as an `Uint8List` object.

The user should hold onto `secU` securely until step 3 of the protocol.
`pub` needs to be passed to the server running step 2.

### Step 2: The server responds to the credential request.

```dart
final result = opaque.CreateCredentialResponse(pub, rec, ids, context);
final resp = result.resp;
final sk = result.sk;
final sec = result.sec;
```

 - `pub` comes from the user running the previous step.
 - `rec` is the user's record stored by the server at the end of the registration protocol.
 - `ids` is an `OpaqueIds` struct that contains the IDs of the user and the server.
 - `context` is a `Uint8List` distinguishing this instantiation of the protocol from others, e.g. "MyApp-v0.2"

 - `resp` needs to be passed to the user running step 3.
 - `sk` is a shared secret, the result of the AKE.
 - The server should hold onto `sec` securely until the optional step
   4 of the protocol, if needed. otherwise this value should be
   discarded securely.

### Step 3: The user recovers its credentials from the server's response.

```dart
final result = opaque.RecoverCredentials(resp, secU, context, ids: ids);
final sk = result.sk;
final authU = result.authU;
final export_key = result.export_key;
```

 - `resp` comes from the server running the previous step.
 - `secU` contains sensitive data and should be disposed securely after usage in this step.
 - `context` is a `Uint8List` distinguishing this instantiation of the protocol from others, e.g. "MyApp-v0.2"

 - `sk` is a shared secret, the result of the AKE.
 - `authU` is an authentication tag that can be passed in step 4 for explicit user authentication.
 - `export_key` can be used to decrypt additional data stored by the server.

### Step 4 (Optional): The server authenticates the user.

This step is only needed if there is no encrypted channel setup
towards the server using the shared secret.

```dart
opaque.UserAuth(sec, authU);
```

 - `sec` contains sensitive data and should be disposed securely after usage in this step.
 - `authU1` comes from the user running the previous step.


