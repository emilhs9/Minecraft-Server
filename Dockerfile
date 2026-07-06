FROM eclipse-temurin:21-jre-jammy

LABEL maintainer="Ad Dream Server"
LABEL description="Ad Dream Minecraft Server - Purpur 1.21.4"

ENV TZ=Asia/Baku
ENV MEMORY=6G
ENV JAVA_FLAGS=""

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /server

COPY purpur.jar /server/purpur.jar
COPY server.properties /server/server.properties
COPY config/ /server/config/
COPY plugins/ /server/plugins/
COPY purpur.yml /server/purpur.yml
COPY log4j2.xml /server/log4j2.xml

RUN mkdir -p world world_nether world_the_end save logs

EXPOSE 25565

VOLUME ["/server"]

ENTRYPOINT ["sh", "-c", "\
  java \
  -Xms${MEMORY} \
  -Xmx${MEMORY} \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+DisableExplicitGC \
  -XX:+AlwaysPreTouch \
  -XX:G1NewSizePercent=30 \
  -XX:G1MaxNewSizePercent=40 \
  -XX:G1HeapRegionSize=8M \
  -XX:G1ReservePercent=20 \
  -XX:G1HeapWastePercent=5 \
  -XX:G1MixedGCCountTarget=4 \
  -XX:InitiatingHeapOccupancyPercent=15 \
  -XX:G1MixedGCLiveThresholdPercent=90 \
  -XX:G1RSetUpdatingPauseTimePercent=5 \
  -XX:SurvivorRatio=32 \
  -XX:+PerfDisableSharedMem \
  -XX:MaxTenuringThreshold=1 \
  -Dusing.aikars.flags=https://mcflags.emc.gs \
  -Daikars.new.flags=true \
  -Dlog4j.configurationFile=log4j2.xml \
  --add-modules=jdk.incubator.vector \
  -jar purpur.jar \
  --nogui \
  ${JAVA_FLAGS}"]
