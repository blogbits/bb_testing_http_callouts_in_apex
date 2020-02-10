@isTest
public with sharing class HttpMockBuilder {
    
    public static final Integer  STATUS_CODE_400 = 400;
    public static final Integer  STATUS_CODE_404 = 404;
    public static final Integer  STATUS_CODE_200 = 200;
    public static final Integer  STATUS_CODE_500 = 500;
    public static final Integer  STATUS_CODE_503 = 503;

    private HttpMock mock;
    
    public HttpMockBuilder() {
        this.mock = new HttpMock();
    }
    
    public HttpMockBuilder withBody(String value){
        this.mock.setBody(value);
        return this;
    }
    
    public HttpMockBuilder withStatusNotFound() {
        this.mock.setStatusCode(HttpMockBuilder.STATUS_CODE_404);
        return this;
    }

    public HttpMockBuilder withStatusBadRequest() {
        this.mock.setStatusCode(HttpMockBuilder.STATUS_CODE_400);
        return this;
    }

    public HttpMockBuilder withStatusServerError() {
        this.mock.setStatusCode(HttpMockBuilder.STATUS_CODE_500);
        return this;
    }

    public HttpMockBuilder withStatusServerUnavailable() {
        this.mock.setStatusCode(HttpMockBuilder.STATUS_CODE_503);
        return this;
    }

    public HttpCalloutMock build() {
        return this.mock;
    }

    private class HttpMock implements HttpCalloutMock {

        private HttpResponse res;
    
        public HttpMock() {
            initDefaults();
        }
    
        public HttpResponse respond(HttpRequest req) {
            return res;
        }
    
        public void setBody(String value) {
            res.setBody(value);
        }
    
        public void setStatusCode(Integer code){
            res.setStatusCode(code);
        }
    
        private void setContentTypeJson() {
            res.setHeader('Content-Type', 'application/json');        
        }
    
        private void initDefaults(){
            res = new HttpResponse();            
            this.setStatusCode(HttpMockBuilder.STATUS_CODE_200);
            this.setContentTypeJson();
        }
    }
}
