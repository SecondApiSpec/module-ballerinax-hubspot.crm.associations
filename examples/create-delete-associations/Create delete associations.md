# Create Delete Associations

This example demonstrates how to manage CRM associations between HubSpot objects using the Ballerina HubSpot CRM Associations connector. The script creates default and labeled associations between deals and companies, reads the associations, and then deletes them (both specific labeled associations and all associations).

## Prerequisites

1. **HubSpot Setup**
   > Refer to the [HubSpot setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations/tree/main/ballerina/Package.md) to obtain OAuth2 credentials.

2. **Configuration**
   
   Create a `Config.toml` file in the project root directory with your HubSpot OAuth2 credentials:

   ```toml
   clientId = "<Your Client ID>"
   clientSecret = "<Your Client Secret>"
   refreshToken = "<Your Refresh Token>"
   ```

3. **HubSpot CRM Data**
   
   Ensure you have valid deal and company object IDs in your HubSpot account. Update the following constants in `main.bal` with your actual object IDs:
   
   ```ballerina
   const string FROM_OBJECT_ID = "46989749974";  // Your deal ID
   const string TO_OBJECT_ID = "43500581578";    // Your company ID
   ```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

Upon successful execution, you will see output showing:
- Creation of default associations between the deal and company
- Creation of labeled associations with a user-defined association type
- Reading of associations between the objects
- Deletion of specific labeled associations
- Reading associations after specific deletion
- Deletion of all remaining associations
- Final read confirming all associations have been removed