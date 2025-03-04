package com.posthogreactnativesessionreplay

import android.util.Log
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.UiThreadUtil

import com.posthog.PostHog
import com.posthog.PostHogConfig
import com.posthog.android.PostHogAndroid
import com.posthog.android.PostHogAndroidConfig
import com.posthog.internal.PostHogPreferences
import com.posthog.internal.PostHogPreferences.Companion.ANONYMOUS_ID
import com.posthog.internal.PostHogPreferences.Companion.DISTINCT_ID
import com.posthog.internal.PostHogSessionManager
import java.util.UUID

class PosthogReactNativeSessionReplayModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  fun start(
    sessionId: String,
    sdkOptions: ReadableMap,
    sdkReplayConfig: ReadableMap,
    decideReplayConfig: ReadableMap,
    promise: Promise
  ) {
    val initRunnable = Runnable {
      try {
        val uuid = UUID.fromString(sessionId)
        PostHogSessionManager.setSessionId(uuid)

        val context = this.reactApplicationContext
        val apiKey = sdkOptions.getString("apiKey") ?: ""
        val host = sdkOptions.getString("host") ?: PostHogConfig.DEFAULT_HOST
        val debugValue = sdkOptions.getBoolean("debug")

        val maskAllTextInputs = sdkReplayConfig.getBoolean("maskAllTextInputs")
        val maskAllImages = sdkReplayConfig.getBoolean("maskAllImages")
        val captureLog = sdkReplayConfig.getBoolean("captureLog")
        val debouncerDelayMs = sdkReplayConfig.getInt("androidDebouncerDelayMs")

        val endpoint = decideReplayConfig.getString("endpoint")

        val distinctId = try {
          sdkOptions.getString("distinctId") ?: ""
        } catch (e: Throwable) {
          logError("parse distinctId", e)
          ""
        }
        val anonymousId = try {
          sdkOptions.getString("anonymousId") ?: ""
        } catch (e: Throwable) {
          logError("parse anonymousId", e)
          ""
        }
        val theSdkVersion = sdkOptions.getString("sdkVersion")

        var theFlushAt = 20
        if (sdkOptions.hasKey("flushAt")) {
          theFlushAt = sdkOptions.getInt("flushAt")
        }

        val config = PostHogAndroidConfig(apiKey, host).apply {
          debug = debugValue
          captureDeepLinks = false
          captureApplicationLifecycleEvents = false
          captureScreenViews = false
          flushAt = theFlushAt
          sessionReplay = true
          sessionReplayConfig.screenshot = true
          sessionReplayConfig.captureLogcat = captureLog
          sessionReplayConfig.debouncerDelayMs = debouncerDelayMs.toLong()
          sessionReplayConfig.maskAllImages = maskAllImages
          sessionReplayConfig.maskAllTextInputs = maskAllTextInputs

          if (!endpoint.isNullOrEmpty()) {
            snapshotEndpoint = endpoint
          }

          if (!theSdkVersion.isNullOrEmpty()) {
            sdkName = "posthog-react-native"
            sdkVersion = theSdkVersion
          }
        }
        PostHogAndroid.setup(context, config)

        setIdentify(config.cachePreferences, distinctId, anonymousId)
      } catch (e: Throwable) {
        logError("start", e)
      } finally {
        promise.resolve(null)
      }
    }

    // forces the SDK to be initialized on the main thread
    if (UiThreadUtil.isOnUiThread()) {
      initRunnable.run()
    } else {
      UiThreadUtil.runOnUiThread(initRunnable)
    }
  }

  @ReactMethod
  fun startSession(sessionId: String, promise: Promise) {
    try {
      val uuid = UUID.fromString(sessionId)
      PostHogSessionManager.setSessionId(uuid)
      PostHog.startSession()
    } catch (e: Throwable) {
      logError("startSession", e)
    } finally {
      promise.resolve(null)
    }
  }

  @ReactMethod
  fun isEnabled(promise: Promise) {
    try {
      promise.resolve(PostHog.isSessionReplayActive())
    } catch (e: Throwable) {
      logError("isEnabled", e)
      promise.resolve(false)
    }
  }

  @ReactMethod
  fun endSession(promise: Promise) {
    try {
      PostHog.endSession()
    } catch (e: Throwable) {
      logError("endSession", e)
    } finally {
      promise.resolve(null)
    }
  }

  @ReactMethod
  fun identify(distinctId: String, anonymousId: String, promise: Promise) {
    try {
      setIdentify(PostHog.getConfig<PostHogConfig>()?.cachePreferences, distinctId, anonymousId)
    } catch (e: Throwable) {
      logError("identify", e)
    } finally {
      promise.resolve(null)
    }
  }

  private fun setIdentify(
    cachePreferences: PostHogPreferences?,
    distinctId: String,
    anonymousId: String
  ) {
    cachePreferences?.let { preferences ->
      if (anonymousId.isNotEmpty()) {
        preferences.setValue(ANONYMOUS_ID, anonymousId)
      }
      if (distinctId.isNotEmpty()) {
        preferences.setValue(DISTINCT_ID, distinctId)
      }
    }
  }

  private fun logError(method: String, error: Throwable) {
    Log.println(Log.ERROR, POSTHOG_TAG, "Method $method, error: $error")
  }

  companion object {
    const val NAME = "PosthogReactNativeSessionReplay"
    const val POSTHOG_TAG = "PostHog"
  }
}
