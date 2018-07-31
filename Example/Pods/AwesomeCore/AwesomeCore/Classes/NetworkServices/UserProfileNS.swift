//
//  UserProfileNS.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 04/09/2017.
//

import Foundation

class UserProfileNS {
    
    static var shared = UserProfileNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var lastUserProfileRequest: URLSessionDataTask?
    var lastQuestUserProfileRequest: URLSessionDataTask?
    var lastUserProfilePictureRequest: URLSessionDataTask?
    var lastUpdateProfileRequest: URLSessionDataTask?
    var lastHomeUserProfileRequest: URLSessionDataTask?
    var lastUpdateHomeUserProfileRequest: URLSessionDataTask?
    
    init() {}
    
    func fetchUserProfile(forcingUpdate: Bool, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        
        //        lastUserProfileRequest?.cancel()
        lastUserProfileRequest = nil
        
        lastUserProfileRequest = awesomeRequester.performRequestAuthorized(ACConstants.shared.userProfileURL, forceUpdate: forcingUpdate) { (data, error, responseType) in
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.lastUserProfileRequest = nil
                response(UserProfileMP.parseUserProfileFrom(jsonObject), nil)
            } else {
                self.lastUserProfileRequest = nil
                if let error = error {
                    response(nil, error)
                    return
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
            }
        }
    }
    
    func fetchQuestUserProfile(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping (UserProfile?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let userProfile = UserProfileMP.parseUserProfileFrom(data)
            response(userProfile, nil)
            
            return userProfile != nil
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                lastQuestUserProfileRequest?.cancel()
                lastQuestUserProfileRequest = nil
            }
            
            lastQuestUserProfileRequest = awesomeRequester.performRequestAuthorized(
                ACConstants.shared.questsURL, forceUpdate: forceUpdate, method: .POST, jsonBody: QuestProfileGraphQLModel.queryProfile(), completion: { (data, error, responseType) in
                    self.lastQuestUserProfileRequest = nil
                    
                    //process response
                    let hasResponse = processResponse(data: data, response: response)
                    
                    //fetches again based on response type
                    if !forceUpdate && responseType == .cached {
                        didRespondCachedData = hasResponse
                        
                        fetchFromAPI(forceUpdate: true)
                    } else if let error = error {
                        print("Error fetching from API: \(error.message)")
                        
                        if !didRespondCachedData {
                            response(nil, error)
                        }
                    }
            })
        }
        
        // fetches from cache if the case
        if params.contains(.shouldFetchFromCache) {
            fetchFromAPI(forceUpdate: false)
        } else {
            fetchFromAPI(forceUpdate: true)
        }
    }
    
    func uploadUserProfilePicture(usingPicture picture: UIImage, response: @escaping ([String: AnyObject]?, ErrorData?) -> Void) {
        
        let jpegCompressionQuality: CGFloat = 0.7 // Set this to whatever suits your purpose
        guard let base64String = UIImageJPEGRepresentation(picture, jpegCompressionQuality)?
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
        
        //        lastUpdateProfileRequest?.cancel()
        lastUpdateProfileRequest = nil
        
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
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping (HomeUserProfile?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let user = UserProfileMP.parseHomeUserProfileFrom(data)
            response(user, nil)
            
            return user != nil
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
//                lastHomeUserProfileRequest?.cancel()
                lastHomeUserProfileRequest = nil
            }
            
            lastHomeUserProfileRequest = awesomeRequester.performRequestAuthorized(
                ACConstants.shared.userProfileForToken, forceUpdate: forceUpdate, method: .GET, completion: { (data, error, responseType) in
                    self.lastHomeUserProfileRequest = nil
                    
                    //process response
                    let hasResponse = processResponse(data: data, response: response)
                    
                    //fetches again based on response type
                    if !forceUpdate && responseType == .cached {
                        didRespondCachedData = hasResponse
                        
                        fetchFromAPI(forceUpdate: true)
                    } else if let error = error {
                        print("Error fetching from API: \(error.message)")
                        
                        if !didRespondCachedData {
                            response(nil, error)
                        }
                    }
            })
        }
        
        // fetches from cache if the case
        if params.contains(.shouldFetchFromCache) {
            fetchFromAPI(forceUpdate: false)
        } else {
            fetchFromAPI(forceUpdate: true)
        }
        
    }
    
    // updateHomeUserProfile
    func updateHomeUserProfile(withEmail email: String?, firstName: String?, lastName: String?, gender: String?, lang: String?, dateOfBirth: String?,
                               phone: String?, profession: String?, industry: String?, country: String?, city: String?, shortBio: String?, discoverable: Bool?,
                               website: String?, title: String?, facebook: String?, twitter: String?, linkedIn: String?, metaTags: String?,
                               ageGroup: String?, response: @escaping (HomeUserProfile?, ErrorData?) -> Void) {
        //        lastUpdateHomeUserProfileRequest?.cancel()
        lastUpdateHomeUserProfileRequest = nil
        
        let headers = AwesomeCore.getMobileRequestHeaderWithApiKeys()
        
        var body: [String : Any] = [:]
        
        body["email"] = email
        body["first_name"] = firstName
        body["last_name"] = lastName
        body["gender"] = gender
        body["lang"] = lang
        body["date_of_birth"] = dateOfBirth // not yet available for updating in the api endpoint. as of today 06.07.2018
        body["phone"] = phone
        body["profession"] = profession
        body["industry"] = industry
        body["country"] = country
        body["city"] = city
        body["bio"] = shortBio
        body["discoverable"] = discoverable?.description
        body["website"] = website
        body["title"] = title
        body["facebook"] = facebook
        body["twitter"] = twitter
        body["linked_in"] = linkedIn
        body["meta_tags"] = metaTags
        body["enrolment_group"] = ageGroup
        
        lastUpdateHomeUserProfileRequest = awesomeRequester.performRequest(ACConstants.shared.updateUserProfileForToken, method: .PUT, forceUpdate: true, jsonBody: body, headers: headers) { (data, error, responseType) in
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
