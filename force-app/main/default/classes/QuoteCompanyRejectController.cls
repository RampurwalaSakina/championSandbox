public without sharing class QuoteCompanyRejectController {
    public String reason { get; set; }
    public String currentRecordId {get;set;}
    public String messageTitle {get;set;}
    public String messageDescription {get;set;}

   public void changeStatus() {
       String currentPage = ApexPages.currentPage().getUrl();
       currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
       buildertek__Quote__c quote= [Select Id , Name ,  buildertek__Status__c, buildertek__Description__c From buildertek__Quote__c  WHERE Id=:currentRecordId LIMIT 1];
       if(quote.buildertek__Status__c=='Ready for Approval'){
           quote.buildertek__Status__c='Rejected';
           quote.buildertek__Description__c=reason;
           
           messageTitle='Rejected';
           messageDescription='Thankyou for Rejecting';
           update quote;
       }else{
           messageTitle='Status: '+ quote.buildertek__Status__c;
           messageDescription='This Quote is not ready for Company Rejected. Please Contact your admin for more information.';
       }
   }
}