#!/usr/bin/env bash
mvn clean install -DskipTests
docker build -t e2e-test-sample-webgui .