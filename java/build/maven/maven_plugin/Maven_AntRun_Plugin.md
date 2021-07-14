# [Maven AntRun Plugin](https://maven.apache.org/plugins/maven-antrun-plugin/)

- [Maven AntRun Plugin](#maven-antrun-plugin)
  - [update jar](#update-jar)

## update jar

    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-antrun-plugin</artifactId>
        <version>1.6</version>
        <executions>
            <execution>
                <id>repack</id>
                <phase>package</phase>
                <goals>
                    <goal>run</goal>
                </goals>
                <configuration>
                    <target>
                        <jar destfile="${project.build.outputDirectory}/../${project.name}-${project.version}-jar-with-dependencies.jar" update="true">
                            <zipfileset dir="${project.build.outputDirectory}/<directory-contain-the-file-to-update>" includes="<file-to-update>" prefix="<relative-directory-in-jar-to-contain-the-file-to-update>"/>
                        </jar>
                    </target>
                </configuration>
            </execution>
        </executions>
    </plugin>
