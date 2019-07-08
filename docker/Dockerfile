FROM openjdk:8

# Install basic requirements
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -yqq && \
    apt-get install -yyq apt-transport-https \
    build-essential \
    cloc \
    cmake \
    curl \
    grep \
    perl \
    procps \
    sed \
    sudo \
    sysstat \
    tree

# Install R
RUN echo "deb http://cloud.r-project.org/bin/linux/debian stretch-cran35/" > /etc/apt/sources.list.d/r.list && \
    apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update -yqq && \
    apt-get install -yqq \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    pandoc \
    r-base \
    r-base-dev \
    zlib1g-dev

# Install R packages
RUN Rscript -e 'install.packages(c("tidyverse", "feather", "fs", "httr", "pbapply", "lubridate", "DT", "ggplot2", "ggthemes", "knitr", "devtools"), Ncpus=parallel::detectCores(), repos="https://cloud.r-project.org")'

# Install SBT
RUN echo "deb https://dl.bintray.com/sbt/debian /" > /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update -yqq && \
    apt-get install -yqq \
    sbt

# Install ammonite
RUN curl -L https://github.com/lihaoyi/Ammonite/releases/download/1.6.9/2.12-1.6.9 > /usr/local/bin/amm && \
    chmod +x /usr/local/bin/amm

# Install newer GNU parallel
RUN mkdir /tmp/parallel && \
    curl -L https://ftp.gnu.org/gnu/parallel/parallel-20190422.tar.bz2 | tar -xj -C /tmp/parallel --strip 1 && \
    cd /tmp/parallel && \
    ./configure && \
    make && \
    make install 

# User managements
# I use 1100 so it is different from my own uid and gid for testing
ENV USER=scala USER_ID=1100 USER_GID=1100
RUN groupadd --gid "${USER_GID}" "${USER}" && \
    useradd \
      --uid ${USER_ID} \
      --gid ${USER_GID} \
      --groups sudo \
      --create-home \
      --shell /bin/bash \
      ${USER} && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /home/scala

ADD entrypoint.sh /entrypoint.sh

RUN chmod 700 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
