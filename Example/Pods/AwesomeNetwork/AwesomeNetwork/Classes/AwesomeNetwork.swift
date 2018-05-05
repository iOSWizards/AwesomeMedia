//
//  AwesomeNetwork.swift
//  MVA Home
//
//  Created by Antonio da Silva on 20/02/2017.
//  Copyright © 2017 Mindvalley. All rights reserved.
//

import Foundation

public enum NetworkStateEvent: String {
    case connected = "connected"
    case disconnected = "disconnected"
}

public struct AwesomeNetwork {

    public static var shared: AwesomeNetworkHelper?
   
    public static func startNetworkStateNotifier() {
        shared = AwesomeNetworkHelper()
        shared?.startNetworkStateNotifier()
    }
}
