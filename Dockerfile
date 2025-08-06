FROM ballerina/ballerina:2201.12.7
WORKDIR /app
COPY . .
CMD ["bal", "run"]
