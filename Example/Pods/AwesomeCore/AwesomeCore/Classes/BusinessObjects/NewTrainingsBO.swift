//
//  NewTrainingsBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 05/09/17.
//

import Foundation

public struct NewTrainingsBO {
    
    static var newTrainingsNS = NewTrainingsNS.shared
    
    private init() {}
    
    public static func fetchNewTrainings(forcingUpdate: Bool = false, response: @escaping ([TrainingCard], ErrorData?) -> Void) {
        newTrainingsNS.fetchNewTrainings(forcingUpdate: forcingUpdate) { (newTrainings, error) in
            DispatchQueue.main.async {
                response(newTrainings, error)
            }
        }
    }
}
