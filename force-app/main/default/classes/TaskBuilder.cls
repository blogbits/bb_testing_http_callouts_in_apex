public with sharing class TaskBuilder {
    
    private Task obj;
    public static final String DEFAULT_SUBJECT = 'Test Subject';
    public static final String STATUS_IN_PROGRESS = 'In Progress';
    public static final String STATUS_COMPLETE = 'Completed';
    public static final String TYPE_OTHER = 'Other';
    public static final String TYPE_CALL = 'Call';

    
    public TaskBuilder() {
        obj = new Task();
    }

    public TaskBuilder withSubject(String value){
        obj.Subject = value;
        return this;
    }

    public TaskBuilder withStatus(String value){
        obj.Status = value;
        return this;
    }

    public TaskBuilder withType(String value){
        obj.Type = value;
        return this;
    }

    public TaskBuilder withToDoId(Integer value){
        obj.Todo_Id__c = value;
        return this;
    }

    public TaskBuilder withWhoId(ID value){        
        obj.WhoId = value;
        return this;
    }

    public TaskBuilder withOwner(ID value){
        obj.OwnerId = value;
        return this;
    }

    public TaskBuilder withTestDefaults() {
        withSubject(TaskBuilder.DEFAULT_SUBJECT);
        withStatus(TaskBuilder.STATUS_IN_PROGRESS);
        withType(TaskBuilder.TYPE_OTHER);
        withOwner(UserInfo.getUserId());
        return this;
    }

    public Task build() {
        return obj;
    }
}
