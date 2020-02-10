@isTest
private with sharing class ToDoWrapperTest {

    static final Integer ContactsCreated = 50;

    @TestSetup
    static void makeData(){
         List<Contact> contacts = TestDataFactory.insertContacts(ContactsCreated);
         TestDataFactory.insertTasksForContacts(contacts);
    }
    
    @IsTest
    static void testToDoMappingFromJson(){
         
         List<ToDo> todos = new List<ToDo>();
         todos.add( new Todo('Title 1', 100, 1, false));
         todos.add( new Todo('Title 2', 100, 2, false));
         todos.add( new Todo('Title 3', 200, 3, false));
         todos.add( new Todo('Title 4', 200, 4, false));
         String json = TestDataFactory.buildJsonTodoMessages(todos);
         Integer expectedSize = todos.size();
         ToDo expectToDo1 = todos[0];
         ToDoWrapper sut = new ToDoWrapper();
         sut.setfromJson(json);
         ToDo actualToDo1 = sut.todos[0];
         System.assertEquals(expectedSize, sut.todos.size());
         System.assertEquals(expectToDo1.title, actualToDo1.title);
         System.assertEquals(expectToDo1.userId, actualToDo1.userId);
         System.assertEquals(expectToDo1.Id, actualToDo1.Id);
         System.assertEquals(expectToDo1.completed, actualToDo1.completed);
    }
        
    @IsTest
    static void testFromJsonMalformedUserId(){
         
         String json = TestDataFactory.buildJsonTodoMessagesMalformed();
         JSONException expectedException;
         try { 
          ToDoWrapper sut = new ToDoWrapper().setfromJson(json);
         } catch (JSONException e){
              expectedException = e;
         }
         System.assertNotEquals(expectedException, null);
         System.assert(expectedException.getMessage().contains('Unexpected character'));
    } 

    @IsTest
    static void testGetUserIds(){         
          Integer userId1 = 1;
          Integer userId2 = 2;
          Integer userId3 = 3;
          List<ToDo> todos = new List<ToDo>();
          todos.add( new Todo('Title 1', userId1, 1, false));
          todos.add( new Todo('Title 2', userId1, 2, false));
          todos.add( new Todo('Title 3', userId2, 3, false));
          todos.add( new Todo('Title 4', userId2, 4, false));
          todos.add( new Todo('Title 5', userId3, 5, false));
          todos.add( new Todo('Title 6', userId3, 6, false));
          todos.add( new Todo('Title 7', userId1, 7, false));
          todos.add( new Todo('Title 8', userId1, 8, false));

          String json = TestDataFactory.buildJsonTodoMessages(todos);
          Integer expectedUniqueUserSize = 3;
          ToDoWrapper sut = new ToDoWrapper().setfromJson(json);

          System.assertEquals(expectedUniqueUserSize, sut.getUserIds().size());
    }

    @IsTest
    static void testTasksWithNoneMatchingContacts(){
         
         List<ToDo> todos = new List<ToDo>();
         Integer invalidUserId1 = 9001;
         Integer invalidUserId2 = 9002;
         Integer validUserId = 1;

         todos.add( new Todo('Title 1', invalidUserId1, 1, false));
         todos.add( new Todo('Title 2', invalidUserId1, 2, false));
         todos.add( new Todo('Title 3', invalidUserId1, 3, false));
         todos.add( new Todo('Title 4', invalidUserId2, 4, false));
         todos.add( new Todo('Title 5', invalidUserId2, 5, false));
         todos.add( new Todo('Title 6', invalidUserId2, 6, false));
         todos.add( new Todo('Title 7', validUserId, 7, false));
         Integer expectedSize = 1;

         ToDoWrapper sut = new ToDoWrapper();
         sut.todos = todos;
         List<Task> tasks = sut.getAsTasks();

         System.assertEquals(expectedSize, tasks.size());
    }

    @IsTest
    static void testContactsWithExistingUserIds(){
         List<Integer> existingUserIds = new List<Integer>{2,4,6,8,10};
         
         ToDoWrapper.Contacts sut = new ToDoWrapper.Contacts();
         sut.setByUserIds(new Set<Integer>(existingUserIds));
         Set<Integer> actualUserIds = sut.getContactsMap().keySet();

         System.assertEquals(actualUserIds.size(), existingUserIds.size());
         System.assert(actualUserIds.containsAll(existingUserIds));
         System.assertEquals(existingUserIds[0], sut.getByUserId(existingUserIds[0]).User_Id__c);
    }

     @IsTest
    static void testContactsWithMixOfUserIds(){
         List<Integer> existingUserIds = new List<Integer>{1,2,3,4,5};
         List<Integer> nonExistingUserIds = new List<Integer>{200,400,600,800,1000};
         List<Integer> mixUserIds = new List<Integer>();
         mixUserIds.addAll(existingUserIds);
         mixUserIds.addAll(nonExistingUserIds);
         
         ToDoWrapper.Contacts sut = new ToDoWrapper.Contacts();
         sut.setByUserIds(new Set<Integer>(mixUserIds));
         Set<Integer> actualUserIds = sut.getContactsMap().keySet();

         System.assertEquals(actualUserIds.size(), existingUserIds.size());
         System.assert(actualUserIds.containsAll(existingUserIds));
         System.assertEquals(existingUserIds[0], sut.getByUserId(existingUserIds[0]).User_Id__c);
    }
}
