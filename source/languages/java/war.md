---
title: Correctly deploy your .war archive
category: languages
date: 25/02/2015
tags: programming, dev, war, java, language
---

# Correctly deploy your .war archive

If the result of your maven build result in a `.war` file, a little additional
work is required.

## Add the webapp-runner as dependency

To correcly execute your war file, we need you to add the
[webapp-runner](https://github.com/jsimone/webapp-runner) dependency to your
`pom.xml` file. This dependency let us start your application by starting
Tomcat in a simple command.

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
                <version>7.0.57.2</version>
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

## Define your Procfile

To tell use how to start your application, you need to create a `Procfile` file
at the root of your project: [more doc about Procfiles](/internals/procfile)

```
web: java $JAVA_OPTS -jar target/dependency/webapp-runner.jar --port $PORT target/*.war
```

That's it, just commit your `pom.xml` and your `Procfile` and your app will
deploy in the blink of an eye.
