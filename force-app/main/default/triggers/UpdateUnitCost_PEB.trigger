trigger UpdateUnitCost_PEB on Product2 (after insert , after update) {
    if(Trigger.isInsert || Trigger.isAfter || Trigger.isUpdate){
        List<Product2> productList = new List<Product2>();
        productList =[Select id , name, (Select id , name From PricebookEntries)  from Product2];
        for(Product2 product : productList){
            for(PricebookEntry  pricebookEntry : product.PricebookEntries){
                System.debug(pricebookEntry);
            }
        }


    }

}