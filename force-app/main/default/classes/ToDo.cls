public with sharing class ToDo {
    
    public String title { get; set; }
    public Integer userId { get; set; }
    public Integer id { get; set; }
    public Boolean completed { get; set; }
    
    public ToDo() {
    }

    public ToDo(String title,Integer userId, Integer id, Boolean completed){
        this.title = title;
        this.userId = userId;
        this.id = id;
        this.completed = completed;
    }
}
