**Docker-tomcat-NewRelic-Java**

![New Relic & Docker](https://cms-assets.tutsplus.com/uploads/users/343/posts/24891/preview_image/docker_newrelic3.png)

Use this repository to get New Relic Java Agent integrated with a container built with [google jib](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin).

NOTE: This is a simple tutorial that entails a Dockerfile and a docker run command to bake New Relic Java Agent into the latest Tomcat (8.0) container.

You will require the following two things to get started:
1. You will need an official license from New Relic SaaS UI: rpm.newrelic.com/accounts/xxxxxx (If you don't have a New Relic Account, sign up for a trial on [New Relic Sign Up Page!](https://newrelic.com/signup) 
2. Use the official Tomcat docker image - [Docker Hub tomcat!](https://hub.docker.com/_/tomcat/)

Once you have the above two sorted, you can proceed with the following:

**STEP 1**. Install Docker on your host - I used the free SMP Debian 4.9.130-2 (2018-10-27) x86_64 GNU/Linux for testing purposes

**STEP 2**. Once Docker is up and running, use the Dockerfile attached in this Github Repo to create a local tomcat image that entails New Relic Java Agent. You may build the container with this command - docker build -t distroless-newrelic

**STEP 3**. Once the container image is ready, you can add it to your maven build process with the jib plugin:

```xml
<plugin>
    <groupId>com.google.cloud.tools</groupId>
    <artifactId>jib-maven-plugin</artifactId>
    <version>0.10.0</version>
    <configuration>
        <to>
            <image>${project.artifactId}</image>
        </to>
        <from>
            <image>distroless-newrelic</image>
        </from>
        <container>
            <jvmFlags>
                <jvmFlag>-Dnewrelic.config.license_key=<!--unique_newrelic_license_key--></jvmFlag>
                <jvmFlag>-Dnewrelic.config.distributed_tracing.enabled=<!--true/false--></jvmFlag>
                <jvmFlag>-Dnewrelic.config.file=/newrelic/newrelic.yml</jvmFlag>
                <jvmFlag>-Dnewrelic.config.app_name=${project.artifactId}</jvmFlag>
                <jvmFlag>-javaagent:/newrelic/newrelic.jar</jvmFlag>
            </jvmFlags>
            <useCurrentTimestamp>true</useCurrentTimestamp>
        </container>
    </configuration>
    <executions>
        <execution>
            <phase>verify</phase>
            <goals>
                <goal>build</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

