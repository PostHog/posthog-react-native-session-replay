import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'posthog-react-native-session-replay' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const PosthogReactNativeSessionReplay =
  NativeModules.PosthogReactNativeSessionReplay
    ? NativeModules.PosthogReactNativeSessionReplay
    : new Proxy(
        {},
        {
          get() {
            throw new Error(LINKING_ERROR);
          },
        }
      );

export function multiply(a: number, b: number): Promise<number> {
  return PosthogReactNativeSessionReplay.multiply(a, b);
}

export function start(
  sessionId: string,
  sdkOptions: { [key: string]: any },
  sdkReplayConfig: { [key: string]: any },
  decideReplayConfig: { [key: string]: any }
): Promise<void> {
  return PosthogReactNativeSessionReplay.start(
    sessionId,
    sdkOptions,
    sdkReplayConfig,
    decideReplayConfig
  );
}

export function startSession(sessionId: string): Promise<void> {
  return PosthogReactNativeSessionReplay.startSession(sessionId);
}

export function endSession(): Promise<void> {
  return PosthogReactNativeSessionReplay.endSession();
}

export function isEnabled(): Promise<boolean> {
  return PosthogReactNativeSessionReplay.isEnabled();
}

export interface PostHogReactNativeSessionReplayModule {
  start: (
    sessionId: string,
    sdkOptions: { [key: string]: any }, // options from SDK such as apiKey
    sdkReplayConfig: { [key: string]: any }, // config from SDK
    decideReplayConfig: { [key: string]: any } // config from Decide API
  ) => Promise<void>;

  startSession: (sessionId: string) => Promise<void>;

  endSession: () => Promise<void>;

  isEnabled: () => Promise<boolean>;
}

const PostHogReactNativeSessionReplay: PostHogReactNativeSessionReplayModule = {
  start,
  startSession,
  endSession,
  isEnabled,
};

export default PostHogReactNativeSessionReplay;
