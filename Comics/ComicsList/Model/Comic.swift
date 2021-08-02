import RealmSwift

class Comic: Object, Decodable {
    
    @objc dynamic var marvelId = ""                     // id комикса в Marvel API
    @objc dynamic var title = ""                        // название
    @objc dynamic var pageCount: String?                // число страницы
    @objc dynamic var descr: String = "Недоступно"      // описание
    @objc dynamic var imageData: Data?                  // изображение
    @objc dynamic var date = Date()                     // дата создания
                                                        // TODO: по плану мониторить дату последнего просмотра комикса и удалять старые
    
    convenience init(marvelId: String, title: String, description: String, pageCount: String?, imageData: Data?) {
        self.init() // инициализируем свойства по умолчанию
        self.marvelId = marvelId
        self.title = title
        self.descr = description
        self.pageCount = pageCount
        self.imageData = imageData
    }
    
    convenience init(marvelId: String, title: String, description: String?, pageCount: String?) {
        self.init() // инициализируем свойства по умолчанию
        self.marvelId = marvelId
        self.title = title
        if let description = description {
            self.descr = description
        }
        self.pageCount = pageCount
    }
}
