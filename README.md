OOPSLA19 Artifact - Scala Implicits are Everywhere
================

## Artifact Description

This is the artifact for the paper *Scala Implicits are Everywhere* at
OOPSLA 2019. The aim is to:

1.  show extracting implicit declarations and call sites from Scala
    code,
2.  demonstrate running the analysis pipeline, and
3.  make available the large corpus of Scala projects used for the
    paper.

The artifact is composed of 3 two parts. First part uses an example
Scala project to show an implicit extraction and an overview of the
underlying model. Second part demonstrates the analysis on a set of 50
randomly selected Scala projects. Finally, the third part will look at
the results of the analysis pipeline on the corpus used for paper.

## Requirements

The pipeline depends on a number of tools. The full requirements are
listed in the documentation of the [analysis pipeline
itself](https://github.com/PRL-PRG/scala-implicits-analysis/tree/oopsla19#requirementsalysis/).
To make it more convenient we have build a docker image that has all
these dependencies installed. The image is available on [Docker
HUB](https://hub.docker.com/r/prlprg/oopsla19-scala). This image can be
either pulled directly from the Hub or
<a href="#building-image-locally">build locally</a>. To run the image,
you will need [docker community
edition](https://docs.docker.com/install/) version 18+ and bash.

The docker image only includes the dependencies needed to build the
pipeline. This allows one to start from scratch without the need of
installing any tools. However, building the pipeline and compiling the
Scala projects that are part of the corpora included in this artifact
requires a large number of external dependencies. We have packaged these
in an tarball so one can start with a hot cache. Similarly, building
Scala projects is a resource intensive project. We could use only small
projects, but they will not be very representative of the real world.
Instead we have also packaged the built corpus which can be used to
speed up the evaluation (in the end, the intention is not to test SBT or
Scala compiler). However, it is perfectly fine to start from scratch
skipping the optional steps bellow. One only need a bit more patience.

This artifact requires about \~13GB of free space.

## Getting Started Guide

The following steps are intended for the *kick-the-tires phase* to
ensure that all the components work. If you run into some problems,
please check the <a href="#troubleshooting">troubleshooting</a> section
we have added at the end. This guide was tested on Linux and OSX.

1.  Clone the artifact
    
    ``` sh
    git clone https://github.com/fikovnik/OOPSLA19-artifact
    ```
    
    Unless stated otherwise, all the subsequent commands should be run
    *inside the artifact’s directory*:
    
    ``` sh
    cd OOPSLA19-artifact
    ```

2.  Clone the analysis pipeline:
    
    It is a separate open source project hosted on GitHub.
    
    ``` sh
    git clone --single-branch --branch oopsla19 https://github.com/PRL-PRG/scala-implicits-analysis
    ```
    
    It is *important* that you use =oopsla19= branch:
    
    ``` sh
    git --git-dir=scala-implicits-analysis/.git branch
    * oopsla19
    ```
    
    After cloning, the artifacts directory should look like:
    
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
        │   └── ...
        ├── README.Rmd               -- these instructions
        └── run.sh                   -- this guide

3.  Download the cache files (*optional*)
    
    This includes cache for SBT, [Ivy](ant.apache.org/ivy) (the
    dependency manager used by SBT) and
    [coursier](https://github.com/coursier/coursier) (alternative
    artifact fetcher used by some Scala projects). Even with this cache,
    SBT might still decide to download some dependencies, but populating
    the cache will speed things up. The download size is 2.6GB.
    
    ``` sh
    curl -O cache.tar.xz https://owncloud.cesnet.cz/index.php/s/hUbBGxG2cgih4h9/download
    ```
    
    The MD5SUM is `sh md5sum cache.tar.xz`.
    
    ``` sh
    tar xfvJ cache.tar.xz
    ```
    
    After downloading and extracting it should look like:
    
        ├── cache
        │   ├── coursier            -- coursier cache
        │   ├── ivy                 -- ivy cache
        │   └── sbt                 -- sbt cache
        ├── corpora
        │   └── ...
        ├── docker
        │   └── ...
        ├── scala-implicits-analysis
        │   └── ...
        └── ...

4.  Download the built corpora (*optional*)
    
    This includes cloned Scala projects that are part of the corpora
    (one project for the `2-single` and 50 projects for the
    `3-sample-set` corpora). The projects are already built. Please not
    that the rest of the pipeline still needs to be run, it is only the
    project building that will be skipped. The download size is 500MB.

<!-- end list -->

``` sh
   curl -O corpora.tar.xz https://owncloud.cesnet.cz/index.php/s/tI7FIxneRjSjSMW/download
```

The MD5SUM is `sh md5sum corpora.tar.xz`.

``` sh
tar xfvJ corpora.tar.xz
```

After downloading and extracting it should look like:

    ├── cache
    │   └── ...
    ├── corpora
    │   ├── 1-example
    │   │   └── ...
    │   ├── 2-single
    │   │   ├── all-projects   -- includes the built projects
    │   │   └── ...
    │   ├── 3-sample-set
    │   │   ├── all-projects   -- includes the built projects
    │   │   └── ...
    │   └── 4-github
    │       └── ...
    ├── docker
    │   └── ...
    ├── scala-implicits-analysis
    │   └── ...
    └── ...

1.  Make sure you have a docker installed and running
    
    ``` sh
    docker run --rm hello-world
    ```

2.  Pull the docker image (or <a href="#building-image-locally">build
    one locally</a>)
    
    ``` sh
    docker pull prlprg/oopsla19-scala
    ```

3.  Check that the image can be run
    
    The image needs a number of directories and environment variables
    set which would make it cumbersome to provide each time. There is a
    bash script `run.sh` that encapsulates all the necessary settings.
    Please use this script to run the image.
    
    ``` sh
    ./run.sh id
    uid=1000(scala) gid=1000(scala) groups=1000(scala),27(sudo)
    ```
    
    The `uid` and `gid` returned should be the same as are on your host
    system. You can double check that by running `id -u` and `id -g`.
    This is important because while the commands will run in the docker
    image, they will modify the files in this directory. If the `uid` or
    `gid` are different it will be inconvenient for you to view the
    results and remove them at the end.
    
    You might see a warning like:
    
        groupmod: GID '20' already exists
    
    This can be ignored (most likely you are on OSX which assigns lower
    GID to the user group).

4.  Build the pipeline
    
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
    ./run.sh make -C scala-implicits-analysis
    ```

5.  Run the pipeline on a single project corpus
    
    We will run the pipeline on a corpus that contains only one, yet
    real Scala project. The corpus is located in `corpora/2-single`
    directory.
    
    ``` sh
    ./run.sh make -C corpora/2-single
    ```

6.  Check the results
    
    After the make is done, there should be three HTML files in the
    corpus directory:
    
    ``` sh
    ls -1 corpora/2-single/*.html
    implicits-analysis.html
    stage1-analysis.html
    stage3-analysis.html
    ```
    
    The `stage*-analysis.html` describes the state of the corpus while
    the `implicits-analysis.html` summarizes the extracted implicits.
    The details of what to expect in each of these files follow in the
    part 2 of this artifact. Please mind that the reports were prepared
    for large corpus and thus with only a one project some of the tables
    will be either empty or useless. The same applies to the plots which
    might not be scaled properly.

This concludes the getting started guide.

## Part 1

## Part 2

### A note about concurrency

## Part 3

The corpus of all the GitHub Scala projects is available on server at:

    http://prl1.ele.fit.cvut.cz:8149/github

If you are concerned about privacy you can access it via a VPN service
or TOR although we do not keep any access logs.

The reason why do not create an archive of it is its size:

1.  The cache similar to what we have used in this artifact has 110GB:
      - 29GB `cache/coursier`
      - 79GB `cache/ivy`
      - 2GB `cache/sbt/sbt-boot`
2.  The corpus itself has 1.1TB.

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

### Out of memory exception

Compiling Scala projects can be rather expensive. TODO:

TODO: note on parallelism corpora/3-sample-set/jobsfile.txt
