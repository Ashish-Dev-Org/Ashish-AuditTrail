global class AuditBatchClass implements Database.Batchable<sObject>{

    AuditTrail__c atc = AuditTrail__c.getInstance('Main');
    Datetime dts = atc.Last_Batch_Run__c;
    List<Audit_Trail__c> ATILoad = new List<Audit_Trail__c>();
    String query,query1;
    
    global AuditBatchClass(){
        query = 'SELECT Id,Action,CreatedById,CreatedDate,Display,Section,DelegateUser FROM SetupAuditTrail';
        query1 = 'SELECT Id,Action, CreatedById,CreatedDate,Display,Section FROM SetupAuditTrail where CreatedDate >: dts';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(atc.Batch_Sync__c){
            if(atc.Last_Batch_Run__c==null){
            	return Database.getQueryLocator(query);
        		}
			else 
            	return Database.getQueryLocator(query1);
        }else
        return null;
    }
    

    global void execute(Database.BatchableContext BC, List<SetupAuditTrail> scope){

        for(SetupAuditTrail sat: scope){
            Audit_Trail__c at = new Audit_Trail__c();
            at.Action__c = sat.Action;
            at.Audit_Component__c = sat.Section;
            at.Audit_Created_Date__c = sat.CreatedDate;
            //at.Audit_Delegated_User__c = sat.DelegateUser;
            at.Audit_Display__c = sat.Display;
            at.Audit_Id__c = sat.Id;
            at.Audit_Rec_User__c = sat.CreatedById;
           	ATILoad.add(at);
            
        }
        if(ATILoad.size() > 0){
           insert ATILoad;
        }
        
    }
    global void finish(Database.BatchableContext BC){
    	atc.Last_Batch_Run__c = system.now();
        update atc;
    }
}