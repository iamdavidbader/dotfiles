#-----------------------------------------
# Shell and OS types.
#-----------------------------------------

if [ -n "$BASH_VERSION" ]; then
  PROFILE_SHELL=bash
elif [ -n "$ZSH_VERSION" ]; then
  PROFILE_SHELL=zsh
fi

#-----------------------------------------
# Sourcing.
#-----------------------------------------

# Shell-specific configs.
if [ -f "$HOME/.${PROFILE_SHELL}rc" ]; then
  . "$HOME/.${PROFILE_SHELL}rc"
fi

