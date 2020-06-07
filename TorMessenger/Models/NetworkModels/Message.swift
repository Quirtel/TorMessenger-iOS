import ObjectMapper

struct Message: Mappable {
    var fromUserId = String()
    var toUserId = String()
    var messageId: String?
    var text = String()
    var sentTime: Int64 = 0
    
    init(fromUserId: String, toUserId: String, messageId: String?,
         text: String, sentTime: Int64) {
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.messageId = messageId
        self.text = text
        self.sentTime = sentTime
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.fromUserId <- map["fromUserId"]
        self.toUserId <- map["toUserId"]
        self.messageId <- map["messageId"]
        self.text <- map["text"]
        self.sentTime <- map["sentTime"]
    }
}
