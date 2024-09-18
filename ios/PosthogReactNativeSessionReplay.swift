import PostHog

@objc(PosthogReactNativeSessionReplay)
class PosthogReactNativeSessionReplay: NSObject {

  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }
  
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

    let maskAllTextInputs = sdkReplayConfig["maskAllTextInputs"] as? Bool ?? false
    config.sessionReplayConfig.maskAllTextInputs = maskAllTextInputs

    let maskAllImages = sdkReplayConfig["maskAllImages"] as? Bool ?? false
    config.sessionReplayConfig.maskAllImages = maskAllImages

    let iOSdebouncerDelayMs = sdkReplayConfig["iOSdebouncerDelayMs"] as? Int ?? 1000
    let timeInterval: TimeInterval = Double(iOSdebouncerDelayMs) / 1000.0
    config.sessionReplayConfig.debouncerDelay = timeInterval

    let captureNetworkTelemetry = sdkReplayConfig["captureNetworkTelemetry"] as? Bool ?? false
    config.sessionReplayConfig.captureNetworkTelemetry = captureNetworkTelemetry

//    let endpoint = decideReplayConfig["endpoint"] as? String?
//    if let endpoint = endpoint {
//      config.sessionReplayConfig.snapshotEndpoint = endpoint
//    }

    PostHogSDK.shared.setup(config)

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
}
