@isTest
public class AgentBuilderControllerMock implements HttpCalloutMock {
  public HTTPResponse respond(HTTPRequest req) {
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setStatusCode(200);
    res.setBody('{"client_secret": "mocked-token"}');
    return res;
  }
}