Import-Module 'C:\Program Files\Pure Storage\D.O.E.S\DOES.Powershell.dll'

Add-DataEngine -DatabaseType MicrosoftSQL -Hostname localhost -DatabaseName db1 -Amount 1 -Unit Gigabytes -NumberOfThreads 8 -UserName admin -Password VMware1! -Folder \\10.21.152.167\packages\datafiles\DataEngineFilesOracle1
