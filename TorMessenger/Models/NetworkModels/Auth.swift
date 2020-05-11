import Foundation
import ObjectMapper

struct Auth: Mappable {
    var shortAddress = String()
    var passwordHash = String()
    
    init(login: String, passwordHash: String) {
        self.shortAddress = login
        self.passwordHash = passwordHash
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        shortAddress <- map["shortAddress"]
        passwordHash <- map["passwordHash"]
    }
}
