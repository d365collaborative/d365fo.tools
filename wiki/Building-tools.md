When you contribute to the d365fo.tools project you will quickly learn that we have several validation steps that might throw an error when you are creating PR's against the repository.

## **Prerequisites**
* PSModuleDevelopment (PowerShell module to aid with development)
   * `Install-Module PSModuleDevelopment -Force -Confirm:$false`
* platyPS (PowerShell module to aid with documentation for modules)
   * `Install-Module platyPS -Force -Confirm:$false`

## **Format Comment Based help**
We try to keep the formatting of the Comment Based Help the same across every contributor, so here is the base script on [gist](https://gist.github.com/Splaxi/ff7485a24f6ed9937f3e8da76b5d4840).

You need to work a little with the path to the folder, but otherwise it is as simple as copy & pasting the content into a new powershell console or simply execute the ps1 file directly. When you create a local git repository on your machine, you need to adjust the path from the gist. You should adjust the **"C:\GITHUB\LocalRepository\"** part of the path to match where your local repository is stored. Then rest should work as expected. You should store the file **OUTSIDE** the repo, so it doesn't become part of the project.

## **Generate-ParameterUnitTests**
We try to mitigate the drifting changes that might get introduced when multiple people contribute to the same project. We also try to ensure that the parameters doesn't change **without** we knowing it. This helps us update the examples inside the Comment Based Help and therefor the user base. Find the base script on [gist](https://gist.github.com/Splaxi/2a24fc3c5193089ae7047ac5b8f104db).

You need to work a little with the path to the folder, but otherwise it is as simple as copy & pasting the content into a new powershell console or simply execute the ps1 file directly. When you create a local git repository on your machine, you need to adjust the path from the gist. You should adjust the **"C:\GITHUB\LocalRepository\"** part of the path to match where your local repository is stored. Then rest should work as expected. You should store the file **OUTSIDE** the repo, so it doesn't become part of the project.

## **Update-Docs**
Whenever we release a new version of the module, we push the updated markdown files used for documentation, to make sure that users can lookup parameter names and parameterset specification. Find the base script on [gist](https://gist.github.com/Splaxi/8934e13cb35918d13af6e3a21c208b0e).

You need to work a little with the path to the folder, but otherwise it is as simple as copy & pasting the content into a new powershell console or simply execute the ps1 file directly. When you create a local git repository on your machine, you need to adjust the path from the gist. You should adjust the **"C:\GITHUB\LocalRepository\"** part of the path to match where your local repository is stored. Then rest should work as expected. You should store the file **OUTSIDE** the repo, so it doesn't become part of the project.

## **Closing notes**
The reason why we keep these steps manual for the time being is to make sure that nothing gets updated without we either knowing about it or without us making a "decision" to update these things.