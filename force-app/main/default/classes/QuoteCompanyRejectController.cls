public without sharing class QuoteCompanyRejectController {
    public String reason { get; set; }
    public String currentRecordId {get;set;}
    public String messageTitle {get;set;}
    public String messageDescription {get;set;}
    public boolean displayMessage {get;set;}
    public String rejectionReason { get; set; }
    public buildertek__Quote__c quote { get; set; }


    public QuoteCompanyRejectController(){
        String currentPage = ApexPages.currentPage().getUrl();
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        quote= [Select Id , Name ,  buildertek__Status__c, buildertek__Description__c, OwnerId From buildertek__Quote__c  WHERE Id=:currentRecordId LIMIT 1];

 

    }


    public void saveReason() {    
        System.debug('rejectionReason' +  rejectionReason);
        if(rejectionReason != '' && rejectionReason != null){

            quote.buildertek__Description__c = rejectionReason;
            quote.buildertek__Status__c='Rejected';
    
            messageTitle='Rejected';
            messageDescription='Thankyou for Rejecting';
            update quote;
    
            User u = [SELECT Id, Email FROM User WHERE Id = :quote.OwnerId];
    
             OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress Limit 1];
             EmailTemplate templateId = [Select Id from EmailTemplate where DeveloperName = 'Quote_Rejected_Internally' limit 1];
    
             if ( owea.size() > 0  && templateId != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {u.Email};
                mail.setToAddresses(toAddresses);
                mail.setTemplateId(templateId.Id);
                mail.setTargetObjectId(u.Id);
                mail.setSaveAsActivity(false);
                mail.setWhatId(quote.Id);
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            displayMessage = true;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please Enter Rejection Reason.'));

        }

    }


    public void checkStatus(){
        displayMessage = true;
    //    buildertek__Quote__c quote= [Select Id , Name ,  buildertek__Status__c, buildertek__Description__c, OwnerId From buildertek__Quote__c  WHERE Id=:currentRecordId LIMIT 1];
       if(quote.buildertek__Status__c != 'Ready for Approval'){
           messageTitle='Status: '+ quote.buildertek__Status__c;
           messageDescription='This Quote is not ready for Company Rejected. Please Contact your admin for more information.';
       }else{
            displayMessage = false;
       }
    }

   public void changeStatus() {
    //    buildertek__Quote__c quote= [Select Id , Name ,  buildertek__Status__c, buildertek__Description__c, OwnerId From buildertek__Quote__c  WHERE Id=:currentRecordId LIMIT 1];
       if(quote.buildertek__Status__c=='Ready for Approval'){
           quote.buildertek__Status__c='Rejected';
           quote.buildertek__Description__c=reason;
           
           messageTitle='Rejected';
           messageDescription='Thankyou for Rejecting';
           update quote;

           User u = [SELECT Id, Email FROM User WHERE Id = :quote.OwnerId];

            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress Limit 1];
            if ( owea.size() > 0 ) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {u.Email};
                toAddresses.add('jaimin.s@mvclouds.com');
                mail.setToAddresses(toAddresses);
                mail.setSubject('Quote Rejected Internally : ' + quote.Name);
                mail.setPlainTextBody('Your Quote has been rejected');
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }

       }else{
           messageTitle='Status: '+ quote.buildertek__Status__c;
           messageDescription='This Quote is not ready for Company Rejected. Please Contact your admin for more information.';
       }
   }
}