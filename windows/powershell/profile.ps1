

# Bare wsl opens the Linux home; arguments are forwarded unchanged.
function global:wsl {
    if ($args.Count -eq 0) {
        wsl.exe --cd '~'
    } else {
        wsl.exe @args
    }
}
