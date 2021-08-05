import Foundation

struct Comic {
    
    var marvelId = ""                     // id комикса в Marvel API
    var title = ""                        // название
    var pageCount: String?                // число страницы
    var descr: String?                    // описание
    var date = Date()                     // дата создания
    var comicImage: ComicImage?           // изображение
    var imagePath: String                 // ссылка на изображение
    var imageExt: String                  // расширение изображения ( необходимо для API-запроса )
    
    
    init(marvelId: String, title: String, description: String?, pageCount: String?, path: String, ext: String) {
        self.marvelId = marvelId
        self.title = title
        self.descr = description
        self.pageCount = pageCount
        self.imagePath = path
        self.imageExt = ext
    }
    
}

// изображение комикса
struct ComicImage {
    var imageData: Data?
    init(imageData: Data) {
        self.imageData = imageData
    }
}
