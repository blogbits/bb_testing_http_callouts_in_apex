@isTest
private with sharing class ToDoServiceTest {
        
    static final Integer TestContactsCreated = 50;
    static final Integer TestTasksCreated = 50;

    @TestSetup
    static void makeData(){         
         List<Contact> contacts = TestDataFactory.insertContacts(TestContactsCreated);
         TestDataFactory.insertTasksForContacts(contacts);
    }

    @IsTest static void testTestDataFactory() {        
        Map<Id, Contact> contacts = new Map<Id, Contact>([select id, name from Contact]);
        Map<Id, Task> tasks = new Map<Id, Task>([Select Id, WhoId, Subject from Task where WhoId in :contacts.keySet()]);
        System.assertEquals(contacts.size(), tasks.size());
        System.assertEquals(TestContactsCreated, contacts.size());
    }    
    
    @IsTest static void testSyncCreatesNewTasks(){
        // Should create tasks for new todo ids
        List<Integer> newToDoIds = new List<Integer>{1111, 1112, 1113, 1114, 1115};
        List<Integer> userIds = new List<Integer>{1, 1, 1, 3, 3};
        String json = TestDataFactory.buildJsonTodoMessages(newToDoIds, userIds);
        Map<Id, Task> tasks = ToDoServiceTest.selectTasksByToDoIds(newToDoIds);

        System.assertEquals(0, tasks.size());

        Test.startTest();
            HttpCalloutMock mock = new HttpMockBuilder()
                .withBody(json)
                .build();
            Test.setMock(HttpCalloutMock.class, mock);
            ToDoService.syncTodos();
        Test.stopTest();

        tasks = ToDoServiceTest.selectTasksByToDoIds(newToDoIds);
        System.assertEquals(tasks.size(), newToDoIds.size());
    }

    @IsTest static void testSyncUpdateExistingTasks(){
        // Should update tasks for existing todo ids
        List<Integer> existingTodoIds = new List<Integer>{5,10,15,20,25,30};
        List<Integer> usersIds = new List<Integer>{5,10,15,20,25,30};
        Map<Id, Task> allTasks = ToDoServiceTest.selectAllTasks();
        
        System.assertEquals(allTasks.size(), TestTasksCreated);
        String json = TestDataFactory.buildJsonTodoMessages(existingTodoIds, usersIds);
        
        Test.startTest();
            HttpCalloutMock mock = new HttpMockBuilder().withBody(json).build();
            Test.setMock(HttpCalloutMock.class, mock);
            ToDoService.syncTodos();
        Test.stopTest();

        allTasks = ToDoServiceTest.selectAllTasks();
        System.assertEquals(allTasks.size(), TestTasksCreated);        
    }

    @IsTest static void testSyncUpsertsTasks(){
        // Should create new tasks for new todo ids and update existing tasks
        List<Integer> newToDoIds = new List<Integer>{2111, 2112, 2113, 2114, 2115};
        List<Integer> existingTodoIds = new List<Integer>{5,10,15,20,25};
        List<Integer> userIds = new List<Integer>{1, 1, 1, 1, 1, 2, 2, 2, 2, 2};
        List<Integer> todoIds = new List<Integer>();
        todoIds.addAll(newToDoIds);
        todoIds.addAll(existingTodoIds);
        String json = TestDataFactory.buildJsonTodoMessages(todoIds, userIds);
        Integer expectedTaskCount = TestTasksCreated + newToDoIds.size();

        Map<Id, Task> tasks = ToDoServiceTest.selectTasksByToDoIds(newToDoIds);

        System.assertEquals(0, tasks.size());

        Test.startTest();
            HttpCalloutMock mock = new HttpMockBuilder().withBody(json).build();
            Test.setMock(HttpCalloutMock.class, mock);
            ToDoService.syncTodos();
        Test.stopTest();

        tasks = ToDoServiceTest.selectAllTasks();
        System.assertEquals(expectedTaskCount, tasks.size());
    }

    @IsTest static void testSyncWithNonMatchingUserIds(){
        // Should create tasks for existing contacts only
        List<Integer> newToDoIds = new List<Integer>{3111, 3112, 3113, 3114, 3115};
        List<Integer> newUserIds = new List<Integer>{2221, 2222, 2223, 2224, 2225};
        String json = TestDataFactory.buildJsonTodoMessages(newToDoIds, newUserIds);
        Map<Id, Task> tasks = ToDoServiceTest.selectTasksByToDoIds(newToDoIds);
        Integer expectedTaskCount = 0;
        
        System.assertEquals(expectedTaskCount, tasks.size());

        Test.startTest();
            HttpCalloutMock mock = new HttpMockBuilder().withBody(json).build();
            Test.setMock(HttpCalloutMock.class, mock);
            ToDoService.syncTodos();
        Test.stopTest();

        tasks = ToDoServiceTest.selectTasksByToDoIds(newToDoIds);
        System.assertEquals(expectedTaskCount, tasks.size());
    }

    @isTest static void testThrowFor404(){
        // Should throw for non 200 http status codes
        SyncTodoException expectedException;
        try{
            Test.startTest();
                HttpCalloutMock mock = new HttpMockBuilder()
                    .withBody(TestDataFactory.buildJsonTodoMessages(new List<Integer>{5000}, new List<Integer>{1}))
                    .withStatusNotFound()
                    .build();
                Test.setMock(HttpCalloutMock.class, mock);
                ToDoService.syncTodos();
            Test.stopTest();        
        } catch( SyncTodoException e){
            expectedException = e;
        }
        System.assertNotEquals(expectedException,null,'Should throw exception');
    }


    @isTest static void testThrowFor500(){
        // Should throw for non 200 http status code        
        SyncTodoException expectedException;
        try{
            Test.startTest();
                HttpCalloutMock mock = new HttpMockBuilder()
                .withBody(TestDataFactory.buildJsonTodoMessages(new List<Integer>{5000}, new List<Integer>{1}))
                .withStatusServerError()
                .build();
                Test.setMock(HttpCalloutMock.class, mock);
                ToDoService.syncTodos();
            Test.stopTest();        
        } catch( SyncTodoException e){
            expectedException = e;
        }
        System.assertNotEquals(expectedException,null,'Should throw exception');
    }
        
        
    @isTest static void testThrowOnMalformedJson(){
        // Should throw for mal-formed json
        String json = TestDataFactory.buildJsonTodoMessagesMalformed();
        JSONException expectedException = null;
        try { 
            Test.startTest();
            HttpCalloutMock mock = new HttpMockBuilder().withBody(json).build();
            Test.setMock(HttpCalloutMock.class, mock);
            ToDoService.syncTodos();
            Test.stopTest();
        } catch (JSONException e) {
            expectedException = e;                
        }
        
        System.assertNotEquals(null, expectedException, 'Should throw exception');
        System.assert(expectedException.getMessage().contains('Unexpected character'));
    }

    @IsTest static void testHttpResponseVaues(){        
        Test.startTest();
        HttpCalloutMock mock = new HttpMockBuilder().build();
        Test.setMock(HttpCalloutMock.class, mock);

        HttpResponse res = ToDoService.fetchFromExternal();
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');        
        System.assertEquals(200, res.getStatusCode());
        Test.stopTest();        
    }

    private static Map<Id, Task> selectTasksByToDoIds(List<Integer> todoIds){
        return new Map<Id, Task>([Select Id, WhoId, Subject 
        from Task where Todo_Id__c in :todoIds]);
    }

    private static Map<Id, Task> selectAllTasks(){
        return new Map<Id, Task>([Select Id, WhoId, Subject from Task]);
    }
}
