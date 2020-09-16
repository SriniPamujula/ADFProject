Import-Module -Name Az

Connect-AzAccount

Get-AzSubscription

Select-AzSubscription -SubscriptionId "f3e5ebbb-5665-4eab-9b43-xxxxx"



# Register for Azure Data Lake Storage Gen1
Register-AzResourceProvider -ProviderNamespace "Microsoft.DataLakeStore"



#create resource group
$resourceGroupName = "ADFEngineeringRG";
$ResGrp = New-AzResourceGroup $resourceGroupName -location 'East US'


#create create data lake store account
$dataLakeStorageGen1Name = "adfengineeringdls"
New-AzDataLakeStoreAccount -ResourceGroupName $resourceGroupName -Name $dataLakeStorageGen1Name -Location "East US 2"


#Test datalake account
Test-AzDataLakeStoreAccount -Name $dataLakeStorageGen1Name

#create inputdirectory
$myrootdir = "/"
New-AzDataLakeStoreItem -Folder -AccountName $dataLakeStorageGen1Name -Path $myrootdir/inputdirectory

#test inputdirectory
Get-AzDataLakeStoreChildItem -AccountName $dataLakeStorageGen1Name -Path $myrootdir

#upload csv
Import-AzDataLakeStoreItem -AccountName $dataLakeStorageGen1Name `
   -Path "C:\Users\xxxx\xxxx\Documents\ADFEngineering\Rounding_List_LAKETAHOE_20200818073151.csv" `
   -Destination $myrootdir\incoming\Rounding_List_LAKETAHOE_20200818073151.csv