#!/usr/bin/env bash

# This is inspired by:
# https://github.com/travis-infrastructure/terraform-config/blob/master/runtests

set -euo pipefail

main() {
  echo -e '\n-----> Validating JSON'
  for f in $(git ls-files '*.json'); do
    echo -en "$f "
    python -m json.tool <"${f}" >/dev/null
    echo "✓"
  done

  echo -e '\n-----> Running shellcheck'
  git grep -El '^#!/.+\b(bash|sh)\b' -- './*' ':(exclude)*.tmpl' | xargs shellcheck

  echo -e '\n-----> Running terraform validate'
  for d in $(git ls-files '*.tf' | xargs -n1 dirname | LC_ALL=C sort | grep -E -v '^\.$' | uniq); do
    echo -en "${d} "
    terraform validate -check-variables=false "${d}"
    echo "✓"
  done

  echo -e '\n-----> Success!'
}

main "$@"
