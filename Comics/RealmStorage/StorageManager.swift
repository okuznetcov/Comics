import RealmSwift

let realm = try! Realm()

class StoargeManager {
    static func saveObject(_ comic: Comic) {
        try! realm.write {
            realm.add(comic)
        }
    }
    
    static func deleteObject(_ comic: Comic) {
        try! realm.write {
            realm.delete(comic)
        }
    }
    
    static func editObjectImage(_ comic: Comic, imageData: Data) {
        try! realm.write {
            comic.imageData = imageData
        }
    }
    
    static func editObject(parameter: () -> Void) {
        try! realm.write {
            parameter()
        }
    }
}
