@isTest(seeAllData=false)
private class Test_AuditBatchClass {

    public static User usr{get;set;}
    public static List<SetupAuditTrail> auditRec{get;set;}
    public static AuditTrail__c AudCus {get;set;}
       
    static void setupData(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.runAs(thisUser){
            usr = AuditBatchDataFactory.getAdminUser();
            auditRec = AuditBatchDataFactory.getAuditRecords();
            AudCus = AuditBatchDataFactory.getSyncDetails();
        }
    }
    static testMethod void test(){
        
        setupData();
        Test.startTest();
        AuditBatchClass abc = new AuditBatchClass();
        abc.execute(null, auditRec);
        Database.executeBatch(abc);
        abc.finish(null);
        Test.stopTest();

    }
    
}