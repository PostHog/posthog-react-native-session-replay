#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(PosthogReactNativeSessionReplay, NSObject)

RCT_EXTERN_METHOD(start:(NSString)sessionId
                 withSdkOptions:(NSDictionary)sdkOptions
                 withSdkReplayConfig:(NSDictionary)sdkReplayConfig
                 withDecideReplayConfig:(NSDictionary)decideReplayConfig
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(startSession:(NSString)sessionId
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(isEnabled:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(endSession:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(identify:(NSString)distinctId
                  withAnonymousId:(NSString)anonymousId
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
