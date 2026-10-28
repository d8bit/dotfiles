# env-indicator.zsh
# Indicador en el prompt del entorno cargado + carga/descarga limpia de variables.
#
# INSTALACIÓN
#   1. En cada fichero de variables, define a qué entorno pertenece:
#        export DEPLOY_ENV="prod"        # o pre, staging, dev...
#      (usa siempre `export`, no `typeset -x`)
#
#   2. Al final de ~/.zshrc (después del tema / oh-my-zsh):
#        source ~/ruta/env-indicator.zsh
#
#   3. Cambia tus alias para usar envload en lugar de source:
#        alias env-prod='envload ~/envs/prod.env'
#        alias env-dev='envload ~/envs/dev.env'
#
# COMANDOS
#   envload <fichero>   Descarga el entorno actual (si hay) y carga el nuevo
#   envunload           Quita las variables cargadas y restaura las que pisaron
#   envwhich            Muestra el entorno, el fichero y los NOMBRES de variables
#
# Si haces `source fichero` directamente, el indicador también aparece
# (lee DEPLOY_ENV), pero envunload solo podrá quitar DEPLOY_ENV.

# ------------------------------------------------------------------ config ---

# Color por entorno (nombres de zsh o números 0-255)
typeset -gA ENV_INDICATOR_COLORS=(
  prod        red
  pro         red
  production  red
  admin       magenta
  pre         yellow
  staging     yellow
  dev         green
)
typeset -g ENV_INDICATOR_DEFAULT_COLOR=blue

# Entornos "peligrosos": indicador resaltado y confirmación en terraform
typeset -ga ENV_PROTECTED=(prod pro production admin)

# Variables que no se rastrean al cargar
typeset -ga _ENV_IGNORE_VARS=(_ OLDPWD PWD SHLVL)

# ---------------------------------------------------------------- internos ---

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
  # Quita el indicador anterior si sigue al principio del prompt
  PROMPT=${PROMPT#"$_ENV_INDICATOR_PREV"}
  local seg=$(_env_indicator_segment)
  PROMPT="${seg}${PROMPT}"
  _ENV_INDICATOR_PREV=$seg
}

# --------------------------------------------------------------- comandos ---

envload() {
  local file=$1
  if [[ -z $file || ! -r $file ]]; then
    print -u2 "envload: no puedo leer '$file'"
    return 1
  fi

  [[ -n $DEPLOY_ENV || ${#_ENV_LOADED_VARS} -gt 0 ]] && envunload --quiet

  # Foto de las variables exportadas antes de cargar
  local -A before
  local name
  for name in ${(k)parameters[(R)*export*]}; do
    before[$name]=${(P)name}
  done

  if ! source "$file"; then
    print -u2 "envload: error al cargar '$file' (puede haber quedado a medias)"
  fi

  # Qué ha añadido o cambiado el fichero
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
    print -u2 "envload: '$file' no define DEPLOY_ENV; uso '$DEPLOY_ENV'"
  fi

  local color=$(_env_color "$DEPLOY_ENV")
  print -P "Entorno cargado: %F{$color}%B${DEPLOY_ENV//\%/%%}%b%f (${#_ENV_LOADED_VARS} variables)"
}

envunload() {
  local quiet=0
  [[ $1 == --quiet ]] && quiet=1

  if [[ -z $DEPLOY_ENV && ${#_ENV_LOADED_VARS} -eq 0 ]]; then
    (( quiet )) || print "No hay ningún entorno cargado"
    return 0
  fi

  local old=$DEPLOY_ENV name
  if (( ${#_ENV_LOADED_VARS} == 0 )); then
    print -u2 "envunload: '$old' se cargó sin envload; solo quito DEPLOY_ENV"
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
  (( quiet )) || print "Entorno '$old' descargado"
}

envwhich() {
  if [[ -z $DEPLOY_ENV ]]; then
    print "Sin entorno cargado"
    return 1
  fi
  local color=$(_env_color "$DEPLOY_ENV")
  print -P "Entorno:   %F{$color}%B${DEPLOY_ENV//\%/%%}%b%f"
  [[ -n $_ENV_LOADED_FILE ]] && print -r -- "Fichero:   $_ENV_LOADED_FILE"
  (( ${#_ENV_LOADED_VARS} )) && print -r -- "Variables: ${(j:, :)${(@o)_ENV_LOADED_VARS}}"
  return 0
}

# ------------------------------------------- confirmación en terraform -------
# Pide escribir el nombre del entorno antes de apply/destroy/import en un
# entorno protegido. Borra este bloque si no lo quieres.

_env_confirm() {
  if [[ -z $DEPLOY_ENV ]]; then
    print -P "%F{yellow}⚠ No hay entorno cargado: se usarán las credenciales por defecto.%f"
    return 0
  fi
  _env_is_protected "$DEPLOY_ENV" || return 0
  local answer
  print -P "%F{red}%B⚠ Vas a ejecutar '${1//\%/%%}' en ${(U)DEPLOY_ENV//\%/%%}%b%f"
  read "answer?Escribe '$DEPLOY_ENV' para confirmar: "
  if [[ $answer != "$DEPLOY_ENV" ]]; then
    print "Cancelado."
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

# Powerlevel10k: añade "deploy_env" a POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
# en ~/.p10k.zsh y este segmento se usará en lugar de tocar PROMPT.
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
