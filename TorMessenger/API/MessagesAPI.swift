import Moya

public enum Messages {
    case send
    case retrieve
}

extension Messages: TargetType {
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
        return .requestPlain
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}
