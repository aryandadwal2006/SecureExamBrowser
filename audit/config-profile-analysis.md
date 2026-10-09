# Configuration and Screenshot-Path Review

**Updated:** 2026-10-09  
**Scope:** Checked-in legacy XUL source, default/sample JSON profiles, and session initialization. This is not a dump of the candidate's effective runtime configuration.

## 1. Configuration-selection behavior

The legacy `SebConfig.jsm` loader:
- loads `default.json` from the browser process directory as its default configuration;
- then reads a custom configuration from an explicit `config` command-line parameter when present, otherwise from `config.json` in the process directory;
- merges the custom object over the default object before applying preferences and continuing initialization.

This means repository sample files are not sufficient to determine what the candidate's assessment enabled. The actual process directory, configuration argument/file, externally supplied assessment configuration and merge result must be established from an authorized runtime or installation manifest. Do not treat `config.SEB22.json` or `config.full.json` as the active Accenture policy merely because they are present in the repository.

## 2. Configuration variability

The checked-in JSON files include baseline, development, server/demo and named compatibility profiles. Their values differ on process monitoring, browser messaging, server features and screenshot-related settings. They are examples, not a per-session effective configuration record.

The loader merges a custom JSON object over `default.json`; therefore a missing field may inherit a default while an explicitly supplied field may override it. The active process directory, config source/argument and post-merge values are not established by the public repository alone.

## 3. Screenshot-source review

The checked-in legacy source defines a browser-window-to-image helper in `SebScreenshot.jsm` and a screenshot-data handler in `SebServer.jsm`; the startup module imports and initializes the screenshot module. The canonical Git blobs for these assets match the files inside the current public signed MSI; see [legacy source/package comparison](legacy-source-package-comparison.md).

Static source presence is not proof that a screenshot feature is activated for the assessment. The effective configuration, end-to-end activation, capture scope, and any transmission/retention for this specific session remain unknown. The presence of browser-window image code is also not, by itself, proof of continuous whole-desktop capture.

## 4. Evidence that would settle this correctly

1. Canonical-source versus signed-MSI package comparison using the Git blob bytes (not Windows line-ending-normalized working files).
2. Exact active file paths, MVIDs/hashes and configuration identifiers from a disposable Windows test VM.
3. A documented authorized positive-control test with independent host telemetry and a test-server receipt, where available.

## 5. Conclusion

Current evidence does not determine whether the user's specific mock session enabled browser-window screenshots or whole-desktop capture. Distinguish:
- webcam/audio recording disclosed by the UI;
- web-page and navigation telemetry described in the public policy;
- native monitoring of process/window/display state;
- browser-window image capture;
- whole-desktop pixel capture.

These are separate controls. A setting in a sample config, a source function, or absence of a visible warning is not proof of the session's exact capture behavior.
