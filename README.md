# Garrys-Mod-Backdoor-Protector-Script
This script scans Garry's Mod addons for known backdoor patterns, remote execution hooks, and obfuscated logic that may compromise server integrity. It is designed for server owners, modders, and educators who want to audit Lua code safely, transparently, and collaboratively.
The Backdoor Protector is part of EmporiumRP’s diagnostic suite, built to reinforce ethical scripting practices and protect community spaces from hidden exploits.

What It Does

Recursively scans .lua files inside specified addon folders

Flags risky constructs such as:

RunString, CompileString, loadstring

Suspicious use of net.Receive, net.ReadString, http.Fetch

Obfuscated patterns like string.char, encoded payloads, or unreadable logic

Logs results to scan_log.txt with file paths, pattern types, and line numbers

Does not modify or delete any files—purely observational

How It Works
Place the script in garrysmod/lua/autorun/server

Define which addon folders to scan by editing the addonFolders table Example: local addonFolders = { "my_addon_1", "legacy_scripts", "suspect_folder" }

Trigger the scan from your server control panel console (not in-game) using: run_backdoor_scan

The script scans each Lua file, matches against known risky patterns, and writes results to scan_log.txt in /logs/

How to Use
Place the .lua script in garrysmod/lua/autorun/server

Edit the addonFolders table to include the names of the folders you want to scan

Open your server’s control panel console

Run: run_backdoor_scan

Review the output in garrysmod/logs/scan_log.txt

False Positives Disclaimer
This script may flag false positives, especially in addons that use:

Minified or compressed Lua for performance

Legitimate networking or serialization logic

Custom encoding or obfuscation for optimization

These patterns are not inherently malicious. All flagged results should be reviewed manually before taking action. The goal is to raise awareness and support ethical auditing—not to accuse or blacklist.

Educational Intent
This tool is designed to:

Help admins audit unknown or legacy addons

Teach newer developers how to recognize risky patterns

Promote transparent scripting and ethical governance

Support collaborative modding culture through open-source diagnostics

Licensing & Attribution
This script is licensed under the MIT License with lore attribution. All code and architecture are authored by Meth Monsignor. No flagged addons are included in this repository—only the scanning logic.
