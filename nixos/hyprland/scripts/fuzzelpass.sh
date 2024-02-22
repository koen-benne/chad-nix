#!/usr/bin/env bash

shopt -s nullglob globstar

dmenu=fuzzel

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | fuzzel -i -l 20 -d)

[[ -n $password ]] || exit

if [[ $password == otp* ]]; then
  pass otp -c "$password" 2>/dev/null
else
	pass show -c "$password" 2>/dev/null
fi
