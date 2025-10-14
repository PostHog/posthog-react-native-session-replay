import PostHog

// Meant for internally logging PostHog related things
private func hedgeLog(_ message: String) {
    print("[PostHog] \(message)")
}

@objc(PosthogReactNativeSessionReplay)
class PosthogReactNativeSessionReplay: NSObject {
    private var config: PostHogConfig?

    @objc(start:withSdkOptions:withSdkReplayConfig:withDecideReplayConfig:withResolver:withRejecter:)
    func start(
        sessionId: String, sdkOptions: [String: Any], sdkReplayConfig: [String: Any],
        decideReplayConfig: [String: Any], resolve: RCTPromiseResolveBlock,
        reject _: RCTPromiseRejectBlock
    ) {
        // we've seen cases where distinctId and anonymousId are not strings, so we need to check and convert them
        guard let sessionIdStr = sessionId as? String else {
            hedgeLog("Invalid sessionId provided: \(sessionId). Expected a string.")
            resolve(nil)
            return
        }

        let apiKey = sdkOptions["apiKey"] as? String ?? ""
        let host = sdkOptions["host"] as? String ?? PostHogConfig.defaultHost
        let debug = sdkOptions["debug"] as? Bool ?? false

        PostHogSessionManager.shared.setSessionId(sessionIdStr)

        let config = PostHogConfig(apiKey: apiKey, host: host)
        config.sessionReplay = true
        config.captureApplicationLifecycleEvents = false
        config.captureScreenViews = false
        config.debug = debug
        config.sessionReplayConfig.screenshotMode = true
        config.surveys = false

        let maskAllTextInputs = sdkReplayConfig["maskAllTextInputs"] as? Bool ?? true
        config.sessionReplayConfig.maskAllTextInputs = maskAllTextInputs

        let maskAllImages = sdkReplayConfig["maskAllImages"] as? Bool ?? true
        config.sessionReplayConfig.maskAllImages = maskAllImages

        let maskAllSandboxedViews = sdkReplayConfig["maskAllSandboxedViews"] as? Bool ?? true
        config.sessionReplayConfig.maskAllSandboxedViews = maskAllSandboxedViews

        // read throttleDelayMs and use iOSdebouncerDelayMs as a fallback for back compatibility
        let throttleDelayMs =
            (sdkReplayConfig["throttleDelayMs"] as? Int)
                ?? (sdkReplayConfig["iOSdebouncerDelayMs"] as? Int)
                ?? 1000

        let timeInterval: TimeInterval = Double(throttleDelayMs) / 1000.0
        config.sessionReplayConfig.throttleDelay = timeInterval

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

        guard let storageManager = self.config?.storageManager else {
            hedgeLog("Storage manager is not available in the config.")
            resolve(nil)
            return
        }

        setIdentify(storageManager, distinctId: distinctId, anonymousId: anonymousId)

        resolve(nil)
    }

    @objc(startSession:withResolver:withRejecter:)
    func startSession(
        sessionId: String, resolve: RCTPromiseResolveBlock, reject _: RCTPromiseRejectBlock
    ) {
        // we've seen cases where distinctId and anonymousId are not strings, so we need to check and convert them
        guard let sessionIdStr = sessionId as? String else {
            hedgeLog("Invalid sessionId provided: \(sessionId). Expected a string.")
            resolve(nil)
            return
        }
        PostHogSessionManager.shared.setSessionId(sessionIdStr)
        PostHogSDK.shared.startSession()
        resolve(nil)
    }

    @objc(isEnabled:withRejecter:)
    func isEnabled(resolve: RCTPromiseResolveBlock, reject _: RCTPromiseRejectBlock) {
        let isEnabled = PostHogSDK.shared.isSessionReplayActive()
        resolve(isEnabled)
    }

    @objc(endSession:withRejecter:)
    func endSession(resolve: RCTPromiseResolveBlock, reject _: RCTPromiseRejectBlock) {
        PostHogSDK.shared.endSession()
        resolve(nil)
    }

    @objc(identify:withAnonymousId:withResolver:withRejecter:)
    func identify(
        distinctId: String, anonymousId: String, resolve: RCTPromiseResolveBlock,
        reject _: RCTPromiseRejectBlock
    ) {
        // we've seen cases where distinctId and anonymousId are not strings, so we need to check and convert them
        guard let distinctIdStr = distinctId as? String,
              let anonymousIdStr = anonymousId as? String
        else {
            hedgeLog(
                "Invalid distinctId: \(distinctId) or anonymousId: \(anonymousId) provided. Expected strings."
            )
            resolve(nil)
            return
        }
        guard let storageManager = config?.storageManager else {
            hedgeLog("Storage manager is not available in the config.")
            resolve(nil)
            return
        }
        setIdentify(storageManager, distinctId: distinctIdStr, anonymousId: anonymousIdStr)

        resolve(nil)
    }

    private func setIdentify(
        _ storageManager: PostHogStorageManager, distinctId: String, anonymousId: String
    ) {
        if !anonymousId.isEmpty {
            storageManager.setAnonymousId(anonymousId)
        }
        if !distinctId.isEmpty {
            storageManager.setDistinctId(distinctId)
        }
    }
}
