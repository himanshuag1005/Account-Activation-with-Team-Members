trigger TeamMemberTrigger on SQX_Team_Members__c (after insert, after update, after delete) {

    Set<String> Member_Type = new Set<String>();
    Set<Id> accountIds = new Set<Id>();
    if(trigger.isInsert || trigger.isUpdate) {
        for(SQX_Team_Members__c team : Trigger.new) {
            accountIds.add(team.Account__c);
        }
    }
    if(trigger.isDelete) {
        for(SQX_Team_Members__c team : Trigger.old) {
            accountIds.add(team.Account__c);
        }
    }
    List<Account> accToUpdate = [SELECT Id, (SELECT Id, Member_Type__c FROM Team_Members__r) FROM Account WHERE Id IN : accountIds];
    for(Account acc : accToUpdate) {
        for(SQX_Team_Members__c teamMember : acc.Team_Members__r) {
            if(teamMember.Member_Type__c != null) {
                Member_Type.add(teamMember.Member_Type__c);
            }
        }
        if(acc.Team_Members__r.size() >=2 && Member_Type.contains('HR') && Member_Type.contains('Admin')) {
            acc.Active__c = true;
        } else {
            acc.Active__c = false;
        }
        update accToUpdate;
    }

}