import ballerina/http;

service /api on new http:Listener(8080) {

    resource function get reward() returns string {
        return "Welcome to the Reward Service!";
    }
}
