import Foundation
import ObjectMapper

struct UserRegistration: Mappable, Codable {
    var firstName: String = ""
    var lastName: String?
    var bio: String?
    var shortAddress: String = ""
    var passwordHash: String = ""
    
    init(firstName: String, lastName: String, bio: String?,
         shortAddress: String, passwordHash: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.shortAddress = shortAddress
        self.passwordHash = passwordHash
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        bio <- map["bio"]
        shortAddress <- map["shortAddress"]
        passwordHash <- map["passwordHash"]
    }
}
