import UIKit

// структуры для парсинга JSON-ответа Marvel API

struct APIComicResult: Codable {
    var data: APIComicData
}

struct APIComicData: Codable {
    var count: Int
    var results: [DownloadedComic]
}

struct DownloadedComic: Identifiable, Codable {
    var id: Int
    var title: String
    var description: String?
    var pageCount: Int
    var thumbnail: ImageData
    var urls: [[String: String]]
}

struct ImageData: Codable {
    var path: String
    var `extension`: String
}


