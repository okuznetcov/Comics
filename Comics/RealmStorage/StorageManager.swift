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
}
