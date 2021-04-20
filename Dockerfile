FROM debian
RUN  apt update && apt install make gcc -y
WORKDIR /tmp/xinetd
COPY . .
RUN bash configure && \
make && \
make install

FROM debian:stable-slim
RUN mkdir -p /etc/xinetd.d
COPY --from=0 /usr/local/sbin/xinetd /usr/local/sbin/
COPY --from=0 /usr/local/sbin/itox /usr/local/sbin/
COPY --from=0 /usr/local/sbin/xconv.pl /usr/local/sbin/
COPY --from=0 /tmp/xinetd/contrib/xinetd.conf /etc/xinetd.conf
COPY --from=0 /tmp/xinetd/contrib/xinetd.conf /etc/xinetd.d/example.conf
ENTRYPOINT [ "/usr/local/sbin/xinetd", "-d" ]