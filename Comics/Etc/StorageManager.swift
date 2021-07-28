import RealmSwift

let realm = try! Realm()

class StoargeManager {
    static func saveObject(_ place: Comic) {
        try! realm.write {
            realm.add(place)
        }
    }
}
