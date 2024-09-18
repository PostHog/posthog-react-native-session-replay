import { useState, useEffect } from 'react';
import { StyleSheet, View, Text, Platform } from 'react-native';
import type PostHogReactNativeSessionReplay from 'posthog-react-native-session-replay';

export let OptionalReactNativeSessionReplay:
  | typeof PostHogReactNativeSessionReplay
  | undefined;

try {
  OptionalReactNativeSessionReplay = Platform.select({
    macos: undefined,
    web: undefined,
    default: require('posthog-react-native-session-replay'), // Only Android and iOS
  });
} catch (e) {
  // do nothing
  console.warn(
    'PostHog Debug',
    `Error loading posthog-react-native-session-replay: ${e}`
  );
}

export default function App() {
  const [result, setResult] = useState<string | undefined>();

  useEffect(() => {
    if (OptionalReactNativeSessionReplay) {
      setResult('ok');
      // OptionalReactNativeSessionReplay.isEnabled().then((isEnabled) => {
      //   console.warn('PostHog Debug', `isEnabled: ${isEnabled}`);
      //   setResult(isEnabled.valueOf().toString());
      // });
      // OptionalReactNativeSessionReplay.startSession(
      //   'e58ed763-928c-4155-bee9-fdbaaadc15f3'
      // )
      //   .then(() => {
      //     setResult('ok');
      //   })
      //   .catch(() => {
      //     setResult('failed');
      //   });
      // OptionalReactNativeSessionReplay.start(
      //   'e58ed763-928c-4155-bee9-fdbaaadc15f3',
      //   {
      //     apiKey: 'phc_QFbR1y41s5sxnNTZoyKG2NJo2RlsCIWkUfdpawgb40D',
      //     host: 'https://us.i.posthog.com',
      //   },
      //   {},
      //   {}
      // )
      //   .then(() => {
      //     OptionalReactNativeSessionReplay?.isEnabled().then((isEnabled) => {
      //       console.warn('PostHog Debug', `isEnabled: ${isEnabled}`);
      //       setResult(`isEnabled: ${isEnabled}`);
      //     });
      //   })
      //   .then(() => {
      //     setResult('ok');
      //   })
      //   .catch(() => {
      //     setResult('failed');
      //   });
    } else {
      console.warn('PostHog Debug', `meh`);
    }
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
