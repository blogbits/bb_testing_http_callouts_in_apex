public with sharing class ToDoWrapper {
    
    public List<ToDo> todos {get; set;}
    
    public ToDoWrapper() {
        todos = new List<ToDo>();
    }

    public ToDoWrapper setfromJson(String jsonMessage) {
        this.todos = (List<ToDo>)JSON.deserialize(jsonMessage, List<ToDo>.class);
        return this;
    }

    public Set<Integer> getUserIds() {
        Set<Integer> result = new Set<Integer>();
        for(Todo t : todos ){
            result.add(t.userId);
        }
        return result;
    }

    public List<Task> getAsTasks(){        
        TaskMapper taskMapper = new TaskMapper(this);
        return taskMapper.mapToTasks();
    }
        
    private class TaskMapper {
        
        ToDoWrapper wrapper;
        public TaskMapper(ToDoWrapper wrapper){
            this.wrapper = wrapper;
        }
     
        public List<Task> mapToTasks() {
            List<Task> tasks = new List<Task>();
            Contacts contacts = new Contacts().setByUserIds(wrapper.getUserIds());
            for (ToDo todo : wrapper.todos) {            
                if(contacts.existsByUserId(todo.userId)){
                    Task task = doMap(todo, contacts.getByUserId(todo.userId));
                    tasks.add(task);
                }
            }
            return tasks;
        }
        
        private Task doMap(Todo todo, Contact contact) {
           String taskStatus = todo.completed ? TaskBuilder.STATUS_COMPLETE : TaskBuilder.STATUS_IN_PROGRESS;
           return new TaskBuilder()
                    .withSubject(todo.title)
                    .withWhoId(contact.id)
                    .withToDoId(todo.id)
                    .withStatus(taskStatus)
                    .build();
        }
    }

    public class Contacts {
            
        private Map<Integer, Contact> contactsMap = new Map<Integer, Contact>();
        
        public Contacts setByUserIds(Set<Integer> userIds) {
            contactsMap.clear();
            for (Contact contact : [SELECT Id, User_Id__c from Contact where User_Id__c in :userIds]) {
                contactsMap.put((Integer)contact.User_Id__c, contact);
            }
            return this;
        }

        public Boolean existsByUserId(Integer userId){            
            return contactsMap.containsKey(userId);
        }

        public Contact getByUserId(Integer userId){
            return contactsMap.get(userId);
        }

        public Integer size() {
            return contactsMap.size();
        }

        public Map<Integer, Contact> getContactsMap() {
            return contactsMap;
        }
    }
}
