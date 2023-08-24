@isTest
private class TeamMemberTriggerTest {

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
            Username = 'admin1005.ag@example.com',
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
            Username = 'standard1005.ag@example.com',
            Alias = 'standard',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert standardUser;
    }

    @isTest
    static void testTeamMemberTrigger_AdminUser() {
        // Set the current user as admin
        User adminUser = [SELECT Id FROM User WHERE LastName = 'Admin' LIMIT 1];
        System.runAs(adminUser) {
            // Create an Account
            Account testAccount = new Account(Name = 'Test Account', Active__c = false);
            insert testAccount;

            // Create two Team Members for the Account
            List<SQX_Team_Members__c> teamMembers = new List<SQX_Team_Members__c>();
            teamMembers.add(new SQX_Team_Members__c(Name = 'Team Member 1', Account__c = testAccount.Id, Member_Type__c = 'HR'));
            teamMembers.add(new SQX_Team_Members__c(Name = 'Team Member 2', Account__c = testAccount.Id, Member_Type__c = 'Admin'));
            insert teamMembers;
            
            // Verify that the Account is activated
            testAccount = [SELECT Active__c FROM Account WHERE Id = :testAccount.Id];
            System.assertEquals(true, testAccount.Active__c);
        }
    }

    @isTest
    static void testTeamMemberTrigger_StandardUser() {
        // Set the current user as standard user
        User standardUser = [SELECT Id FROM User WHERE LastName = 'Standard' LIMIT 1];
        System.runAs(standardUser) {
            // Create an Account
            Account testAccount = new Account(Name = 'Test Account', Active__c = false);
            insert testAccount;

            // Create two Team Members for the Account
            List<SQX_Team_Members__c> teamMembers = new List<SQX_Team_Members__c>();
            teamMembers.add(new SQX_Team_Members__c(Name = 'Team Member 1', Account__c = testAccount.Id, Member_Type__c = 'HR'));
            teamMembers.add(new SQX_Team_Members__c(Name = 'Team Member 2', Account__c = testAccount.Id, Member_Type__c = 'Sales'));  // Not Admin
            insert teamMembers;
            
            // Verify that the Account is not activated
            testAccount = [SELECT Active__c FROM Account WHERE Id = :testAccount.Id];
            System.assertEquals(false, testAccount.Active__c);
        }
    }
}