//
//  UserProfileNS.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 04/09/2017.
//

import Foundation

class UserProfileNS: BaseNS {
    
    static var shared = UserProfileNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var lastUserProfileRequest: URLSessionDataTask?
    var lastUserProfilePictureRequest: URLSessionDataTask?
    var lastUpdateProfileRequest: URLSessionDataTask?
    var lastHomeUserProfileRequest: URLSessionDataTask?
    var lastUpdateHomeUserProfileRequest: URLSessionDataTask?
    
    override init() {}
    
    func fetchUserProfile(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (UserProfile?, ErrorData?) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.lastUserProfileRequest = nil
                response(UserProfileMP.parseUserProfileFrom(jsonObject), nil)
                return true
            } else {
                self.lastUserProfileRequest = nil
                if let error = error {
                    response(nil, error)
                    return false
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.userProfileURL
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        lastUserProfileRequest = awesomeRequester.performRequestAuthorized(url, forceUpdate: true) { (data, error, responseType) in
            if processResponse(data: data, error: error, response: response) {
                self.saveToCache(url, method: method, bodyDict: nil, data: data)
            }
        }
    }
    
    func fetchQuestUserProfile(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (UserProfile?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let userProfile = UserProfileMP.parseUserProfileFrom(data)
            response(userProfile, nil)
            
            return userProfile != nil
        }
        
        let url = ACConstants.shared.questsURL
        let method: URLMethod = .POST
        let jsonBody = QuestProfileGraphQLModel.queryProfile()
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
        }
        
        _ = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: jsonBody, data: data)
                }
        })
        
    }
    
    func uploadUserProfilePicture(usingPicture picture: UIImage, response: @escaping ([String: AnyObject]?, ErrorData?) -> Void) {
        
        let jpegCompressionQuality: CGFloat = 0.7 // Set this to whatever suits your purpose
        guard let base64String = picture.jpegData(compressionQuality: jpegCompressionQuality)?
            .base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)) else {
                return
        }
        
        let profilePhotoBody = [
            "profile_photo": [
                "content": base64String,
                "content_type": "image/jpeg",
                "file_name": "profile_photo"]
        ]
        
        lastUserProfilePictureRequest?.cancel()
        lastUserProfilePictureRequest = nil
        
        lastUserProfilePictureRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.userProfilePictureURL, forceUpdate: true, method: .PUT, jsonBody: profilePhotoBody as [String: AnyObject], completion: { (data, error, responseType) in
                self.lastUserProfilePictureRequest = nil
                
                //process response
                if let jsonObject = AwesomeCoreParser.jsonObject(data) {
                    response(jsonObject as? [String: AnyObject], nil)
                } else {
                    response(nil, error)
                }
        })
    }
    
    func updateProfile(withEmail email: String, firstName: String, lastName: String, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        
        lastUpdateProfileRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.questsURL, forceUpdate: true, method: .POST, jsonBody: QuestProfileGraphQLModel.mutateUpdateProfile(email, firstName: firstName, lastname: lastName), completion: { (data, error, responseType) in
                if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                    self.lastUpdateProfileRequest = nil
                    response(UserProfileMP.parseUserProfileFrom(jsonObject), nil)
                } else {
                    self.lastUpdateProfileRequest = nil
                    if let error = error {
                        response(nil, error)
                        return
                    }
                    response(nil, ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
    
    func fetchHomeUserProfile(forcingUpdate: Bool, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (HomeUserProfile?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (HomeUserProfile?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let user = UserProfileMP.parseHomeUserProfileFrom(data)
            response(user, nil)
            
            return user != nil
        }
        
        let url = ACConstants.shared.userProfileForToken
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        lastHomeUserProfileRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, method: method, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: nil, data: data)
                }
        })
    }
    
    // updateHomeUserProfile
    func updateHomeUserProfile(profileDic: [String: Any], response: @escaping (HomeUserProfile?, ErrorData?) -> Void) {
        let headers = AwesomeCore.getMobileRequestHeaderWithApiKeys()
        lastUpdateHomeUserProfileRequest = awesomeRequester.performRequest(ACConstants.shared.updateUserProfileForToken, method: .PUT, forceUpdate: true, jsonBody: profileDic, headers: headers) { (data, error, responseType) in
            if let jsonObject = data {
                self.lastUpdateHomeUserProfileRequest = nil
                response(UserProfileMP.parseHomeUserProfileFrom(jsonObject), nil)
            } else {
                self.lastHomeUserProfileRequest = nil
                if let error = error {
                    response(nil, error)
                    return
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
            }
        }
    }
}
