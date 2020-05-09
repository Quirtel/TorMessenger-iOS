import Foundation

struct User {
    var firstName: String
    var lastName: String?
    var bio: String?
    var shortAddress: String
    var lastSeen: String
    
    init(firstName: String, lastName: String, bio: String?, shortAddress: String, lastSeen: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
        self.shortAddress = shortAddress
        self.lastSeen = lastSeen
    }
}
