# ============================================================
# discovery-service — Netflix Eureka Server
# Java 17 | Spring Boot 3.5.6
# ============================================================

# ---------- Stage 1 : Build ----------
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline -q

COPY src ./src
RUN mvn package -DskipTests -q

# ---------- Stage 2 : Runtime ----------
FROM eclipse-temurin:17-jre-alpine AS runtime
WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /build/target/discovery-service-*.jar app.jar

RUN chown appuser:appgroup app.jar
USER appuser

EXPOSE 8762
ENTRYPOINT ["java", "-jar", "app.jar"]
