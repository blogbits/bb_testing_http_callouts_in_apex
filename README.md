# Testing Http based call-outs in Apex

Demonstration project - techniques for testing http based call-outs to external services using the Salesforce Apex language.

The related blog post "Testing Http based call-outs in Apex" is available at [kleencut.net](https://www.kleencut.net/blog/mocking-todo-example) 


The following project is in the Salesforce source format and can be installed and ran on a scratch org.

Git clone the source:

```bash
https://github.com/blogbits/bb_testing_http_callouts_in_apex.git
```

Create a scratch org from within the project directory.  This command assumes you have a **default** DevHub configured:

```bash
sfdx force:org:create -f ./config/project-scratch-def.json -a <name>
```

If a default DevHub is not configured then you need to add the --targetdevhubusername (-v) parameter:

```bash
sfdx force:org:create -f ./config/project-scratch-def.json -a <name> -v <Your-DevHub-Username>
```

You can config a default DevHub globally (not project specific) by using the config command. For example:

```bash
sfdx force:config:set defaultdevhubusername=<username> -g
```

Once you have the scratch Org created you can set it as the default scratch org for the project. This will then be used for all future `push` and `pull` commands without needing the -u parameter.

```bash
sfdx force:config:set defaultusername=<username>
```

Push the project source to your scratch org (this command assumes that a scratch org has been set as the default see above)

```
sfdx force:source:push
```

Open the scratch org:

```bash
sfdx force:org:open -u <username>|<alias>
```


Run some tests. Eg

```bash
sfdx force:apex:test:run --tests ToDoServiceTest --resultformat human
```
