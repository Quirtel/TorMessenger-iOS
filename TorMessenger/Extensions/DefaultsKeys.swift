import SwiftyUserDefaults

extension DefaultsKeys {
    var username: DefaultsKey<String?> { .init("username") }
    var passwordHash: DefaultsKey<String?> { .init("passwordHash") }
    var authToken: DefaultsKey<String> { .init("authToken", defaultValue: "") }
    var tokenExpirationDate: DefaultsKey<String> { .init("expiresAt", defaultValue: "") }
    var firstName: DefaultsKey<String> { .init("firstName", defaultValue: "") }
    var lastName: DefaultsKey<String> { .init("lastName", defaultValue: "") }
    var bio: DefaultsKey<String> { .init("bio", defaultValue: "") }
}
