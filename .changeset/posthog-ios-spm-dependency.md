---
'posthog-react-native-session-replay': minor
---

Source `posthog-ios` via Swift Package Manager when the React Native `spm_dependency` podspec helper is available (RN >= 0.75). React Native < 0.75 still resolves `posthog-ios` through CocoaPods trunk via the fallback branch. This unblocks `posthog-ios`'s CocoaPods deprecation (see PostHog/posthog-ios#472) without changing how consumers install this package — `pod install` continues to work.

The SPM path uses `upToNextMinorVersion: 3.58.1` (`>= 3.58.1, < 3.59.0`) to match the existing CocoaPods `~> 3.58.1` constraint, so the current per-release bump cadence for `posthog-ios` is unchanged.
