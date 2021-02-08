#!/bin/sh

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"
export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"
ESLINT_FORMATTER="${GITHUB_ACTION_PATH}/eslint-formatter-rdjson/index.js"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "${TEMP_PATH}" "${REVIEWDOG_VERSION}" 2>&1
echo '::endgroup::'

PACKAGE_MANAGER="${INPUT_PACKAGE_MANAGER}"
if [ $PACKAGE_MANAGER != "npm" -a $PACKAGE_MANAGER != "yarn" ]; then
  echo "Unsupported package manager. Specify npm or yarn"
  exit 1
fi
if [ ! -f "$($PACKAGE_MANAGER bin)/eslint" ]; then
  echo "::group:: Running `$PACKAGE_MANAGER install` to install eslint ..."
  $PACKAGE_MANAGER install
  echo '::endgroup::'
fi

echo "eslint version:$($(npm bin)/eslint --version)"

echo '::group:: Running eslint with reviewdog 🐶 ...'
$(npm bin)/eslint -f="${ESLINT_FORMATTER}" ${INPUT_ESLINT_FLAGS:-'.'} \
  | reviewdog -f=rdjson \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-review}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
echo '::endgroup::'
