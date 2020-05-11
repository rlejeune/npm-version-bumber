# npm-version-bumper

A Github action that will bump your NPM version to match the next git tag.

This action should be used with the [**create-pull-request**](https://github.com/marketplace/actions/create-pull-request) action to create a pull request with the modified package.json

## Usage

```
name: NPM Version Bumper

on:
  push:
    branches:
      - develop

jobs:
  npm_version_checker_job:
    runs-on: ubuntu-latest
    name: Bumping the NPM version
    steps:
      - name: Action checkout
        uses: actions/checkout@v2

      - name: NPM version bumper
        id: npm_version_bumper
        uses: rlejeune/npm-version-bumper@master

      - name: Open a Pull Request with new version
        uses: peter-evans/create-pull-request@v2
        with:
          commit-message: 'Bumped the NPM version to match next release'
          title: 'Bumped the NPM version to match next release'
          commiter: GitHub <noreply@github.com>
          branch: chore/npm-version-bump
          labels: chore
          base: develop

```

### Options

**Environment Variables**

- **DESIRED_BUMP** (optional) - Which type of bump to use, minor will be used by default if none are provided.

**Outputs**

- **new_npm_version** - The new npm version, or the actual one if it has not been modified.

## Workflow

- Add this action to your repo
- Commit some changes
- Push to develop, or open a PR
- On push to `develop`, the action will
  - Get the latest tag
  - Bump the npm version with `minor` version unless the DESIRED_BUMP is set to `major` or `patch`
    - Make sure that your bump match the one in Release Drafter so your npm version always match the nest release.
  - The create-pull-request action will then create a branch, and a PR from this branch to `develop`
  - This PR will be labeled as `chore`
