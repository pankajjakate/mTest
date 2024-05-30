@isTest
public class AccountTotalUpdate_Test {
    @TestSetup
    static void createTestData() {
       createAccountWithContactData(3, 100);
    }
    
    static void createAccountWithContactData(Integer noContact, Decimal total) {
        Account acc = new Account();
        acc.Name = 'test name';
        acc.total__c = total;
        insert acc;

        List<Contact> contactList = new List<Contact>();
        for(Integer i =0; i<noContact; i++){
            Contact c = new Contact();
            c.LastName = 'text Contact' + i ;
            c.AccountId = acc.Id;
            contactList.add(c);
        }
       insert contactList;
    }
    
    @isTest
    static void checkTotalandShareTest(){
        test.StartTest();
        List<Account> account = [SELECT id, name , total__c from Account];
        List<Contact> contacts = [SELECT id, name , share__c from Contact where accountId in : account];
        
        system.assertEquals(account.size(), 1);
        system.assertEquals(contacts.size(), 3);
        
        account[0].total__c = 120;
        update account[0];
        
        account = [SELECT id, name , total__c from Account];
        contacts = [SELECT id, name , share__c from Contact where accountId in : account];
        
        Decimal totalShare = 0;
        for(Contact con: contacts){
            totalShare += con.share__c;
        }        
        system.assertEquals(totalShare, account[0].total__C);
        
        test.StopTest();
    }
}