# Static Service Analysis — First Pass

**Updated:** 2026-10-09  
**Target:** main / SebWindowsServiceWCF.exe  
**Repository size:** 170,496 bytes  
**Git blob ID:** 1364103ef2f4ce48f42f0dc3a71616fc3d40cf7d  
**Evidence type:** Read-only PE/CLI metadata and selected CIL bodies; no target code executed.

## Binary facts observed
- PE signature is valid and the machine field is 0x014c (32-bit x86).
- The file contains a CLR/CLI header and metadata streams. Its method bodies are managed CIL.
- Sections include .text, .rsrc and .reloc.
- Metadata identifies service classes including SebWindowsServiceWCF, RegistryService, SIDHandler, RegistryEntryExtensions and CommandExecutor.
- The contracts DLL metadata identifies IRegistryServiceContract and registry/policy operations. This is contract metadata, not proof that no other monitoring mechanism exists elsewhere.

## Relevant call-path observations

### Service startup and IPC
- InitializeHost constructs a System.ServiceModel.NetNamedPipeBinding, sets its receive timeout, creates a ServiceHost, and adds a service endpoint.
- The method's user-string heap contains the endpoint string: net.pipe://localhost/SebWindowsServiceWCF/service.
- OnStart initializes the host, opens the communication object and schedules ResetOnStartup through Task.Run.
- The actual security mode and runtime authorization behaviour of the binding have not been exhaustively verified. Do not infer that a named pipe is unauthenticated from endpoint or binding names alone.

### Process-presence check
- IsSebRunning calls System.Diagnostics.Process.GetProcessesByName with the literal process name secureexambrowser.
- A second string in that method says: “Failed to check whether SEB is running - assuming it is...”
- ResetOnStartup calls IsSebRunning. Its associated user strings include:
  - “Waiting {0}s before attempting to reset any changes...”
  - “Detected new SecureExamBrowser process! Stopping reset attempts.”
  - “Attempt {0}/{1} failed, waiting {2}s before trying again...”
  - “All {0} attempts failed.”
- These observations support the interpretation that this routine checks for the SEB process while managing host-policy reset/recovery behaviour. In the inspected method, the process query is not a list of competing browser names.
- This is not evidence that all parts of the system fail to monitor external processes. The main application executable, active online client and any separate endpoint agent still need investigation.

### Host policy management
- RegistryService contains SetRegistryEntries, ResetRegistryEntries, TryCreateEntry, CanReset, DisableWindowsUpdate and SetWindowsUpdate.
- The code preserves registry values for later restoration and logs operations.
- CommandExecutor uses ProcessStartInfo and Process.Start to execute a selected command and collect output. The caller, executable/argument provenance and authorization checks require further review before drawing a security conclusion.
- The legacy service log's recorded Task Manager/workstation/password restrictions are consistent with the policy-management class names, but exact log/build correspondence remains unverified.

## Qualified conclusions
1. **Observed:** The inspected service contains host-policy management and a check for the presence of the SEB executable.
2. **Inferred:** The service path inspected so far is primarily a policy-management/recovery service; its demonstrated process query is focused on whether SEB itself is running.
3. **Unknown:** Whether SecureExamBrowser.exe separately enumerates unrelated processes, whether a different monitoring agent is installed, what the online exam client reports, and how server-side rules use those reports.
4. **Not tested:** Any dynamic Windows behavior, external-process detection outcome, alert propagation, or human-observation outcome.

## Next static-analysis actions
- Inspect SecureExamBrowser.exe metadata and CIL on a local machine; this connector returned an empty base64 body for that 1.92 MB file, so it has not been analysed here.
- Parse IRegistryServiceContract operation signatures and inspect service dispatch/authorization in context.
- Trace every caller of CommandExecutor and identify permitted commands and argument sources.
- Establish active config/source correspondence before attributing legacy XUL behaviour to the shipped browser.

## Method
CIL decoding used the opcode definitions in rea-main/src/dotnet/ManagedMemberInstructionDecoder.ts as a reference while inspecting the selected method bodies. This was not a full REA build/test run and was not a substitute for an independent decompiler or dynamic validation.
