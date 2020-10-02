import Vapor
import FluentSQLite

final class Snapshot: Codable {
    var id: Int?
    var title: String
    var description: String?
    var userID: User.ID?
}

extension Snapshot: SQLiteModel {}
extension Snapshot: Content {}
extension Snapshot: Migration {}
extension Snapshot: Parameter {}
