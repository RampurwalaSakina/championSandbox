public class Vfquotecontroller {
     public String reason { get; set; }
     public String currentRecordId {get;set;}
     public String messageTitle {get;set;}
     public String messageDescription {get;set;}

    public void determinePage() {
        String currentPage = ApexPages.currentPage().getUrl();
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        buildertek__Quote__c quote= [Select Id , Name ,  buildertek__Status__c From buildertek__Quote__c  WHERE Id=:currentRecordId LIMIT 1];
        if(quote.buildertek__Status__c=='Ready for Approval'){
            quote.buildertek__Status__c='Approved';
            messageTitle='Approved';
            messageDescription='Thankyou for Approved';
            update quote;
        }else{
            messageTitle='Status: '+ quote.buildertek__Status__c;
            messageDescription='This Quote is not ready for Company Approved. Please Contact your admin for more information.';
        }
        // if (currentPage.contains('QuoteCompanyRejected')) {
        //     changeStatusToRejected();
        // } else if (currentPage.contains('QuoteCompanyApproved')) {
        //     changeStatusToAccepted();
        // }
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