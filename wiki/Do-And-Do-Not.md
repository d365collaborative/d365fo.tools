# Writing Documentation:

* [If a a function accepts pipeline input, there should at least be one example that shows it being used that way.](https://trello.com/c/Aax7fm9M/52-if-a-a-function-accepts-pipeline-input-there-should-at-least-be-one-example-that-shows-it-being-used-that-way)


* [In Examples, we need to ensure that no unneeded quotes in parameter values and discourage useless quotes.](https://trello.com/c/rXl5jFf2/19-code-verbosity-quotes-when-not-required-semicolons-anything-else-that-doesnt-fit-in-name-usage)

# Writing Code:

* [Prefer dot notation over `Select -ExpandProperty`.](https://trello.com/c/p9c6clqP/59-using-get-childitem-fullname-or-get-childitem-select-expandproperty-fullname)
  * eg. `(Get-ChildItem).FullName`
    
* [Try to return a useful object for the use case and dont try to overtly customize standard .NET types unless needed.](https://trello.com/c/9qcfNYbo/60-do-we-need-to-consistently-output-the-same-type-of-objects-pscustomobject-vs-datatable-vs-out-dbadatatable-is-nice-but-has-a-per)

* [When supressing output using null types, use chained assignment.](https://trello.com/c/zraES2j3/43-null-name-f-some-string-vs-name-f-some-string-out-null)
  * eg. `$null = $result = Command-WhichProducedOutputWhenAssigned`

* [Avoid Write-Output, instead return useful objects closest to the value type of the target](https://trello.com/c/fWiKta1O/15-do-we-write-output-immediately-instead-of-gathering-results-and-waiting-until-the-end-of-the-function-to-return-them)

* [If you need to initialize a value, use $null and avoid values such as a blank string](https://trello.com/c/pvvSrLw7/38-use-null-instead-of-unless-otherwise-required-ie-in-a-pscustomobject-database-vs-database-null)

* [Semicolons are discouraged unless absolutely necessary, consider breaking your statements on multiple lines](https://trello.com/c/rXl5jFf2/19-code-verbosity-quotes-when-not-required-semicolons-anything-else-that-doesnt-fit-in-name-usage):
  * eg. Constructing a pscustomobject from a hash table, also useful for cheap object creation:

    ```
    [pscustomobject]@{
        ServerName = $servername
        IsEnabled = $true
    }
    ```
* [For encapsulating input please use double quotes in PowerShell any output should have bracket escaped values.](https://trello.com/c/rXl5jFf2/19-code-verbosity-quotes-when-not-required-semicolons-anything-else-that-doesnt-fit-in-name-usage)

* [Avoid continuation marks (backticks) in code if at all possible.](https://trello.com/c/Xja13fUY/20-do-we-have-guidelines-for-consistent-use-of-one-liners)

* [Do not indent BEGIN, PROCESS, or END in advanced functions.](https://trello.com/c/yaHYu157/7-how-to-properly-space-for-begin-process-end-0-spaces-from-the-left-line-spacing-can-be-ambiguous-when-using-single-line-scriptbl)

* [Casing follows PowerShell community recommendations](https://trello.com/c/MxprMJhU/5-casing-of-if-else-continue-return-begin-process-end):
  
  * Lower:
    * Language keyword (try, catch, foreach)
    * Process block keyword (begin, process, end)

  * Pascal:
    * Comment help keywords (.Example, .Synopsis)
    * Package or modules 
    * Class
    * Exception
    * Global variables
        
  * Camel Case:
    * Local variables ($localArgument)
    
  * There may be rare cases in which features do not work without required casing, in those cases ignore these recommendations.

* [When choosing names and methods for booleans, consider using a more descriptive name than "Enabled" or "IsEnabled", instead add additional descriptive information such as "IsAdEnabled" or "IsSqlEnabled"](https://trello.com/c/qfXBDHm8/39-isenabled-vs-status)

* The defacto naming convention for any command is ApprovedVerb-D365*

* [Use one space after a bracket.](https://trello.com/c/Lb6rUOD4/37-how-should-spaces-must-come-after-brackets-where-object-whatever-eq-whatever)

* [Use `-Force` instead of `-Confirm:$False`](https://trello.com/c/OYaUyhMO/27-we-did-discuss-this-tweeted-with-msft-about-it-got-mixed-reviews-one-tweet-in-particular-lined-up-with-the-way-that-we-use-force)

* [Open braces on the same line, Closing braces always on their own line.](https://trello.com/c/20GTHsQM/63-when-creating-script-blocks-create-a-bracket-on-new-line-http-www-poll-maker-com-results924522x3e366fd2-38)

* [There is no need to write empty keywords in advanced functions if they are not used (`begin`,`process`,`end`)](https://trello.com/c/NYtu5JUJ/40-do-we-want-to-use-an-empty-begin-and-empty-end-in-advanced-functions-when-we-have-no-code-to-place-in-the-script-block-please-le)

**Note:** This entire page is deeply inspired by the work done over in the [dbatool.io](https://github.com/sqlcollaborative/dbatools) module. Pay them a visit and learn from the very same people as we did.