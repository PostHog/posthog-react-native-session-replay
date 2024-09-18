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

    PostHogSessionManager.shared.startSession(sessionId)

    let config = PostHogConfig(apiKey: apiKey, host: host)
    config.sessionReplay = true
    config.captureApplicationLifecycleEvents = false
    config.captureScreenViews = false
    config.debug = debug
    config.sessionReplayConfig.screenshotMode = true
    // TODO: all missing config from sdkReplayConfig and decideReplayConfig
    PostHogSDK.shared.setup(config)

    resolve(nil)
  }
  
  @objc(startSession:withResolver:withRejecter:)
  func startSession(sessionId: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    PostHogSessionManager.shared.startSession(sessionId)
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
