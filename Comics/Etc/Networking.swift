import Foundation
import CryptoKit

let PUBLIC_KEY = "3da5d03b94d2533740ede81f1d6baf7f";
let PRIVATE_KEY = "6da1e100b192ee4ac295b0dc7675b6b69425d4d3";
let ENTRY_POINT = "https://gateway.marvel.com/v1/public"

class Networking {

    let urlInput: String?               // основа url-запроса, например /comics
    
    init(url: String) {
        self.urlInput = url
    }
    
    fileprivate func timestamp() -> Double {        // получаем timestamp который хочет Marvel API для авторизации
        return Date().timeIntervalSince1970
    }
    
    fileprivate func getHash(timestamp: Double) -> String {     // генерируем хэш из timestamp и двух ключей
        let d = "\(timestamp)\(PRIVATE_KEY)\(PUBLIC_KEY)"
        let r = Insecure.MD5.hash(data: d.data(using: .utf8)!)
        return String("\(r)".split(separator: " ")[2])
    }
    
    fileprivate func addAuthCredits(url: String) -> String {        // добавляем ключи к url
        let currentTimestamp = timestamp()
        return "\(ENTRY_POINT)\(url)?ts=\(currentTimestamp)&limit=1&apikey=\(PUBLIC_KEY)&hash=\(getHash(timestamp: currentTimestamp))"
    }
    
    public func makeRequest(completion: @escaping (Result<[Comic]?, Error>) -> Void) {
        guard let urlString = urlInput else { return }
        let validUrl = addAuthCredits(url: urlString)
        print(validUrl)
        guard let url = URL(string: validUrl) else { return }
     
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                
                if let dictionary = json as? [String: Any] {
                    if let dat = dictionary["data"] as? [String: Any] {
                        print(dat)
                    }
                }
//                //let obj = try JSONDecoder().decode([Comic].self, from: data!)
//                //completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
