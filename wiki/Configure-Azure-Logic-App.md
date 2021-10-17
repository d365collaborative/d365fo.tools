### **Intro**
So you want to be able to notify someone when a cmdlet is done running? You read about the magical Invoke-D365LogicApp cmdlet?

This will guide you through on how to configure everything inside the Azure Portal.

### **Requirements**
You will need the following **before** you can start:
1. An active Azure subscription
2. An Office365 user account (Azure Active Directory)
   - Email license assigned

### **Prepare**
Download a copy of the file [AzureLogicApp-Template.json](https://raw.githubusercontent.com/d365collaborative/d365fo.tools/master/AzureLogicApp-Template.json)
 and save if on your computer.

### **Implementation**
1. Visit https://portal.azure.com
2. Click **"Create a resource"**
 
[[images/AzureLogicApp.001.png]]

3. Search for **"Template"** and select the **"Template deployment"** option from the results

[[images/AzureLogicApp.002.png]]

4. Click "Create"

[[images/AzureLogicApp.003.png]]

5. Click **"Build your own template in the editor"**

[[images/AzureLogicApp.004.png]]

6. Click **"Load file"**

[[images/AzureLogicApp.005.png]]

7. Locate the **"AzureLogicApp-Template.json"* file that you downloaded earlier.

[[images/AzureLogicApp.006.png]]

8. After the import of the json file, click on the **"Variables"** and select the **"ConnectionName"**. Change the name of the connection in the editor if you want - it doesn't have any real impact on the solution.

[[images/AzureLogicApp.007.png]]

9. Fill in all the details that are necessary, click the **"I agree to the terms and conditions stated above"** checkbox and click on **"Purchase"**

[[images/AzureLogicApp.008.png]]

10. Wait for the deployment to complete. Click on the notification icon in the top right corner.

[[images/AzureLogicApp.009.png]]

11. Click on **"Resource groups"** and search for the resource group you filled in during deployment. Click the resource group to continue.

[[images/AzureLogicApp.011.png]]

12. Click on **"NotifyWhenDone"** (Logic App) - remember that you could have changed the name during deployment.

[[images/AzureLogicApp.012.png]]

13. Click **"Edit"**

[[images/AzureLogicApp.013.png]]

14. Click on the **"Connections"** bar with the **Outlook** icon and the yellow/orange exclamation mark. Click on **"Invalid Connection"**.

[[images/AzureLogicApp.014.png]]

15. Select an account of yours that is an AAD and have an email license.

[[images/AzureLogicApp.015.png]]

16. Click on the connection that has a blue checkmark to the left.

[[images/AzureLogicApp.016.png]]

17. Validate that things look like they should.

[[images/AzureLogicApp.017.png]]

18. Save the Logic App.
19. Click **"Edit"** once more.
20. Click **"When a Http Request is received"** and click on the copy to clipboard button next to the URL.

[[images/AzureLogicApp.018.png]]