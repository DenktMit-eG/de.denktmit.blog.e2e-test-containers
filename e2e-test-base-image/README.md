# E2E-Tests base image

The base container is designed as a self-explanatory starting point to derive from. It already contains minimalistic
specs and a test class to serve as a very basic example. If you just want to give it a try and see what it does, follow
the instructions of the main README.md of this project id the parent dir. This README.md file gives you an overview of
how everything is glued together.

## The components of the base image

The base image mainly consists of two parts. The **cli** folder contains the bash magic for CLI and provides the
self-explanatory usage capabilities of the base image. The **tests** folder contains the Gauge specific setup to express
specification in Markdown and execute them against some system under test.

## The CLI magic inside /cli

The CLI approach I used to implement the cli features is inspired by
the [Build a Custom CLI with Bash](https://medium.com/@brotandgames/build-a-custom-cli-with-bash-e3ce60cfb9a4) post of
Brot & Games. Basically we have an entrypoint in
**cli.sh** that shows helpful usage instructions and lists available commands. If a recognised command is provided, it
delegates the call accordingly. Every command itself is implemented in its own file inside the commands subdirectory.

This sample image only defines a **e2etests** command defined inside the **commands/e2etests.sh** file. If you take a
look into both the rather simple shell scripts, you will notice, that they include some textfiles to provide their help
texts.

* **cli-desc.txt:** This defines the main description shown in the help text if you call the cli without params
* **e2etests-env.txt:** Describes mandatory and optional environment variables needed to be defined to run the tests
* **e2etests-tags.txt:** Lists the tags that can be used to narrow down the E2E tests to be run
* **e2etests-volumes.txt:** Describes some paths of interest, a user of the E2E test container might want to mount

## The Gauge setup inside /tests

The in-container /tests path should be overridden to suite your needs. You could do that on the fly by mounting to
/tests or, for the purpose of releasing tests, building a new container with the /tests dir replaced. Gauge in the
current version uses this folders

* **/tests:** The base repository of the Gauge tests. Should at least contain a Gauge manifest.json
* **/tests/specs:** The Gauge specifications to run are found in
* **/tests/env:** Gauge environment setup is done here with properties files.
* **/tests/libs:** Any additional libraries to run the tests should be available here
* **/tests/assets:** Any additional assets, e.g. certificates, security vaults, media should be found here
* **/tests/reports:** The gauge tests generate a nice HTML report the ends up here
* **/tests/logs:** Logs created by gauge are available in

## The Dockerfile

The Dockerfile describes how the base image is build. It basically install Gauge, some utilities and a Firefox browser
to be able to run browser based web GUI tests. Unfortunately being used on CI system, we won't usually have an X-Server
available to make good use of the Gauge screenshot feature for failing tests. Therefore, we apply some trickery
installing the Xvfb virtual framebuffer instead of a full blown X-Server.

Beware, the framebuffer needs to be running before starting a headless browser. We adjust the entrypoint.sh to start the
Xvfb for us and bind it to :0, before executing the command handed over on `docker run [options] <command>`. Except for 
the XVfb workaround, the Docker build itself is business as usual.

## Building your own releasable test container

As stated, the base image is intended to be overridden by developers to provide product specific test containers. But
how do you do it? Well basically you should adjust the **cli/\*.txt** files to your needs to make clear, what your
container tests, what env variables to configure and and what volumes one might want to mount. Second you will want to
replace the **tests** folder with your own specific Gauge test setup. The e2e-test-sample-webgui is a full-fledged
sample showcasing the relevant steps and an integration into a Maven build process.

## Links

* [Build a Custom CLI with Bash](https://medium.com/@brotandgames/build-a-custom-cli-with-bash-e3ce60cfb9a4)
* [Gauge testing framework](https://gauge.org/)
* [Gauge java language bindings](https://github.com/getgauge/gauge-java)
* [DenktMit eG tech blog](https://denktmit.de/outreach.html)