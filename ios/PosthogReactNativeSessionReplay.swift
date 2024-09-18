import PostHog

@objc(PosthogReactNativeSessionReplay)
class PosthogReactNativeSessionReplay: NSObject {

  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }
  
  @objc(start:withSdkOptions:withSdkReplayConfig:withDecideReplayConfig:withResolver:withRejecter:)
  func start(sessionId: String, sdkOptions: [String: Any], sdkReplayConfig: [String: Any], decideReplayConfig: [String: Any], resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) {
    resolve(nil)
  }
  
  @objc(startSession:withResolver:withRejecter:)
  func startSession(sessionId: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(nil)
  }
  
  @objc(isEnabled:withRejecter:)
  func isEnabled(resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Bool {
    let isEnabled = false
    resolve(isEnabled)
    return isEnabled
  }
  
  @objc(endSession:withRejecter:)
  func endSession(resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(nil)
  }
}
