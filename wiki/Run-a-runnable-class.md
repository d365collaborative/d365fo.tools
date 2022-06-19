**You want to execute / run a runnable class**

```
Invoke-D365SysRunnerClass -ClassName SysDBInformation
```
*This will start a web browser and have it call the SysRunnerClass menu item with the SysDBInformation name of a runnable class*

```
Invoke-D365SysRunnerClass -ClassName SysDBInformation -Company USMF
```
*This will start a web browser and have it call the SysRunnerClass menu item with the SysDBInformation name of a runnable class and only execute it against the USMF company*

**Want to execute the SysFlushAod class**
```
Invoke-D365SysFlushAodCache
```
*This will start a web browser and have it call the SysRunnerClass menu item with the SysFlushAod name as the runnable class to execute*