---
title: Deploy your Spring Boot application
modified_at: 2015-08-26 00:00:00
categories: languages java
tags: war java spring spring-boot
---

> Takes an opinionated view of building production-ready Spring applications.
> Spring Boot favors convention over configuration and is designed to get you up
> and running as quickly as possible.

> [Sprint Boot official website](http://projects.spring.io/spring-boot/)

Scalingo supports Spring Boot as well as any other Java framework deployable with
Maven. The only condition is to configure your application to listen on the
`PORT` environment variable.

The application can be deployed as a .jar file or a standalone .war file. This
page describes how to achive both.

## WAR or JAR

Your Spring Boot application can be packaged as a `jar` or as a `war` ([see the
Spring documentation
here](http://docs.spring.io/spring-boot/docs/current/reference/html/howto-traditional-deployment.html)).

The way you choose to package your application change the way you deploy on
Scalingo.

## As a JAR

This way doesn't need extra stuff to work with Scalingo. You just have to
create a `Procfile` file at the root of your project: [more doc about
Procfiles]({% post_url internals/2014-12-01-procfile %})

```yaml
web: java $JAVA_OPTS -jar target/*.jar --spring.profiles.active=YOUR_PROD_PROFILE
```

_Don't forget to specify the production profile (if you use [Spring
profiles](http://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-profiles.html))
as a parameter._

That's it, just commit your `Procfile` and your app will deploy in the blink of
an eye.

## As a WAR

This one is more complicated as we need to:

- replace the classic `web.xml` file
- modify the maven or gradle build file
- slightly change the `Procfile` that works with standard `war` files

### web.xml

To replace the classic `web.xml` file, you have to create new class that
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

### Listen on ${PORT}

Specify the good port to listen in your Spring Boot application [configuration
file](http://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html).

```text
server:
    port: ${PORT}
```

### Define your Procfile

To define how to start your application, you need to create a `Procfile` file
at the root of your project: [more doc about Procfiles]({% post_url internals/2014-12-01-procfile %})

```yaml
web: java $JAVA_OPTS -Dspring.profiles.active=YOUR_PROD_PROFILE -jar target/dependency/webapp-runner.jar --port $PORT --expand-war target/*.war
```

_Don't forget to specify the production profile (if you use [Spring
profiles](http://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-profiles.html))
as a parameter._

That's it, just commit your `pom.xml` and your `Procfile` and your app will
deploy in the blink of an eye.
