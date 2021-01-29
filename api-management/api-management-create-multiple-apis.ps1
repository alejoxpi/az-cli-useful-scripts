#==========================================
# @title:  Script para la creacion de APIs y Operaciones en el servicio API Management de Azure
# @author: Jose Alejandro Benitez Aragon
# @date:   27-01-2021
# Licensed under the MIT License. @alejoxpi
#
# This script allows the automated creation of APIs and their operations on the Azure API Management service using the az cli.
#
# By configuring the parameters, the APIs array and their respective operations, 
# executing the script the records will be created in the defined API Management service and only 
# some minor aspects will remain pending like Product, Tags.
#  
# Useful info
# https://www.thinktecture.com/en/azure/exposing-apis-using-azure-api-management/
# https://blogvaronis2.wpengine.com/powershell-array/
# https://dev.to/markusmeyer13/create-azure-api-management-api-operation-with-azure-cli-4pg6
#==========================================

$ResourceGroup = "Resource-Group-Name"
$Subscription = "1afad5e0-a878-44b0-8c8c-211123332f7e78"
$ApiManagementServiceName = "APIM-DEV-01"

az account set --subscription $Subscription

#Array of object, 1st level contains API that will be created.
#2nd contains the operations of the API.
$inputAPI = @(
    [pscustomobject]@{
        ApiID='api-products-dev';
        ApiName='API-PRODUCTS-DEV';
        SourceServiceURL='https://api-products-dev.azuresites.net/api';
        ApiPath='/products-dev';
        ApiDescription='Description of API';
        ApiType = "http";        
        Protocols = "https";
        operaciones = @(
            [pscustomobject]@{
                OperationName='Health Check';
                OperationPath="/v1/HealthCheck";
                OperationMethod = "GET";
                OperationDescription = "Health check of the service";
            },
            [pscustomobject]@{
                OperationName='Create Product';
                OperationPath="/v1/CreateProduct";
                OperationMethod = "POST";
                OperationDescription = "Let you create a product";
            },
            [pscustomobject]@{
                OperationName='Delete Product';
                OperationPath="/v1/DeleteProduct";
                OperationMethod = "DELETE";
                OperationDescription = "Let you delete a product";
            }
        )
    },
    [pscustomobject]@{
        ApiID='api-customers-dev';
        ApiName='API-CUSTOMERS-DEV';
        SourceServiceURL='https://api-customers-dev.azuresites.net/api';
        ApiPath='/customers-dev';
        ApiDescription='Description of API';
        ApiType = "http";        
        Protocols = "https";
        operaciones = @(
            [pscustomobject]@{
                OperationName='Health Check';
                OperationPath="/v1/HealthCheck";
                OperationMethod = "GET";
                OperationDescription = "Health check of the service";
            },
            [pscustomobject]@{
                OperationName='Create Customer';
                OperationPath="/v1/CreateCustomer";
                OperationMethod = "POST";
                OperationDescription = "Let you create a customer";
            },
            [pscustomobject]@{
                OperationName='Delete Customer';
                OperationPath="/v1/DeleteCustomer";
                OperationMethod = "DELETE";
                OperationDescription = "Let you delete a customer";
            }
        )
    }

)

#Loop over APIs
for($i=0; $i -lt $inputAPI.Length; $i++)
{
    az apim api create  `
    --api-id $inputAPI[$i].ApiID  `
    --display-name $inputAPI[$i].ApiName  `
    --path $inputAPI[$i].ApiPath  `
    --resource-group $ResourceGroup  `
    --service-name $ApiManagementServiceName  `
    --api-type $inputAPI[$i].ApiType  `
    --description $inputAPI[$i].ApiDescription  `
    --protocols $inputAPI[$i].Protocols  `
    --service-url $inputAPI[$i].SourceServiceURL  `
    --subscription $Subscription  `
    --verbose
    
#loop over operations
    for($j=0; $j -lt $inputAPI[$i].operaciones.Length; $j++)
    {
        az apim api operation create  `
        --api-id $inputAPI[$i].ApiID  `
        --display-name $inputAPI[$i].operaciones[$j].OperationName  `
        --method $inputAPI[$i].operaciones[$j].OperationMethod  `
        --resource-group $ResourceGroup  `
        --service-name $ApiManagementServiceName  `
        --url-template $inputAPI[$i].operaciones[$j].OperationPath  `
        --description $inputAPI[$i].operaciones[$j].OperationDescription  `
        --subscription $Subscription  `
        --verbose
    }    
}