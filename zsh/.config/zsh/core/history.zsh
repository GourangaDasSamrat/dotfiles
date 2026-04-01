# history setup
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify

# skip saving sensitive data
zshaddhistory() {
  local cmd="${1%%$'\n'}"
  cmd="${cmd## }"
  local lower_cmd="${cmd:l}"

  # prefixes that almost always carry credentials
  local blocked_prefixes=(
    'pass ' 'op ' 'bw ' 'gpg ' 'ssh-keygen ' 'openssl '
    'curl ' 'wget ' 'mysql -p' 'psql ' 'redis-cli '
    'docker login' 'gh auth' 'git remote set-url' 'usql'
  )

  local blocked_substrings=(
    password passwd secret secretkey
    api_key apikey api_secret
    access_key access_token auth_token bearer
    private_key privkey client_secret client_id
    database_url db_password aws_secret aws_access
    stripe_key twilio_auth webhook_secret signing_secret
  )

  local blocked_patterns=(
    'export\ *=*'           
    '[A-Z]*=*'              
    '*authorization*'       
    '*://*:*@*'             
    '*--password*'
    '*--token*'
    '*--secret*'
    '*--aws-secret*'
    '*--service-account-key*'
  )

  # DRY: single check function
  _blocked() {
    local val="$1" item
    shift
    for item in "$@"; do [[ "$val" == ${item}* ]] && return 0; done
    return 1
  }

  _blocked "$cmd"       "${blocked_prefixes[@]}"   && return 1
  _blocked "$lower_cmd" "${blocked_substrings[@]/#/*}" && return 1  # wrap as *sub*

  for pat in "${blocked_patterns[@]}"; do
    [[ "$lower_cmd" == ${~pat} ]] && return 1  # ${~pat} enables glob in variable
  done

  return 0
}
