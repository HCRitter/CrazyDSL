Function Get-Columns {
    Param(
        [ValidateSet("SecurityEvent","Syslog","AzureActivity","Heartbeat")]
        $TableName,
        $JSONPath = '.\CommunityDemo\CrazyDSL\Columns.json'
    )
    $ColumnsData = Get-Content -Path $JSONPath | ConvertFrom-Json
    return $ColumnsData.Tables | Where-Object { $_.Name -eq $TableName } | Select-Object -ExpandProperty Columns
}

Add-Type @"
using System.Collections.Generic;

public static class KQLState {
    public static string CurrentTable = "";
}
"@

Function KQLTable {
    Param (
        [ValidateSet("SecurityEvent","Syslog","AzureActivity","Heartbeat")]
        $Name
    )
}

function KQLWhere {
    Param (
        $Column,
        [scriptblock]$Condition
    )
    "$([KQLState]::CurrentTable) | Where $Column $Condition"
}

function KQLQuery{
    Param (
        [scriptblock]$Query
    )
    &$Query
}


$s = {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    Get-Columns -TableName ([KQLState]::CurrentTable) | Where-Object {
        $_ -like "*$wordToComplete*"
    } | ForEach-Object {
        "'$_'"
    }
}

Register-ArgumentCompleter -CommandName KQLWhere -ParameterName Column -ScriptBlock $s


