import Vapor
import Authentication

struct AuthenticationController: RouteCollection {
    func boot(router: Router) throws {
        let authenticationRoute = router
            .grouped("api", "authenticate")
            .grouped(User.basicAuthMiddleware(using: BCryptDigest()))
        
        registerAuthenticate(authenticationRoute)
    }
    
    private func registerAuthenticate(_ route: Router) {
        route.post() { (req) -> Future<Token> in
            let user = try req.requireAuthenticated(User.self)
            let token = try Token.generate(for: user, on: req)
            return token.save(on: req)
        }
    }
}
