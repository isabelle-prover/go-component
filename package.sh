#!/usr/bin/env bash

set -eo pipefail

echo "Checking cleanliness of working directory ..."

git diff --exit-code > /dev/null
git diff --cached --exit-code > /dev/null
[[ -z "$(git ls-files --exclude-standard --others)" ]]

echo "Working directory clean"

set -x

go_version="1.21.0"
version="$go_version-$(git describe --tags --always)"
package="go-$version.tar.gz"

url="https://go.dev/dl/go${go_version}.linux-amd64.tar.gz"
target="go.tar.gz"

curl -Lo "$target" "$url"
sha256sum --check checksum

tar xzf "$target"

files=(
  "go"
  "etc/settings"
)

tar --transform "s,^,go-$version/," -czf "$package" "${files[@]}"
