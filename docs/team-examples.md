# Team-Oriented Examples

These templates help teams reuse `ld` logs in incident response, bug reports, and AI-assisted analysis.

## Incident report template

```text
Title: <Short incident summary>
Date/Time (UTC): <YYYY-MM-DD HH:MM>
Owner: <Name>
Impact: <Users/systems affected>

What happened:
<Plain-language summary>

Timeline:
- <time> <event>
- <time> <event>

Commands and raw terminal session:
<Paste output captured via ld c>

Root cause:
<Known or suspected>

Fix applied:
<What changed>

Follow-ups:
- <action item 1>
- <action item 2>
```

## Bug report template with reproducible CLI session

```text
Title: <Bug summary>
Environment:
- OS:
- Shell:
- Tool version: (run: ld version)

Steps to reproduce:
1. ld start
2. <run command 1>
3. <run command 2>
4. ld stop
5. ld c

Expected behavior:
<what should happen>

Actual behavior:
<what happened>

Terminal session log:
<paste ld output>
```

## AI prompt templates using terminal logs

### Debugging prompt

```text
You are helping me debug a terminal session.
Analyze the log below and provide:
1) likely root cause,
2) confidence level,
3) minimal fix steps,
4) one safer long-term prevention.

Log:
<paste ld output>
```

### Postmortem summary prompt

```text
Summarize this terminal session for an engineering postmortem.
Include:
- key timeline events,
- failed commands/errors,
- successful mitigation steps,
- recommended follow-up actions.

Log:
<paste ld output>
```
