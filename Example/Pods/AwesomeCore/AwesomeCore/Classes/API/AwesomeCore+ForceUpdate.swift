//
//  AwesomeCore+ForceUpdate.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 03/04/2019.
//

import Foundation

public extension AwesomeCore {
    
    public static func getForceUpdate(params: AwesomeCoreNetworkServiceParams, response: @escaping (FUVersionInfo?, ErrorData?) -> Void) {
        ForceUpdateNS.shared.getForceUpdate(params: .standard) { (fuResponse, error) in
            DispatchQueue.main.async {
                response(fuResponse, error)
            }
        }
    }
}
