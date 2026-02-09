import ballerina/io;
import ballerinax/hubspot.crm.associations;

configurable string hubspotAccessToken = ?;

const string CLOSED_WON_DEAL_ID = "12345678901";
const string COMPANY_ID = "98765432101";
const string PRIMARY_CONTACT_ID = "11122233344";

const int:Signed32 PRIMARY_CUSTOMER_ASSOCIATION_TYPE_ID = 341;

public function main() returns error? {
    io:println("=== Customer Onboarding Association Workflow ===");
    io:println("Processing closed-won deal: ", CLOSED_WON_DEAL_ID);
    io:println();

    associations:ConnectionConfig config = {
        auth: {
            token: hubspotAccessToken
        }
    };
    
    associations:Client hubspotClient = check new (config);
    io:println("Successfully initialized HubSpot CRM Associations client");
    io:println();

    io:println("--- Step 1: Retrieving existing associations for company ---");
    io:println("Company ID: ", COMPANY_ID);
    
    associations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging companyContactAssociations = 
        check hubspotClient->/objects/["companies"]/[COMPANY_ID]/associations/["contacts"]();
    
    io:println("Found ", companyContactAssociations.results.length(), " contact associations for the company");
    
    foreach associations:MultiAssociatedObjectWithLabel association in companyContactAssociations.results {
        io:println("  - Contact ID: ", association.toObjectId);
        foreach associations:AssociationSpecWithLabel assocType in association.associationTypes {
            string? labelValue = assocType?.label;
            string labelInfo = labelValue is string ? labelValue : "No label";
            int:Signed32 typeIdValue = assocType.typeId;
            string categoryValue = assocType.category;
            io:println("    Type ID: ", typeIdValue, ", Category: ", categoryValue, ", Label: ", labelInfo);
        }
    }
    io:println();

    associations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging companyDealAssociations = 
        check hubspotClient->/objects/["companies"]/[COMPANY_ID]/associations/["deals"]();
    
    io:println("Found ", companyDealAssociations.results.length(), " existing deal associations for the company");
    foreach associations:MultiAssociatedObjectWithLabel dealAssoc in companyDealAssociations.results {
        io:println("  - Deal ID: ", dealAssoc.toObjectId);
    }
    io:println();

    io:println("--- Step 2: Creating default association between deal and primary contact ---");
    io:println("Deal ID: ", CLOSED_WON_DEAL_ID);
    io:println("Primary Contact ID: ", PRIMARY_CONTACT_ID);
    
    associations:BatchResponsePublicDefaultAssociation dealContactAssociationResult = 
        check hubspotClient->/objects/["deals"]/[CLOSED_WON_DEAL_ID]/associations/default/["contacts"]/[PRIMARY_CONTACT_ID].put();
    
    io:println("Association creation status: ", dealContactAssociationResult.status);
    io:println("Completed at: ", dealContactAssociationResult.completedAt);
    
    foreach associations:PublicDefaultAssociation result in dealContactAssociationResult.results {
        io:println("  Created association - From: ", result.'from.id, " To: ", result.to.id);
        anydata typeIdAnydata = result.associationSpec["typeId"];
        anydata categoryAnydata = result.associationSpec["category"];
        int:Signed32? specTypeId = typeIdAnydata is int:Signed32 ? typeIdAnydata : ();
        string? specCategory = categoryAnydata is string ? categoryAnydata : ();
        io:println("  Association Type ID: ", specTypeId, ", Category: ", specCategory);
    }
    
    int:Signed32? numErrorsValue = dealContactAssociationResult.numErrors;
    if numErrorsValue is int:Signed32 && numErrorsValue > 0 {
        io:println("  Warning: ", numErrorsValue, " errors occurred during association creation");
        associations:StandardError[]? errorsArray = dealContactAssociationResult.errors;
        if errorsArray is associations:StandardError[] {
            foreach associations:StandardError err in errorsArray {
                io:println("    Error: ", err.message);
            }
        }
    }
    io:println();

    io:println("--- Step 3: Creating custom labeled association (Primary Customer) ---");
    io:println("Deal ID: ", CLOSED_WON_DEAL_ID);
    io:println("Company ID: ", COMPANY_ID);
    io:println("Label: Primary Customer");
    
    associations:AssociationSpec[] associationSpecs = [
        {
            associationCategory: "USER_DEFINED",
            associationTypeId: PRIMARY_CUSTOMER_ASSOCIATION_TYPE_ID
        }
    ];
    
    associations:LabelsBetweenObjectPair labeledAssociationResult = 
        check hubspotClient->/objects/["deals"]/[CLOSED_WON_DEAL_ID]/associations/["companies"]/[COMPANY_ID].put(associationSpecs);
    
    io:println("Created labeled association successfully!");
    io:println("  From Object ID: ", labeledAssociationResult.fromObjectId, " (Type: ", labeledAssociationResult.fromObjectTypeId, ")");
    io:println("  To Object ID: ", labeledAssociationResult.toObjectId, " (Type: ", labeledAssociationResult.toObjectTypeId, ")");
    io:println("  Labels: ", labeledAssociationResult.labels);
    io:println();

    io:println("--- Step 4: Verifying created associations ---");
    
    associations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging dealContactVerification = 
        check hubspotClient->/objects/["deals"]/[CLOSED_WON_DEAL_ID]/associations/["contacts"]();
    
    io:println("Deal-to-Contact associations:");
    foreach associations:MultiAssociatedObjectWithLabel contactAssoc in dealContactVerification.results {
        io:println("  - Contact ID: ", contactAssoc.toObjectId);
        foreach associations:AssociationSpecWithLabel assocType in contactAssoc.associationTypes {
            string? labelVal = assocType?.label;
            string labelDisplay = labelVal is string ? labelVal : "Default";
            int:Signed32 typeIdVal = assocType.typeId;
            io:println("    Association: ", labelDisplay, " (Type: ", typeIdVal, ")");
        }
    }
    
    associations:CollectionResponseMultiAssociatedObjectWithLabelForwardPaging dealCompanyVerification = 
        check hubspotClient->/objects/["deals"]/[CLOSED_WON_DEAL_ID]/associations/["companies"]();
    
    io:println("Deal-to-Company associations:");
    foreach associations:MultiAssociatedObjectWithLabel companyAssoc in dealCompanyVerification.results {
        io:println("  - Company ID: ", companyAssoc.toObjectId);
        foreach associations:AssociationSpecWithLabel assocType in companyAssoc.associationTypes {
            string? labelVal = assocType?.label;
            string labelDisplay = labelVal is string ? labelVal : "Default";
            int:Signed32 typeIdVal = assocType.typeId;
            string categoryVal = assocType.category;
            io:println("    Association: ", labelDisplay, " (Type: ", typeIdVal, ", Category: ", categoryVal, ")");
        }
    }
    io:println();

    io:println("=== Customer Onboarding Association Workflow Complete ===");
    io:println("Summary:");
    io:println("  - Retrieved existing company associations for relationship analysis");
    io:println("  - Created default association between deal and primary contact");
    io:println("  - Created custom 'Primary Customer' labeled association between deal and company");
    io:println("  - Verified all associations were created successfully");
    io:println();
    io:println("The deal is now properly linked for accurate reporting and pipeline tracking.");
}