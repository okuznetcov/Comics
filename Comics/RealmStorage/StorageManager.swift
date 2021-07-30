import RealmSwift

let realm = try! Realm()

class StoargeManager {
    static func saveObject(_ comic: Comic) {            // добавление нового комикса в БД
        try! realm.write {
            realm.add(comic)
        }
    }
    
    static func deleteObject(_ comic: Comic) {          // удаление нового комикса в БД
        try! realm.write {
            realm.delete(comic)
        }
    }
    
    static func editObjectImage(_ comic: Comic, imageData: Data) {      // добавление картинки комикса в БД
        try! realm.write {
            comic.imageData = imageData
        }
    }
}
