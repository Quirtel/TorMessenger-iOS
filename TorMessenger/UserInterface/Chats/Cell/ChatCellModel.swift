import UIKit

struct ChatCellModel {
    var name: String
    var lastMessageText: String
    var sentTime: String
    
    init(name: String, lastMessageText: String, sentTime: String) {
        self.name = name
        self.lastMessageText = lastMessageText
        self.sentTime = sentTime
    }
    
    init(name: String, lastMessageText: String, sentTime: UInt64) {
        self.name = name
        self.lastMessageText = lastMessageText
        self.sentTime = String(sentTime)
    }
}
