import Foundation

class DataAccessObject {
    
    static func storeUser() {
        save(object: Model.instance.user, key: "user")
    }
    
    static func retrieveUser() -> User? {
        return load(type: User.self, key: "user")
    }
    
    private static func save<T: Encodable>(object: T?, key: String) {
        let userDefaults = UserDefaults.standard
        if let object = object {
            do {
                let data = try JSONEncoder().encode(object)
                userDefaults.set(data, forKey: key)
            } catch  {
                print("Erro: [\(error.localizedDescription)]")
            }
        } else {
            userDefaults.set(nil, forKey: key)
            userDefaults.removeObject(forKey: key)
        }
    }
    
    private static func load<T : Decodable>(type: T.Type, key: String) -> T? {
        let userDefaults  = UserDefaults.standard
        if let value = userDefaults.data(forKey: key) {
            do {
                let object = try JSONDecoder().decode(T.self, from: value)
                return object
            } catch {
                print("Erro: [\(error.localizedDescription)]")
                return nil
            }
        }
        return nil
    }
}
