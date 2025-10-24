/*
* @description - Proof of concept class to use Open AI Agent builder in a SF LWC
*/
public without sharing class AgentBuilderController {
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

        // Create Session Body
        SessionBody sb = new SessionBody(workflowId, userId, allowFileUpload);
        req.setBody(JSON.serialize(sb));

        try {
            Http http = new Http();
            HttpResponse res;
            res = http.send(req);
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) result?.get('client_secret');
        } catch (Exception e) {
            System.debug(JSON.serializePretty(e));

            return '';
        }
    }

    public class SessionBody {
      Workflow workflow = new WorkFlow();
      String user = '';
      ChatkitConfiguration chatkit_configuration = new ChatkitConfiguration();

      public sessionBody(String workflowId, String userId, Boolean uploadFiles) {
        workflow.id = workflowId;
        user = userId;
        chatkit_configuration.file_upload.enabled = uploadFiles;
      }

    }

    public class WorkFlow {
        public String id = '';
    }

    public class ChatkitConfiguration {
        FileUpload file_upload = new FileUpload();
    }

    public class FileUpload {
        public Boolean enabled = false;
    }
}