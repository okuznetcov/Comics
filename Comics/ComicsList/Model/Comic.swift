//
//  Comic.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 27.07.2021.
//

/*import Foundation

struct Comic: Codable {
    var title: String
    var pageCount: Int
}*/


import RealmSwift

class Comic: Object, Decodable {
    
    @objc dynamic var marvelId = ""
    @objc dynamic var title = ""
    @objc dynamic var pageCount: String?
    @objc dynamic var descr: String = "Недоступно"
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    
    // назначенный инициализатор
    convenience init(marvelId: String, title: String, description: String, pageCount: String?, imageData: Data?) {
        self.init() // инициализируем свойства по умолчанию
        self.marvelId = marvelId
        self.title = title
        self.descr = description
        self.pageCount = pageCount
        self.imageData = imageData
    }
    
    // назначенный инициализатор
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
