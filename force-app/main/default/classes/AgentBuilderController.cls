/**
 * @description Proof of concept class to use OpenAI Agent builder in a Salesforce LWC.
 * Handles session creation and configuration for chatkit integration.
 */
public without sharing class AgentBuilderController {
  
  /**
   * Creates a session with OpenAI chatkit and returns a client secret token.
   * @param allowFileUpload Indicates if file upload should be enabled for the session.
   * @return The client secret token for chatkit, or empty string if failed.
   */
  @AuraEnabled
  public static String createSession(Boolean allowFileUpload) {
    String endpoint = 'callout:openAI/v1/chatkit/sessions';
    HttpRequest req = new HttpRequest();
    req.setEndpoint(endpoint);
    req.setMethod('POST');
    req.setHeader('Authorization', '{!$Credential.Password}');
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('OpenAI-Beta', 'chatkit_beta=v1');
    
    
    // Enrich Session with SF information
    String workflowId = [SELECT Id, Workflow_ID__c FROM Agent_Settings__c LIMIT 1]?.Workflow_ID__c;
    // Don't put on guest site...
    String userId = UserInfo.getUserId();
    
    if (workflowId == null) {
      System.debug('Fill out Workflow_ID__c on Agent_Settings__c to get a valid Client token');
      return '';
    }
    
    
    // Create Session Body
    SessionBody body = new SessionBody(workflowId, userId, allowFileUpload);
    req.setBody(JSON.serialize(body));
    
    try {
      Http http = new Http();
      HttpResponse res;
      res = http.send(req);
      if (res.getStatusCode() != 200) {
        System.debug(JSON.serializePretty(res));
        return '';
      }
      Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
      return (String) result?.get('client_secret');
    } catch (Exception e) {
      System.debug(JSON.serializePretty(e));
      
      return '';
    }
  }
  
  /**
   * Wrapper for session body sent to OpenAI chatkit API.
   */
  public class SessionBody {
    Workflow workflow = new WorkFlow();
    String user = '';
    ChatkitConfiguration chatkit_configuration = new ChatkitConfiguration();
    
    /**
     * Constructor for SessionBody.
     * @param workflowId The workflow ID to use for the session.
     * @param userId The Salesforce user ID.
     * @param uploadFiles Whether file upload is enabled.
     */
    public sessionBody(String workflowId, String userId, Boolean uploadFiles) {
      workflow.id = workflowId;
      user = userId;
      chatkit_configuration.file_upload.enabled = uploadFiles;
    }
  }
  
  /**
   * Represents workflow configuration for chatkit session.
   */
  public class WorkFlow {
    public String id = '';
  }
  
  /**
   * Represents chatkit configuration options.
   */
  public class ChatkitConfiguration {
    FileUpload file_upload = new FileUpload();
  }
  
  /**
   * Represents file upload configuration for chatkit.
   */
  public class FileUpload {
    public Boolean enabled = false;
  }
}