#!/usr/bin/env zsh

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

get_password() {
  [[ -n $1 ]] || exit

  echo $1
  if [[ $1 == otp* ]]; then
    pass otp -c "$1" 2>/dev/null
  else
    pass show -c "$1" 2>/dev/null
  fi
}

selected_file=$(printf '%s\n' "${password_files[@]}" | fzf)
if [[ -n $selected_file ]]; then
    get_password "$selected_file"
fi

