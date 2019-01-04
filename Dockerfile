FROM debian:jessie

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        curl \
        unzip \
        tcputils && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    apt-get autoremove -y

# Download and install the stockfish engine
RUN mkdir /tmp/stockfish && \
    cd /tmp/stockfish && \
    curl -SL "https://stockfish.s3.amazonaws.com/stockfish-10-src.zip" -o download.zip && \
    unzip download.zip && \
    cd src && \
    make profile-build ARCH=x86-64 && \
    make install && \
    cd / && rm -Rf /tmp/stockfish

# Expose the mini-inetd port
EXPOSE 8080

CMD ["/usr/bin/mini-inetd", "-d", "8080", "/usr/local/bin/stockfish", "go"]
