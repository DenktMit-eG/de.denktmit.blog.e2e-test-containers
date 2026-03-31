FROM eclipse-temurin:25-jdk-noble AS build
RUN apt-get update && apt-get install -y --no-install-recommends maven && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:resolve --fail-never -q
COPY src src
COPY specs specs
COPY env env
COPY manifest.json .
RUN mvn clean package -DskipTests -q

FROM e2e-test-base-image:0.0.2
ENV SEARCH_TERM=denktmit.de EXPECTED_RESULT_CONTAINS="YOU MUST OVERRIDE ME"
RUN rm -rf /tests/*
COPY --chown=e2euser:e2euser --from=build /build/target/e2etests/ /tests/
COPY --chown=e2euser:e2euser cli/cli-desc.txt /cli/cli-desc.txt
COPY --chown=e2euser:e2euser cli/commands/e2etests-env.txt /cli/commands/e2etests-env.txt
COPY --chown=e2euser:e2euser cli/commands/e2etests-tags.txt /cli/commands/e2etests-tags.txt
