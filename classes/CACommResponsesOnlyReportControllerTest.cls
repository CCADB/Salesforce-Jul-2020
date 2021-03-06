/*******************************************************************************************************
 Name: CACommResponsesOnlyReportControllerTest

 Dependencies: CACommResponsesOnlyReportController class, CACommResponsesOnlyReportControllerTest Test class,
 CACommResponsesOnlyReportController VF page
 
 Description: This custom report lists responses of all CA Owners for the specific action item(s). 

 A CommunicationId and one/two/three QuestionIds are passed as parameters:
 CommunicationId=<Record id of CA Communication record> 
 QuestionId=<Question Id,Question Id, Question Id> 

 Example: https://ccadb-public.secure.force.com/mozillacommunications/CACommResponsesOnlyReport?CommunicationId=a051J00003waNOW&QuestionId=Q00084,Q00085,Q00098

 Instructions: None
 
 *******************************************************************************************************
 Revision History:
 
     01/21/2020 - Created new class
                
 ******************************************************************************************************/
 
@isTest
private class CACommResponsesOnlyReportControllerTest{

    static testmethod void testSurveyReport() {
    
        // intialize the class which has the test data
        
        PageReference pageRef = Page.CACommResponsesOnlyReport;
        
        // create a CA Owner
        Account caOwnerAccount= getCAOwnerAccount();
        insert caOwnerAccount;
        
        // create a contact who would take the survey
        Contact contactSo = New Contact();
        contactSo.lastName = 'test';
        contactSo.accountId = caOwnerAccount.id;
        insert contactSo;
        
        // create a survey
        CA_Communication__c commSO = New CA_Communication__c ();
        commSo.name='Test';
        commSo.message__c='Test';
        insert commso;
        try{
            // create a dummy question 
            CA_Comm_Question__c  commQuestSo = new CA_Comm_Question__c ();
            commQuestSo.CA_Comm__c = commSo.id;
            commQuestSo.Order_No__c = 1;
            commQuestSo.Question__c = 'test';
            commQuestSo.Default_Text__c = 'Default Text';
            commQuestSo.question_type__c = 'Free Text (Multi line text box)';
            insert commQuestSo;
            CA_Comm_Question__c   commQuestDML1 = [select name from CA_Comm_Question__c   where id = :commQuestSo.id limit 1];
            
            // create a dummy text question 
            CA_Comm_Question__c  commQuestSo2 = new CA_Comm_Question__c ();
            commQuestSo2.CA_Comm__c = commSo.id;
            commQuestSo2.Order_No__c = 2;
            commQuestSo2.Question__c = 'test';
            commQuestSo2.question_type__c = 'Free Text (Multi line text box)';
            insert commQuestSo2;
            CA_Comm_Question__c   commQuestDML2 = [select name from CA_Comm_Question__c   where id = :commQuestSo2.id limit 1];    
            
            // create dummy responses 
            CA_Comm_Response__c  commResponse = New CA_Comm_Response__c ();
            commResponse.Question_Id__c= commQuestSo.id;
            commResponse.response__c = 'test';
            commResponse.ca_owner__c = caOwnerAccount.id;
            commResponse.contact__c = contactSo.id;
            insert commResponse;
            CA_Comm_Response__c  commResponse2 = New CA_Comm_Response__c ();
            commResponse2.Question_Id__c= commQuestSo.id;
            commResponse2.response__c = 'test';
            commResponse2.ca_owner__c = caOwnerAccount.id;
            commResponse2.contact__c = contactSo.id;
            insert commResponse2;
            
            // response for text question
            CA_Comm_Response__c  commResponse3 = New CA_Comm_Response__c ();
            commResponse3.Question_Id__c= commQuestSo2.id;
            commResponse3.response__c = 'test';
            commResponse3.ca_owner__c = caOwnerAccount.id;
            commResponse3.contact__c = contactSo.id;
            insert commResponse3;
            
            // set the survey id as one of the page parameters, this is used by the controller class 
            pageRef.getParameters().put('CommunicationId', commSo.id);  
            pageRef.getParameters().put('QuestionId', commQuestDML1.name+','+commQuestDML2.name+','+commQuestDML2.name);
            
            
            
            // set the current page reference
            Test.setCurrentPage(pageRef); 
            
            // initialize the controller class 
            CACommResponsesOnlyReportController commSummReportController= new CACommResponsesOnlyReportController();
            // CACommResponsesMultipleReportController controller = new CACommResponsesMultipleReportController();
        } 
        catch(Exception ex) {
            system.debug( 'Exception: ' + ex.getTypeName() + ': ' + ex.getMessage() 
            + ' -- ' + ex.getCause() + ' -- ' + ex.getLineNumber() );
        }
    
    }
    
    static testmethod void testSurveyReportNegativeScenario1() {
        // intialize the class which has the test data
        
        PageReference pageRef = Page.CACommResponsesOnlyReport;
        
        // set the current page reference
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('QuestionId', '');
        pageRef.getParameters().put('QuestionIdForText', '');
        
        // initialize the controller class 
        CACommResponsesOnlyReportController commSummReportController= new CACommResponsesOnlyReportController();
        // CACommResponsesMultipleReportController controller = new CACommResponsesMultipleReportController();
    }
        
    static testmethod void testSurveyReportNegativeScenario2() {
        
        // intialize the class which has the test data
        
        PageReference pageRef = Page.CACommResponsesOnlyReport;
        
        // set the current page reference
        Test.setCurrentPage(pageRef); 
        
        // initialize the controller class 
        CACommResponsesOnlyReportController commSummReportController= new CACommResponsesOnlyReportController();
        // CACommResponsesMultipleReportController controller = new CACommResponsesMultipleReportController();
    }
        
    public static Account getCAOwnerAccount(){
        Account parentAccount = new Account();
        parentAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Owner').getRecordTypeID();
        parentAccount.name = 'ParentAccount';
        parentAccount.type = 'Owner';
        parentAccount.status__c= 'Included';
        parentAccount.Revocation_Status__c = 'Included';
        parentAccount.phone='2128425500';
        parentAccount.website  = 'https//www.test.com';
        parentAccount.valid_From_GMT__c= date.today()+1;
        parentAccount.valid_to_GMT__c= date.today()+10;
        parentAccount.company_website__c=  'https//www.test.com';
        parentAccount.organizational_type__c=  'Organizational Type';
        parentAccount.geographic_focus__c=  'Geographic focus';
        parentAccount.primary_market_customer_base__c = 'Primary Market';
        return parentAccount;
    }

}