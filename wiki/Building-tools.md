When you contribute to the d365fo.tools project you will quickly learn that we have several validation steps that might throw an error when you are creating PR's against the repository.

These validations are checked when you create a pull request. The checks are done by GitHub Actions and are defined in the [build.yml](https://github.com/d365collaborative/d365fo.tools/blob/master/.github/workflows/build.yml) file. The GitHub Action will run the PowerShell scripts in the [build](https://github.com/d365collaborative/d365fo.tools/tree/master/build) folder of the repository starting with `vsts-`.

For some of the checks, we have created PowerShell scripts that can be used to automatically make the changes needed to pass the validation. You can run these scripts locally on your machine to make the changes needed before you create a pull request. They are also available as a GitHub Action defined in the [update-generated-text.yml](https://github.com/d365collaborative/d365fo.tools/blob/master/.github/workflows/update-generated-text.yml). If you have your own fork of the repository, you can use this action to automatically update the generated files in your pull requests.

To run the scripts locally, follow the instructions below.

## **Prerequisites**
* PSModuleDevelopment (PowerShell module to aid with development)
   * `Install-Module PSModuleDevelopment -Force -Confirm:$false`
* platyPS (PowerShell module to aid with documentation for modules)
   * `Install-Module platyPS -Force -Confirm:$false`

## **Format Comment Based help**
We try to keep the formatting of the Comment Based Help the same across every contributor. This is done by the [Format-CommentBasedHelp.ps1](https://github.com/d365collaborative/d365fo.tools/tree/master/build/format-commentbasedhelp.ps1) script. If you want to find out more about comment based help, take a look at [about Comment Based Help](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help).

## **Generate-ParameterUnitTests**
We try to mitigate the drifting changes that might get introduced when multiple people contribute to the same project. We also try to ensure that the parameters do not change **without** us knowing about it. This helps us update the examples inside the Comment Based Help and therefor the user base. This is done by the [Generate-ParameterUnitTests.ps1](https://github.com/d365collaborative/d365fo.tools/tree/master/build/generate-parameterunittests.ps1) script. This script will generate a new test file for each command in the module, using the `Invoke-PSMDTemplate` cmdlet of [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment). The tests will check a list of best practices.

## **Update-Docs**
Whenever we release a new version of the module, we push the updated markdown files used for documentation, to make sure that users can lookup parameter names and parameterset specification. This is done by the [Update-Docs.ps1](https://github.com/d365collaborative/d365fo.tools/tree/master/build/update-docs.ps1) script. The markdown files are created from the Comment Based Help in the module. The `New-MarkdownHelp` cmdlet of [platyPS](https://learn.microsoft.com/en-us/powershell/utility-modules/platyps/overview) is used to create the markdown files.

## **Generate-FindCommandIndex**
The [Find-D365Command](Find-D365Command.md) is used to find commands in the module. It acts faster than the built-in Get-Help cmdlet, but it requires a file to be updated whenever a new command is added to the module. This script will update the file with the new command. Find the script in the build folder of the repository: [Generate-FindCommandIndex.ps1](https://github.com/d365collaborative/d365fo.tools/tree/master/build/Generate-FindCommandIndex.ps1).

## **Closing notes**
The reason why we keep these steps manual for the time being is to make sure that nothing gets updated without we either knowing about it or without us making a "decision" to update these things.