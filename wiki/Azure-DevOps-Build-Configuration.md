## **Prerequisites**
You will need a Personal Access Token configured in your github account. Read this [guide](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) to obtain that.

## ﻿**Configure Github Access**
1. Navigate to your Azure DevOps project
2. Click on the **"Project settings"** icon in the bottom left corner of the page

[[images/image-e2513b65-f1db-4dad-a630-0e2ae6510eb9.png]]

3. Select the **"Service connections"** menu option, under the **"Pipelines"** section in the new navigation tile on the left
4. Select **"Github"** from the **"New service connection"** dropdown list

[[images/image-42be014d-3dab-49a4-827b-41ba6385b913.png]]

5. Select the **"Personal access token"** option in the **"Choose authorization"** configuration
6. Fill in a desired **name** for this connection that you are creating in the **"Connection Name"** configuration
7. Fill in your token that you have created on Github in the **"Token"** configuration

[[images/image-99ecf271-0fbd-4b8d-9133-970992f628b2.png]]

8. Validate that the **"Service Connection"** is created as desired and go back to your Azure DevOps project start page

## **Setup the build pipeline**

1. Select the **"Pipelines"** menu option in the navigation on the left
2. Select the **"Builds"** menu option that is revealed under the **"Pipelines"** section in the navigation on the left
3. Click the **"+ New"** iceon and select the **"New build pipeline"** from the dropdown

[[images/image-424819b5-687c-4b5d-8558-9953d7912ab1.png]]

Or if you never did create a build pipeline it will just show you a empty page with just one button to click

[[images/image-c3d3a98c-42bd-4864-b007-8402f94a8d10.png]]

4. You have to select the **"Github"** option and validate that it selects the current **"Service Connection"** created earlier
5. Select the github repository you want to build
6. Select the default branch that the build pipeline should build when you initiate a manuel build
    - **"master"** is the normal default
7. Click continue when ready

[[images/image-b86b0ca1-9123-4e35-9d91-3079b9a70658.png]]

8. Select the **"Empty job"** option in the very top of the page

[[images/image-7a660f10-5970-4246-bb0c-053e24c67689.png]]

9. Select the new Agent job 1 and click on the + sign
10. Search for PowerShell and add 2 x PowerShell tasks

[[images/image-00b1392f-9f4c-4b62-96d8-ba9e67a4e92d.png]]

11. Search for Publish Test Results and add only 1

[[images/image-7cda2c2c-0276-45de-b48a-a250bfafe0b9.png]]

12. Validate that you have **2** PowerShell tasks and **1** Publish Test Results

[[images/image-a520bea2-d107-4df4-9582-534e98563aaa.png]]

13. Select the first PowerShell task, name it **"Prerequisites"**
14. Fill in **"build/vsts-prerequisites.ps1"** into the **"Script Path"**

[[images/image-77dce872-0c56-440a-8103-5b1b1af5be05.png]]

15. Select the second PowerShell task, name it **"Validate"**
16. Fill in **"build/vsts-validate.ps1"** into the **"Script Path"**

[[images/image-7bfbab7d-5253-4ee5-8514-b3ff67e8364b.png]]

17. Select the Publish Test Results and change the **"Test result format"** from **"JUnit"** to **"NUnit"**
18. Expand the **"Control Options"** section and change the **"Run this task"** value from **"Only when all previous tasks have succeeded"** to **"Even if a previous task has failed, even if the build was canceled"**

[[images/image-a46e25f0-f4bd-446d-9942-97bcc614b4f4.png]]

19. When ready click on the **"Save & queue"** button in the top menu and select the **"Save"** option from the dropdown menu

[[images/image-3c49f8ae-a868-46f7-8fa2-402e58cc341d.png]]

20. Go back to the build pipeline overview and **"Queue"** a new build
21. Accept the default values from the popup

[[images/image-9482e53d-e2fc-4129-894d-c6881a23358d.png]]

22. Once the build is done and error free, you can continue the configuration of your github repository and branch protection