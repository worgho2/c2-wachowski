import Foundation

class Model {
    static let instance = Model()
    private init() { }
    
    var user: User?
    
    func loadUser( user: () -> User ) {
        self.user = user()
    }

}

class DataAccessObject {
    
    static func loadFromUserDefaults() {
        //pegar pra salvar no model
    }
    
    static func saveOnUserDefaults() {
        //limpar tudo e escrever de novo ou verificar se tem mudanças
    }

}
