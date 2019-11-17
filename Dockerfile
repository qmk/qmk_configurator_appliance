FROM qmkfm/base_container
MAINTAINER Zach White <skullydazed@gmail.com>
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
EXPOSE 80/tcp

# Install and setup dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    clang \
    curl \
    gnupg \
    nginx \
    redis-server \
    redis-tools \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Clone the git repositories
RUN git clone https://github.com/skullydazed/kle2xy.git
RUN git clone https://github.com/qmk/qmk_api.git
RUN git clone -b local_storage https://github.com/qmk/qmk_compiler.git
RUN git clone https://github.com/qmk/qmk_configurator.git

# Install the requirements
RUN pip3 install -r qmk_api/requirements.txt && \
    pip3 install -e qmk_compiler

# Create directory for redis
RUN mkdir /compiled_firmware /redis_data

# Build configurator
COPY yarn.list /etc/apt/sources.list.d/yarn.list
COPY build_configurator.sh /
RUN bash -i /build_configurator.sh

# Copy config files into place
COPY configurator.env /qmk_configurator/.env
COPY nginx.conf /etc/nginx/nginx.conf
COPY redis.conf /etc/redis.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
