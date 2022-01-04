import ballerina/http;
import ballerina/log;
import ballerina/os;

final string shippingServiceUrl = os:getEnv("SHIPPING_SERVICE_URL");

service /payment on new http:Listener(9090) {

    resource function get purchaseBook/[string bookId](http:Caller caller, http:Request req) returns error? {
        map<json> bookList = {
            "1": {
                id: "1",
                bookName: "HarryPotter1",
                author: "J.K.Rowling",
                price: "500"
            },
            "2": {
                id: "2",
                bookName: "HarryPotter2",
                author: "J.K.Rowling",
                price: "800"
            },
            "3": {
                id: "3",
                bookName: "HarryPotter3",
                author: "J.K.Rowling",
                price: "900"
            }
        };

        json book = bookList[bookId];
        if book is () {
            http:Response err = new;
            err.statusCode = http:STATUS_NOT_FOUND;
            err.setPayload("Ordered book not found in stock");
            error? response = caller->respond(err);
            if (response is error) {
                log:printError("error responding to book-store-service", response);
            }
        } else {
            error? response = caller->respond(book);
            if (response is error) {
                log:printError("error responding to book-store-service", response);
            }
        }
    }

    resource function get finalizePurchase/[string city](http:Caller caller, http:Request req) returns error? {
        http:Client shippingService = check new (shippingServiceUrl);

        http:Response shippingServiceResponse = <http:Response>check shippingService->get("/shipping/shippingPrice/" + city);

        json|error responseData = shippingServiceResponse.getJsonPayload();
        if responseData is error {
            var result = caller->respond("Error while fetching data from shipping service");
            if (result is error) {
                log:printError("Error sending response", result);
            }
        } else {
            var result = caller->respond(responseData);

            if (result is error) {
                log:printError("Error sending response", result);
            }
        }
    }
}
