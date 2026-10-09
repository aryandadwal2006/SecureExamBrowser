# Human-Observation Validation Protocol

**Updated:** 2026-10-09  
**Purpose:** Measure the human component of an authorized proctoring system in a controlled mock assessment. This protocol tests observer consistency and procedure coverage; it does not provide techniques for hiding prohibited activity.

## 1. Boundary

The browser can produce local UI events, host telemetry, logs and remote messages. It cannot, from code inspection alone, establish whether a person was physically present, had a clear view of the candidate's hands/screen, or noticed an event. Human observation is an independent control.

The supplied screenshots and the software artifacts do not establish whether an observer was assigned to the user's particular session or what the observer protocol required. The organizer must define those requirements.

## 2. Pre-test definition

Before a mock exercise, write down:
- the rules the observer is expected to enforce;
- which event categories are in scope;
- the required response for each event;
- whether the observer is live, reviewing a recording, or both;
- the evidence retained, who may view it and for how long;
- the consent/notice shown to the test participant;
- the escalation path for ambiguous events.

Do not start an exercise until the organizer approves the script and recording/retention arrangement.

## 3. Controlled protocol

1. Use a synthetic account and disposable test setup; never use a live hiring assessment.
2. Have an independent facilitator generate a small, pre-approved set of clearly defined test events in the mock environment. Do not disable monitoring, alter the candidate's client, or attempt to hide any event.
3. Include neutral baseline intervals and known-positive events to measure both false alarms and missed observations.
4. Keep the observer blind to exact event timing, but inform them in advance that this is a controlled evaluation and obtain any required consent.
5. Record timestamps for event injection, application/UI result, observer response and available local/server receipt.
6. Have a second reviewer independently score the observer record against the event manifest.
7. Repeat after changing one documented condition at a time, preserving the same starting state and consent rules.

## 4. Measurement

For each predefined event, record:
- whether the observer noticed it;
- time to notice and time to respond;
- whether the response matched the protocol;
- whether software telemetry independently recorded the same event;
- whether an authorized test-server receipt exists;
- whether the event is ambiguous or should not count as a violation.

Report false-positive and missed-event rates separately. A human observer missing an event does not by itself imply a software vulnerability, and software logging an event does not prove a human saw it.

## 5. Separation of evidence

Keep these claims separate:
- **UI:** what the candidate-facing assessment showed;
- **host telemetry:** what the operating system recorded;
- **client/service logs:** what the browser stack recorded;
- **server receipt:** what the authorized backend received;
- **human observation:** what the observer reported;
- **recorded review:** what an authorized independent reviewer later confirmed.

A missing result in one channel cannot establish absence from all other channels.

## 6. Acceptance criteria

A test passes only when the required evidence channels are known healthy and the expected response is present. If a monitor, recording, clock or receipt channel is unavailable, mark the test **inconclusive**, not passed.

Archive only redacted test records with a scenario ID, build/config digest, timestamps, outcome and reviewer disposition. Never commit participant recordings, candidate data, session tokens or unredacted personal information.
