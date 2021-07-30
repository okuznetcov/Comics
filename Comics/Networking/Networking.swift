import CryptoKit
import UIKit

let PUBLIC_KEY = "3da5d03b94d2533740ede81f1d6baf7f";
let PRIVATE_KEY = "6da1e100b192ee4ac295b0dc7675b6b69425d4d3";
let ENTRY_POINT = "https://gateway.marvel.com/v1/public"

class Networking {
    
    static var shared: Networking {
        return Networking()
    }
    
    fileprivate func timestamp() -> Double {        // получаем timestamp который хочет Marvel API для авторизации
        return Date().timeIntervalSince1970
    }
    
    fileprivate func getHash(timestamp: Double) -> String {     // генерируем хэш из timestamp и двух ключей
        let d = "\(timestamp)\(PRIVATE_KEY)\(PUBLIC_KEY)"
        let r = Insecure.MD5.hash(data: d.data(using: .utf8)!)
        return String("\(r)".split(separator: " ")[2])
    }
    
    fileprivate func addAuthCredits(url: String, params: String) -> String {        // добавляем ключи к url
        let currentTimestamp = timestamp()
        return "\(ENTRY_POINT)\(url)?ts=\(currentTimestamp)&\(params)&apikey=\(PUBLIC_KEY)&hash=\(getHash(timestamp: currentTimestamp))"
    }
    
    fileprivate func getImageUrl(url: String, imageExtension: String) -> String {        // добавляем ключи к url
        var address = "\(url)/portrait_incredible.\(imageExtension)"
        if (address.hasPrefix("http")) {
            address = "https" + address.dropFirst(4)
        }
        return address
    }
    
    
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
    
    func fetchImage(url: String, imageExtension: String) -> Data? {
        let imageUrl = getImageUrl(url: url, imageExtension: imageExtension)
        print(imageUrl)
        if imageUrl.contains("image_not_available") {
            return nil
        }
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
            return UIImage(data: data)?.pngData()
        }
        return nil
    }
}
