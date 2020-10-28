# Maven Documentation

- [Maven Documentation](#maven-documentation)
  - [User Centre](#user-centre)
    - [Maven in 5 Minutes](#maven-in-5-minutes)
    - [Maven Getting Started Guide](#maven-getting-started-guide)
      - [Introduction to the Dependency Mechanism](#introduction-to-the-dependency-mechanism)
    - [Maven Mini Guides](#maven-mini-guides)
      - [Using Modules](#using-modules)
        - [The Reactor](#the-reactor)
          - [Reactor Sorting](#reactor-sorting)

## [User Centre](https://maven.apache.org/users/index.html)

### [Maven in 5 Minutes](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html)

### [Maven Getting Started Guide](https://maven.apache.org/guides/getting-started/index.html)

#### [Introduction to the Dependency Mechanism](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html)

### [Maven Mini Guides](https://maven.apache.org/guides/mini/index.html)

#### [Using Modules](https://maven.apache.org/guides/mini/guide-multiple-modules.html)

Maven supports project aggregation in addition to project inheritance

##### The Reactor

The mechanism in Maven that handles multi-module projects is referred to as the reactor. This part of the Maven core does the following:

- Collects all the available modules to build

- Sorts the projects into the correct build order

- Builds the selected projects in order

###### Reactor Sorting

The following relationships are honoured when sorting projects:

- a project dependency on another module in the build

- a plugin declaration where the plugin is another module in the build

- a plugin dependency on another module in the build

- a build extension declaration on another module in the build

- the order declared in the `<modules>` element (if no other rule applies)

Note that only "instantiated" references are used - `dependencyManagement` and `pluginManagement` elements do not cause a change to the reactor sort order
