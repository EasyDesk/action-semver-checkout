# action-semver-checkout
An action that can be used to checkout repos instead of the classic `actions/checkout`.
This action fetches the complete history of the reporitory, then inspects the history in order to 
compute the correct current version with [Semantic Versioning](https://semver.org/).
It also inspects the github event in order to determine whether the current run should trigger a release.


## Usage
This action requires that the tags containing and representing a new version of the software comply with Semantic Version, prefixed by a `v`.

### Usage example
```yaml
    steps:
      - id: semver-checkout # The id field is necessary to capture the action's outputs
        uses: EasyDesk/action-semver-checkout@v1
        with:          
          # (Optional) Repository name with owner (e.g. EasyDesk/action-semver-checkout)
          # If not specified, defaults to ${{ github.repository }}.
          repository: <repo-owner>/<repo-name>
          
          # (Optional) GitHub token that grants access to the repository.
          # If not specified, defaults to ${{ github.token }}.
          token: <token>
          
          # (Optional) Whether to execute `git clean -ffdx && git reset --hard HEAD` before fetching.
          # If not specified, defaults to true.
          clean: true
          
          # (Optional) Whether to download Git-LFS files.
          # If not specified, defaults to false.
          lfs: true
          
          # (Optional) Whether and how to checkout submodules.
          # A 'true' value means to checkout submodules.
          # A 'false' value means to not checkout submodules.
          # A 'recursive' value means to checkout submodules recursively.
          # If not specified, it defaults to false.
          submodule: recursive
      
      # Outputs usage example
      - uses: .../...@...
        with:
          ...: ${{ steps.semver-checkout.outputs.version }}              # Semantic version without the 'v' prefix
          ...: ${{ steps.semver-checkout.outputs.is-dev-version }}       # 'true' if version is a dev build (untagged commit)
          ...: ${{ steps.semver-checkout.outputs.major }}                # Major version
          ...: ${{ steps.semver-checkout.outputs.minor }}                # Minor version
          ...: ${{ steps.semver-checkout.outputs.patch }}                # Patch version
          ...: ${{ steps.semver-checkout.outputs.prerelease }}           # Prerelease version
          ...: ${{ steps.semver-checkout.outputs.build }}                # Build version
          ...: ${{ steps.semver-checkout.outputs.should-release }}       # 'true' if the workflow should trigger a release (tagged commit with semver)
          ...: ${{ steps.semver-checkout.outputs.is-github-prerelease }} # 'true' if the version is a beta, that is it starts with 0. or is a dev version
```
