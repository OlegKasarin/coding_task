# coding_task

Short instruction how to test the app behaviour:
1. Open Remote Config in Firebase project;
2. On Parameters tab click Edit button for "cards" parameter;
3. Change JSON:
- id (Int) - unique id of a card,
- url (String) - image url,
- order (Int) - order of element in collection view.
4. Click Save button;
5. Click Publish changes button.

How to run the app on iOS simulator:
1. Download ZIP;
2. in Terminal jump into related directory with project files (command: "cd /<user>/Downloads/coding_task_ios");
3. Run "pod install" command (if you don't have cocoapods, you can install brew and then use command: "brew install cocoapods");
4. Run coding_task_ios.xcworkspace;
5. Choose any simulator and run the project (cmd + B).