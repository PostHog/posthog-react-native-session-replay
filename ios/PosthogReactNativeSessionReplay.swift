import PostHog

@objc(PosthogReactNativeSessionReplay)
class PosthogReactNativeSessionReplay: NSObject {

  private var config: PostHogConfig?

  @objc(start:withSdkOptions:withSdkReplayConfig:withDecideReplayConfig:withResolver:withRejecter:)
  func start(sessionId: String, sdkOptions: [String: Any], sdkReplayConfig: [String: Any], decideReplayConfig: [String: Any], resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) {
    let apiKey = sdkOptions["apiKey"] as? String ?? ""
    let host = sdkOptions["host"] as? String ?? PostHogConfig.defaultHost
    let debug = sdkOptions["debug"] as? Bool ?? false

    PostHogSessionManager.shared.setSessionId(sessionId)

    let config = PostHogConfig(apiKey: apiKey, host: host)
    config.sessionReplay = true
    config.captureApplicationLifecycleEvents = false
    config.captureScreenViews = false
    config.debug = debug
    config.sessionReplayConfig.screenshotMode = true

    let maskAllTextInputs = sdkReplayConfig["maskAllTextInputs"] as? Bool ?? true
    config.sessionReplayConfig.maskAllTextInputs = maskAllTextInputs

    let maskAllImages = sdkReplayConfig["maskAllImages"] as? Bool ?? true
    config.sessionReplayConfig.maskAllImages = maskAllImages

    let maskAllSandboxedViews = sdkReplayConfig["maskAllSandboxedViews"] as? Bool ?? true
    config.sessionReplayConfig.maskAllSandboxedViews = maskAllSandboxedViews

    let maskPhotoLibraryImages = sdkReplayConfig["maskPhotoLibraryImages"] as? Bool ?? true
    config.sessionReplayConfig.maskPhotoLibraryImages = maskPhotoLibraryImages

    let iOSdebouncerDelayMs = sdkReplayConfig["iOSdebouncerDelayMs"] as? Int ?? 1000
    let timeInterval: TimeInterval = Double(iOSdebouncerDelayMs) / 1000.0
    config.sessionReplayConfig.debouncerDelay = timeInterval

    let captureNetworkTelemetry = sdkReplayConfig["captureNetworkTelemetry"] as? Bool ?? true
    config.sessionReplayConfig.captureNetworkTelemetry = captureNetworkTelemetry

    let endpoint = decideReplayConfig["endpoint"] as? String ?? ""
    if !endpoint.isEmpty {
      config.snapshotEndpoint = endpoint
    }

    let distinctId = sdkOptions["distinctId"] as? String ?? ""
    let anonymousId = sdkOptions["anonymousId"] as? String ?? ""

    let sdkVersion = sdkOptions["sdkVersion"] as? String ?? ""

    let flushAt = sdkOptions["flushAt"] as? Int ?? 20
    config.flushAt = flushAt

    if !sdkVersion.isEmpty {
        postHogSdkName = "posthog-react-native"
        postHogVersion = sdkVersion
    }

    PostHogSDK.shared.setup(config)

    self.config = config

    setIdentify(self.config?.storageManager, distinctId: distinctId, anonymousId: anonymousId)

    resolve(nil)
  }
  
  @objc(startSession:withResolver:withRejecter:)
  func startSession(sessionId: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    PostHogSessionManager.shared.setSessionId(sessionId)
    PostHogSDK.shared.startSession()
    resolve(nil)
  }
  
  @objc(isEnabled:withRejecter:)
  func isEnabled(resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    let isEnabled = PostHogSDK.shared.isSessionReplayActive()
    resolve(isEnabled)
  }
  
  @objc(endSession:withRejecter:)
  func endSession(resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    PostHogSDK.shared.endSession()
    resolve(nil)
  }

  @objc(identify:withAnonymousId:withResolver:withRejecter:)
  func identify(distinctId: String, anonymousId: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    setIdentify(self.config?.storageManager, distinctId: distinctId, anonymousId: anonymousId)

    resolve(nil)
  }

  private func setIdentify(_ storageManager: PostHogStorageManager?, distinctId: String, anonymousId: String) {
    guard let storageManager = storageManager else {
      return
    }
    if !anonymousId.isEmpty {
      storageManager.setAnonymousId(anonymousId)
    }
    if !distinctId.isEmpty {
      storageManager.setDistinctId(distinctId)
    }
  }
}
