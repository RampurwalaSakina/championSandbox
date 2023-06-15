public class Create_Budget_Controller {
    
        @AuraEnabled
    public static ResponseBase createBudgetFromQuote(Id QuoteId) {
        system.debug('testt');
        ResponseBase response = new ResponseBase();
        response.isSuccess = true;
        
        try {
            List<buildertek__Budget__c> newBudget = Create_Budget_Controller.createBudgetFromQuote(new List<Id> {QuoteId});
            response.strMessage = 'success';
            response.newRecordId = newBudget[0].Id;
        }
        catch(Exception ex) {
            response.isSuccess = false;
            response.strMessage = ex.getMessage();
        }
        
        return response;
    }
     public virtual class ResponseBase {
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String strMessage;
        @AuraEnabled public String newRecordId;
    }
     public static List<buildertek__Budget__c> createBudgetFromQuote(List<Id> QuoteId) {
        List<String> quoteIdsList = new List<String>();
        Integer intIndex = 0;
        Map<Integer, buildertek__Budget__c> mapBudgetIndex = new Map<Integer, buildertek__Budget__c>();
        Map<Integer, List<buildertek__Budget_Item__c>> mapBudgetLinesIndex = new Map<Integer, List<buildertek__Budget_Item__c>>();
        
        // List<buildertek__Budget_Item__c> budgetItemList=new List<buildertek__Budget_Item__c>();
        List<String> poIds=new List<String>();
        
        MAP<Integer,List<String>> idMap= new Map<Integer,List<String>>();
        Map<String,String> quoteToBudget = new Map<String,String>();
        Map<String,buildertek__Budget_Item__c> quoteToBudgetItem= new Map<String,buildertek__Budget_Item__c>();
        
        
        buildertek__Quote_Line_Group__c budGroup = new buildertek__Quote_Line_Group__c();
        
        //if(!Test.isRunningTest()){
            buildertek__Quote_Line_Group__c budgetGroup;
          //  if(Schema.sObjectType.buildertek__Quote_Line_Group__c.fields.Id.isAccessible()&&
              //  Schema.sObjectType.buildertek__Quote_Line_Group__c.fields.Name.isAccessible()){
                budgetGroup= [Select Id from buildertek__Quote_Line_Group__c Where Name ='No Grouping'];
              //  }
            if(budgetGroup != null){
                budGroup = budgetGroup;    
            }else{
                budGroup.Name = 'No Grouping';
            //    if(Schema.sObjectType.buildertek__Quote_Line_Group__c.isCreateable()&&
            //   Schema.sObjectType.buildertek__Quote_Line_Group__c.fields.Id.isCreateable() &&
             //  Schema.sObjectType.buildertek__Quote_Line_Group__c.fields.Name.isCreateable()){
                insert budGroup;
             //  }
                
            }    
        //}
        //List<buildertek__Quote__c> allQuote = getQuotesWithLines(QuoteId);
        List<buildertek__Quote__c> allQuote = [SELECT Id, Name, buildertek__Description__c, buildertek__Quote_Amount__c, buildertek__Status__c, buildertek__Project__c, 
                        buildertek__Auto_Number__c, buildertek__Primary__c, buildertek__Markup__c, buildertek__Shipping_and_Handling__c,
                        buildertek__Profit_Margin__c, buildertek__Payment_Terms__c, buildertek__Discount__c, buildertek__Tax__c,
                        buildertek__Expires_On__c, buildertek__Sales_Rep__c, buildertek__Primary_Contact__c, buildertek__Start_Date__c, 
                        buildertek__Bill_To_Name__c, buildertek__Bill_To_Street__c, buildertek__Bill_To_City__c, buildertek__Bill_To_State__c, 
                        buildertek__Bill_To_Country__c, buildertek__Ship_To_Name__c, buildertek__Ship_To_Street__c, buildertek__Ship_To_City__c, 
                        buildertek__Ship_To_State__c, buildertek__Group_Line_Items__c, buildertek__Ship_To_Zip_Code__c, buildertek__Opportunity__c, 
                        buildertek__Email_Body__c, buildertek__Email_Subject__c, buildertek__Ship_To_Country__c, buildertek__Bill_To_Zip_Code__c, 
                        buildertek__SignatureBase64__c,buildertek__Notes__c,buildertek__Quote_File__c,buildertek__Unit_Price__c , Travel_Labor_Premium__c, Travel_Lodging_Premium_25__c, Travel_Premium_25__c,Additional_Total_Premium__c,Fuel_Surcharge_Amount__c
                FROM buildertek__Quote__c
                WHERE Id IN : QuoteId];
        // sakina;'s changes chb 55'
        List<buildertek__Budget_Item__c> budgetItemList = new List<buildertek__Budget_Item__c>();
        List<String> budgetPremiumFieldsList = new  List<String>();
        budgetPremiumFieldsList.add('Travel - Labor Premium (50%)');
        budgetPremiumFieldsList.add('Travel - Lodging Premium (25%)'); 
        budgetPremiumFieldsList.add('Travel - Premium (25%)'); 
        budgetPremiumFieldsList.add('Additional - Total Premium'); 
        budgetPremiumFieldsList.add('Fuel Surcharge Amount'); 
        string budgrpid;
        List<buildertek__Budget_Line_Group__c> budGrouping = [SELECT Id FROM buildertek__Budget_Line_Group__c WHERE Name = 'No Grouping' limit 1];
        if (budGrouping.size() > 0){
              budgrpid = budGrouping[0].Id;
        } else{
            buildertek__Budget_Line_Group__c budgetGroupName = new buildertek__Budget_Line_Group__c();
            budgetGroupName.Name = 'No Grouping';
            insert budgetGroupName;
            budgrpid = budgetGroupName.Id;
        }
        // sakina;'s changes chb 55'

		    
        for(buildertek__Quote__c curQuote : allQuote) {
            // sakina's changes
            System.debug('budgetPremiumFieldsList'+ budgetPremiumFieldsList);

            for(String budgetPremiumFields:budgetPremiumFieldsList){
                buildertek__Budget_Item__c budgetItems1= new buildertek__Budget_Item__c();
                budgetItems1.Name=budgetPremiumFields;
                budgetItems1.buildertek__Quantity__c=1;
                if(budgetPremiumFields=='Travel - Labor Premium (50%)'){
                    budgetItems1.buildertek__Unit_Price__c=curQuote.Travel_Labor_Premium__c;

                }else if(budgetPremiumFields=='Travel - Lodging Premium (25%)'){
                    budgetItems1.buildertek__Unit_Price__c=curQuote.Travel_Lodging_Premium_25__c;


                }else if(budgetPremiumFields=='Travel - Premium (25%)'){
                    budgetItems1.buildertek__Unit_Price__c=curQuote.Travel_Premium_25__c;

                    
                }else if(budgetPremiumFields=='Additional - Total Premium'){
                    budgetItems1.buildertek__Unit_Price__c=curQuote.Additional_Total_Premium__c;

                    
                }else if(budgetPremiumFields=='Fuel Surcharge Amount'){
                    budgetItems1.buildertek__Unit_Price__c=curQuote.Fuel_Surcharge_Amount__c;
                    budgetItems1.buildertek__Sales_Price__c=curQuote.Fuel_Surcharge_Amount__c;

                    
                }
                budgetItemList.add(budgetItems1);

            }
         

            


            //end

            mapBudgetIndex.put(
                intIndex,
                new buildertek__Budget__c(   
                    Name = curQuote.Name,
                    buildertek__Project__c = curQuote.buildertek__Project__c
                )
            );
            quoteIdsList.add(curQuote.Id);
            mapBudgetLinesIndex.put(intIndex, new List<buildertek__Budget_Item__c>());
        }
        
        List<buildertek__Quote_Item__c> quoteItemList = getQuoteLines(quoteIdsList);

        List<buildertek__Budget_Line_Group__c> groupList = [SELECT Id, Name FROM buildertek__Budget_Line_Group__c];

        Map<String, Id> groupMap = new Map<String, Id>();

        for (buildertek__Budget_Line_Group__c groupData : groupList) {
            groupMap.put(groupData.Name, groupData.Id);
        }

        List<buildertek__Budget_Line_Group__c> newGroupList = new List<buildertek__Budget_Line_Group__c>();
        String groupId = budGroup.Id;
        for (buildertek__Quote_Item__c quoteLine : quoteItemList) {
            if (quoteLine.buildertek__Grouping__c != null && quoteLine.buildertek__Grouping__c != groupId) {
                if (!groupMap.containsKey(quoteLine.buildertek__Grouping__r.Name)) {
                    buildertek__Budget_Line_Group__c newGroup = new buildertek__Budget_Line_Group__c();
                    newGroup.Name = quoteLine.buildertek__Grouping__r.Name;
                    newGroupList.add(newGroup);
                }
                groupId = quoteLine.buildertek__Grouping__c;
            }
        }

        if (newGroupList.size() > 0) {
            insert newGroupList;
            for (buildertek__Budget_Line_Group__c groupData : newGroupList) {
                groupMap.put(groupData.Name, groupData.Id);
            }
        }

        idMap.put(intIndex,new List<String>());
        for(buildertek__Quote_Item__c currQuoteLine : quoteItemList) {
            System.debug('currQuoteLine.Material__c ==> '+currQuoteLine.Material__c);
            System.debug('currQuoteLine.Labor__c ==> '+currQuoteLine.Labor__c);
            System.debug('currQuoteLine.Miscellaneous__c ==> '+currQuoteLine.Miscellaneous__c);
            System.debug('currQuoteLine.Equipment__c ==> '+currQuoteLine.Equipment__c);

            mapBudgetLinesIndex.get(intIndex).add(new buildertek__Budget_Item__c(
                Name = currQuoteLine.Name,
                buildertek__Product__c = currQuoteLine.buildertek__Product__c,
                buildertek__Item_Name__c = currQuoteLine.buildertek__Item_Name__c,
                buildertek__Cost_Code__c = currQuoteLine.buildertek__Cost_Code__c,
                buildertek__Quantity__c = currQuoteLine.buildertek__Quantity__c,
                buildertek__Unit_Price__c = currQuoteLine.buildertek__Unit_Cost__c,
                //buildertek__Unit_Price__c = currQuoteLine.buildertek__Net_Unit__c,
                buildertek__Sales_Price__c = currQuoteLine.buildertek__Net_Total_Price__c, 
                buildertek__Budget_Line_Group__c = currQuoteLine.buildertek__Grouping__c,
                buildertek__Group__c = groupMap.get(currQuoteLine.buildertek__Grouping__r.Name),
                buildertek__Markup__c = currQuoteLine.buildertek__Markup__c,

                buildertek__Material_Budget__c =currQuoteLine.Material__c,
                buildertek__Labor_Budget__c	=currQuoteLine.Labor__c,
                buildertek__Misc_Budget__c	=currQuoteLine.Miscellaneous__c,
                buildertek__Equipment_Budget__c = currQuoteLine.Equipment__c
            ));
            if(currQuoteLine.buildertek__Purchase_Order__c!=null){
                poIds.add(currQuoteLine.buildertek__Purchase_Order__c);    
            }
            idMap.get(intIndex).add(currQuoteLine.buildertek__Purchase_Order__c);
        }
         
        intIndex++;
        
        if(!mapBudgetIndex.isEmpty()) {
            List<buildertek__Budget_Item__c> listBudgetItems = new List<buildertek__Budget_Item__c>();
            // if(Schema.sObjectType.buildertek__Budget__c.fields.Name.isCreateable() &&
             //  Schema.sObjectType.buildertek__Budget__c.fields.buildertek__Project__c.isCreateable()){ 
                 insert mapBudgetIndex.values();
             //  }
            system.debug('mapBudgetIndex----'+mapBudgetIndex.values());
            for(Integer currIndex : mapBudgetIndex.keySet()) {

                //sakina'schanges CHB 55
                if(budgetItemList.size() >0){
                    for(buildertek__Budget_Item__c budgetItems: budgetItemList){
                        budgetItems.buildertek__Budget__c=mapBudgetIndex.get(currIndex).Id;
                        budgetItems.buildertek__Group__c = budgrpid;
                    }
                }
                // end sakina's Changes CHB 55


                for(buildertek__Budget_Item__c currBudgetItem : mapBudgetLinesIndex.get(currIndex)) {
                  //  if(Schema.sObjectType.buildertek__Budget_Item__c.fields.buildertek__Budget__c.isCreateable()){ 
                        currBudgetItem.buildertek__Budget__c = mapBudgetIndex.get(currIndex).Id;
                        listBudgetItems.add(currBudgetItem);
                  //  }
                }
            }

            //sakina'schanges CHB 55
            System.debug('budgetItemList'+ budgetItemList);
            if(budgetItemList.size() >0){
                insert budgetItemList;
            }
            // end sakina's Changes CHB 55


            
            if(!listBudgetItems.isEmpty()) {
                insert listBudgetItems;
                 system.debug('listBudgetItems----'+listBudgetItems);
                Map<Integer, List<buildertek__Budget_Item__c>> mapBudgetLines = new Map<Integer, List<buildertek__Budget_Item__c>>();
                Integer i=0;
                for(Integer currIndex : mapBudgetIndex.keySet()) {
                    
                    for(buildertek__Budget_Item__c currBudgetItem : mapBudgetLinesIndex.get(currIndex)) { 
                        if(!mapBudgetLines.containsKey(currIndex)){
                            mapBudgetLines.put(currIndex, new List<buildertek__Budget_Item__c>());
                            mapBudgetLines.get(currIndex).add(listBudgetItems[i]); 
                            i++;
                        }else{
                            mapBudgetLines.get(currIndex).add(listBudgetItems[i]);
                            i++;
                        }
                        
                    }
                }
                
                List<buildertek__Purchase_Order__c> purchaseOrderLst = getPurchaseOrdersWithLines(poIds);
                Map<id,buildertek__Purchase_Order__c> purchaseOrderLstMap = new Map<id,buildertek__Purchase_Order__c>();
                for(buildertek__Purchase_Order__c potemp: purchaseOrderLst){
                    purchaseOrderLstMap.put(potemp.id,potemp);
                }
                List<buildertek__PO_Item_To_Budget_Item_Link__c>  budgetItemLinkRecs= new List<buildertek__PO_Item_To_Budget_Item_Link__c>();

                for(Integer currIndex : idMap.keySet()) {
                    Integer Index=0;
                    for(String temp : idMap.get(currIndex)){
                        if(temp!=null){
                            buildertek__Purchase_Order__c purchaseOrderRec = purchaseOrderLstMap.get(temp);
                            buildertek__Budget_Item__c budgetItemRec = mapBudgetLines.get(currIndex)[Index];
                            for(buildertek__Purchase_Order_Item__c currPOLine : purchaseOrderRec.buildertek__Purchase_Order_Items__r) {

                                buildertek__PO_Item_To_Budget_Item_Link__c budgetItemLinkRec = new buildertek__PO_Item_To_Budget_Item_Link__c();
                                budgetItemLinkRec.buildertek__Approved_PO__c=currPOLine.buildertek__Unit_Price__c;
                                    budgetItemLinkRec.buildertek__PO_Item__c=currPOLine.id;
                                 budgetItemLinkRec.buildertek__Budget_Item__c=budgetItemRec.id;
                                budgetItemLinkRecs.add(budgetItemLinkRec);
                                
                                system.debug('----working in budget contract create helper');
                            }
                        }
                        index++;
                    }
                }
                System.debug('budgetItemLinkRecs :: '+budgetItemLinkRecs);
                if(budgetItemLinkRecs.size()>0){
                   // if (Schema.sObjectType.buildertek__PO_Item_To_Budget_Item_Link__c.fields.buildertek__Approved_PO__c.isCreateable() && 
                      //  Schema.sObjectType.buildertek__PO_Item_To_Budget_Item_Link__c.fields.buildertek__PO_Item__c.isCreateable() &&
                      //   Schema.sObjectType.buildertek__PO_Item_To_Budget_Item_Link__c.fields.buildertek__Budget_Item__c.isCreateable() ) {
                    system.debug('----working in budget contract create helper');   
                    insert budgetItemLinkRecs;
                  //  }
                  system.debug('----working in budget contract create helper');
                }
                  
            }
        }
        
        return mapBudgetIndex.values();
    }
      public static List<buildertek__Quote_Item__c> getQuoteLines(List<Id> quoteIds){
        List<buildertek__Quote_Item__c> quoteItemList;
       
                    
            quoteItemList = [SELECT Id, 
                                    Name, 
                                    buildertek__Item_Name__c,
                                    buildertek__Description__c, 
                                    buildertek__Quantity__c, 
                                    buildertek__Unit_Price__c, 
                                    buildertek__Total_Cost__c, 
                                    buildertek__Quote__c, 
                                    buildertek__Cost_Code__c, 
                                    buildertek__Auto_Number__c, 
                                    buildertek__Product__c, 
                                    buildertek__Grouping__c, 
                                    buildertek__UOM__c, 
                                    buildertek__Vendor__c, 
                                    buildertek__Markup__c, 
                                    buildertek__Unit_Cost__c, 
                                    buildertek__List_Total__c, 
                                    buildertek__Net_Unit__c, 
                                    buildertek__Applied_Markup__c, 
                                    buildertek__Net_Total__c, 
                                    buildertek__MFG_Discount__c,
                                    buildertek__List_Unit_Price__c, 
                                    buildertek__Pricing_Method__c, 
                                    buildertek__Discount__c, 
                                    buildertek__Profit_Margin__c, 
                                    buildertek__Net_Total_Price__c, 
                                    buildertek__Notes__c,
                                     buildertek__Status__c,
                                    buildertek__Purchase_Order__c, 
                                    buildertek__Grouping__r.Name,
                                    Equipment__c, Material__c , Labor__c , Miscellaneous__c	
                                    FROM buildertek__Quote_Item__c
                                    WHERE buildertek__Quote__c IN: quoteIds  And buildertek__Status__c != 'Reject'];      
        
        
        return quoteItemList;
              
    }
    /**
     *  @description Get all Purchase Orders and associated Order Line Items on Purchase Order Id's
     */
    
    public static List<buildertek__Purchase_Order__c> getPurchaseOrdersWithLines(List<Id> listPoIds) {
        List<buildertek__Purchase_Order__c> purchaseorderlist;
        if(Schema.sObjectType.buildertek__Purchase_Order__c.fields.Id.isAccessible() &&
            Schema.sObjectType.buildertek__Purchase_Order_Item__c.fields.Id.isAccessible() &&
            Schema.sObjectType.buildertek__Purchase_Order_Item__c.fields.buildertek__Unit_Price__c.isAccessible() &&
             Schema.sObjectType.buildertek__Purchase_Order_Item__c.fields.buildertek__Purchase_Order__c.isAccessible()){
                purchaseorderlist = [select id,(select id,buildertek__Unit_Price__c from buildertek__Purchase_Order_Items__r) from buildertek__Purchase_Order__c where id In :listPoIds];
        }
        return purchaseorderlist;
    }

}