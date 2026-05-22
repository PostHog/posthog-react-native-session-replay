---
'posthog-react-native-session-replay': minor
---

Add an opt-in Swift Package Manager resolution path for `posthog-ios`. Set `"posthog.useSpm": "true"` in your app's `ios/Podfile.properties.json` and (on RN >= 0.75) `pod install` will resolve `posthog-ios` from `https://github.com/PostHog/posthog-ios.git` via the RN `spm_dependency` helper instead of CocoaPods trunk.

Default behavior is unchanged: without the property, `posthog-ios` resolves through CocoaPods. This makes the SPM path available ahead of [PostHog/posthog-ios#472](https://github.com/PostHog/posthog-ios/issues/472) and the CocoaPods trunk read-only date (2026-12-02) without forcing consumers to migrate yet.

The SPM path uses `upToNextMinorVersion: 3.58.1` to match the existing CocoaPods `~> 3.58.1` constraint and requires `use_frameworks! :linkage => :dynamic` in the consumer's `Podfile` ([known RN limitation](https://github.com/facebook/react-native/pull/44627#issuecomment-2123119711)).
