FROM ruby:2.6.0-alpine3.8

# Install dependencies and perform clean-up
RUN apk update -q \
 && apk add nodejs yarn build-base git wget gcc postgresql-dev \
 && rm -rf /var/lib/apt/lists

WORKDIR /usr/src/app
ENV RAILS_ENV development

# Installing Ruby dependencies
COPY Gemfile* ./
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5

# Install JavaScript dependencies
COPY yarn.lock ./
ENV YARN_INTEGRITY_ENABLED "false"
RUN yarn install && yarn check --integrity

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
