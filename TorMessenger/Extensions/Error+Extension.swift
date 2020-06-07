import Foundation
import Moya

extension Error {
    var statusCode: Int? {
        get {
            let moyaError: MoyaError? = self as? MoyaError
            let response : Response? = moyaError?.response
            let statusCode : Int? = response?.statusCode
            return statusCode
        }
    }
}
