# GitHub Action: Run eslint with reviewdog

[![Docker Image CI](https://github.com/reviewdog/action-eslint/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/reviewdog/action-eslint/actions)
[![depup](https://github.com/reviewdog/action-eslint/workflows/depup/badge.svg)](https://github.com/reviewdog/action-eslint/actions?query=workflow%3Adepup)
[![release](https://github.com/reviewdog/action-eslint/workflows/release/badge.svg)](https://github.com/reviewdog/action-eslint/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/reviewdog/action-eslint?logo=github&sort=semver)](https://github.com/reviewdog/action-eslint/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

This action runs [eslint](https://github.com/eslint/eslint) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

[![github-pr-check sample](https://user-images.githubusercontent.com/3797062/65439130-a6043b80-de61-11e9-98b5-bd9567e184b0.png)](https://github.com/reviewdog/action-eslint/pull/1)
![eslint reviewdog rdjson demo](https://user-images.githubusercontent.com/3797062/97085944-87233a80-165b-11eb-94a8-0a47d5e24905.png)

## Inputs

### `github_token`

**Required**. Default is `${{ github.token }}`.

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

Reporter of reviewdog command [github-pr-check,github-check,github-pr-review].
Default is github-pr-review.
It's same as `-reporter` flag of reviewdog.

github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

### `filter_mode`

Optional. Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
Default is added.

### `fail_on_error`

Optional.  Exit code for reviewdog when errors are found [true,false]
Default is `false`.

### `reviewdog_flags`

Optional. Additional reviewdog flags

### `eslint_flags`

Optional. Flags and args of eslint command. Default: '.'

### `workdir`

Optional. The directory from which to look for and run eslint. Default '.'

### `package_manager`

Optional. Package manager for installing node modules [npm,yarn]. Default: 'npm'

## Example usage

You also need to install [eslint](https://github.com/eslint/eslint).

```shell
# Example
$ npm install eslint -D
```

You can create [eslint
config](https://eslint.org/docs/user-guide/configuring)
and this action uses that config too.

### [.github/workflows/reviewdog.yml](.github/workflows/reviewdog.yml)

```yml
name: reviewdog
on: [pull_request]
jobs:
  eslint:
    name: runner / eslint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: eslint
        uses: reviewdog/action-eslint@v1
        with:
          reporter: github-pr-review # Change reporter.
          eslint_flags: 'src/'
```
