# ============================================
# 第一阶段：Maven 构建
# ============================================
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests -q

# ============================================
# 第二阶段：运行时镜像
# ============================================
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /app/target/library-management-1.0.0.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]