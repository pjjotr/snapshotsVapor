import FluentSQLite
import Vapor
import Authentication

final class Token: Codable {
    var id: UUID?
    var token: String
    var userID: User.ID
    
    init(token: String, userID: User.ID) {
        self.token = token
        self.userID = userID
    }
}

extension Token {
    static func generate(for user: User, on req: Request) throws -> Token {
        let random = try CryptoRandom().generateData(count: 32).base32EncodedString()
        return try Token(token: random, userID: user.requireID())
    }
}

extension Token: Authentication.Token {
    static let userIDKey: UserIDKey = \Token.userID
    typealias UserType = User
}

extension Token: BearerAuthenticatable {
    static let tokenKey: TokenKey = \Token.token
}

extension Token: SQLiteUUIDModel {}
extension Token: Migration {}
extension Token: Content {}
