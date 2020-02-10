public with sharing class ContactBuilder {
    
    private String DEFAULT_LASTNAME = 'Test Lastname';

    private Contact obj;
    
    public ContactBuilder() {
        obj = new Contact();
    }

    public ContactBuilder withLastName(String value)
    {
        obj.LastName = value;
        return this;
    }

    public ContactBuilder withFirstName(String value)
    {
        obj.FirstName = value;
        return this;
    }

    public ContactBuilder withAccount(ID value)
    {
        obj.AccountId = value;
        return this;
    }

    public ContactBuilder withUserId(Integer value)
    {
        obj.User_Id__c = value;
        return this;
    }

    public ContactBuilder withTestDefaults() {
        withLastName(DEFAULT_LASTNAME);
        return this;
    }

    public Contact build()
    {
        return obj;
    }
}
