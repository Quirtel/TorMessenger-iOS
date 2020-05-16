import Foundation
import RealmSwift

final class UserRealmObject: Object {
    dynamic var firstName: String = ""
    dynamic var lastName: String?
    dynamic var bio: String?
    dynamic var shortAddress: String = ""
    dynamic var lastSeen: String = ""
    
    convenience init(with model: User) {
        self.init()
        self.firstName = model.firstName
        self.lastName = model.lastName
        self.bio = model.bio
        self.shortAddress = model.shortAddress
        self.lastSeen = model.lastSeen
    }
}
