
struct Message {
    var fromUserId = String()
    var toUserId = String()
    var messageId: String?
    var text = String()
    var sentTime: UInt64 = 0
    
    init(fromUserId: String, toUserId: String, messageId: String,
         text: String, sentTime: UInt64) {
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.messageId = messageId
        self.text = text
        self.sentTime = sentTime
    }
}
