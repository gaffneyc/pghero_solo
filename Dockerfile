FROM ruby:2-alpine
MAINTAINER Brian Morton "bmorton@yammer-inc.com"

# Install dependencies for gems
RUN apk add --update --no-cache \
  tzdata \
  gcc \
  make \
  libc-dev \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev

# Add and install gem dependencies
ADD Gemfile       /app/Gemfile
ADD Gemfile.lock  /app/Gemfile.lock
RUN sh -l -c "cd /app && bundle install -j4"

# Remove build packages
RUN apk del gcc make

ADD . /app

WORKDIR /app
EXPOSE 8080

CMD bundle exec puma -t ${PUMA_MIN_THREADS:-8}:${PUMA_MAX_THREADS:-12} -w ${PUMA_WORKERS:-1} -p 8080 -e ${RACK_ENV:-production} --preload
