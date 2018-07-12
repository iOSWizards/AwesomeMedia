//
//  AcademyBO.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 30/08/2017.
//

import Foundation

public struct AcademyBO {
    
    static var academyNS = AcademyNS.shared
    
    private init() {}
    
    /// Fetch Academies to a given user authenticated.
    ///
    /// **Note: This block operation is sent back to the Main thread once its execution is done.**
    ///
    /// - forcingUpdate: a flag used to force updating the local cache ( false by default )
    /// - Parameter response: an Array of ACAcademies or in case of error
    ///an empty Array of ACAcademies and the proper error object with.
    public static func fetchAcademies(forcingUpdate: Bool = false, response: @escaping ([ACAcademy], ErrorData?) -> Void) {
        academyNS.fetchAcademies(forcingUpdate: forcingUpdate) { (academies, error) in
            DispatchQueue.main.async {
                response(academies, error)
            }
        }
    }
    
    public static func fetchMembershipAcademies(forcingUpdate: Bool = false, response: @escaping ([MembershipAcademy], ErrorData?) -> Void) {
        academyNS.fetchMembershipAcademies(forcingUpdate: forcingUpdate) { (academies, error) in
            DispatchQueue.main.async {
                response(academies, error)
            }
        }
    }
    
    public static func fetchAcademy(usingAcademyId: Int, forcingUpdate: Bool = false, response: @escaping (ACAcademy?, ErrorData?) -> Void) {
        academyNS.fetchAcademy(usingAcademy: usingAcademyId) { (academy, error) in
            DispatchQueue.main.async {
                response(academy, error)
            }
        }
    }
    
    public static func fetchAcademiesAsCollections(
        itemsPerPage: Int, forcingUpdate: Bool = false, response: @escaping ([ACAcademy], ErrorData?) -> Void) {
        academyNS.fetchAcademiesTypedAs(.collection, itemsPerPage: itemsPerPage, forcingUpdate: forcingUpdate) { (academiesAsCollections, error) in
            DispatchQueue.main.async {
                response(academiesAsCollections, error)
            }
        }
    }
    
    public static func fetchAcademiesAsSubscriptions(
        itemsPerPage: Int, forcingUpdate: Bool = false, response: @escaping ([ACAcademy], ErrorData?) -> Void) {
        academyNS.fetchAcademiesTypedAs(.subscription, itemsPerPage: itemsPerPage, forcingUpdate: forcingUpdate) { (academiesAsSubscriptions, error) in
            DispatchQueue.main.async {
                response(academiesAsSubscriptions, error)
            }
        }
    }
    
}
