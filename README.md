# CrazyDSL

This is a small Proof of Concept (PoC) demonstrating that you can influence argument completers in VSCode/PowerShell **without executing any commands**.

It leverages:
- custom classes
- ScriptAnalyzer rules

The idea is to capture information during static analysis and reuse it to drive IntelliSense for other commands.

---

## How it works (concept)

1. A ScriptAnalyzer rule scans the script for a specific command.
2. It extracts parameter values and stores them in a class (`KQLState`).
3. Argument completers read from that class.
4. As you type, completions are influenced by previously written commands — without execution.

---

## How to use

1. Run the helper functions:

```. .\Helperfunctions.ps1```

2. Run ScriptAnalyzer with the custom rule:

```Invoke-ScriptAnalyzer `
    -Path ".\CommunityDemo\CrazyDSL\Run.ps1" `
    -CustomRulePath ".\CommunityDemo\CrazyDSL\Rule.psm1"```

3. Open `Run.ps1` in VSCode and start typing.

👉 You should now see argument completers for `KQLWhere` being populated automatically based on earlier commands.

---

## Notes

- This is a PoC — expect rough edges.
- Relies on ScriptAnalyzer being executed (manually or via editor integration).
- No actual command execution is required to drive IntelliSense.
  