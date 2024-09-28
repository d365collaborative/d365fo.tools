## **Branching strategy**

We encourage the use of features/bug fixes branches when working against the d365fo.tools repo. Read more about it [here](https://docs.microsoft.com/en-us/azure/devops/repos/git/git-branching-guidance?view=vsts)

One of the benefits of having a feature branch is that if you want to submit multiple PR's against the central repository and you have to rework different parts of any PR, things are separated. When you push your changes to your branch, things get picked up automatically and the check pipeline will execute currently once again.

## **Create a new branch from the desktop client**

1. Make sure that you have selected your local repository
2. Make sure that you have selected the master branch

[[images/Branch.001.png]]

3. Click on the **master** branch icon in the top
4. Click on the **New branch** button in the drop down menu

[[images/Branch.002.png]]

5. Fill in the name of the desired branch
6. Click on **Create branch** when ready
    - We recommend that you provide a meaningful name, without spaces

[[images/Branch.003.png]]

7. Make sure that the branch was created and your local repository is switched to that

[[images/Branch.004.png]]

8. Do your magic and commit stuff to your branch
9. When you are ready to create a pull request (PR), simply click on the **Publish branch** button in the top menu

[[images/Branch.005.png]]

10. To create a PR, simply click on the **Branch** menu item in the very top of the window and click on the **Create pull request** option

[[images/Branch.006.png]]

11. Your default browser will now load and go to github
12. Make sure that you compared the branch against the **master** branch in the d365fo.tools repository

[[images/Branch.007.png]]