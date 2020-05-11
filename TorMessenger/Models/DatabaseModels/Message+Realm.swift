import RealmSwift

final class MessageRealmObject: Object {
    dynamic var fromUserId = String()
    dynamic var toUserId = String()
    dynamic var messageId: String?
    dynamic var text = String()
    dynamic var sentTime: UInt64 = 0
    
    init(with model: Message) {
        self.fromUserId = model.fromUserId
        self.toUserId = model.toUserId
        self.messageId = model.messageId
        self.text = model.text
        self.sentTime = model.sentTime
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
