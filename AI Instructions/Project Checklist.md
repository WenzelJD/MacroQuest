**MQ2-PRIVATE-BUILD-CHECKLIST.md**

### 2) Code Cleanup and Compile
- Rename main executable to generic name
- Rename all DLLs (MQ2Main.dll → winutils.dll or similar) and update internal references
- Change icon and version info using Resource Hacker
- Remove all unused plugins
- Strip debug logging and obvious "MacroQuest"/"MQ2" strings
- Change Window Class Name
- Review and customize key plugins if desired
- Get project compiling cleanly
- Test basic functionality and your existing Lua scripts

### 3) Continuous Maintenance
- After patches: Pull latest source, update offsets, recompile
- Periodically review and remove anything no longer needed
- Keep documentation updated

### 4) Plugin vs Lua Evaluation
- Create `plugin-vs-lua-evaluation.md`
- Evaluate new features: Lua vs Custom Plugin?
- Test cases: `IsBehind(targetID)`, aggro rank, etc.

### 7) Future Possibilities
- External AI chat responder (Lua + external script)
- External launcher / boxing management tool