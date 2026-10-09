# Legacy XUL Source / Package Identity Results

**Updated:** 2026-10-09  
**Workflow:** [37908852563](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37908852563)  
**Machine-readable artifact:** [legacy-source-package-comparison, ID 11605307704](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37908852563/artifacts/11605307704)

## Result

**12 of 12 selected source/config assets match the current signed public SEB 2.0.2 MSI exactly by SHA-256.** The earlier apparent mismatches were caused by Windows checkout line-ending conversion. The corrected pipeline hashes canonical Git blob bytes rather than the transformed working-tree copy.

| Canonical Git path | Canonical bytes | Canonical SHA-256 | Path inside extracted MSI | Match |
|---|---:|---|---|---|
| `SebWindowsBrowser/xul_seb/modules/SebScreenshot.jsm` | 6,339 | `5f0af9da032efb8e279b066402f9685d67ee36f56c080a5f4d8fa10d00376b59` | `SebWindowsBrowser/xul_seb/modules/SebScreenshot.jsm` | Exact |
| `SebWindowsBrowser/xul_seb/modules/SebServer.jsm` | 5,981 | `ac97289e5cde88959422b4e66231860db01db768d9b0f7825c1cc88c8126548c` | `SebWindowsBrowser/xul_seb/modules/SebServer.jsm` | Exact |
| `SebWindowsBrowser/xul_seb/modules/SebHost.jsm` | 20,620 | `4437ace4cdd38d1dac6fe61d811d4ca20b75dbdbeca262f248415df839aca0f0` | `SebWindowsBrowser/xul_seb/modules/SebHost.jsm` | Exact |
| `SebWindowsBrowser/xul_seb/modules/SebConfig.jsm` | 7,567 | `2a92e20ff00e53adfc1f67296ae7b8fd0b7501a6f5adbc42e9276eec79b689d3` | `SebWindowsBrowser/xul_seb/modules/SebConfig.jsm` | Exact |
| `SebWindowsBrowser/xul_seb/modules/seb.jsm` | 30,186 | `a7021afe0610a78d6e8343170816fbc844952430956dd3c21824793bb37ea174` | `SebWindowsBrowser/xul_seb/modules/seb.jsm` | Exact |
| `SebWindowsBrowser/xul_seb/config.default.json` | 2,392 | `b0929e2311801e8b83c142bd66c9085231b789e93b28beef1f34fa2ea52d52c4` | `SebWindowsBrowser/xul_seb/config.default.json` | Exact |
| `SebWindowsBrowser/xul_seb/default.json` | 4,872 | `397ff11b3d4edc9ef0dc0accaf35b4a4f9d50d20bf07224632dea5915e094563` | `SebWindowsBrowser/xul_seb/default.json` | Exact |
| `SebWindowsBrowser/xul_seb/config.json` | 4,937 | `b34a8904ddc03842fbd1d39708a938aa561aa5cff04a2078489e7c059301dc3e` | `SebWindowsBrowser/xul_seb/config.json` | Exact |
| `SebWindowsBrowser/xul_seb/config.SEB22.json` | 8,501 | `0fef225c916b079004a26a80df362eca0ba12b32a296d1eaae0f8021536ed704` | `SebWindowsBrowser/xul_seb/config.SEB22.json` | Exact |
| `SebWindowsBrowser/xul_seb/chrome/content/seb/seb.xul` | 7,042 | `484fa7ad59ebdb1884c83bad499208e7b4547e778560f7f9e4512bbf81c4ceeb` | `SebWindowsBrowser/xul_seb/chrome/content/seb/seb.xul` | Exact |
| `SebWindowsBrowser/xul_seb/chrome/content/seb/message_socket.html` | 144 | `64d59e073a3f2869438e233c2e1522db9389277b6a7bc448c560acee7b012c7d` | `SebWindowsBrowser/xul_seb/chrome/content/seb/message_socket.html` | Exact |
| `SebWindowsBrowser/xul_seb/chrome.manifest` | 810 | `65a7ef596841e5008ea0efe8f283bfad20eec3c81bd338fe3a9686e201ebcf3f` | `SebWindowsBrowser/xul_seb/chrome.manifest` | Exact |
| `SebWindowsBrowser/xul_seb/defaults/preferences/seb.js` | 3,551 | `d1d07c60a21d8ef20b4886d9c126613b2d4ba343e8e63baae384fe71e9e693f7` | `SebWindowsBrowser/xul_seb/defaults/preferences/seb.js` | Exact |

## Interpretation

- These selected legacy assets are in the current public signed MSI and are byte-for-byte identical to the repository's canonical Git blobs.
- This supports using the checked-in source as a faithful copy of these packaged files for static review of this particular public package.
- It does not identify the exact assessment-specific configuration loaded by a candidate session.
- The source contains screenshot-related code, but static source presence is not proof of activation, capture scope, transmission or retention.
- The assessment's effective configuration and runtime behavior still require authorized test-session evidence.
