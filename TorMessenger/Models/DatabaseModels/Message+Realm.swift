import RealmSwift
import MessageKit

final class MessageRealmObject: Object {
   @objc dynamic var fromUserId = String()
   @objc dynamic var toUserId = String()
   @objc dynamic var messageIdentifier: String?
   @objc dynamic var text = String()
   @objc dynamic var sentTime: Int64 = 0
    
    convenience init(with model: Message) {
        self.init()
        self.fromUserId = model.fromUserId
        self.toUserId = model.toUserId
        self.messageIdentifier = model.messageId
        self.text = model.text
        self.sentTime = model.sentTime
    }
}

extension MessageRealmObject: SenderType {
    var senderId: String {
        return fromUserId
    }
    
    var displayName: String {
        return fromUserId
    }
}

extension MessageRealmObject: MessageType {
    var sender: SenderType {
        return self
    }
    
    
    var messageId: String {
        return self.messageIdentifier ?? "0"
    }
    
    var sentDate: Date {
        return .init(timeIntervalSince1970: TimeInterval(sentTime))
    }
    
    var kind: MessageKind {
        .text(self.text)
    }
}
