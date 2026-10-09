# Audit Index

**Working branch:** `redteam/monitoring-audit-2026-10-09`  
**Latest completed CI evidence:** [Run 37906673190](https://github.com/aryandadwal2006/SecureExamBrowser/actions/runs/37906673190)  
**Current phase:** Static analysis and provenance complete; authorized Windows runtime validation pending.

## Start here

1. [plan.md](../plan.md) — investigation sequence and decision gates.
2. [TODO.md](../TODO.md) — current task state.
3. [memory.md](../memory.md) — handoff context for another GPT session.
4. [findings.md](../findings.md) — numbered evidence register.
5. [control-map.md](control-map.md) — high-level monitoring/reporting architecture and unknowns.
6. [test-results.md](test-results.md) — completed vs pending checks.

## Evidence and analysis

- [static-application-analysis.md](static-application-analysis.md) — main SEB executable's managed metadata and selected control-family call edges.
- [static-service-analysis.md](static-service-analysis.md) — Windows service, policy-management and IPC observations.
- [architecture.md](architecture.md) — component boundaries.
- [artifact-manifest.md](artifact-manifest.md) — artifact SHA-256, versions, MVIDs, PE/CLI facts.
- [vendor-package-comparison.md](vendor-package-comparison.md) — public installer signature and package comparison.
- [vendor-component-hashes.md](vendor-component-hashes.md) — full exact hash/path table for all 39 root-level EXE/DLL files.
- [legacy-source-package-comparison.md](legacy-source-package-comparison.md) — canonical Git blob hashes for 12 selected legacy XUL/config assets, all matched against the signed MSI.
- [config-profile-analysis.md](config-profile-analysis.md) — configuration source-selection logic and capture-evidence limitations.
- [defensive-hardening-recommendations.md](defensive-hardening-recommendations.md) — recommended controls and authorized test cases for maintainers.
- [platform-observations.md](platform-observations.md) — screenshots, launch handoff, recording notice, policy scope and uncertainty.
- [test-matrix.md](test-matrix.md) — controlled test cases and verdict rules.

## Results snapshot

- REA build/check/test and static inspection passed in CI; the fast suite reported 3,450 tests passed, 4 skipped.
- The public SEB 2.0.2 MSI validates under Authenticode as signed by Hirepro Consulting Pvt Ltd.
- The Windows runner extracted that MSI without installing it and found exact SHA-256 matches for all 39 root-level repository EXE/DLL files; zero mismatches.
- The user-visible mock-assessment UI states video/audio are recorded. The public policy lists potential proctoring data categories. Legacy source includes browser-window screenshot capability, but packaged source correspondence and session-specific screenshot/full-desktop capture remain unknown.
- No SEB runtime test has run; no bypass has been reproduced or ruled out.

## Reproducibility and scope

Static target analysis did not load or execute the binaries. The MSI was extracted for file-hash comparison only. Do not treat a static method/type name as proof of runtime behavior. Any future dynamic test should be conducted in an authorized disposable Windows VM with independent telemetry and a documented positive control; keep all remote/server/human-observation claims separately evidenced.
