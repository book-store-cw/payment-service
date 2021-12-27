import ballerina/http;
import ballerina/log;


// configurable string SHIPPING_SERVICE = ?;


service /payment on new http:Listener(9090) {

    resource function get sayHello(http:Caller caller, http:Request req) returns error? {
        // http:Client shippingService = check new ();

        // // TODO: Add proper response
        // http:Response shippingServiceResponse = <http:Response>check shippingService->get("/sayHello");
        // string payload = <string>check shippingServiceResponse.getTextPayload();

        var result = caller->respond("Hello, from the payment service!");
        if (result is error) {
            log:printError("Error sending response", result);
        }
    }
}
