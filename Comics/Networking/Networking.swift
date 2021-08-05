import CryptoKit
import UIKit

final class Networking {
    
    private enum Consts {
        static let publicKey: String = "3da5d03b94d2533740ede81f1d6baf7f"
        static let privateKey: String = "6da1e100b192ee4ac295b0dc7675b6b69425d4d3"
        static let entryPoint: String = "https://gateway.marvel.com/v1/public"
    }
    
    static  var shared: Networking { return Networking() }
    private var imagesCache: [String: ComicImage] = [:]                 // кэш для изображений
    
    func fetchComics(url: String, params: String, completion: @escaping (Result<APIComicResult?, Error>) -> Void) {
        
        let validUrl = addAuthCredits(url: url, params: params)
        print(validUrl)
        
        let session = URLSession(configuration: .default)

        session.dataTask(with: URL(string: validUrl)!) { (data, _, err) in
            
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            guard let APIData = data else { return }
            
            do {
                let decodedData = try JSONDecoder().decode(APIComicResult.self, from: APIData)
                completion(.success(decodedData))
            }
            catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    
    func fetchImage(url: String, imageExtension: String) -> ComicImage? {
        print("request for image \(url)")
        let imageUrl = getImageUrl(url: url, imageExtension: imageExtension)            // формируем URL картинки
        if let cachedImage = self.imagesCache[imageUrl] {                                    // если картинка находится в кэше по URL - отдаем ее просто так
            print("returning image \(url) as cached")
            return cachedImage
        } else {                                    // если картинки нет в кэше
            if imageUrl.contains("image_not_available") {                               // если картинка - это Mарвелавская заглушка для комикса без картинки, то отдаем nil
                print("image \(url) is N/a")
                return nil
            }
                                                                                    // если картинка это не заглушка
            if let data = try? Data(contentsOf: URL(string: imageUrl)!) {               // грузим картинку из интернета
                //print(imageUrl)
                print("making web request for \(url)")
                let comicImage = ComicImage(imageData: (UIImage(data: data)?.pngData())!)   // создаем экземпляр класса, хранящий картинку и помещаем ее данные туда
                self.imagesCache[imageUrl] = comicImage    // сохраняем полученный класс в кэш
                return comicImage
            }
        }
        return nil
    }
    
    private func timestamp() -> Double {        // получаем timestamp который хочет Marvel API для авторизации
        return Date().timeIntervalSince1970
    }
    
    private func getHash(timestamp: Double) -> String {     // генерируем хэш из timestamp и двух ключей
        let d = "\(timestamp)\(Consts.privateKey)\(Consts.publicKey)"
        let r = Insecure.MD5.hash(data: d.data(using: .utf8)!)
        return String("\(r)".split(separator: " ")[2])
    }
    
    private func addAuthCredits(url: String, params: String) -> String {        // добавляем ключи к url
        let currentTimestamp = timestamp()
        return "\(Consts.entryPoint)\(url)?ts=\(currentTimestamp)&\(params)&apikey=\(Consts.publicKey)&hash=\(getHash(timestamp: currentTimestamp))"
    }
    
    private func getImageUrl(url: String, imageExtension: String) -> String {        // генерируем URL для изображения
        var address = "\(url)/portrait_incredible.\(imageExtension)"
        if (address.hasPrefix("http")) {
            address = "https" + address.dropFirst(4)
        }
        return address
    }
}
