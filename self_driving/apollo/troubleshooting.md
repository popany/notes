# Troubleshooting

- [Troubleshooting](#troubleshooting)
  - [r7.0.0](#r700)
    - [zlib-1.2.11.tar.gz is not found on official](#zlib-1211targz-is-not-found-on-official)

## r7.0.0

### [zlib-1.2.11.tar.gz is not found on official](https://onlyabug.com/issue/zlib-1211targz-is-not-found-on-official-14374)

I have the same problem, then edit two files:
apollo/.cache/bazel/540135163923dd7d5820f3ee4b306b32/external/io_bazel_rules_go/go/private/repositories.bzl
line 95 - 101
http_archive( name = "net_zlib", build_file = "@com_google_protobuf//:third_party/zlib.BUILD", sha256 = "91844808532e5ce316b3c010929493c0244f3d37593afd6de04f71821d5136d9", strip_prefix = "zlib-1.2.12", urls = ["https://zlib.net/zlib-1.2.12.tar.gz"], )

apollo/.cache/bazel/540135163923dd7d5820f3ee4b306b32/external/rules_proto/proto/private/dependencies.bzl
line 31-38
"zlib": { "sha256": "91844808532e5ce316b3c010929493c0244f3d37593afd6de04f71821d5136d9", "build_file": "@com_google_protobuf//:third_party/zlib.BUILD", "strip_prefix": "zlib-1.2.12", "urls": [ "https://zlib.net/zlib-1.2.12.tar.gz", ], },

then build again
