FROM e2e-test-base-image:latest
ENV SEARCH_TERM=denktmit.de EXPECTED_RESULT_CONTAINS="YOU MUST OVERRIDE ME"
RUN rm -rf /tests/
COPY target/e2etests/ /tests/
COPY cli/cli-desc.txt /cli/cli-desc.txt
COPY cli/commands/e2etests-env.txt /cli/commands/e2etests-env.txt
COPY cli/commands/e2etests-tags.txt /cli/commands/e2etests-tags.txt
