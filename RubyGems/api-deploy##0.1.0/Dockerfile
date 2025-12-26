# ruby dependencies and ansible
#FROM docker.artifactory.yoox.net/ruby:2.4.0-alpine
FROM ruby:2.4-alpine
RUN apk add --update --no-cache make ansible less

# takes VP as --build-arg for vault pass
ARG VP=''

# creates workdir
ENV APP_PATH /app/
RUN mkdir $APP_PATH
WORKDIR $APP_PATH

# decrypts vault in machine
COPY config/vault vault
COPY .vault_pass.py .
RUN mkdir ~/.config/
RUN ansible-vault view --vault-password-file=.vault_pass.py vault > ~/.config/api_deploy_overrides.json

# setup gem deps
COPY Gemfile* $APP_PATH
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install

# copy in app
COPY . $APP_PATH

# set LOG_LEVEL to verbose
#ENV LOG_LEVEL info
