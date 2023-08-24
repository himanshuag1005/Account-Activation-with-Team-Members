trigger AccountTrigger on Account (after insert) {
    
    List<SQX_Team_Members__c> teamMemberToInsert = new List<SQX_Team_Members__c>();
    for(Account acc : Trigger.new) {
        teamMemberToInsert.add(new SQX_Team_Members__c(Name = 'Team Member 1', Account__c = acc.id));
        teamMemberToInsert.add(new SQX_Team_Members__c(Name = 'Team Member 2', Account__c = acc.id));
    }
    if(!teamMemberToInsert.isEmpty()) {
        insert teamMemberToInsert;
    }
}