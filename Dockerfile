FROM bitwalker/alpine-elixir-phoenix:latest

ENV MIX_ENV prod

RUN apk --no-cache --update add postgresql-client yarn

RUN mkdir /opencov
WORKDIR /opencov

ADD mix.exs /opencov/mix.exs
ADD mix.lock /opencov/mix.lock
ADD package.json /opencov/package.json
ADD yarn.lock /opencov/yarn.lock

RUN yarn install
RUN mix deps.get

ADD . /opencov
RUN mix compile
RUN mix assets.compile
ENTRYPOINT ["mix", "phx.server"]
