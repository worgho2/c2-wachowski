import Foundation

class DataAccessObject {
    
    private static let fileNameBasedOnUniqueUUID = UUID().uuidString
    private static let filePath = getDocumentsDirectory().appendingPathComponent(fileNameBasedOnUniqueUUID)
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func storeUser() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: Model.instance.user!, requiringSecureCoding: false)
            try data.write(to: filePath)
            print("SUCESSO SALVANDO EM CACHE")
        } catch {
            print("ERRO: [\(error.localizedDescription)]")
        }
    }
    
    static func retrieveUser() -> User? {
        do {
            let data = try Data(contentsOf: filePath)
            let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? User
            print("SUCESSO RECUPERANDO DO CACHE")
            return user
        } catch {
            print("ERRO: [\(error.localizedDescription)]")
            return nil
        }
    }
}
