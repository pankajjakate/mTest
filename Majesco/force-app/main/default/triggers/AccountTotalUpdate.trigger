trigger AccountTotalUpdate on Account (after update){
	set<id> accountIdList = new Set<Id>();
	Map<id, Double> accountIdMapTotal = new Map<id, Double>();
    List<Contact> contactUpdateShare = new List<Contact>();
    
	if(trigger.isAfter && trigger.isUpdate){
		if(!trigger.new.isEmpty()){
			for(Account acc: trigger.new){
                if(acc.total__c == null || acc.total__c == 0) {
                    acc.total__c.addError('Total Filed is should not be empty or null');
                }else  if(trigger.oldMap != null && acc.total__c != trigger.oldMap.get(acc.id).total__c){
                  	accountIdMapTotal.put(acc.id, acc.total__c);	
                }
			}
		}
	}
	
	Map<id, List<Contact>> accMapContactList = new Map<id, List<Contact>>();
	if(!accountIdMapTotal.isEmpty()){
		for(Contact con : [Select id, name, AccountId from Contact where AccountId in: accountIdMapTotal.keySet()]){
			if(!accMapContactList.containsKey(con.AccountId)){
				accMapContactList.put(con.AccountId, new List<Contact>{con});
			}else{
				List<Contact> conList = new List<Contact>();
				if(accMapContactList.containsKey(con.AccountId)){
					conList = accMapContactList.get(con.AccountId);
				}
				conList.add(con);
				accMapContactList.put(con.AccountId, conList);
			}
		}
	}
	
	if(!accMapContactList.isEmpty()){
		
		for(Id accId: accountIdMapTotal.keySet()){
            system.debug('accId ' + accId);
			List<Contact> contoUpdate = accMapContactList.get(accId);
			
			if(!contoUpdate.isEmpty()){
				Decimal profitShare = Decimal.valueOf(accountIdMapTotal.get(accId)).divide(contoUpdate.size(), 2);
				Decimal leftOverProfitAmount = (accountIdMapTotal.get(accId) - (profitShare * contoUpdate.size()));
				
                /*system.debug('## Total ' + accountIdMapTotal.get(accId));
                system.debug('## profitShare ' + profitShare);
                system.debug('## leftOverProfitAmount ' + leftOverProfitAmount);
                
                if(accountIdMapTotal.get(accId) != (profitShare + leftOverProfitAmount)){
                    system.debug('## Total ' + accountIdMapTotal.get(accId) + ' != sharedTotal' + (profitShare + leftOverProfitAmount));
                }*/
                
                //leftOverProfitAmount this has to distribut some where in the contact
                //Right now I have shared it to the first contact or can have options
                //1. We can create check box primary contact or something and share him
                //2. Random contact can have leftOverProfitAmount
				Boolean isFirstTime = true;
				for(contact con: contoUpdate){
					if(isFirstTime){
						con.share__c = profitShare + leftOverProfitAmount;
                        isFirstTime = false;
					}else{
						con.share__c = profitShare;
					}
					contactUpdateShare.add(con);
				}
			}
		}
	}
	
	if(!contactUpdateShare.isEmpty()){
		update contactUpdateShare;
	}
}