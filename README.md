# posthog-react-native-session-replay

Session Replay for React Native (Android and iOS)

## Installation

```sh
npm install posthog-react-native-session-replay
```

## iOS dependency resolution

By default, `posthog-ios` is resolved through CocoaPods trunk via `pod install`.

[CocoaPods trunk goes read-only on 2026-12-02](https://blog.cocoapods.org/CocoaPods-Specs-Repo/) and `posthog-ios` is moving to Swift Package Manager (see [PostHog/posthog-ios#472](https://github.com/PostHog/posthog-ios/issues/472)). To opt this package into the SPM resolution path early, add the following to your app's `ios/Podfile.properties.json`:

```json
{
  "posthog.useSpm": "true"
}
```

When that property is set and React Native >= 0.75 is in use, `pod install` resolves `posthog-ios` from `https://github.com/PostHog/posthog-ios.git` via the RN `spm_dependency` helper. The SPM path requires `use_frameworks! :linkage => :dynamic` in your `Podfile` ([known limitation](https://github.com/facebook/react-native/pull/44627#issuecomment-2123119711)).
