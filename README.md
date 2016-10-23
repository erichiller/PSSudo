# PSSudo

Fork from <https://github.com/ecsousa/PSSudo>

Modifications:
1. `-cur_console` for `sudo <arguments>` so that elevated PowerShell in ConEmu runs in the same window/tab/console
2. When checking for Aliases, use `Ignore` as the `-ErrorAction` so that errors are not detected in `oh-my-posh` templates
3. Added `f--k`, allowing for `sudo !!` fuctionality - executing the last command in elevated mode. 