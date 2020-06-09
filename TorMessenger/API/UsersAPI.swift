import Foundation
import Moya
import SwiftyUserDefaults

enum UsersAPI {
    case getUserInformation(parameter: String)
    case register(userParameter: UserRegistration)
    case auth(credentials: Auth)
    case fetchMultipleUsers(parameter: [String])
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
        case .fetchMultipleUsers:
            return "/fetchMultiple"
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
        case .fetchMultipleUsers:
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
        case .fetchMultipleUsers(parameter: let parameter):
            return .requestJSONEncodable(parameter)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .auth:
            return ["Content-Type": "application/json"]
        case .register:
            return ["Content-Type": "application/json"]
        case .getUserInformation:
            return ["Content-Type": "application/json",
                    "Authorization" : "Bearer \(Defaults[\.authToken])"]
        case .fetchMultipleUsers:
            return ["Content-Type": "application/json",
                    "Authorization" : "Bearer \(Defaults[\.authToken])"]
        }
        
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
