# Module Documentation

Do not hand-edit `*.md` files here. They are generated.

To generate / update all markdown help files after adding or changing a public function, run from the repo root with PowerShell 5:

```powershell
pwsh -NoProfile -File ./build/update-docs.ps1
```

The script takes no parameters. It deletes and regenerates every `*.md` file in this folder, so always run it after a comment-based help change and include the full regeneration in your commit.

Requires `platyPS` (`New-MarkdownHelp`). Install prerequisites with `build/vsts-prerequisites.ps1` if the help command is missing.
