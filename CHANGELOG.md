## Next

## 1.1.1 - 2025-06-24

- fix: check if distinctId and anonId are a string before using it
- chore: pin the iOS SDK to 3.21.x
- chore: pin the Android SDK to 3.19.1

## 1.1.0 - 2025-06-06

- chore: remove maskPhotoLibraryImages from the SDK config

## 1.0.6 - 2025-04-22

- fix: add types key to package.json

## 1.0.5 - 2025-03-04

- chore: pin the iOS SDK to 3.20.x

## 1.0.4 - 2025-03-03

- chore: pin the iOS SDK to 3.18.x until we fix [this issue](https://github.com/PostHog/posthog-ios/issues/292)

## 1.0.3 - 2025-02-26

- chore: bump Android SDK to 3.11.3

## 1.0.2 - 2025-02-25

- fix: distinctId and anonymousId should degrade gracefully if they are strings that can't be parsed

## 1.0.1 - 2025-02-21

- chore: pin the iOS SDK to 3.x.x

## 1.0.0 - 2025-02-07

- chore: Session Replay - GA

## 0.1.9 - 2025-01-09

- chore: pin the iOS SDK to 3.18.0

## 0.1.8 - 2024-11-26

- fix: mask sandboxed system views like photo picker and user library photos

## 0.1.7 - 2024-11-19

- fix: respects the flushAt flag

## 0.1.6 - 2024-10-25

- chore: forces the SDK to be initialized on the main thread

## 0.1.5 - 2024-10-18

- chore: target min iOS 13 in podspec

## 0.1.4 - 2024-10-14

- chore: upgrade Android SDK to 3.8.2

## 0.1.3 - 2024-10-11

- chore: upgrade Android SDK to 3.8.1

## 0.1.2 - 2024-09-24

- chore: set the right sdk name and version

## 0.1.1 - 2024-09-24

- fix: session replay plugin isn't properly identifying users already identified

## 0.1.0 - 2024-09-19

- first minor release for React Native Session Replay
