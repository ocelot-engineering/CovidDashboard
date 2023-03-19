#
# VS code debugging
#

# Taken from https://gist.github.com/strengejacke/82e8d7b869bd9f961d12b4091c145b88

# Load all and refresh breakpoints
ret <- pkgload::load_all()
exports <- as.environment(paste0("package:", environmentName(ret$env)))
vscDebugger::.vsc.refreshBreakpoints(list(ret$env, exports))

runApp()
