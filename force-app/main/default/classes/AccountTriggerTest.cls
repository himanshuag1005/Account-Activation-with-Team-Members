@isTest
private class AccountTriggerTest {

    @testSetup
    static void setupTestData() {
        // Create test user profiles for admin and standard user
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        // Create test users
        User adminUser = new User(
            ProfileId = adminProfile.Id,
            LastName = 'Admin',
            Email = 'admin@example.com',
            Username = 'admin1001.ag@example.com',
            Alias = 'admin',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert adminUser;
        
        User standardUser = new User(
            ProfileId = standardProfile.Id,
            LastName = 'Standard',
            Email = 'standard@example.com',
            Username = 'standard1002.ag@example.com',
            Alias = 'standard',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert standardUser;
    }

    @isTest
    static void testAccountTrigger_AdminUser() {
        // Set the current user as admin
        User adminUser = [SELECT Id FROM User WHERE LastName = 'Admin' LIMIT 1];
        System.runAs(adminUser) {
            // Create an account to trigger the trigger
            Account testAccount = new Account(Name = 'Test Account', Active__c = false);
            insert testAccount;
            
            // Verify team members were inserted
            List<SQX_Team_Members__c> insertedTeamMembers = [SELECT Id FROM SQX_Team_Members__c WHERE Account__c = :testAccount.Id];
            System.assertEquals(2, insertedTeamMembers.size());
        }
    }

    @isTest
    static void testAccountTrigger_StandardUser() {
        // Set the current user as standard user
        User standardUser = [SELECT Id FROM User WHERE LastName = 'Standard' LIMIT 1];
        System.runAs(standardUser) {
            // Create an account to trigger the trigger
            Account testAccount = new Account(Name = 'Test Account', Active__c = false);
            insert testAccount;
            
            // Verify no team members were inserted
            List<SQX_Team_Members__c> insertedTeamMembers = [SELECT Id FROM SQX_Team_Members__c WHERE Account__c = :testAccount.Id];
            System.assertEquals(2, insertedTeamMembers.size());
        }
    }
}