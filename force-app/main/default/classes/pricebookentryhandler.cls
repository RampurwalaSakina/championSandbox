public without sharing class pricebookentryhandler {

    public static void updateUnitCost(List<PricebookEntry> pricebookentry, Map<Id,PricebookEntry> oldvalue) {
        for (pricebookentry pbe: pricebookentry){
            PricebookEntry oldpbe = oldvalue.get(pbe.Id);
            if(pbe.buildertek__Unit_Cost__c	!= oldpbe.buildertek__Unit_Cost__c){
                System.debug('pbe'+ pbe.buildertek__Unit_Cost__c);
            }
        }
    }
}