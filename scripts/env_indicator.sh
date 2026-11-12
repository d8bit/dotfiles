# env-indicator.zsh
# Prompt indicator for the loaded environment + clean loading/unloading of variables.
#
# SETUP
#   1. In each variables file, declare which environment it belongs to:
#        export DEPLOY_ENV="prod"        # or pre, staging, test...
#      (always use `export`, not `typeset -x`)
#
#   2. At the end of ~/.zshrc (after your theme / oh-my-zsh):
#        source ~/path/to/env-indicator.zsh
#
#   3. Change your aliases to use envload instead of source:
#        alias env-prod='envload ~/envs/prod.env'
#        alias env-test='envload ~/envs/test.env'
#
# COMMANDS
#   envload <file>   Unload the current environment (if any) and load the new one
#   envunload        Remove the loaded variables and restore any they overwrote
#   envwhich         Show the environment, the file and the variable NAMES
#
# If you run `source file` directly, the indicator still shows up
# (it reads DEPLOY_ENV), but envunload can only remove DEPLOY_ENV.

# ------------------------------------------------------------------ config ---

# Color per environment (zsh color names or numbers 0-255)
typeset -gA ENV_INDICATOR_COLORS=(
  prod        red
  pro         red
  production  red
  admin       magenta
  pre         yellow
  staging     yellow
  test         green
)
typeset -g ENV_INDICATOR_DEFAULT_COLOR=blue

# "Dangerous" environments: highlighted indicator and terraform confirmation
typeset -ga ENV_PROTECTED=(prod pro production admin)

# Variables that are not tracked when loading
typeset -ga _ENV_IGNORE_VARS=(_ OLDPWD PWD SHLVL)

# ---------------------------------------------------------------- internals ---

typeset -ga _ENV_LOADED_VARS=()
typeset -gA _ENV_PREV_VALUES=()
typeset -g  _ENV_LOADED_FILE=""
typeset -g  _ENV_INDICATOR_PREV=""

_env_color() {
  print -rn -- "${ENV_INDICATOR_COLORS[$1]:-$ENV_INDICATOR_DEFAULT_COLOR}"
}

_env_is_protected() {
  (( ${ENV_PROTECTED[(Ie)$1]} ))
}

_env_indicator_segment() {
  [[ -z $DEPLOY_ENV ]] && return
  local color=$(_env_color "$DEPLOY_ENV")
  local name=${DEPLOY_ENV//\%/%%}
  if _env_is_protected "$DEPLOY_ENV"; then
    print -rn -- "%K{$color}%F{white}%B ⚠ ${(U)name} %b%f%k "
  else
    print -rn -- "%F{$color}[$name]%f "
  fi
}

_env_indicator_precmd() {
  # Remove the previous indicator if it is still at the start of the prompt
  PROMPT=${PROMPT#"$_ENV_INDICATOR_PREV"}
  local seg=$(_env_indicator_segment)
  PROMPT="${seg}${PROMPT}"
  _ENV_INDICATOR_PREV=$seg
}

# ---------------------------------------------------------------- commands ---

envload() {
  local file=$1
  if [[ -z $file || ! -r $file ]]; then
    print -u2 "envload: cannot read '$file'"
    return 1
  fi

  [[ -n $DEPLOY_ENV || ${#_ENV_LOADED_VARS} -gt 0 ]] && envunload --quiet

  # Snapshot of exported variables before loading
  local -A before
  local name
  for name in ${(k)parameters[(R)*export*]}; do
    before[$name]=${(P)name}
  done

  if ! source "$file"; then
    print -u2 "envload: error while loading '$file' (it may be partially loaded)"
  fi

  # What the file added or changed
  _ENV_LOADED_VARS=()
  _ENV_PREV_VALUES=()
  for name in ${(k)parameters[(R)*export*]}; do
    (( ${_ENV_IGNORE_VARS[(Ie)$name]} )) && continue
    if (( ! ${+before[$name]} )); then
      _ENV_LOADED_VARS+=$name
    elif [[ ${before[$name]} != ${(P)name} ]]; then
      _ENV_LOADED_VARS+=$name
      _ENV_PREV_VALUES[$name]=${before[$name]}
    fi
  done
  _ENV_LOADED_FILE=${file:A}

  if [[ -z $DEPLOY_ENV ]]; then
    export DEPLOY_ENV=${${file:t}%.*}
    _ENV_LOADED_VARS+=DEPLOY_ENV
    print -u2 "envload: '$file' does not define DEPLOY_ENV; using '$DEPLOY_ENV'"
  fi

  local color=$(_env_color "$DEPLOY_ENV")
  print -P "Environment loaded: %F{$color}%B${DEPLOY_ENV//\%/%%}%b%f (${#_ENV_LOADED_VARS} variables)"
}

envunload() {
  local quiet=0
  [[ $1 == --quiet ]] && quiet=1

  if [[ -z $DEPLOY_ENV && ${#_ENV_LOADED_VARS} -eq 0 ]]; then
    (( quiet )) || print "No environment loaded"
    return 0
  fi

  local old=$DEPLOY_ENV name
  if (( ${#_ENV_LOADED_VARS} == 0 )); then
    print -u2 "envunload: '$old' was loaded without envload; only removing DEPLOY_ENV"
  fi

  for name in $_ENV_LOADED_VARS; do
    if (( ${+_ENV_PREV_VALUES[$name]} )); then
      typeset -gx "$name=${_ENV_PREV_VALUES[$name]}"
    else
      unset "$name"
    fi
  done
  unset DEPLOY_ENV

  _ENV_LOADED_VARS=()
  _ENV_PREV_VALUES=()
  _ENV_LOADED_FILE=""
  (( quiet )) || print "Environment '$old' unloaded"
}

envwhich() {
  if [[ -z $DEPLOY_ENV ]]; then
    print "No environment loaded"
    return 1
  fi
  local color=$(_env_color "$DEPLOY_ENV")
  print -P "Environment: %F{$color}%B${DEPLOY_ENV//\%/%%}%b%f"
  [[ -n $_ENV_LOADED_FILE ]] && print -r -- "File:        $_ENV_LOADED_FILE"
  (( ${#_ENV_LOADED_VARS} )) && print -r -- "Variables:   ${(j:, :)${(@o)_ENV_LOADED_VARS}}"
  return 0
}

# ------------------------------------------------ terraform confirmation ----
# Asks you to type the environment name before apply/destroy/import in a
# protected environment. Delete this block if you don't want it.

_env_confirm() {
  if [[ -z $DEPLOY_ENV ]]; then
    print -P "%F{yellow}⚠ No environment loaded: default credentials will be used.%f"
    return 0
  fi
  _env_is_protected "$DEPLOY_ENV" || return 0
  local answer
  print -P "%F{red}%B⚠ You are about to run '${1//\%/%%}' in ${(U)DEPLOY_ENV//\%/%%}%b%f"
  read "answer?Type '$DEPLOY_ENV' to confirm: "
  if [[ $answer != "$DEPLOY_ENV" ]]; then
    print "Cancelled."
    return 1
  fi
}

terraform() {
  if (( ${@[(Ie)apply]} || ${@[(Ie)destroy]} || ${@[(Ie)import]} )); then
    _env_confirm "terraform $*" || return 1
  fi
  command terraform "$@"
}

# ------------------------------------------------------------------ prompt ---

# Powerlevel10k: add "deploy_env" to POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
# in ~/.p10k.zsh and this segment is used instead of modifying PROMPT.
prompt_deploy_env() {
  [[ -z $DEPLOY_ENV ]] && return
  local color=$(_env_color "$DEPLOY_ENV")
  if _env_is_protected "$DEPLOY_ENV"; then
    p10k segment -b "$color" -f white -t "⚠ ${(U)DEPLOY_ENV}"
  else
    p10k segment -f "$color" -t "$DEPLOY_ENV"
  fi
}

if (( ! $+functions[p10k] )); then
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _env_indicator_precmd
fi
