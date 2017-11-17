# Simple ETL Framework

## Introduction

All ETL projects require a standard structure one or way or another due to the fact there are several moving parts inherent to these.
Typically they need:
1. A repository for the code
2. A sane way to manage environment configuration, including settings that are environment-aware (usernames, passwords, databases, etc)
3. A simple way to refer to tooling instalation and settings
4. A simple way for packaging and testing the code
5. (optional) project encapsulation (e.g. multiple projects being able to run at the same time, if required)

The objective of this framework is to simplify the above, while providing a level of customization that can come at project level.

To note that this framework was conceived to be used with file based projects only. EE Repository support is TBD.

## Dependencies

1. Pentaho Data Integration
2. Maven (optional if you want to package locally)
3. A convenient code/text editor (atom or visual studio code are recommended at a minimum)

## Framework structure

```
etl/bin            <- general execution scripts
     /base         <- the base framework
   /environments   <- base folder for environment configuration
     /env1
       /runtime1
         /.kettle
         /.pentaho
       /runtime2
    /env2
       /runtime1
   /model          <- sql scripts, mondrian models
   /repository     <- the ETL
   /src            <- additional java code
extensions/        <- java extensions not related to PDI (e.g hadoop input formats)
plugins/           <- additional PDI plugins or existing plugins with fixes
pom.xml            <- the main pom file that guides packaging
```

## The Environments

The framework allows having a an arbitrary number of environments setup, making it easy to version control all of them in the same place. It is the developer responsibility to make sure sensitive informations such as passwords don't end up in a VCS.

To instruct the framework to use a certain environment there are 2 environment variables made available:
1. PENTAHO_ENV - points to the base environment folder (default: local)
2. PENTAHO_EXEC_RUNTIME - defines which runtime settings should be used to execute (default: development)

An example environment structure can be as follows:
```
/demo
  /development
/local
  /development
/hdp63
  /development
  /qat
  /production
/aws
  /ec2dev
  /ec2qat
/gcp
  /gcpdev
  /gcpprod
```

Each of the environments kettle.properties, shared.xml, metastore or any other relevant configuration files must be kept in sync when adding/updating/removing new execution variables. A script that detects differences could potentially be developed (TBD).

### Setting up an environment

It is recommended that on unix systems, especially fixed environments, such as qat/prod have the environment settings set system wide to avoid misuse. System configuration files such as .bashrc or .bash_profile are good contenders to host these settings and potentially automate deployments:

```
export PENTAHO_ENV=hdp63
export PENTAHO_EXEC_RUNTIME=production
```

### The boot.conf file

An additional configuration which is environment aware exists within each of the runtimes to allow changing values like the jvm home, pdi version and default JAVA options. This is the boot.conf file, which takes care of the initial bootstrap of the execution.

```
PENTAHO_HOME=/usr/local/pentaho/design-tools/data-integration
PENTAHO_DI_JAVA_OPTIONS="-Xms1g -Xmx2g"
PENTAHO_JAVA_HOME=/usr/jvm/latest
```

## Unit Testing

The src sub-folder inside the ETL folder contains an example extension of a JUnit unit test that triggers the unit testing framework job to execute all the available tests which are executed when running the `mvn test` command.

These tests are executed based on a configuration file and lightweight framework made of 2 PDI transformations.

### Unit Test setup

Inside the etl/repository/tests there is an xml file that contains the configuration for all the unit tests available to be executed. These unit tests are themselves PDI transformations or jobs.

```
<test-set>
    <test name="a plus b" order="1" location="a_plus_b_mapping_test.ktr" class="sum.tests.ex" package="test"/>
    <test name="a minus b" order="2" location="a_minus_b_mapping_test.ktr" class="sub.tests" package="test"/>
</test-set>
```

The test attribute of the xml file contains the configuration of the test execution:
* name: name that will be presented in the final report
* location: the ktr/kjb location inside the unit folder
* class and package: the names for the test groups in the final report and will drive, for example, the jenkins grouping in the UI

### Executing Unit Tests

To execute tests, execute the following command in the project root folder:
```
mvn test
```

### Unit Test Results

The unit testing framework produces a junit result compliant XML file that can be used as an artefact to displays the test results in a CI server such as jenkins or bamboo.

## Framework Setup

Required steps to bootstrap a brand new project:
1. Make a copy of the base framework skeleton
2. (optional) Setup the bundled demo environment with example configuration for the new developers
3. Upload to the desired VCS and allow project developers access to it 

## Developer Setup

1. Copy the etl/environments/demo environment to create a local one
```
cp -vr etl/environments/demo etl/environments/local
```
2. Setup the environment configuration in etl/environments/local/development/boot.conf
```
PENTAHO_HOME=/Users/puls3/Development/tools/data-integration/6106-242-ee
PENTAHO_DI_JAVA_OPTIONS="-Xms1024m -Xmx2048m -XX:MaxPermSize=256m"
PENTAHO_JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_102.jdk/Contents/Home
```
3. Open Spoon via the relevant Spoon script (windows or unix) in the etl/bin/base folder

When completing these steps, the developer will have a local instance already setup for development within the project context

## Packaging the project

To package the project, execute the following command in the project root folder:
```
mvn package
```

This will produce a zip file that contains all the necessary artefacts for deployment: the etl, plugins and extensions
