# Configuration and Screenshot-Path Review

**Updated:** 2026-10-09  
**Scope:** Checked-in legacy XUL source, default/sample JSON profiles, and session initialization. This is not a dump of the candidate's effective runtime configuration.

## 1. Configuration-selection behavior

The legacy `SebConfig.jsm` loader:
- loads `default.json` from the browser process directory as its default configuration;
- then reads a custom configuration from an explicit `config` command-line parameter when present, otherwise from `config.json` in the process directory;
- merges the custom object over the default object before applying preferences and continuing initialization.

This means repository sample files are not sufficient to determine what the candidate's assessment enabled. The actual process directory, configuration argument/file, externally supplied assessment configuration and merge result must be established from an authorized runtime or installation manifest. Do not treat `config.SEB22.json` or `config.full.json` as the active Accenture policy merely because they are present in the repository.

## 2. Sample configuration matrix

The files below are versioned repository examples, not evidence of the effective configuration during the user's session.

| Checked-in profile | `sebScreenshot` | `sebServerEnabled` | `monitorProcesses` | Interpretation |
|---|---|---|---|---|
| `config.default.json` | false | false | false | Broad baseline defaults. |
| `config.json` | false | false | Not explicitly set in the inspected profile | Example configuration; inherits unspecified keys from defaults. |
| `config.SEB22.json` | Not explicitly set | Not established by the inspected excerpt | true | Separate SEB 2.2-style profile with a prohibited-process list; not proven to be the exam's effective config. |
| `config.custom.json` | false | true | false | Development/custom example; server feature enabled in this example only. |
| `config.dev.json` | false | true | Not explicitly set in the inspected profile | Development profile, not proof of assessment behavior. |
| `config.full.json` | false | true | Not explicitly set in the inspected profile | Full test/demo profile, not proof of assessment behavior. |
| `config.localhost.json` | false | true | false | Local demo configuration. |
| `config.server.json` | false | true | false | Local server/demo configuration. |

Important: values omitted from a custom configuration may be inherited from the default object. Features that require a server endpoint also depend on endpoint configuration and successful initialization, not only a Boolean property.

## 3. Screenshot-source review

The checked-in legacy source defines a browser-window-to-image helper in `SebScreenshot.jsm` and a screenshot-data handler in `SebServer.jsm`. It also imports and initializes the screenshot module in `seb.jsm`. A search across the checked-in `SebWindowsBrowser/xul_seb` JavaScript, XUL and HTML files did not find a direct call to `createScreenshotController`. This is a source-search observation only, not proof that a screenshot cannot occur in a particular build: dynamic call paths, generated/package differences and external configuration can affect runtime behavior.

The default and checked-in named sample profiles shown above have `sebScreenshot` false or inherit that default. They do **not** establish the effective assessment setting, and they do not prove the browser is incapable of other capture mechanisms. The legacy function draws a supplied browser window; that fact alone is not continuous whole-desktop capture.

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
