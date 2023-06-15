@isTest
public class Create_Budget_Controller_Test {
	@isTest
    static void testMethod1(){
        buildertek__Project__c project = new buildertek__Project__c();
        project.Name = 'Test Project';
        insert project;

        Account acc = new Account();
        acc.Name = 'Testing';
        insert acc;

        Contact con = new Contact();
        con.LastName = 'Testing Contact';
        con.Email = 'Testing@gmail.com';
        insert con;

        buildertek__Budget__c budget = new buildertek__Budget__c();
        budget.Name = 'Testing budget';
        insert budget;
        
        buildertek__Quote_Line_Group__c quoteLineGroup =new buildertek__Quote_Line_Group__c ();
        quoteLineGroup.Name='No Grouping';
        insert quoteLineGroup;
        
        buildertek__Quote__c quote = new buildertek__Quote__c();
        quote.Name = 'Test quote';
        quote.buildertek__Project__c = project.Id;
        quote.buildertek__Type__c = 'Master';
        insert quote;
        
        List<buildertek__Quote_Item__c> quoteItemList = new List<buildertek__Quote_Item__c>();
	    buildertek__Quote_Item__c quoteItem = new buildertek__Quote_Item__c();
	    quoteItem.Name = 'Material';
	    quoteItem.buildertek__Quantity__c = 10;
	    quoteItem.buildertek__Unit_Price__c = 100;
	    quoteItem.buildertek__Quote__c = quote.Id;
	    quoteItemList.add(quoteItem);
	    insert quoteItemList;
        
        Create_Budget_Controller.createBudgetFromQuote(quote.Id);
    }
}