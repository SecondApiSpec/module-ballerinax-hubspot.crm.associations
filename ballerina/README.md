## Overview

[HubSpot](https://www.hubspot.com/) is a cloud-based customer relationship management (CRM) platform that helps businesses grow by providing tools for marketing, sales, customer service, and content management, all unified on a single platform.

The `ballerinax/hubspot.crm.associations` package offers APIs to connect and interact with [HubSpot CRM Associations API](https://developers.hubspot.com/docs/api/crm/associations) endpoints, specifically based on [HubSpot CRM Associations API v4](https://developers.hubspot.com/docs/api/crm/associations).
## Setup guide

To use the HubSpot CRM Associations connector, you must have access to the HubSpot API through a [HubSpot developer account](https://developers.hubspot.com/) and obtain an API access token. If you do not have a HubSpot account, you can sign up for one [here](https://app.hubspot.com/signup-hubspot/crm).

### Step 1: Create a HubSpot Account

1. Navigate to the [HubSpot website](https://www.hubspot.com/) and sign up for an account or log in if you already have one.

2. Note that while HubSpot offers a free CRM, certain API features and higher rate limits may require a Professional or Enterprise plan subscription depending on your usage requirements.

### Step 2: Generate an API Access Token

HubSpot uses private apps to generate access tokens for API authentication. Follow these steps to create one:

1. Log in to your HubSpot account.

2. In the main navigation bar, click the Settings icon (gear icon) in the top right corner.

3. In the left sidebar menu, navigate to Integrations > Private Apps.

4. Click Create a private app.

5. On the Basic Info tab, provide a name and description for your app.

6. Navigate to the Scopes tab and select the required scopes for CRM associations (such as `crm.objects.contacts.read`, `crm.objects.contacts.write`, `crm.objects.companies.read`, `crm.objects.companies.write`, and other relevant object scopes).

7. Click Create app in the top right corner, then review the information and click Continue creating.

8. Once created, your access token will be displayed. Click Show token to reveal it.

> **Tip:** You must copy and store this key somewhere safe. It won't be visible again without clicking "Show token" and for security reasons, you should treat it as a sensitive credential.
## Quickstart

To use the `HubSpot CRM Associations` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerina/oauth2;
import ballerinax/hubspot.crm.associations as hscrmassociations;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the obtained credentials:

```toml
clientId = "<Your_Client_Id>"
clientSecret = "<Your_Client_Secret>"
refreshToken = "<Your_Refresh_Token>"
```

2. Create a `hscrmassociations:ConnectionConfig` and initialize the client:

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

final hscrmassociations:Client hscrmassociationsClient = check new ({
    auth: {
        clientId,
        clientSecret,
        refreshToken
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create associations between objects

```ballerina
public function main() returns error? {
    hscrmassociations:BatchInputPublicAssociationMultiPost payload = {
        inputs: [
            {
                'from: {
                    id: "12345"
                },
                to: {
                    id: "67890"
                },
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 1
                    }
                ]
            }
        ]
    };

    hscrmassociations:BatchResponseLabelsBetweenObjectPair response = check hscrmassociationsClient->/associations/["contacts"]/["companies"]/batch/create.post(payload);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```
## Examples

The `hubspot.crm.associations` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples), covering the following use cases:

1. [Create delete associations](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/create-delete-associations) - Demonstrates how to create and delete associations between CRM objects.
2. [Deal association workflow](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/deal-association-workflow) - Illustrates managing deal associations in a workflow scenario.
3. [Create read associations](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/examples/create-read-associations) - Shows how to create and retrieve associations between CRM records.