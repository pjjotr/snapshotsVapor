import Vapor
import FluentSQLite
import Authentication

final class User: Codable {
    var id: Int?
    var username: String
    var password: String
}

extension User {
    var snapshots: Children<User, Snapshot> {
        return children(\.userID)
    }
}

extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \.username
    static let passwordKey: PasswordKey = \.password
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}

extension User: SQLiteModel {}
extension User: Content {}
extension User: Migration {}
extension User: Parameter {}
