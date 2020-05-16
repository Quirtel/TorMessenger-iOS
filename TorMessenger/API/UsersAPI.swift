import Foundation
import Moya

enum UsersAPI {
    case getUserInformation(parameter: String)
    case register(userParameter: User)
    case auth(credentials: Auth)
}

extension UsersAPI: TargetType {
    public var baseURL: URL {
        URL(string: "http://localhost:8080/v1/users")!
    }
    
    public var path: String {
        switch self {
        case .getUserInformation(let user):
            return "/getUserInformation/" + user
        case .register:
            return "/register"
        case .auth:
            return "/auth"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUserInformation:
            return .get
        case .register:
            return .post
        case .auth:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .auth(let credentials):
            return .requestParameters(parameters: credentials.toJSON(),
                                      encoding: JSONEncoding.default)
        case .getUserInformation:
            return .requestPlain
        case .register(userParameter: let userParameter):
            return .requestParameters(parameters: userParameter.toJSON(),
                                      encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
