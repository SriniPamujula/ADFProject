#create input dataset
Set-AzDataFactoryV2Dataset -DataFactoryName $DataFactory.DataFactoryName `
    -ResourceGroupName $ResGrp.ResourceGroupName -Name "InputDataset" `
    -DefinitionFile ".\InputDataset.json"

#create output dataset
#Set-AzDataFactoryV2Dataset -DataFactoryName $DataFactory.DataFactoryName `
#    -ResourceGroupName $ResGrp.ResourceGroupName -Name "OutputDataset" `
#    -DefinitionFile ".\OutputDataset.json"

# creating database dataset is working in progress

#create pipeline
$DFPipeLine = Set-AzDataFactoryV2Pipeline `
    -DataFactoryName $DataFactory.DataFactoryName `
    -ResourceGroupName $ResGrp.ResourceGroupName `
    -Name "Adfv2QuickStartPipeline" `
    -DefinitionFile ".\Adfv2QuickStartPipeline.json"

# create pipeline run
$RunId = Invoke-AzDataFactoryV2Pipeline `
  -DataFactoryName $DataFactory.DataFactoryName `
  -ResourceGroupName $ResGrp.ResourceGroupName `
  -PipelineName $DFPipeLine.Name

# monitor the pipeline run
while ($True) {
    $Run = Get-AzDataFactoryV2PipelineRun `
        -ResourceGroupName $ResGrp.ResourceGroupName `
        -DataFactoryName $DataFactory.DataFactoryName `
        -PipelineRunId $RunId

    if ($Run) {
        if ($run.Status -ne 'InProgress') {
            Write-Output ("Pipeline run finished. The status is: " +  $Run.Status)
            $Run
            break
        }
        Write-Output "Pipeline is running...status: InProgress"
    }

    Start-Sleep -Seconds 10
}


# activity run details

Write-Output "Activity run details:"
$Result = Get-AzDataFactoryV2ActivityRun -DataFactoryName $DataFactory.DataFactoryName -ResourceGroupName $ResGrp.ResourceGroupName -PipelineRunId $RunId -RunStartedAfter (Get-Date).AddMinutes(-30) -RunStartedBefore (Get-Date).AddMinutes(30)
$Result

Write-Output "Activity 'Output' section:"
$Result.Output -join "`r`n"

Write-Output "Activity 'Error' section:"
$Result.Error -join "`r`n"


#cleanup the resources
Remove-AzResourceGroup -ResourceGroupName $resourcegroupname

#clenup only datafactory
Remove-AzDataFactoryV2 -Name $dataFactoryName -ResourceGroupName $resourceGroupName




