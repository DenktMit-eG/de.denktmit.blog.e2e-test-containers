# E2E-Test web GUI sample

The web GUI sample container is designed as a self-explanatory sample testcontainer inheriting from the base image, that
is also part of this project. This file explains, how the overriding of the base image is done and how the Maven
integration works. If you just want to give it a try and see what it does, follow the instructions of the main README.md
of this project.

## How the container assembly works

The **build_image.sh** script builds the sample-webgui container in two steps. It first runs a Maven build and then runs
the docker build itself. Lets follow trough.

## The Maven build

The Gauge framework itself is written in Go, but the execution of specs can be implemented in different languages. In
this sample, we decided to make used of the [Gauge java language bindings](https://github.com/getgauge/gauge-java).
Since we want to run some real browser webtests, we are going to use Selenide that provides a neat DSL helper on top of
Selenium and Webdriver. To make some assertions, we will use JUnit 5. Since the Gauge Java binding relies on SLF4J we
decided to use Logback as a logging facade. You will find these four projects as dependencies in this projects pom.xml
file.

The main task of the Maven build is, to assemble everything needed for the **/tests** directory to be included in the
test container. Not only do we need to add the Markdown specs and the implementing test code. We also need to provide
the additional library dependencies for Selenide and JUnit but need to take care of excluding dependencies already
provided by Gauge java to avoid class path conflicts.

We solve the task by using the [Maven assembly plugin](http://maven.apache.org/plugins/maven-assembly-plugin/) that is
perfectly suited to package such stuff based on a **src/assembly/assembly.xml** configuration. Lets have a look

    <assembly xmlns="http://maven.apache.org/ASSEMBLY/2.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/ASSEMBLY/2.0.0 http://maven.apache.org/xsd/assembly-2.0.0.xsd">
    
        <id>e2e-tests</id>
        <formats>
            <format>dir</format>
        </formats>
        <includeBaseDirectory>false</includeBaseDirectory>
        <dependencySets>
            <dependencySet>
                <excludes>
                    <exclude>com.thoughtworks.gauge:gauge-java</exclude>
                </excludes>
                <outputDirectory>libs</outputDirectory>
                <useProjectArtifact>false</useProjectArtifact>
                <useTransitiveDependencies>true</useTransitiveDependencies>
                <useTransitiveFiltering>true</useTransitiveFiltering>
                <scope>test</scope>
            </dependencySet>
        </dependencySets>
        <fileSets>
            <fileSet>
                <includes>
                    <include>manifest.json</include>
                    <include>env/**</include>
                    <include>specs/**</include>
                    <include>src/test/java/**</include>
                    <include>src/test/resources/**</include>
                </includes>
            </fileSet>
        </fileSets>
    </assembly>

We want to aggregate everything needed into a directory, therefore our output format is **dir**. By using
the <dependencySet> directive, we include all direct and transitive Maven dependencies and place it in the libs
directory. Within the <excludes> we define to omit everything already included in gauge-java.

With the <fileSets> directive on the other hand, we include the relevant Gauge configuration, resources like the Logback
configuration and Java classes implementing the executable specifications and of course the specs itself.

Running the Maven build produces the **target/e2etests** directory that we want to include in our E2E testcontainer.

## The Docker build

The Docker build becomes quite trivial. We remove the container internal **/tests** folder inherited from the base image
to replace it with the **target/e2etests** contents created by the Maven build.

To adjust the CLI help texts, we furthermore replace the original txt files by custom once specific for the sample
webgui container. And thats it, a custom sample webgui container inheriting from thje e2e-test-base-image.

## Links

* [Build a Custom CLI with Bash](https://medium.com/@brotandgames/build-a-custom-cli-with-bash-e3ce60cfb9a4)
* [Gauge testing framework](https://gauge.org/)
* [Gauge java language bindings](https://github.com/getgauge/gauge-java)
* [Selenide - Conciste UI Tests](https://selenide.org/)
* [Maven assembly plugin](http://maven.apache.org/plugins/maven-assembly-plugin/)
* [DenktMit eG tech blog](https://denktmit.de/outreach.html)