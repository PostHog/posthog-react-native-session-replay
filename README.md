# posthog-react-native-session-replay

Session Replay for React Native (Android and iOS)

## Installation

```sh
npm install posthog-react-native-session-replay
```

## iOS dependency resolution

`posthog-ios` is resolved through Swift Package Manager when the React Native `spm_dependency` podspec helper is available (RN >= 0.75); older React Native versions fall back to CocoaPods trunk. The install command (`pod install`) is unchanged — the swap is internal to the podspec.

Once [CocoaPods trunk goes read-only on 2026-12-02](https://blog.cocoapods.org/CocoaPods-Specs-Repo/), React Native < 0.75 consumers will need to upgrade React Native to keep receiving `posthog-ios` updates.
