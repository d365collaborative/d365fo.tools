# Unit Tests for Public Functions

Do not hand-edit `*.Tests.ps1` files here. They are generated.

To generate / update all parameter unit tests after adding or changing a public function, run from the repo root with PowerShell 5:

```powershell
pwsh -NoProfile -File ./build/generate-parameterunittests.ps1
```

The script takes no parameters. It deletes and regenerates every `*.Tests.ps1` file in this folder, so always run it after a parameter signature change and include the full regeneration in your commit.

Requires `PSModuleDevelopment` (`Invoke-PSMDTemplate`). Install prerequisites with `build/vsts-prerequisites.ps1` if the template command is missing.
