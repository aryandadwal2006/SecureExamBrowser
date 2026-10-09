# Root Binary Component Hash Manifest

**Updated:** 2026-10-09  
**Source:** repository root at branch baseline; comparison against the current public signed SEB 2.0.2 MSI extracted on a Windows CI runner without installation.  
**CI run:** [37906673190](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190)  
**Raw comparison artifact:** [11604173812](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190/artifacts/11604173812)

## Result

**39 / 39 exact matches.** Every top-level repository `.exe` and `.dll` has a same-named candidate in the extracted MSI with identical byte length and SHA-256. Zero missing candidates; zero mismatches.

The installer was extracted for analysis but not installed or executed. The table below is a static package-provenance record; it does not establish which package is installed on an individual machine.

| Repository file | Bytes | SHA-256 | Extracted package path | Match |
|---|---:|---|---|---|
| `AForge.dll` | 17,920 | `966a474060a8aca70c73ba09d0b6fe2353035961c7107b9003ef879c010ff8da` | `seb/SourceDir/AForge.dll` | Exact |
| `AForge.Video.DirectShow.dll` | 61,440 | `666d44798d94eafa1ed21af79e9bc0293ffd96f863ab5d87f78bcee9ef9ffd6b` | `seb/SourceDir/AForge.Video.DirectShow.dll` | Exact |
| `AForge.Video.dll` | 20,992 | `bafa6ed04ca2782270074127a0498dde022c2a9f4096c6bb2b8e3c08bb3d404d` | `seb/SourceDir/AForge.Video.dll` | Exact |
| `ARSoft.Tools.Net.dll` | 299,520 | `38025717f348a2d3f712e5f3c6d7834f86fd19c032100be909a3c4240e36285a` | `seb/SourceDir/ARSoft.Tools.Net.dll` | Exact |
| `BouncyCastle.Crypto.dll` | 2,236,416 | `1985b85bb44be6c6eaf35e02ef11e23a890e809b8ec2e53210a4ad5a85b26c70` | `seb/SourceDir/BouncyCastle.Crypto.dll` | Exact |
| `Dia2Lib.dll` | 59,024 | `6c4cac68010fe032218efe5e9fcf46eef9f77bfaa5f3bd33f03c5ff77d5a8fac` | `seb/SourceDir/Dia2Lib.dll` | Exact |
| `DirectShowLib-2005.dll` | 303,104 | `bbcbb170242d9ff1b56680a80b1f8755df1135f9c714535ff3b3f575442f38dc` | `seb/SourceDir/DirectShowLib-2005.dll` | Exact |
| `Fleck.dll` | 35,840 | `1e5caa69fa221cac1cb34916436979b94bcbd6d140687d20a5c7811f9f7c5800` | `seb/SourceDir/Fleck.dll` | Exact |
| `hirepro-chromium-installer.exe` | 102,636,032 | `1b3c640153c82eb40074e4bf55877a90ea5f2ea3d426e5de4eddc0c4bc09ea16` | `seb/SourceDir/hirepro-chromium-installer.exe` | Exact |
| `IconLib.dll` | 55,808 | `e40d8efc484407921c46b1fb4678812464e00a3737816f0791ff63c8078880c1` | `seb/SourceDir/IconLib.dll` | Exact |
| `Ionic.Zip.dll` | 463,360 | `a063153882ce2a4a57cccf857c0d976effb2e6cb94d264108fbcffe1c621e8ce` | `seb/SourceDir/Ionic.Zip.dll` | Exact |
| `MetroFramework.dll` | 316,928 | `812eba8230c39e33d58a125ec74b3f406e03eb35dcabd15843e174e1899c752b` | `seb/SourceDir/MetroFramework.dll` | Exact |
| `Microsoft.Diagnostics.FastSerialization.dll` | 75,296 | `4967b3847eb6291e375470b6d7c4660a76e0ae6de09b2a8f57d7ff28440b3a39` | `seb/SourceDir/Microsoft.Diagnostics.FastSerialization.dll` | Exact |
| `Microsoft.Diagnostics.Tracing.TraceEvent.dll` | 3,136,032 | `2f0c3201ccb1e7eb78842a0ba5b1390f32c6543a5954d3b359b1a0cb4de03f24` | `seb/SourceDir/Microsoft.Diagnostics.Tracing.TraceEvent.dll` | Exact |
| `NAudio.dll` | 468,480 | `59b11c65247d06e6c66b99a6569786a6dce83d1e78d4e8c62572467cf985ee80` | `seb/SourceDir/NAudio.dll` | Exact |
| `netstandard.dll` | 101,728 | `a6c285224ccb2cd3d70bb5f25a4011ba5c26f29249f58a7bf8ec2759b13b6dc9` | `seb/SourceDir/netstandard.dll` | Exact |
| `Newtonsoft.Json.dll` | 513,536 | `526f69142edc80cb1f261acdb7c73ce3db841d21ac26bee6715f604c8a238be1` | `seb/SourceDir/Newtonsoft.Json.dll` | Exact |
| `SEBWindowsServiceContracts.dll` | 6,144 | `60309b30499bbe98f98e1cc07cdc5379c34bafd1172ac2f8f8f5e8384250a2e5` | `seb/SourceDir/SEBWindowsServiceContracts.dll` | Exact |
| `SebWindowsServiceWCF.exe` | 170,496 | `a2ac4fd12eaa38ffd8f422b20eef68bae8f7b44b91ababfe7447ef2fc9c6ac57` | `seb/SourceDir/SebWindowsServiceWCF.exe` | Exact |
| `SecureExamBrowser.exe` | 1,924,120 | `9b7c84cb4d5be544592696177cf9ee576bc01fbbac5f1d7ba74e0676798dd38e` | `seb/SourceDir/SecureExamBrowser.exe` | Exact |
| `System.Data.Common.dll` | 24,904 | `125847878672eac8fcdc8b687ca785e32ec1e4fca633059e74a757cccbab1893` | `seb/SourceDir/System.Data.Common.dll` | Exact |
| `System.Diagnostics.StackTrace.dll` | 24,392 | `ac4444b8e3c8f827943c437b0017557ade7024fdc5e28e2303fc7c2dfcabb332` | `seb/SourceDir/System.Diagnostics.StackTrace.dll` | Exact |
| `System.Diagnostics.Tracing.dll` | 34,656 | `c9df1cc080a352ba90637c870757583441a68464d5336aa60ae3f8dbe5f7a085` | `seb/SourceDir/System.Diagnostics.Tracing.dll` | Exact |
| `System.Globalization.Extensions.dll` | 24,392 | `7b8d5b0291493f3748fec9652ebebe877f3a64a6c48a77dfe99698c2fa29ade2` | `seb/SourceDir/System.Globalization.Extensions.dll` | Exact |
| `System.IO.Compression.dll` | 67,656 | `0b1da5a833e512b0eab28e66f440329f04d6034e944a3b1e107b496f44dd8d04` | `seb/SourceDir/System.IO.Compression.dll` | Exact |
| `System.IO.Compression.FileSystem.dll` | 27,552 | `1513e86e58c14dde3c3f6e8ba0bd52dc6c257d4974fe5a0983588f6d9d2d4c78` | `seb/SourceDir/System.IO.Compression.FileSystem.dll` | Exact |
| `System.Management.Automation.dll` | 7,522,816 | `d0fbaa3bfb9380e2128015a9080a0403baa3b593f20366bfefd20a56f2195a9f` | `seb/SourceDir/System.Management.Automation.dll` | Exact |
| `System.Net.Http.dll` | 199,528 | `d6cd39b6db2fdf65f7051a11e448a04b0efc17f3c8b515f2b546294e1c2dc9b9` | `seb/SourceDir/System.Net.Http.dll` | Exact |
| `System.Net.Sockets.dll` | 24,904 | `0fb12bb97b1ef5a52a984ae45ebae24a619ea58c11945eff08a72c2d223d80e5` | `seb/SourceDir/System.Net.Sockets.dll` | Exact |
| `System.Runtime.CompilerServices.Unsafe.dll` | 16,768 | `3cadcb6b8a7335141c7c357a1d77af1ff49b59b872df494f5025580191d1c0d5` | `seb/SourceDir/System.Runtime.CompilerServices.Unsafe.dll` | Exact |
| `System.Runtime.InteropServices.RuntimeInformation.dll` | 24,392 | `74a3958078702635ba57e2c24adf4b05170e73d858ef06b9ea4ca2939ea6e769` | `seb/SourceDir/System.Runtime.InteropServices.RuntimeInformation.dll` | Exact |
| `System.Runtime.Serialization.Primitives.dll` | 24,400 | `b2eb0120d025a9024080c064d9706982d054f7c8fab7722a4c8354ac700e06f9` | `seb/SourceDir/System.Runtime.Serialization.Primitives.dll` | Exact |
| `System.Runtime.Serialization.Xml.dll` | 24,904 | `5e6e06bc6c3e251a73e564f029226e7a0e879ef101246adeadd85ad5960b36b4` | `seb/SourceDir/System.Runtime.Serialization.Xml.dll` | Exact |
| `System.Security.Cryptography.Algorithms.dll` | 24,904 | `25f92c648ff5a9cea293687612667d8bfada15db93dd46832c97d4bb754d48ae` | `seb/SourceDir/System.Security.Cryptography.Algorithms.dll` | Exact |
| `System.Security.SecureString.dll` | 23,904 | `2f3e147ef8535fbe11b3e5c5fabccbd01ec80c172bfb03ac88f7d457f85419d4` | `seb/SourceDir/System.Security.SecureString.dll` | Exact |
| `System.Threading.Overlapped.dll` | 24,392 | `9da0c0a6f239fb16b7d6f4f58d798a0b2a661dbe3a5b0184a40a96a6c8791574` | `seb/SourceDir/System.Threading.Overlapped.dll` | Exact |
| `System.ValueTuple.dll` | 24,416 | `337a361a7da505b414d8ea3da36f57919c732a91ca9ebae69127f235c22651d0` | `seb/SourceDir/System.ValueTuple.dll` | Exact |
| `System.Xml.XPath.XDocument.dll` | 23,880 | `9a1ddcc71d8485a3be5082bd4c3e32c571427ae13439c3d1a478d0e5b16e9f6a` | `seb/SourceDir/System.Xml.XPath.XDocument.dll` | Exact |
| `TraceReloggerLib.dll` | 23,216 | `6830c0f1d3f3c17719181e73dd5cfa8ccbb3f3c575329d2120576545103467b5` | `seb/SourceDir/TraceReloggerLib.dll` | Exact |

## Interpretation

- The root-level executable/DLL set matches the current public vendor installer exactly.
- A component's lack of a standalone Authenticode signature does not imply tampering when its exact bytes are inside an Authenticode-valid installer.
- The user's installed files and candidate-specific download still require local verification.
- Hash equality demonstrates file identity, not runtime safety or correctness.
