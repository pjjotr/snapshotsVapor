import Vapor
import Authentication

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")
        registerCreateUser(usersRoute)
        registerGetSingleUser(usersRoute)
        
        let authenticatedRoute = usersRoute.grouped([User.tokenAuthMiddleware(), User.guardAuthMiddleware()])
        registerMe(authenticatedRoute)
    }
    
    private func registerCreateUser(_ route: Router) {
        route.post("create") { (req) -> Future<User> in
            try req.content.decode(User.self)
            .flatMap(to: User.self) { (user) in
                user.password = try BCrypt.hash(user.password)
                return user.save(on: req)
            }
        }
    }
    
    private func registerMe(_ route: Router) {
        route.get("me") { (req) -> User in
            try req.requireAuthenticated(User.self)
        }
    }
    
    private func registerGetSingleUser(_ route: Router) {
        route.get(User.parameter) { (req) -> Future<User> in
            try req.parameters.next(User.self)
        }
    }
}
