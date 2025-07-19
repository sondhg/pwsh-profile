# ============================================================================
# PowerShell 7 Profile Configuration
# ============================================================================
# ! This is for PowerShell 7 profile initialization, not PowerShell 5 (Window PowerShell).
# ! This file is located at: C:\Users\DELL\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# ! Notice the difference in the path: "PowerShell" instead of "WindowsPowerShell".

# ============================================================================
# ! ENVIRONMENT VARIABLES
# ============================================================================

# Set Python encoding to UTF-8

$env:PYTHONIOENCODING = 'utf-8' 

# Set bat theme
$env:BAT_THEME = 'tokyonight_night'

# Set Starship config path
$env:STARSHIP_CONFIG = "$HOME\.config\starship.toml"

# Configure fzf to use fd for file search
$env:FZF_DEFAULT_COMMAND = 'fd --type file --strip-cwd-prefix --hidden --follow --exclude .git'
# Use same fd command for Ctrl+T file search
$env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
# Configure fd for Alt+C directory search
$env:FZF_ALT_C_COMMAND = 'fd --type directory --strip-cwd-prefix --hidden --follow --exclude .git'

# Preview file content using bat (https://github.com/sharkdp/bat). Because I use fd for FZF_DEFAULT_COMMAND, the "--bind 'ctrl-/:change-preview-window(down|hidden|)'" in FZF_CTRL_T_OPTS won't work.
$env:FZF_CTRL_T_OPTS = "--walker-skip .git,node_modules,target --preview 'bat -n --color=always {}'"

# Print tree structure in the preview window with eza
$env:FZF_ALT_C_OPTS = "--walker-skip .git,node_modules,target --preview 'eza --color=always --all --git-ignore --group-directories-first --tree {}'"

# ============================================================================
# ! MODULE IMPORTS
# ============================================================================

# Import PSFzf for fuzzy finding
Import-Module PSFzf

# ============================================================================
# ! THIRD-PARTY TOOL INITIALIZATION
# ============================================================================



# Initialize Starship prompt
Invoke-Expression (&starship init powershell)

# Just type "scoop search" and it will use "scoop-search" (much faster than default scoop search) under the hood
Invoke-Expression (&scoop-search --hook)

# Initialize thefuck for command correction
Invoke-Expression "$(thefuck --alias)"

# Initialize zoxide for smart directory navigation
# ! Must invoke zoxide init AFTER starship initialization so that database of zoxide is built correctly
Invoke-Expression (& { (zoxide init powershell | Out-String) })



# ============================================================================
# ! FUZZY FINDER (FZF) CONFIGURATION
# ============================================================================

# Set PSFzf keybindings: Ctrl+T for files, Ctrl+R for history
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# Optional PSFzf tab completion (currently disabled)
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
# Set-PsFzfOption -TabExpansion

# Enable fuzzy edit alias
Set-PsFzfOption -EnableAliasFuzzyEdit

# ============================================================================
# ! FUNCTIONS
# ============================================================================

# Enhanced ls with eza
function els { eza --icons=always --all --git-ignore --group-directories-first @args }
function et { eza --all --git-ignore --group-directories-first --tree @args }

# fzf Fuzzy find files with bat preview, use Tab key to select multiple files, use Enter key to open selected files in VS Code
function fzfc { code $(fzf -m --preview="bat --color=always {}") @args }

function fzfp { fzf -m --preview="bat --color=always {}" @args }

# cd to directory of $PROFILE (profile.ps1 for PowerShell)
function pcd {
    Set-Location (Split-Path -Path $PROFILE -Parent)
}


# ============================================================================
# ! ALIASES
# ============================================================================
