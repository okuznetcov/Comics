import UIKit

class ComicsRepository {
    
    private static let API = Networking.shared
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    // Загрузить комиксы из Marvel API
    static func loadComics(limit: Int, offset: Int, completion: @escaping ([Comic]) -> () ) {
        
        ComicsRepository.API.fetchComics(url: "/comics", params: "limit=\(limit)&offset=\(offset)", completion: { result in
            //guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    case .success(let apiData):
                
                        guard let apiData = apiData else { return }
                        
                        var fetchedComics: [Comic] = []                   // поместим загруженные комиксы в fetchedComics
                        
                        for comic in apiData.data.results {
                            
                            let newComic = Comic(marvelId: "\(comic.id)",
                                                 title: comic.title,
                                                 description: comic.description,
                                                 pageCount: "\(comic.pageCount)",
                                                 path: comic.thumbnail.path,
                                                 ext: comic.thumbnail.extension)
                            
                            fetchedComics.append(newComic)
                        }
                        
                        completion(fetchedComics)
                    case .failure(_):
                        print("error")
                 }
            }
        })
    }
    
    static func loadImage(imagePath: String, imageExtension: String, completion: @escaping (ComicImage?) -> ()) {
        DispatchQueue.global().async {
            let imageData = self.API.fetchImage(url: imagePath, imageExtension: imageExtension)
            DispatchQueue.main.async {
                completion(imageData)
            }
        }
    }
}
