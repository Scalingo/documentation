---
title: Deploy your Spring Boot application
modified_at: 2023-02-14 00:00:00
tags: war java spring spring-boot
---

{% note %}
  Takes an opinionated view of building production-ready Spring applications.
  Spring Boot favors convention over configuration and is designed to get you up and running as quickly as possible.
  <br/>
  [Sprint Boot official website](https://spring.io/projects/spring-boot)
{% endnote %}

Scalingo supports Spring Boot as well as any other Java framework deployable
with Maven. The only condition is to configure your application to listen on
the `PORT` environment variable.

The application can be deployed as a .jar file or a standalone .war file. This
page describes how to achieve both.

## WAR or JAR

Your Spring Boot application can be packaged as a `jar` or as a `war` ([see the Spring documentation here](https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.traditional-deployment)).

The way you choose to package your application changes the way you deploy on
Scalingo.

### Listen on ${PORT}

For both WAR and JAR deployments, you need to specify the good port to listen to in your Spring Boot application [configuration file](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config).

```text
server:
    port: ${PORT}
```

## As a JAR

Deploying a JAR file does not require any extra stuff to work with Scalingo.

### Define your Procfile

One still need to describe in a `Procfile` how the application should be started. Add a [`Procfile`]({% post_url platform/app/2000-01-01-procfile %}) file at the root of your project:

To define how to start your application, you need to create a `Procfile` file
at the root of your project. [More documentation about Procfile]({% post_url
platform/app/2000-01-01-procfile %}).

```yaml
web: java $JAVA_OPTS -jar target/*.jar --spring.profiles.active=YOUR_PROD_PROFILE
```

_Don't forget to specify the production profile (if you use [Spring
profiles](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.profiles))
as a parameter._

Commit your `Procfile` and push your modifications to deploy your application.

## As a WAR

This one is more complicated as we need to:

- replace the classic `web.xml` file
- modify the maven or Gradle build file
- slightly change the `Procfile` that works with standard `war` files

### web.xml

To replace the classic `web.xml` file, you have to create a new class that
sources the Spring Boot application.

```java
public class ApplicationWebXml extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }

}
```

### pom.xml (or build.gradle)

1. Avoid conflicts between Tomcat

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-tomcat</artifactId>
    <!-- Add this -->
    <scope>provided</scope>
</dependency>
```

2. Add webapp-runner **8.0.24.0** (Spring Boot needs Tomcat 8.x for websockets)

```xml
<build>
  ...
  <plugins>
    ...
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-dependency-plugin</artifactId>
      <version>2.3</version>
      <executions>
        <execution>
          <phase>package</phase>
          <goals><goal>copy</goal></goals>
          <configuration>
            <artifactItems>
              <artifactItem>
                <groupId>com.github.jsimone</groupId>
                <artifactId>webapp-runner</artifactId>
                <version>8.0.24.0</version>
                <destFileName>webapp-runner.jar</destFileName>
              </artifactItem>
            </artifactItems>
          </configuration>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

### Define your Procfile

To define how to start your application, you need to create a `Procfile` file
at the root of your project. [More documentation about Procfile]({% post_url
platform/app/2000-01-01-procfile %}).

```yaml
web: java $JAVA_OPTS -Dspring.profiles.active=YOUR_PROD_PROFILE -jar target/dependency/webapp-runner.jar --port $PORT --expand-war target/*.war
```

_Don't forget to specify the production profile (if you use [Spring
profiles](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.profiles))
as a parameter._

Commit your `pom.xml` and your `Procfile`, and push the modifications to deploy your application.
