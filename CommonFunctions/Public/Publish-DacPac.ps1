<#
.SYNOPSIS
Will Invoke DacPac utilising sqlpackage.exe

.DESCRIPTION
Deploy a dacpac against specified instance of SQL Server Using psobject where Property is name of variable/parameter and value is the desired value.
The 'DefaultFilePrefix' is always the value of TargetDatabase parameter.

.PARAMETER SqlServerName
Name of the SQL Server. populates /TargetServerName:

.PARAMETER TargetDatabase
Defines the target database and will also be utilised for the the /v:DefaultFilePrefix

.PARAMETER SourceFile
Full Path to the .dacpac file to be published. Populates /SourceFile:

.PARAMETER Properties
[Hashtable] Where property is name of parameter with its value.

.PARAMETER Variables
[Hashtable] Object of variables with property name of var and value is input.

.EXAMPLE
$prop = @{BlockOnPossibleDataLoss = $true; BlockWhenDriftDetected = $false; CreateNewDatabase = $false; TreatVerificationErrorsAsWarnings = $true }
$vars = @{Variable1 = "Dev"; foo="bar" }
Publish-DacPac -SqlServername 'localhost\SQLEXPRESS' -TargetDatabase "TestDb" -SourceFile "C:\Staging\TestDb\TestDb.dacpac" -Properties $prop -Variables $vars

Will publish dacpac Testdb to localhost\SQLEXPRESS.

.NOTES
Requires sqlpackage.exe to be installed on executing machine within Program Files(x86), with administrator rights on database server.
#>
function Publish-DacPac {    
    param (
        [Parameter(Mandatory = $true, position = 0, HelpMessage = "Name of the SQL Server Instance.", ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $false)]
        [string]$SqlServerName,
				
        [Parameter(Mandatory = $true, position = 1, HelpMessage = "Name of Target Database", ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $false)]
        [string] $TargetDatabase,

        [Parameter(Mandatory = $true, position = 2, helpmessage = "Full path to Dacpac file.")]
        [ValidateScript( {
                if (-not (Test-Path $_)) {
                    throw "File does not exist"
                }
                if (-not(Test-Path $_ -pathtype leaf)) {
                    throw "The path argument must be a file. Folder paths are not allowed."
                }
                if ($_.Extension -ne '.dacpac') { throw "The file specified in the path must be of type dacpac." }
                return $true
            })]
        [System.IO.FileInfo]$SourceFile,
				
        [Parameter(Mandatory = $true, position = 3, helpmessage = "PSObject containing Parameters for the dacpac to utilise.")]
        [ValidateScript( {
                if ($_.Keys.Count -le 0) { throw "[hashtable] 'Parameters' must have atleast one key value pair" }else { return $true }
            })]
        [hashtable]$Properties,
				
        [Parameter(mandatory = $true, position = 4, helpmessage = "PSObject containing variables for dacpac")]
        [ValidateScript( {
                if ($_.Keys.Count -le 0) { throw "[hashtable] 'Variables' must have atleast one key value pair" }else { return $true }
            })]
        [hashtable]$Variables
    )
    
    begin {

        #Validate all keys provided are of valid Parameters for publish action case-sensitive
        $validProperties = @("AdditionalDeploymentContributorArguments", "AdditionalDeploymentContributors", 
            "AllowDropBlockingAssemblies", "AllowIncompatiblePlatform", "AllowUnsafeRowLevelSecurityDataMovement", "BackupDatabaseBeforeChanges", "BlockOnPossibleDataLoss", "BlockWhenDriftDetected",
            "CommandTimeout", "CommentOutSetVarDeclarations", "CompareUsingTargetCollation", "CreateNewDatabase", "DeployDatabaseInSingleUserMode", "DisableAndReenableDdlTriggers", "DoNotAlterChangeDataCaptureObjects",
            "DoNotAlterReplicatedObjects", "DoNotDropObjectType", "DoNotDropObjectTypes", "DropConstraintsNotInSource", "DropDmlTriggersNotInSource", "DropExtendedPropertiesNotInSource", "DropIndexesNotInSource",
            "DropObjectsNotInSource", "DropPermissionsNotInSource", "DropRoleMembersNotInSource", "DropStatisticsNotInSource", "ExcludeObjectType", "ExcludeObjectTypes", "GenerateSmartDefaults", "IgnoreAnsiNulls", "IgnoreAuthorizer", "IgnoreColumnCollation", "IgnoreColumnOrder", 
            "IgnoreComments", "IgnoreCryptographicProviderFilePath", "IgnoreDdlTriggerOrder", "IgnoreDdlTriggerState", "IgnoreDefaultSchema", "IgnoreDmlTriggerOrder", "IgnoreDmlTriggerState", "IgnoreExtendedProperties", 
            "IgnoreFileAndLogFilePath", "IgnoreFilegroupPlacement", "IgnoreFileSize", "IgnoreFillFactor", "IgnoreFullTextCatalogFilePath", "IgnoreIdentitySeed", "IgnoreIncrement", "IgnoreIndexOptions",
            "IgnoreIndexPadding", "IgnoreKeywordCasing", "IgnoreLockHintsOnIndexes", "IgnoreLoginSids", "IgnoreNotForReplication", "IgnoreObjectPlacementOnPartitionScheme", "IgnorePartitionSchemes",
            "IgnorePermissions", "IgnoreQuotedIdentifiers", "IgnoreRoleMembership", "IgnoreRouteLifetime", "IgnoreSemicolonBetweenStatements", "IgnoreTableOptions", "IgnoreUserSettingsObjects", "IgnoreWhitespace",
            "IgnoreWithNocheckOnCheckConstraints", "IgnoreWithNocheckOnForeignKeys", "IncludeCompositeObjects", "IncludeTransactionalScripts", "NoAlterStatementsToChangeClrTypes", "PopulateFilesOnFileGroups",
            "RegisterDataTierApplication", "RunDeploymentPlanExecutors", "ScriptDatabaseCollation", "ScriptDatabaseCompatibility", "ScriptDatabaseOptions", "ScriptDeployStateChecks",
            "ScriptFileSize", "ScriptNewConstraintValidation", "ScriptRefreshModule", "Storage", "TreatVerificationErrorsAsWarnings", "VerifyCollationCompatibility", "VerifyDeployment"
        )

        foreach ($key in $Properties.Keys) {
            if ($validProperties -cnotcontains $key) {
                throw "Property '$($key)' is not a valid Property for sqlpackage.exe, Do note this is case sensitive."
            }
        }

        $exe = Get-SqlPackage
        if ($null -ne $exe) {
            Set-Alias -name sqlpackage -value $exe
        }
        else {
            throw "Unable to locate sqlpackage.exe"
        }

        $args = "sqlpackage /a:Publish /sf:`"$SourceFile`" /tsn:`"$SqlServerName`" /tdn:`"$TargetDatabase`" /v:`"DefaultFilePrefix`"=`"$TargetDatabase`""
    }
    
    process {
		
        foreach ($key in $Properties.Keys) {
            $value = $Properties[$key]
            $args += " /p:`"$key`"=`"$value`""
        }

        foreach ($key in $Variables.Keys) {
            $value = $Variables[$key]
            $args += " /v:`"$key`"=`"$value`""
        }

        Invoke-Expression $args
    }
}