The messaging system in d365fo.tools is a powerful tool to centralize all informational data and manage its flow. Simply put: You give it a message you want to write, and tell the system how important it is (what Level it has) and the system will handle 'the rest'.
The rest being ...
- Logging the message
- Deciding whether it should be written to the console screen (host/information)
- Deciding whether it should be written to verbose only
- Deciding whether it should be written to debug
- Deciding whether it should be written as a warning
It will also automatically add a timestamp and the name of the function calling it to the message.

Here's a simple example on how to use it:
```PowerShell
Write-PSFMessage -Level Verbose -Message "I'm an example message and will probably - but not necessarily - written to the verbose stream"
```

# The Levels of power
There are 10 Levels you can choose from when writing a message. d365fo.tools-users can configure 9 of them as they please, controlling how much verbosity they want. Only the warning level cannot be altered by the user.

By default, the first three levels are written to screen:
* Critical / 1
* Important / Output / 2
* Significant / 3

By default, the second set of three levels are written to verbose only:
* VeryVerbose / 4
* Verbose / 5
* SomewhatVerbose / 6

All messages get sent to debug by default, but three more levels exist that are debug only:
* System / 7
* Debug / 8
* InternalComment / 9

Finally, there's the warning level:
* Warning / 666

In all cases, both the text as well as the numerical value can be used at your own discretion.

# When to use?

Basically, Write-Message _completely replaces_ all instances of Write-Host, Write-Information, Write-Verbose, Write-Debug, Write-Warning and Write-Output. If you'd use one of those, use Write-Message instead. (Write-Output has seen lots of misuse for verbose communication with the user, and has thus been deprecated for use of generating actual output objects.)
As a general guideline though:

## When to give warning

Whenever something fails but isn't bad enough to warrant terminating the function (or skipping to the next input) over, it's time to use Write-Message's warning level:

```PowerShell
Write-Message -Level Warning -Message "Failed to access XYZ. Continuing but will lack some information"
```
As shown in the example, this is usually used when a function fails to access supplementary data.

This is *not* intended for use when something crippling happens, something you'd stop the function or skip processing the current input item over! See the guide on flow control and `Stop-Function` for details on how to handle that.

## When to directly contact the user

The first three Levels are reserved for things that the human user must be communicated with. Which Level to use is at the discretion of the developer - in case of doubt use Important/Output/2 - the greater the impact of whatever is being communicated, the lower (numeric based) the Level should be.

Things that should be communicated to the user:
- Deprecation warnings
- Loading additional resources that one would not expect to need when running the function (e.g.: Importing another module)
- Sanity checks. Keeping users from committing folly is high on our todo list.
- Information that may induce a human user to interrupt execution

## This ain't no chat engine

The verbose Levels - VeryVerbose/4, Verbose/5 and SomewhatVerbose/6 - exist to provide general status information, what the function is doing right now. This means it is not shown to the user by default, but may be helpful in showing what the function is doing and how fast it is progressing.

General usage and associated Level:
- Setup actions taken in the begin block: Verbose/5
- Starting to process an input item (Such as an object received from pipeline): VeryVerbose/4
- Individual processing phases: Verbose/5
- Actions that are part of a processing phase: SomewhatVerbose/6

Example:

_Warning: This is only to show the use of the various verbosity levels. It is not meant as an example of good function names and blithely ignores any error handling, in order to not clutter this example!_
```PowerShell
function Get-Test
{
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )
    Begin
    {
        Write-Message -Level Verbose -Message "Connecting to Server"
        $smo = Connect-SqlServer
    }
    Process
    {
        foreach ($Item in $InputObject)
        {
            Write-Message -Level VeryVerbose -Message "Processing $Item"
            
            #region 1) Do Stuff
            Write-Message -Level Verbose -Message "Doing stuff with $Item"
            Do-Stuff $Item
            #endregion 1) Do Stuff
            
            #region 2) Do more stuff
            Write-Message -Level Verbose -Message "Doing more stuff with $Item"
            
            Write-Message -Level SomewhatVerbose -Message "Converting stuff"
            Convert-Stuff $item
            
            Write-Message -Level SomewhatVerbose -Message "Waiting for stuff"
            Wait-ForStuff $item
            
            Write-Message -Level SomewhatVerbose -Message "Removing stuff"
            Remove-Stuff $item
            #endregion 2) Do more stuff
            
            #region 3) Finish doing stuff
            Write-Message -Level Verbose -Message "Finishing doing stuff with $Item"
            Close-Stuff $item
            #endregion 3) Finish doing stuff
        }
    }
    End
    {
        Write-Message -Level Verbose -Message "Disconnecting from Server"
        $smo.Disconnect()
    }
}
```

## Debugging messages

Finally, the lower Levels are for debugging purposes only. Feel free to add them wherever it may be convenient to have some information written for debugging purposes but no pretext for even verbose output. Truly, this only exists for log purposes.
Also information that is directly development-related (such as immediate SQL statements that will be sent to the SQL server) and of no immediate interest to a user should be written to debug channels only. In that case, it is appropriate to write _two_ messages. One (on the verbose side) for the action being taken in humanly understandable text and one (on the debug side, e.g. _System_ or _Debug_) for the actual technical step taken.

# Minimum usage

The minimum required in a d365fo.tools function is:
- Warnings as described in the warnings section
- VeryVerbose and Verbose messages, as shown in the section on verbosity

**Note:** This entire page is deeply inspired by the work done over in the [dbatool.io](https://github.com/sqlcollaborative/dbatools) module. Pay them a visit and learn from the very same people as we did.