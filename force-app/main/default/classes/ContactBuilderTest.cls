@isTest
public with sharing class ContactBuilderTest {

@isTest static void testBuilderDefaults() {
        Contact c = new ContactBuilder()
            		.withTestDefaults()            		
            		.build();
        System.assertNotEquals(null, c.LastName);        
}

    @isTest static void testBuilderWithCalls() {
        final String LastName = 'Lastname';
        final String FirstName = 'Firstname';
        final Integer userId = 5;

        Contact c = new ContactBuilder()
            		.withLastName(LastName)
                    .withFirstName(FirstName)
                    .withUserId(userId)
            		.build();
        System.assertEquals(FirstName, c.FirstName);
        System.assertEquals(LastName, c.LastName);   
        System.assertEquals(userId, c.User_Id__c);
    }
}
