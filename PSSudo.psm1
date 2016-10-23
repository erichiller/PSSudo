<#
.SYNOPSIS
sudo - like logic
.DESCRIPTION
Allows for
(1) linux like sudo <command>
(2) linux like sudo !!
	which will run the last command entered in elevated permissions
	This is incredibly usefull for instance, when you forgot to run sudo
	(or did not kn	ow that it required admin rights) on the previous command`
#>

function Start-Elevated {

	if($args[0] -eq '!!'){
		f--k;

	} else {

		$psi = new-object System.Diagnostics.ProcessStartInfo
		$emuHk = $env:ConEmuHooks -eq 'Enabled'

		if($args.Length -eq 0) {
			if($emuHk) {
				$psi.FileName = $env:WINDIR + '\System32\WindowsPowerShell\v1.0\powershell.exe'
				$psi.Arguments = "-new_console:a -ExecutionPolicy $(Get-ExecutionPolicy) -NoLogo"
				$psi.UseShellExecute = $false
			}
			else {
				Write-Warning "You must provide a program to be executed with its command line arguments."
				return
			}
		}
		else {
		
			if($args.Length -ne 1) {
				$cmdLine = [string]::Join(' ', ($args[1..$args.Length] | % { '"' + (([string] $_).Replace('"', '""')) + '"' }) )
			}
			else {
				$cmdLine = ''
			}

			$cmd = $args[0]
			
			$alias = Get-Alias $cmd -ErrorAction Ignore
			while($alias) {
				$cmd = $alias.Definition;
				$alias = Get-Alias $cmd -ErrorAction Ignore
			}

			$cmd = Get-Command $cmd -ErrorAction SilentlyContinue

			switch -regex ($cmd.CommandType) {
				'Application' {
					$program = $cmd.Source
				}
				'Cmdlet|Function' {
					$program = $env:WINDIR + '\System32\WindowsPowerShell\v1.0\powershell.exe'

					$cmdLine = "$($cmd.Name) $cmdLine"
					$cmdLine = "-NoLogo -Command `"$cmdLine; pause`""

				}
				'ExternalScript' {
				$program = $env:WINDIR + '\System32\WindowsPowerShell\v1.0\powershell.exe'

				$cmdLine = "& '$($cmd.Source)' $cmdLine"
				$cmdLine = "-NoLogo -Command `"$cmdLine; pause`""
				}
				default {
					Write-Warning "Command '$($args[0])' not found."
					return
				}
			}

			if($emuHk) {
				$psi.UseShellExecute = $false
				$cmdLine = "-cur_console:a $cmdLine";
			}
			else {
				$psi.Verb = "runas"
			}


			$psi.FileName = $program
			$psi.Arguments = $cmdLine
		}

		[System.Diagnostics.Process]::Start($psi) | out-null
	
	}
}

<#
.SYNOPSIS
Allows for sudo !!
Which will run the last command entered in elevated permissions
	This is incredibly usefull for instance, when you forgot to run sudo
	(or did not kn	ow that it required admin rights) on the previous command`
.LINK
Source: https://stapp.space/run-last-command-in-elevated-powershell/
#>
function f--k {
	$cmd = (Get-History ((Get-History).Count))[0].CommandLine
	Write-Host "Running $cmd in $PWD"
	sudo powershell -NoExit -Command "pushd '$PWD'; Write-host 'cmd to run: $cmd'; $cmd"
}

Set-Alias sudo Start-Elevated

