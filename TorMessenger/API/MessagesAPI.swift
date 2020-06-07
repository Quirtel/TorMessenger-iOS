import Moya
import SwiftyUserDefaults

public enum MessagesAPI {
    case send(toUserId: String, text: String)
    case retrieve
}

extension MessagesAPI: TargetType {
    public var baseURL: URL {
        URL(string: "http://localhost:8080/v1/messages")!
    }
    
    public var path: String {
        switch self {
        case .send:
            return "/send"
        case .retrieve:
            return "/retrieve"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .send:
            return .post
        case .retrieve:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .send(let toUserId, let text):
            return .requestParameters(parameters: ["toUserId" : toUserId, "text" : text], encoding: JSONEncoding.default)
        case .retrieve:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Authorization" : "Bearer \(Defaults[\.authToken])"
        ]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
