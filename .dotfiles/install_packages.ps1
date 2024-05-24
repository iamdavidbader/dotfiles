    # To allow execution of this script execute the 
    # following as an administrator:
    #
    # `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned`
    #
    # Install New apps
    $apps = @(
        @{name = "Microsoft.VisualStudioCode" }, 
        @{name = "Microsoft.WindowsTerminal"; source = "msstore" },
        @{name = "Git.Git" },
        @{name = "dandavison.delta"},
        @{name = "sharkdp.bat"},
        @{name = "BurntSushi.ripgrep.MSVC"}
    );
    Foreach ($app in $apps) {
        #check if the app is already installed
        $listApp = winget list --exact -q $app.name
        if (![String]::Join("", $listApp).Contains($app.name)) {
            Write-host "Installing:" $app.name
            if ($app.source -ne $null) {
                winget install --exact --silent $app.name --source $app.source --accept-package-agreements
            }
            else {
                winget install --exact --silent $app.name --accept-package-agreements 
            }
        }
        else {
            Write-host "Skipping Install of " $app.name
        }
    }