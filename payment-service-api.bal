import ballerina/http;
import ballerina/log;


configurable string SHIPPING_SERVICE = ?;


service /hello on new http:Listener(9090) {

    resource function get sayHello(http:Caller caller, http:Request req) returns error? {
        http:Client hrService = check new (SHIPPING_SERVICE);

        // TODO: Add proper response
        http:Response shippingServiceResponse = <http:Response>check hrService->get("/sayHello");
        string payload = <string>check shippingServiceResponse.getTextPayload();


        // Send a response back to the caller.
        var result = caller->respond("Hello, from the payment service!");
        if (result is error) {
            log:printError("Error sending response", result);
        }
    }
}
