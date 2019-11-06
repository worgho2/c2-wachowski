import Foundation

class Model {
    static let instance = Model()
    
    var user: User?
    
    private init() {
        loadUser { () -> User? in
            return DataAccessObject.retrieveUser()
        }
    }
    
    func loadUser( user: () -> User? ) {
        self.user = user()
    }

}

