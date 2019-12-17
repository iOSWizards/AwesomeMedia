//
//  AwesomeTrackingV2.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/10/19.
//

import Foundation
import AwesomeCore
import AppsFlyerLib
import Mixpanel
import Appboy_iOS_SDK

public class AwesomeTrackingV2: NSObject {
    
    private var formatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter
    }()
    
    private let headers: [[String]] = [["raw", "Content-Type"]]
    private let requester: AwesomeCoreRequester = AwesomeCoreRequester()
    
    /// New eventstream V2 method to register the user device, call it once on `didFinishLaunch`.
    public func registerDevice() {
        let body: [String: Any] = [
               "sent_at": formatter.string(from: Date()),
               "type": "register",
               "client_id": AwesomeTrackingConstants.stagingClientId,
                "context": [
                    "registered_at": formatter.string(from: Date()),
                    "braze_device_id": String(Appboy.sharedInstance()?.getDeviceId() ?? ""),
                    "mixpanel_id": String(Mixpanel.mainInstance().distinctId),
                    "appsflyer_device_id": String(AppsflyerHelper.appsFlyerUID),
                    "traits": [
                        "device_id": AwesomeTrackingConstants.deviceId
                    ]
                ]
        ]
        
        _ = requester.performRequest(AwesomeTrackingConstants.registerUrl, method: .POST, bodyData: buildData(body), headerValues: headers, forceUpdate: true, shouldCache: false, timeoutAfter: 20, completion: { (data, error, _) in
            if let data = data {
                print("EVENTSTREAM V2 - register \(String(data: data, encoding: .utf8) ?? "no data")")
            }
            print("EVENTSTREAM V2 - register \(String(describing: error))")
        })
    }
    
    /// New eventstream V2 method to identify the user, call it once after the user is logged in and you already called `AwesomeTracking.setUserProfile`.
    public func identify() {
        let body: [String: Any] = [
                  "sent_at": formatter.string(from: Date()),
                   "type": "identity",
                   "client_id": AwesomeTrackingConstants.stagingClientId,
                   "context": [
                       "appsflyer_device_id": AppsflyerHelper.appsFlyerUID,
                       "braze_id": String(Appboy.sharedInstance()?.getDeviceId() ?? ""),
                       "mixpanel_id": Mixpanel.mainInstance().distinctId,
                       "traits": [
                        "user_id": AwesomeTracking.shared.user?.uid ?? "not",
                        "device_id": AwesomeTrackingConstants.stagingClientId
                       ]
                   ]
        ]
        
        _ = requester.performRequest(AwesomeTrackingConstants.identifyUrl, method: .POST, bodyData: buildData(body), headerValues: headers, forceUpdate: true, shouldCache: false, timeoutAfter: 20, completion: { (data, error, _) in
            if let data = data {
                print("EVENTSTREAM V2 - identify \(String(data: data, encoding: .utf8) ?? "no data")")
            }
            print("EVENTSTREAM V2 - identify \(String(describing: error))")
        })
    }
    
    /// New eventstream V2 method to send events to MV analytics.
    /// - Parameter appVersion: The app version number, from the main app, library will always ask it.
    /// - Parameter eventName: The event name you are going to send.
    /// - Parameter properties: The properties for the event that you are going to send, it's represented by a dictionary of Strings.
    public func sendEvent(_ eventName: String, properties: [String: String]) {
        var properties: [String: String] = properties
        properties["platform"] = "iOS"
        properties["app_version"] = appVersion
        properties["email"] = AwesomeTracking.shared.user?.email ?? "not set"
        properties["auth0 id"] = AwesomeTracking.shared.user?.uid ?? "not set"
        properties["app_name"] = "Mindvalley App"
        let body: [String: Any] = [
                    "type": "event",
                    "sent_at": formatter.string(from: Date()),
                    "client_id": AwesomeTrackingConstants.stagingClientId,
                    "integrations": AwesomeTracking.shared.activeEventstreamTools.map({ (tool) -> String in
                        return tool.rawValue
                    }),
                    "context": [
                      "active": "true",
                      "app": [
                        "name": "MV app iOS",
                        "version": appVersion
                      ],
                      "device": [
                        "brand": "Apple",
                        "model": UIDevice.current.localizedModel,
                        "manufacturer": "Apple"
                      ],
                      "os": [
                        "name": UIDevice.current.systemName,
                        "version": UIDevice.current.systemVersion
                      ],
                      "timezone": Calendar.current.timeZone.identifier,
                      "traits": [
                        "device_id": AwesomeTrackingConstants.deviceId,
                        "user_id": AwesomeTracking.shared.user?.uid ?? "not"
                      ]
                    ],
                    "data": [
                            [
                              "event": eventName,
                              "properties": properties
                            ]
                        ]
        ]
        
        _ = requester.performRequest(AwesomeTrackingConstants.eventsUrl, method: .POST, bodyData: buildData(body), headerValues: headers, forceUpdate: true, shouldCache: false, timeoutAfter: 20, completion: { (data, error, _) in
            if let data = data {
                print("EVENTSTREAM V2 - event \(String(data: data, encoding: .utf8) ?? "no data")")
            }
            print("EVENTSTREAM V2 - event \(String(describing: error))")
        })
    }
    
}

// Data builder

extension AwesomeTrackingV2 {
    
    private func buildData(_ body: [String: Any]) -> Data? {
        var data: Data?
        do {
            try data = JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            NSLog("Error unwraping json object")
        }
        return data
    }
    
}

// MARK: - Helpers

extension AwesomeTrackingV2 {
    private var appVersion: String {
        let dictionary = Bundle.main.infoDictionary!
        if let version = dictionary["CFBundleShortVersionString"] as? String, let build = dictionary["CFBundleVersion"] as? String {
            return "\(version) build \(build)"
        }
        return ""
    }
}
