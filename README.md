OOPSLA19 Artifact - Scala Implicits are Everywhere
================

## Artifact Description

This is the artifact for the paper *Scala Implicits are Everywhere* at
OOPSLA 2019. The aim is to:

1.  show extracting implicit declarations and call sites they are
    involved in from Scala code,
2.  demonstrate running the analysis pipeline, and
3.  make available the large corpus of Scala projects used for the
    paper.

The artifact is composed of 2 two parts. First will use a sample Scala
project to show implicit extract and overview the data model behind.
Then we will show how to extend the analysis for a number of projects.

## Requirements

The pipeline depends on a number of tools. The full requirements are
listed in the documentation of the [analysis pipeline
itself](https://github.com/PRL-PRG/scala-implicits-analysis/tree/oopsla19#requirementsalysis/).
To make it more convenient we have build a docker image that has all
these dependencies installed. The image is available on [Docker
HUB](https://hub.docker.com/r/prlprg/oopsla19-scala). This image can be
either pulled directly from the Hub or
<a href="#building-image-locally">build image locally</a>. To run the
image, you will need [docker community
edition](https://docs.docker.com/install/) version 18+ and bash.

## Getting Started Guide

The following steps are intended for the *kick-the-tires phase* to
ensure that all the components work. If you run into some problems,
please check the <a href="#troubleshooting">troubleshooting</a> section
we have added at the end. This guide was tried on Linux and OSX.

1.  Clone the artifact
    
    ``` sh
    git clone https://github.com/fikovnik/OOPSLA19-artifact
    ```
    
    Unless stated otherwise, all the subsequent commands should be run
    *inside the artifact’s directory*:
    
    ``` sh
    cd OOPSLA19-artifact
    ```
    
    We will refer to it as `$DIR`: Just to make sure the commands are
    executed from the right place.

2.  Clone the analysis pipeline:
    
    ``` sh
    git clone --single-branch --branch oopsla19 https://github.com/PRL-PRG/scala-implicits-analysis
    ```
    
    It is *important* that you use =oopsla19= branch. After clonning,
    the artifacts directory should look like:
    
        ├── corpora
        │   ├── 1-example            -- an example project to demonstrate implciti extraction
        │   ├── 2-single             -- a single real-world Scala project to check the pipeline
        │   ├── 3-sample-set         -- a sample set of random Scala projects
        │   └── 4-github             -- placeholder for the entire analyzed repository (not downloaded yet)
        ├── docker                   -- the source code for building the docker image
        │   ├── Dockerfile
        │   ├── entrypoint.sh
        │   └── Makefile
        ├── scala-implicits-analysis -- the analysis pipeline (clonned in the last step)
        ├── README.Rmd               -- these instructions
        └── run.sh                   -- this guide

3.  Make sure you have a docker installed and running
    
    ``` sh
    docker run --rm hello-world
    ```

4.  Pull the docker image (or <a href="#building-image-locally">build
    one locally</a>)
    
    ``` sh
    docker pull prlprg/oopsla19-scala
    ```

5.  Check that the image can be run
    
    The image needs a number of directories and environment variables
    set which would make it cumbersome to provide each time. There is a
    bash script `run.sh` that encapsulates all the necessary settings.
    Please use this script to run the image.
    
    ``` sh
    ./run.sh id
    uid=1000(scala) gid=1000(scala) groups=1000(scala),27(sudo)
    ```
    
    The `uid` and `gid` returned should be the same as are on your host
    system. This is important because while the commands will run in the
    docker image, they will modify the files in this directory. If the
    `uid` or `gid` are different it will be inconvenient for you to view
    the results and remove them at the end.

6.  Setup a run alias (*optional*)
    
    There are two ways how to run the tools installed in the image:
    
      - run `./run.sh bash` and then run all the consecutive commands
        inside this session
      - run each command from your own shell by prepending the command
        with the `./run.sh` script
    
    For the second way, it is convenient to setup a shell alias:
    
    ``` sh
    alias run=$(pwd)/run.sh
    ```

7.  Build the pipeline
    
    The pipeline consists of the following tools:
    
      - sbt-plugins - a SBT plugin adding `metadata` and `semanticdb`
        commands for metadata extraction and semanticdb generation.
      - libs - the model of implicits, the implicit extractor and a
        number of tools that export the results into CSV files.
      - scripts/analysis - R notebooks containing data analysis
      - scripts/tools - a modified version of
        [Dejavu](https://github.com/PRL-PRG/dejavu-artifact) allowing to
        index Scala files.
    
    To build these tools, run the following:
    
    ``` sh
    ./run.sh -C scala-implicits-analysis
    ```

8.  Run the pipeline on a single project corpus
    
    We will try out the pipeline on the a Scala corpus that contains
    only one, yet real project. The corpus is located in
    `corpora/2-single` directory.
    
    ``` sh
    ./run.sh make -C corpora/2-single
    ```

9.  Check the results
    
    After the make is done, the should be three HTML files in the corpus
    directory:
    
    ``` sh
    ls -1 corpora/2-single
    implicits-analysis.html
    stage1-analysis.html
    stage3-analysis.html
    ```
    
    The `stage*-analysis.html` describes the state of the corpus while
    the `implicits-analysis.html` summarizes the extracted implicits.
    The details of what to expect in each of these files follow in the
    part 2 of this artifact.

## Building image locally

<a name="#building-image-locally"/>

To build image locally you can either use make by running:

``` sh
make -C docker
```

or by directly run `docker build`:

``` sh
docker build -t prlprg/oopsla19-scala docker
```

## Toubleshooting

<a name="troubleshooting"/>

### Docker on OSX

It is better to use homebrew cask to install docker:

``` sh
brew cask install docker
```

in case you see `docker: Cannot connect to the Docker daemon at
unix:///var/run/docker.sock. Is the docker daemon running?.` error
message cf: <https://stackoverflow.com/a/44719239>

### Docker on Linux

In some distribution the package does not add the current user to
`docker` group. In this case, either add yourself to `docker` group or
run the `./run*` commands with `sudo`.

### Error: `gpg: keyserver receive failed: Cannot assign requested address= when building image` while building the docker image

The keyserver that is used to add debian APT repositories for newer
version of R and SBT sometimes does not work. What has worked all the
time was simply repeating the image build process by rerunning the make.

### Error: A compilation error `Caused by: scala.reflect.internal.MissingRequirementError: object scala in compiler mirror not found.`

Rebuild
[BuildInfo](scala-implicits-analysis/libs/tools/target/scala-2.12/src_managed/main/sbt-buildinfo/BuildInfo.scala)
file by deleting the file and running `./run.sh make -C
scala-implicits-analysis/libs`.
