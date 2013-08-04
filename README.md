CQ Scripts
==========

CQ Sample Build Scripts

* For use with CQ projects utilizing Maven or VLT project structures
* Designed for local or CI deployments
* Tested with CQ 5.5 projects


Script Information & Usage
--------------------------

Additional details of the individual scripts can be found here.


### cq-deploy.sh

The deploy script performs imports to CQ via either VLT or Maven. A bundle/mvn project can be identified via a ```src/main/java``` directory, while node/vlt projects can be identified via ```src/main/content```.

The script should be edited to provide a default project name:

```
# Environment Defaults
project=add-project-name-here
```

As detailed below, environment-specific configuration can be used to override the script's default CQ server location and credentials. The default project can also be set as a value in the ```{environment}.properties``` file.

#### Usage

Assuming the main project consists of a number of node & bundle projects named with the ```{project-name}-{sub-project-name}``` convention, multiple projects can be deployed using the following syntax:

```
cq-deploy.sh subproj-1 subproj-2 …
```

In order to use an environment-specific property file, the first argument should be the name of the ```example-env.properties``` file:

```
cq-deploy.sh example-env subproj-1 subproj-2 …
```

By default project OSGI bundles are deployed into CQ at the ```/apps/{project}/install``` location in the repository. If not cleaned up during full builds, older versions of project OSGI bundles can hang around and become activated.

When running a full deploy, the *clean-bundles* argument can be used to cleanup the install location. As shown here, this argument should come after any environment overrides, but before any additional sub-projects are deployed.

```
cq-deploy.sh example-env clean-bundles subproj-1 subproj-2 …
```

Finally, CQ generated clientlibs for the project (located under ```var/clientlibs/etc/designs/{project}/clientlibs```) can be cleaned up via adding *clean-clientlibs* to the command:

```
cq-deploy.sh example-env clean-bundles clean-clientlibs subproj-1 subproj-2 …
```


### cq-init.sh

The init script serves two purposes:

* First, the *config* project is imported into CQ, allowing for default runmode configuration to be quickly imported into CQ.
* Secondly, the entire project will be built. This ensures that the parent pom, and any dependent sub-projects (e.g. taglib may depend on services) has been built and is available in the local maven repository

#### Usage

This script is called directly, using an optional environment argument to override the defaults:

```
cq-init.sh example-env
```


### cq-import-nodes.sh

The import nodes script imports all node projects into the repository.

Under the hood this script just calls the *deploy* script: passing any optional environment arguments, specifying *clean-clientlibs*, and including all of the subprojects containing CQ nodes to be deployed.

For the example script here, that's the *config* and *view* projects based on the CQ Blueprints Archetype.

#### Usage

This script is called directly, using an optional environment argument to override the defaults:

```
cq-import-nodes.sh example-env
```


### cq-import-bundles.sh

The import bundles script imports all bundle projects into the repository.

Under the hood this script just calls the *deploy* script: passing any optional environment arguments, specifying *clean-bundles*, and including all of the subprojects containing OSGI bundles to be deployed.

For the example script here, that's the *services* and *taglib* projects based on the CQ Blueprints Archetype.

#### Usage

This script is called directly, using an optional environment argument to override the defaults:

```
cq-import-bundles.sh example-env
```


### cq-import-all.sh

The import all script imports all projects into the repository, including both node projects as well as bundle projects.

Under the hood this script just calls the two *import-nodes* and *import-bundles* scripts.

#### Usage

This script is called directly, using an optional environment argument to override the defaults:

```
cq-import-all.sh example-env
```


### cq-mvn-refresh.sh

The mvn refresh script builds eclipse project/classpath files for all projects, such that the projects can easliy be imported into eclipse.

The script should be edited to provide a default project name:

```
# Environment Defaults
project=add-project-name-here
```

First, a full mvn build is run at the top-level of the project, to ensure that the parent pom is rebuilt, and all sub-projects will compile.

Next, each subproject is built using the maven eclipse plugin, generating approriate eclipse ```.project``` and ```.classpath``` files, enabling all of the sub-projects to be imported into eclipse.

#### Usage

This script is called directly:

```
cq-mvn-refresh.sh
```


Additional Information
----------------------

Scripts are assumed to be deployed at the root of the project directory, for example:

```
{project-dir}/scripts
```

By adding this directory to the ```$PATH```, the scripts can be run from anywhere; they only need to be located relative to the target projects. See the individual scripts for additional information.

Assumes CQ Project Structures based off of the [CQ Blueprints Maven Archetype](http://www.cqblueprints.com/xwiki/bin/view/Blue+Prints/The+CQ+Project+Maven+Archetype)


### Maven Builds

These scripts utilize Maven command line builds, and as they are designed to work with CQ Blueprints projects, will need access to the Adobe, and CQ Blueprints Maven Repositories:

* [CQ Blueprints Maven Repository](http://www.cqblueprints.com/xwiki/bin/view/Blue+Prints/Connecting+to+the+CQ+Blueprints+Repository)
* [Adobe Maven Repository](http://www.cqblueprints.com/xwiki/bin/view/Blue+Prints/Connecting+to+the+Adobe+Maven+Repository)

Maven version should be at least [Maven 3](http://maven.apache.org/)

The scripts use the following cmd to deploy OSGI bundle projects:

```
mvn clean install -P cq -P cqblueprints -Pauto-deploy -Dcq.host=$cqhost -Dcq.port=$cqport -Dcq.user=$cquser -Dcq.password=$cqpassword
```


### VLT Builds

The scripts are also designed to work with Maven projects containing CQ Nodes (node projects).

VLT should be included within the CQ Quickstart, located at:

```
crx-quickstart/opt/filevault
```

Once VLT is installed and added to the ```$PATH```, the scripts will use the following cmd to deploy CQ node projects:

```
vlt --credentials $cquser:$cqpassword import -v http://$cqhost:$cqport/crx {node-project}/src/main/content /
```

Further info and configuration instructions can be found at the [Adobe VLT Page](http://dev.day.com/docs/en/cq/current/core/how_to/how_to_use_the_vlttool.html).


### Environment Specific Deploys

The scripts are designed to be run with environment-specific properties files which specify the approriate CQ server and credentials.

Property values can be placed in an ```{environment-name}.properties``` file containing values for the CQ server and credentials:

```
cqhost=localhost
cqport=4502
cquser=admin
cqpassword=admin
```

Local and CI author/publish examples are included in this project.
