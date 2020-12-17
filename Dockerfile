FROM crystallang/crystal:0.35.1-alpine as build
WORKDIR /workspace/
COPY shard.yml shard.lock /workspace/
RUN shards install
COPY . /workspace/
RUN shards build --static --release

FROM alpine:3
LABEL maintainer="sieg@nyrst.tools"
COPY --from=build /workspace/bin/brrr /
RUN apk --update add ca-certificates && \
  rm -rf "/var/cache/apk/*"
ENTRYPOINT ["/brrr"]
CMD ["help"]