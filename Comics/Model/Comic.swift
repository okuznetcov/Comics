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

class Comic: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var pageCount: String?
    
    // назначенный инициализатор
    convenience init(title: String, pageCount: String?) {
        self.init() // инициализируем свойства по умолчанию
        self.title = title
        self.pageCount = pageCount
    }
}
