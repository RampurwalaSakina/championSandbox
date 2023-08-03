public class Vfquotecontroller {
     public String reason { get; set; }
     public String currentRecordId {get;set;}
     public String messageTitle {get;set;}
     public String messageDescription {get;set;}

    public void determinePage() {
        String currentPage = ApexPages.currentPage().getUrl();
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        buildertek__Quote__c quote= [Select Id , Name ,  buildertek__Status__c, OwnerId From buildertek__Quote__c  WHERE Id=:currentRecordId LIMIT 1];
        if(quote.buildertek__Status__c=='Ready for Approval'){
            quote.buildertek__Status__c='Approved';
            messageTitle='Approved';
            messageDescription='Thankyou for Approved';
            update quote;

            User u = [SELECT Id, Email FROM User WHERE Id = :quote.OwnerId];

            //query email template 
            EmailTemplate templateId = [Select Id from EmailTemplate where DeveloperName = 'Quote_Approved_Internally' limit 1];

            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress Limit 1];
            if ( owea.size() > 0 && templateId != null ) {
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
        }else{
            messageTitle='Status: '+ quote.buildertek__Status__c;
            messageDescription='This Quote is not ready for Company Approved. Please Contact your admin for more information.';
        }
    }

    public PageReference redirectPage() {
        String currentPage = ApexPages.currentPage().getUrl();
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        String sfdcBaseURL = System.Url.getOrgDomainUrl().toExternalForm();
        System.debug('Base URL>>' + sfdcBaseURL );
        sfdcBaseURL = sfdcBaseURL + '/lightning/r/buildertek__Quote__c/'+currentRecordId+'/view';
        PageReference pageRef = new PageReference(sfdcBaseURL);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    // public void changeStatusToRejected() {
    //     buildertek__Quote__c quote= [Select Id , Name ,  buildertek__Status__c From buildertek__Quote__c  WHERE Id=:currentRecordId LIMIT 1];
    //     quote.buildertek__Status__c ='Rejected';
    //     update  quote;
    // }
    
    // public void changeStatusToAccepted() {
    //     System.debug('changeStatusToAccepted');
    //     buildertek__Quote__c quote= [Select Id , Name ,  buildertek__Status__c From buildertek__Quote__c  WHERE Id=:currentRecordId LIMIT 1];
    //     quote.buildertek__Status__c ='Approved';
    //     messageTitle=quote.Name;
    //     messageDescription=quote.buildertek__Status__c;

    // }

}