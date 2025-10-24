@isTest
public class AgentBuilderControllerTest {
  @isTest
  static void testCreateSessionReturnsEmptyWhenNoWorkflowId() {
    // Setup: Remove workflow ID from Agent_Settings__c
    Agent_Settings__c settings = new Agent_Settings__c();
    settings.Workflow_ID__c = null;
    insert settings;
    
    Test.startTest();
    String result = AgentBuilderController.createSession(false);
    Test.stopTest();
    
    System.assertEquals('', result, 'Should return empty string when no workflow ID');
  }
  
  @isTest
  static void testCreateSessionReturnsTokenWhenWorkflowIdPresent() {
    // Setup: Add workflow ID to Agent_Settings__c
    Agent_Settings__c settings = new Agent_Settings__c();
    settings.Workflow_ID__c = 'test-workflow-id';
    insert settings;
    
    // Mock HTTP callout
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new AgentBuilderControllerMock());
    String result = AgentBuilderController.createSession(false);
    Test.stopTest();
    
    System.assertEquals('mocked-token', result, 'Should return mocked token from callout');
  }
}