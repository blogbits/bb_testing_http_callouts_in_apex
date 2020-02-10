@isTest
public with sharing class TaskBuilderTest {
    
    @IsTest
    static void testWithDefaults(){

         Task t = new TaskBuilder()
                        .withTestDefaults()
                        .build();
         System.assertEquals(TaskBuilder.DEFAULT_SUBJECT, t.subject);
         System.assertEquals(TaskBuilder.STATUS_IN_PROGRESS, t.status);
         System.assertEquals(TaskBuilder.TYPE_OTHER, t.type);
         System.assertEquals(UserInfo.getUserId(), t.ownerId);
    }

    static void testWithCalls(){
         String status = TaskBuilder.STATUS_IN_PROGRESS;
         String subject = TaskBuilder.DEFAULT_SUBJECT;
         String type = TaskBuilder.TYPE_OTHER;
         ID ownerId = UserInfo.getUserId();
         Integer todoId = 1;

         Task t = new TaskBuilder()
                        .withStatus(status)
                        .withSubject(subject)
                        .withType(type)
                        .withOwner(ownerId)
                        .withToDoId(todoId)
                        .build();
         System.assertEquals(subject, t.subject);
         System.assertEquals(status, t.status);
         System.assertEquals(type, t.type);
         System.assertEquals(ownerId, t.ownerId);
         System.assertEquals(todoId, t.Todo_Id__c);
    }
}
