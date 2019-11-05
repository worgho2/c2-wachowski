import Foundation

class DataAccessObject {
    
    private static let randomFilename = UUID().uuidString
    private static let fullPath = getDocumentsDirectory().appendingPathComponent(randomFilename)
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func storeUser() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: Model.instance.user!, requiringSecureCoding: false)
            try data.write(to: fullPath)
        } catch {
            print("Couldn't write file")
        }
    }
    
    static func retrieveUser() -> User? {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: fullPath.path) as? Data else { return nil }
        
        do {
            if let loadedUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? User {
                return loadedUser
            }
        } catch {
            print("Couldn't read file.")
        }
        
        return nil
    }
}
