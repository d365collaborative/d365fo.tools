Here, we'll help you understand how to contribute to the project, and talk about fun stuff like styles and guidelines.
# Contributing
Let's sum this up saying that we'd **LOVE** your help. We're slowly getting the hang of running an open source project of this size but we're still learning along the way.

There are several ways to contribute:
 - Create new commands (PowerShell/Dynamics 365 for Finance & Operations knowledge required)
 - Report bugs (everyone can do it)
 - Tests (Pester knowledge required)
 - Documentation: functions, website, this guide, everything can be improved (everyone can)
 - Code review (PowerShell/Dynamics 365 for Finance & Operations knowledge required)

If you wanna help out to make the module even more robust
   - Standardize param names
   - Create tests for existing functions
   - Review existing function documentation

## Documentation
Documentation is really the area we welcome any help possible. The documentation refers to CBH (Comment Based Help). The CBH documentation is included with each command and is the content you see when you run `Get-Help Function-Name`. If any of that content is not clear enough or if the examples in the functions are not working, you should say so (e.g. raise an issue on GitHub or contact us on twitter). Even if you are a casual user or a PowerShell newbie, we need your angle to make it as straight forward and clear as possible.

## Contribute New Commands
Start out reviewing the [list of functions on in the docs folder](https://github.com/d365collaborative/d365fo.tools/tree/master/docs), or pulling the list from the module with `Get-Command -Module d365fo.tools -CommandType Function | Out-GridView`. If you find something similar already exists, open [a new issue on GitHub](https://github.com/d365collaborative/d365fo.tools/issues/new) to request an enhancement to that command. If nothing similar pops up, either ping @splaxi on twitter with your idea about the new command or open a new issue on GitHub with details or requirements you need.

## Report Bugs
[Open a new issue](https://github.com/d365collaborative/d365fo.tools/issues/new) on GitHub and fill in all the details. The title should report the affected function, followed by a brief description (e.g. _Get-D365Environment - Add property x to default view_). The provided template holds most of the details coders need to fix the issue.

## Fix Bugs
If you feel for fixing a bug, but don't know GitHub enough, the dbatools.io project has a good starting guide. We are on the same team, so instead of us writing a guide that is close to theirs - we simply point to theirs [step-by-step guide](https://dbatools.io/firstpull).

[Open a PR](https://github.com/d365collaborative/d365fo.tools/pulls) targeting ideally just one ps1 file (the PR needs to target the *master* branch), with the name of the function being fixed as a title. Everyone will chime in reviewing the code and either approve the PR or request changes. The more targeted and focused the PR, the easier to merge, the fastest to go into the next release. Keep them as simple as possible to speed up the process.

## Branching
Make sure to read our [branching guide](https://github.com/d365collaborative/d365fo.tools/wiki/Branching) on the wiki to get a good starting point.

## Automated build
If you want to get early warning about what you need to fix in the PR you want to create, you could configure your own Azure DevOps account to build from your own Github repository. Read the guide on how to utilize the same build steps as we are [here](https://github.com/d365collaborative/d365fo.tools/wiki/Azure-DevOps-Build-Configuration)


## Standardize Parameters and Variables
We chose to follow the standards below when creating parameters and variables for a function:

1) Any variable used in the parameter block must have first letter of each word capitalized. (e.g. `$FilePath`, `$BacpacPath`). This is also called [PascalCase](https://en.wikipedia.org/wiki/Camel_case).
2) Any variable used in the parameter block **is required** to be singular.
3) Any variable not part of the parameter block, that is multiple words, will follow the camelCase format. (e.g. `$currentFile`, `$hotfixManifest`)
4) Refrain from using single character variable names (e.g. `$i` or `$x`). Try to make them "readable" in the sense that if someone sees the variable name they can get a hint what it presents (e.g. `$db`, `$operatorName`).

When you are working with "objects" in D365FO, say with files, what variable name you use should be based on what operation you are doing. You can find examples of various situations in the current code of the module to see more detailed examples. As an example: in situations where you are looping over the files for a folder, try to use a plural variable name for the collection and then single or abbreviated name in the loop for each object of that collection. e.g. `foreach ($file in $files) {...`.

## Tests
Remember that tests are needed to make sure d365fo.tools code behaves properly. The ultimate goal is for any user to be able to run d365fo.tools' tests within their environment and, depending on the result, be sure everything works as expected. d365fo.tools works on a matrix of environments that will hardly be fully covered by a Continuous Integration system. That being said, we have Azure DevOps set up to run at each and every commit.

### How to write tests
To save resources and be more flexible, we split tests with tags into two main categories, "UnitTests" and "IntegrationTests". Below is a starting list of things to consider when writing your test:
- "UnitTests" do not require an instance to be up and running, and are easily the most flexible to be ran on every user computer. - "IntegrationTests" instead require one or more active instances, and there is a bit of setup to do in order to run them.
- Every one of the "IntegrationTests" may need to create a resource (e.g. a database).
- Every resource should be named with the "d365fo.toolsci_" prefix. _The test should attempt to clean up after itself leaving a pristine environment._
- Try to write tests thinking they may run in each and every user's test environment.

The d365fo.tools-templates repository holds examples, but you can also inspect/copy/cannibalize existing tests. You'll see that every test file is named with a simple convention _Verb-Noun*.Tests.ps1_, and this is required by [Pester](https://GitHub.com/pester/Pester), which is the de-facto standard for running tests in PowerShell.

Tests make sure a "contract" is made between the code and its behavior: once a test is formalized, changes to the code itself or enhancement will be written making sure existing functionality is retained, making the entire d365fo.tools experience more stable.

**Note:** This entire page is deeply inspired by the work done over in the [dbatool.io](https://github.com/sqlcollaborative/dbatools) module. Pay them a visit and learn from the very same people as we did.