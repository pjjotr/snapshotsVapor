import Vapor
import Authentication

struct SnapshotsController: RouteCollection {
    func boot(router: Router) throws {
        let route = router
            .grouped("api", "snapshots")
            .grouped([User.tokenAuthMiddleware(), User.guardAuthMiddleware()])
        
        registerGetSnapshots(route)
        registerCreateSnapshot(route)
    }
    
    private func registerGetSnapshots(_ route: Router) {
        route.get() { (req) -> Future<[Snapshot]> in
            let user = try req.requireAuthenticated(User.self)
            return try user.snapshots.query(on: req).all()
        }
    }
    
    private func registerCreateSnapshot(_ route: Router) {
        route.post() { (req) -> Future<Snapshot> in
            let user = try req.requireAuthenticated(User.self)
            return try req.content
                .decode(Snapshot.self)
                .flatMap(to: Snapshot.self) { (snapshot) in
                    snapshot.userID = user.id
                    return snapshot.save(on: req)
            }
        }
    }
}
