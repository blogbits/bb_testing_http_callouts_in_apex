public with sharing class ToDoService {
    
    private static final String  INVALID_RESPONSE_MESSAGE = 'Endpoint response was invalid:';
    private static final String ENDPOINT_TODO_URL = 'callout:jsonplaceholder/todos/';

    public ToDoService() {
    }
        
    public static HttpResponse fetchFromExternal() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT_TODO_URL);
        req.setMethod('GET');
        HttpResponse res = new Http().send(req);
        return res;
    } 

    @Future(callout=true) 
    public static void syncTodos() {
        HTTPResponse res = fetchFromExternal();        
        if( res.getStatusCode() != 200 ){
            throw new SyncTodoException(INVALID_RESPONSE_MESSAGE + ' Status Code ' + res.getStatusCode()); 
        }
        ToDoWrapper todoWrapper = new ToDoWrapper().setfromJson(res.getBody());
        List<Task> tasks = todoWrapper.getAsTasks();
        Database.upsert(tasks, Task.fields.Todo_Id__c, true);
    }
}
