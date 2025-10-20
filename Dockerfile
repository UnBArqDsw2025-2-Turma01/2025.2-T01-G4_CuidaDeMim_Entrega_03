FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client curl

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install --jobs 4 --retry 3

COPY . .

RUN gem install rails -v 7.1.4

EXPOSE 3000

CMD ["bash"]
