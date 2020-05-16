import SwiftyUserDefaults

extension DefaultsKeys {
    var username: DefaultsKey<String?> { .init("username") }
    var passwordHash: DefaultsKey<String?> { .init("passwordHash") }
    var authToken: DefaultsKey<String> { .init("authToken", defaultValue: "") }
    var tokenExpirationDate: DefaultsKey<String> { .init("expiresAt", defaultValue: "") }
}
