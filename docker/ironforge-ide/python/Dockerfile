ARG NODE_VERSION=12.18.3

FROM node:${NODE_VERSION}
ARG version=1.7.0
WORKDIR /home/ironforge
ADD $version.package.json ./package.json
ARG GITHUB_TOKEN
RUN yarn --pure-lockfile && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn theia download:plugins && \
    yarn --production && \
    yarn autoclean --init && \
    echo *.ts >> .yarnclean && \
    echo *.ts.map >> .yarnclean && \
    echo *.spec.* >> .yarnclean && \
    yarn autoclean --force && \
    yarn cache clean

FROM node:${NODE_VERSION}

# Install Python 3 from source
ARG VERSION=3.8.3

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y make build-essential libssl-dev \
    && apt-get install -y libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    && apt-get install -y libncurses5-dev  libncursesw5-dev xz-utils tk-dev \
    && wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz \
    && tar xvf Python-$VERSION.tgz \
    && cd Python-$VERSION \
    && ./configure \
    && make -j8 \
    && make install \
    && cd .. \
    && rm -rf Python-$VERSION \
    && rm Python-$VERSION.tgz

RUN apt-get update \
    && apt-get install -y python-dev python-pip \
    && pip install --upgrade pip --user \
    && apt-get install -y python3-dev python3-pip \
    && pip3 install --upgrade pip --user \
    && pip3 install python-language-server flake8 autopep8 \
    && apt-get install -y yarn \
    && apt-get clean \
    && apt-get auto-remove -y \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN mkdir -p /home/ironforge \
    && mkdir -p /home/project \
    && groupadd ironforge -g 1001 \
    && useradd ironforge -u 1001 -g 1001 -s /bin/bash \
    && chown ironforge:ironforge -R /home/project /home/ironforge \
    && update-alternatives --install /usr/local/bin/python python /usr/local/bin/python3 10 \
    && update-alternatives --install /usr/local/bin/pip pip /usr/local/bin/pip3 10


ENV HOME /home/ironforge
WORKDIR /home/ironforge
COPY --from=0 /home/ironforge /home/ironforge
EXPOSE 3000
ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/home/ironforge/plugins
ENV USE_LOCAL_GIT true

USER ironforge 

ENTRYPOINT [ "node", "/home/ironforge/src-gen/backend/main.js", "/home/project", "--hostname=0.0.0.0" ]