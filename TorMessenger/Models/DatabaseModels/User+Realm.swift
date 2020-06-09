import Foundation
import RealmSwift

final class UserRealmObject: Object {
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String?
    @objc dynamic var bio: String?
    @objc dynamic var shortAddress: String = ""
    @objc dynamic var lastSeen: String? = ""
    
    convenience init(with model: User) {
        self.init()
        self.firstName = model.firstName
        self.lastName = model.lastName
        self.bio = model.bio
        self.shortAddress = model.shortAddress
        self.lastSeen = model.lastSeen
    }
    override static func primaryKey() -> String? {
        return "shortAddress"
    }
}
