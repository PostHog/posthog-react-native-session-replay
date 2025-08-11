Releasing
=========

 1. Update the CHANGELOG.md with the version and date 
 2. Choose a tag name (e.g. `3.0.0`), this is the version number of the release.
    1. Preview releases follow the pattern `3.0.0-alpha.1`, `3.0.0-beta.1`, `3.0.0-RC.1`
    2. Execute the script with the tag's name, the script will update the version file and create a tag.

    ```bash
    ./scripts/prepare-release.sh 3.0.0
    ```

 3. Go to [GH Releases](https://github.com/PostHog/posthog-react-native-session-replay/releases)
 4. Choose a release name (e.g. `3.0.0`), and the tag you just created, ideally the same.
 5. Write a description of the release.
 6. Publish the GH release.
 7. Publish the package to NPM (see notes below)
 8. Done

### Publishing to NPM

> **Note:** The package is currently published at [posthog-react-native-session-replay](https://www.npmjs.com/package/posthog-react-native-session-replay) under the [manoelposthog](https://www.npmjs.com/~manoelposthog) user. This should eventually be moved to the posthog user.

After completing steps 1-6 above, follow these steps to publish to NPM:

#### Prerequisites
- Ensure you have access to publish to the `posthog-react-native-session-replay` package on NPM
- If you don't have access, contact the package maintainer (currently https://www.npmjs.com/~manoelposthog) to grant your NPM user access to the package

#### Steps

1. **Install dependencies** (if not done already, required for the build process):
   ```bash
   npm install
   ```

2. **Authenticate with NPM** (if not already authenticated):
   ```bash
   npm adduser
   ```
   Follow the prompts to log in with your NPM credentials.

3. **Publish the package**:
   ```bash
   npm publish
   ```

The `npm publish` command will automatically run the `prepare` script which builds the package using `react-native-builder-bob` before publishing.