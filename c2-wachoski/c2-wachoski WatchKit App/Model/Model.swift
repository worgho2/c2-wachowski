import Foundation

class Model {
    static let instance = Model()
    private init() {
        DataAccessObject.loadFromUserDefaults()
    }
    
    var user: User?
    var plants: [Plant] = []
    
    func loadUser( user: () -> User ) {
        self.user = user()
    }

}

