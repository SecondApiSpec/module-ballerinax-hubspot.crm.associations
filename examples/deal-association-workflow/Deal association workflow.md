# Deal Association Workflow

This example demonstrates how to automate a customer onboarding workflow by managing associations between HubSpot CRM objects. The script retrieves existing company associations, creates default and custom labeled associations between deals, contacts, and companies, and verifies the created relationships.

## Prerequisites

1. **HubSpot Setup**
   > Refer to the [HubSpot setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/blob/main/ballerina/Package.md#setup-guide) to obtain your access token.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your HubSpot credentials:

   ```toml
   hubspotAccessToken = "<Your HubSpot Access Token>"
   ```

3. **Update Object IDs**
   
   Before running the example, update the following constants in `main.bal` with your actual HubSpot object IDs:
   
   - `CLOSED_WON_DEAL_ID` - The ID of the deal to associate
   - `COMPANY_ID` - The ID of the company to link
   - `PRIMARY_CONTACT_ID` - The ID of the primary contact
   - `PRIMARY_CUSTOMER_ASSOCIATION_TYPE_ID` - Your custom association type ID for "Primary Customer" label

## Run the Example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

Upon successful execution, you will see output showing:
- Existing company-to-contact and company-to-deal associations
- Creation of a default association between the deal and primary contact
- Creation of a custom "Primary Customer" labeled association between the deal and company
- Verification of all created associations