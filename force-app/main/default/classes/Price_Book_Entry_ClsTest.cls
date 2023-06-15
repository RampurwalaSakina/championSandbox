@isTest
public with sharing class Price_Book_Entry_ClsTest {
    @isTest
    static void testMethod1(){
        Product2 pro = new Product2(Name = 'iPhone X', Family = 'Mobile');
        Insert pro;
        
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        Update standardPricebook;
    
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        
        pbe.Equipment_Rental__c = 32;
        pbe.Labor__c = 32;
        pbe.Material__c = 32;
        pbe.Equipment_Rental_Markup_Percent__c = 1;
        pbe.Labor_Markup__c = 1;
        pbe.Material_Markup__c = 1;
        pbe.Miscellaneous_Markup__c = 1;
        pbe.Miscellaneous__c = 26;
        Price_Book_Entry_Cls.getRecord(pbe.Id);
        Price_Book_Entry_Cls.updateRecord(pbe);
    }
}