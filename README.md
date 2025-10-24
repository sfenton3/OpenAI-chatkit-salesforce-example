
# OpenAI ChatKit Salesforce Example

>This project demonstrates how to integrate OpenAI's ChatKit with Salesforce using Lightning Web Components (LWC), Apex, and Named Credentials.

## Overview

This Salesforce DX project provides a proof-of-concept for embedding OpenAI ChatKit into Salesforce. It uses a custom LWC (`agentBuilderLWC`) and Apex controller (`AgentBuilderController.cls`) to securely create chat sessions and interact with OpenAI via Named Credentials.

## Main Components

- **Apex Controller**: `AgentBuilderController.cls` handles session creation.
- **LWC**: `agentBuilderLWC` loads the ChatKit widget and connects it to the backend via Apex.
- **Static Resource**: `chatkit.js` is the ChatKit widget loaded in the LWC.
- **Named Credential**: `openAI.namedCredential-meta.xml` securely stores API credentials for outbound calls.
- **Custom Object**: `Agent_Settings__c` stores configuration such as workflow IDs.

## Setup Instructions

1. **Clone the repository**
2. **Authorize your Salesforce org**
	```
	sfdx auth:web:login -a <your-org-alias>
	```
3. **Deploy the source to your org**
	```
	sfdx force:source:deploy -p force-app
	```
4. **Configure Named Credential**
	- Update `openAI.namedCredential-meta.xml` with your OpenAI API credentials.
5. **Assign permissions**
	- Ensure users have access to the custom object and Apex class.
6. **Add the LWC to a Lightning page**
	- Drag `agentBuilderLWC` onto your desired Lightning page.

## Usage

Once deployed, users can interact with the ChatKit widget directly in Salesforce. The widget uses the Apex controller to create secure sessions and communicate with OpenAI.

## Project Structure

- `force-app/main/default/classes/AgentBuilderController.cls`: Apex backend logic
- `force-app/main/default/lwc/agentBuilderLWC/`: LWC frontend
- `force-app/main/default/staticresources/chatkit.js`: ChatKit widget
- `force-app/main/default/namedCredentials/openAI.namedCredential-meta.xml`: API credentials
- `force-app/main/default/objects/Agent_Settings__c/`: Custom object for configuration

## Testing & Development

- Run unit tests with:
  ```
  npm run test:unit
  ```
- Lint and format code:
  ```
  npm run lint
  npm run prettier
  ```

## Resources

- [OpenAI ChatKit Documentation](https://platform.openai.com/docs/chatkit)
- [Salesforce DX Documentation](https://developer.salesforce.com/tools/vscode/)

---
For questions or contributions, please open an issue or pull request.

## Steps to Setup:

1. Make sure you have an OpenAI Account and have deployed a Agent Builder
2. Deploy a Agent Builder and copy workflow ID, fill in on Agent Builder custom setting.
3. Generate an OpenAI API key on OpenAI profile page and copy key, fill in on named credential under password.
4. Add your scatch org or dev org domain as a whitelisted domain on OpenAI profile page

## Troubleshooting steps
1. Make sure OpenAI API key is entered on Named Credential
2. Make sure Agent Builder custom setting has your Workflow ID and that the workflow is Deployed
3. Make sure you have your org whitelisted on openAI or you will get a verification error. It can take 15 minutes for this to propogate
4. Make sure the CSP for the openAPI cdn is enabled, or you cannot use the iframe.
5. ...
