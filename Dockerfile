FROM openjdk:8-alpine as pdfbox
RUN apk add maven git
RUN git clone --depth 1 --recursive https://github.com/dariusf/PDFInverter.git && \
  cd PDFInverter && \
  cd pdfbox && mvn clean install && cd ..

# Building pdfbox can take a while and we want it to be cached, so fetch the repository again
# in case there were changes.
# Cache invalidation: this: https://github.com/moby/moby/issues/1996

FROM openjdk:8-alpine
COPY --from=pdfbox /root/.m2 /root/.m2
RUN apk add git && git clone --depth 1 --recursive https://github.com/dariusf/PDFInverter.git
RUN cd PDFInverter && chmod +x gradlew && ./gradlew buildAndMaybeRelease

ENTRYPOINT ["java", "-jar", "/PDFInverter/build/libs/PDFInverter.jar"]
