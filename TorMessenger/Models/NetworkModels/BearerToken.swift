import ObjectMapper

struct BearerToken: Mappable {
    var userId = ""
    var token = ""
    var expirationDate = 0
    
    init?(map: Map) {}
       
    mutating func mapping(map: Map) {
        userId <- map["userId"]
        token <- map["token"]
        expirationDate <- map["expirationDate"]
    }
}
