public with sharing class TestDataFactory {

    public static List<Contact> insertContacts(Integer numToCreate) {

       List<Contact> contacts = new List<Contact>();
       Integer userId = 0;
       for (Integer i = 0; i < numToCreate; i++ ) {
            userId = userId + 1;
            Contact c = new ContactBuilder()
            .withTestDefaults()
            .withUserId(userId)
            .build();
             contacts.add(c);
       }
       insert contacts;
       return contacts;
    }


    public static List<Task>  insertTasksForContacts(List<Contact> contacts){
        
        List<Task> tasks = new List<Task>();
        Integer taskId = 0;
        for (Integer i = 0; i < contacts.size(); i++) {
            taskId = taskId + 1;
            Task t = new TaskBuilder()
                .withTestDefaults()
                .withWhoId(contacts[i].id)
                .withToDoId(taskId)
                .build();

            tasks.add(t);
        }
        insert tasks;
        return tasks;
    }

    public static String buildJsonTodoMessagesMalformed(){
         String json = '[';
         json = json + '{"userId":abc, "id": 10,"title": "One delectus aut autem", "completed": false},';
         json = json + ']';
         return json;
    }

    public static String buildJsonTodoMessages(List<ToDo> todos) {

        List<Integer> taskIds = new List<Integer>();
        List<Integer> userIds = new List<Integer>();
        List<String>  titles = new List<String>();
        List<Boolean> completed = new List<Boolean>();
        
        for (Todo todo : todos) {
            taskIds.add(todo.id);
            userIds.add(todo.userId);
            titles.add(todo.title);
            completed.add(todo.completed);
        }
        return buildJsonTodoMessages(taskIds, userIds, titles, completed);
     }

    public static String buildJsonTodoMessages(List<Integer> todoIds
                                              ,List<Integer> userIds) {
        List<Todo> todos = new List<Todo>();        
        String titlePrefix = 'Todo Title ';
        for (Integer i = 0; i < todoIds.size(); i++) {
            String title = titlePrefix + todoIds[i];
            Boolean completed = false;
            Todo todo = new Todo(title, userIds[i], todoIds[i], completed);
            todos.add(todo);
        }        
        return buildJsonTodoMessages(todos);
   }

   private static String buildJsonTodoMessages(List<Integer> taskIds
                                              ,List<Integer> userIds
                                              ,List<String>  titles
                                              ,List<Boolean> completed) {
        String jsonBody= '';
        Integer lastLoop = taskIds.size() - 1;
        for (Integer i = 0; i < taskIds.size(); i++) {            
            jsonBody = jsonBody + '{';
            jsonBody = jsonBody + ' "userId": "' + userIds[i] + '"';
            jsonBody = jsonBody + ',"id":' + taskIds[i];
            jsonBody = jsonBody + ',"title": "' + titles[i] +'"';
            jsonBody = jsonBody + ',"completed":' + completed[i];
            jsonBody = jsonBody + '}';
            if(i < lastLoop ){
                jsonBody = jsonBody + ',';
            }
        }
        
        return TestDataFactory.formatTodoMessagesAsArray(jsonBody);
   }
   
   private static String formatTodoMessagesAsArray(String messages) {
       return '[' + messages + ']';
   }
}
