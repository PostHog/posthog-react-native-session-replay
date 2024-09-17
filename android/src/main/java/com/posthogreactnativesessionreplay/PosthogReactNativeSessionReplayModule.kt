package com.posthogreactnativesessionreplay

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableMap;

import com.posthog.PostHog
import com.posthog.android.PostHogAndroid
import com.posthog.android.PostHogAndroidConfig
import com.posthog.internal.PostHogSessionManager
import java.util.UUID

class PosthogReactNativeSessionReplayModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  fun multiply(a: Double, b: Double, promise: Promise) {
    promise.resolve(a * b)
  }

  @ReactMethod
  fun start(sessionId: String, sdkOptions: ReadableMap, sdkReplayConfig: ReadableMap, decideReplayConfig: ReadableMap, promise: Promise) {
    val uuid = UUID.fromString(sessionId)
    PostHogSessionManager.setSessionId(uuid)

    val context = this.getReactApplicationContext()
    val apiKey = sdkOptions.getString("apiKey") ?: ""
    val host = sdkOptions.getString("host") ?: ""

    val config = PostHogAndroidConfig(apiKey, host)
    PostHogAndroid.setup(context, config)

    promise.resolve(null)
  }

  @ReactMethod
  fun startSession(sessionId: String, promise: Promise) {
    val uuid = UUID.fromString(sessionId)
    PostHogSessionManager.setSessionId(uuid)
    PostHog.startSession()
    promise.resolve(null)
  }

  @ReactMethod
  fun isEnabled(promise: Promise) {
    promise.resolve(PostHog.isSessionReplayActive())
  }

  @ReactMethod
  fun endSession(promise: Promise) {
    promise.resolve(null)
  }

  companion object {
    const val NAME = "PosthogReactNativeSessionReplay"
  }
}
