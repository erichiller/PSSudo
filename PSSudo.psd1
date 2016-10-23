@{
RootModule = 'PSSudo.psm1'
ModuleVersion = '2.0.0'
GUID = '75640361-a312-4e57-8564-9c8b904d333b'
Author = 'Eric Hiller '
Description = 'Function for executing programs with adminstrative privileges'
PowerShellVersion = '3.0'
DotNetFrameworkVersion = '4.0'
CLRVersion = '4.0'
FunctionsToExport = @('Start-Elevated')
AliasesToExport = @('sudo')
HelpInfoURI = 'https://github.com/erichiller/PSSudo'
PrivateData = @{
        Tags='sudo elevation'
        ProjectUri='https://github.com/erichiller/PSSudo'
    }
}
