FROM swift:6.3

WORKDIR /app

COPY Package.swift .
COPY Sources Sources
COPY Tests Tests

RUN swift build --configuration release

CMD ["swift", "run", "demo"]
