# EduBox web assets

The web build needs two files next to `index.html`. They must be ABI-compatible
with the app's pinned `drift` 2.34.4 and `sqlite3` 3.8.0 resolution.

| File | Source | SHA-256 |
| --- | --- | --- |
| `drift_worker.js` | https://github.com/simolus3/drift/releases/download/drift-2.35.3/drift_worker.js | `a54b81412d4c4ab56653bb9e4c02912b0820bb37e2bba00722ddef4d78083d4a` |
| `sqlite3.wasm` | https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.8.0/sqlite3.wasm | `efd308be92a34f3aa15f289a37f213b0230fd80888a1364326ee29579d892d37` |

Worker note: the `drift_worker.js` published with drift 2.34.4 was compiled
before sqlite3 3.8.0 and fails to instantiate the 3.8.0 wasm with
`LinkError: Import #6 "dart" "xFileSize64": function import requires a
callable`. The 2.35.3 worker is the nearest official release built against
sqlite3 3.8.0; its worker protocol is negotiated (v3) and was verified against
the app's drift 2.34.4 with a real browser login. The 2.35.3 release's own
`sqlite3.wasm` is byte-identical to the sqlite3 3.8.0 asset above.

`lib/src/local/local_store_platform_web.dart` opens the browser database as
`edubox` with `WasmDatabase.open`, using these root-relative URLs. Drift probes
OPFS first and falls back to IndexedDB or in-memory storage as the browser
allows.

To verify or refresh:

```sh
sha256sum web/drift_worker.js web/sqlite3.wasm
flutter build web --dart-define=EDUBOX_SERVER_URL=http://localhost:8080/
```

The server target stays Android; this web build is only for the local trial.
