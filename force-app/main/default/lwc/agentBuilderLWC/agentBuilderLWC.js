import { LightningElement } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import createSession from "@salesforce/apex/AgentBuilderController.createSession";
import chatkit from "@salesforce/resourceUrl/chatkit";

export default class AgentBuilderLWC extends LightningElement {
  chatkitInitialized = false;

  async renderedCallback() {
    if (this.chatkitInitialized) {
      return;
    }

    this.chatkitInitialized = true;
    loadScript(this, chatkit).then(() => {
      const container = this.template.querySelector(".chatkit-container");
      const chatkitElement = document.createElement("openai-chatkit");
      container.appendChild(chatkitElement);

      chatkitElement.setOptions({
        api: {
          getClientSecret() {
            return createSession({ allowFileUpload: false });
          }
        }
      });
    });
  }
}