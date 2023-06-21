public with sharing class Price_Book_Entry_Cls {
    public static Boolean isRollUpCostChange= true;

    @AuraEnabled
    public static PricebookEntry getRecord(String recordId){
        PricebookEntry pbEntry = [SELECT Id, Name, Pricebook2Id, Product2Id, CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice, CreatedDate, CreatedById,
                                    LastModifiedDate, Projected_Sales_Price__c, LastModifiedById, SystemModstamp, ProductCode, IsDeleted, IsArchived, buildertek__Discount__c, buildertek__Markup__c,
                                    Markup_Amount__c, buildertek__Multiplier__c, buildertek__PriceBook_Amounts__c, buildertek__Unit_Cost__c, Labor__c, Material__c, Equipment_Rental__c,
                                    Miscellaneous_Markup_Amount__c, Miscellaneous_Markup__c,  Material_Markup__c,  Material_Markup_Amount__c, Labor_Markup__c, Labor_Markup_Amount__c,
                                    Equipment_Rental_Markup_Percent__c, Equipment_Rental_Markup_Amount__c, Rollup_Costs_Plus_Markup__c, Direct_Markup__c,
                                    Miscellaneous__c, Rollup_Costs__c FROM PricebookEntry WHERE Id =: recordId];
        return pbEntry;
    }

    @AuraEnabled
    public static void updateRecord(PricebookEntry pbEntry){

        Decimal rollupListPrice = 0; //Represents the Rollup Cost Plus Markup Amount field.
        Decimal rollupUnitCost = 0;  //Represents the Rollup Costs field.
        Decimal laborMarkupvalue = 0;
        Decimal materialMarkupvalue = 0;
        Decimal equipmentMarkupvalue = 0;
        Decimal MiscellaneousMarkupvalue = 0;

        System.debug('buildertek__Unit_Cost__c ' + pbEntry.buildertek__Unit_Cost__c);


        if (pbEntry.Equipment_Rental__c != null && pbEntry.Equipment_Rental__c != 0) {
            rollupListPrice += pbEntry.Equipment_Rental__c;
            rollupUnitCost += pbEntry.Equipment_Rental__c;
            if (pbEntry.Equipment_Rental_Markup_Percent__c != null && pbEntry.Equipment_Rental_Markup_Percent__c != 0){
                equipmentMarkupvalue = pbEntry.Equipment_Rental__c * pbEntry.Equipment_Rental_Markup_Percent__c/100;
                rollupListPrice = equipmentMarkupvalue + rollupListPrice;
            }
        }
        if (pbEntry.Labor__c != null && pbEntry.Labor__c != 0) {
            rollupListPrice += pbEntry.Labor__c;
            rollupUnitCost += pbEntry.Labor__c;
            if (pbEntry.Labor_Markup__c != null && pbEntry.Labor_Markup__c != 0){
                laborMarkupvalue = pbEntry.Labor__c * pbEntry.Labor_Markup__c/100;
                rollupListPrice = laborMarkupvalue + rollupListPrice;
            }
        }
        if (pbEntry.Material__c != null && pbEntry.Material__c != 0) {
            rollupListPrice += pbEntry.Material__c;
            rollupUnitCost += pbEntry.Material__c;
            if (pbEntry.Material_Markup__c != null && pbEntry.Material_Markup__c != 0){
                materialMarkupvalue = pbEntry.Material__c * pbEntry.Material_Markup__c/100;
                rollupListPrice = materialMarkupvalue + rollupListPrice;
            }
        }
        if (pbEntry.Miscellaneous__c != null && pbEntry.Miscellaneous__c != 0) {
            rollupListPrice += pbEntry.Miscellaneous__c;
            rollupUnitCost += pbEntry.Miscellaneous__c;
            if (pbEntry.Miscellaneous_Markup__c != null && pbEntry.Miscellaneous_Markup__c != 0){
                MiscellaneousMarkupvalue = pbEntry.Miscellaneous__c * pbEntry.Miscellaneous_Markup__c/100;
                rollupListPrice = MiscellaneousMarkupvalue + rollupListPrice;
            }
        }

        Decimal markUpAmount = 0;
        Decimal RollupConstPlus = rollupUnitCost + equipmentMarkupvalue + laborMarkupvalue + materialMarkupvalue + MiscellaneousMarkupvalue;

        //comment due to CHB 57
        if(rollupListPrice == 0){
            if(rollupUnitCost !=  pbEntry.Rollup_Costs__c){
                pbEntry.buildertek__Unit_Cost__c = rollupUnitCost;
            }

            //* logic added by Nishit for CHB-58 if rollupListPrice = 0 then value = 0
            if((rollupUnitCost !=  pbEntry.Rollup_Costs_Plus_Markup__c)){
                pbEntry.buildertek__Markup__c =  rollupUnitCost;
            }
        }


        if (rollupListPrice > 0 ) {

            //* logic added by Nishit for CHB-58
            if((rollupListPrice !=  pbEntry.Rollup_Costs_Plus_Markup__c)){
                Decimal markUp = (((rollupUnitCost - RollupConstPlus ) / rollupUnitCost) * (-1))*100;
                Decimal valueSet = markup.setscale(2);
                pbEntry.buildertek__Markup__c =  valueSet;
            }

            //comment due to CHB 57
            if(rollupUnitCost !=  pbEntry.Rollup_Costs__c){
                pbEntry.buildertek__Unit_Cost__c = rollupUnitCost;
            }

            if(pbEntry.buildertek__Markup__c != null){
                //! commenting this line 16/06 because of conflicting with CHB-58
                // markUpAmount = pbEntry.buildertek__Markup__c * pbEntry.UnitPrice/100;
            }
            else if(pbEntry.buildertek__Markup__c == null){
                markUpAmount = 0;
            }
            else{
                markUpAmount = rollupListPrice;
            }
            System.debug('UnitPrice in if '+rollupListPrice + markUpAmount);
            pbEntry.UnitPrice = rollupListPrice + markUpAmount;

        }else{

            if(pbEntry.buildertek__Markup__c != null){
                markUpAmount = pbEntry.buildertek__Markup__c * rollupListPrice/100;
            }
            else if(pbEntry.buildertek__Markup__c == null){
                markUpAmount = 0;
            }

            //pbEntry.buildertek__Unit_Cost__c = rollupUnitCost;
            //pbEntry.buildertek__Unit_Cost__c = pbEntry.Rollup_Costs__c;
            //pbEntry.UnitPrice = pbEntry.Rollup_Costs_Plus_Markup__c;
            System.debug('UnitPrice in else '+rollupListPrice + markUpAmount);
            pbEntry.UnitPrice = rollupListPrice + markUpAmount;
        }

        update pbEntry;
        System.debug('buildertek__Unit_Cost__c after update ' + pbEntry.buildertek__Unit_Cost__c);

    }
}