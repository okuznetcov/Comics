import Foundation
import CryptoKit

let PUBLIC_KEY = "3da5d03b94d2533740ede81f1d6baf7f";
let PRIVATE_KEY = "6da1e100b192ee4ac295b0dc7675b6b69425d4d3";
let ENTRY_POINT = "https://gateway.marvel.com/v1/public/"

class Networking {

    
    fileprivate func timestamp() -> Double {
        return Date().timeIntervalSince1970
    }
    
    fileprivate func getHash(timestamp: Double) -> String {
        let d = "\(timestamp)\(PRIVATE_KEY)\(PUBLIC_KEY)"
        let r = Insecure.MD5.hash(data: d.data(using: .utf8)!)
        return String("\(r)".split(separator: " ")[2])
    }
    
    fileprivate func addAuthCredits(url: String) -> String {
        let currentTimestamp = timestamp()
        return "\(ENTRY_POINT)\(url)?ts=\(currentTimestamp)&apikey=\(PUBLIC_KEY)&hash=\(getHash(timestamp: currentTimestamp))"
    }
    
    /*
     
     var objects = [Comic]()
     
     func getObjects() {
         let networking = Networking(url: "https://gateway.marvel.com/v1/public/comics")
         networking.makeRequest { [weak self] result in
             guard let self = self else { return }
             DispatchQueue.main.async {
                 switch result {
                 case .success(let data):
                     self.objects = data!
                     print(self.objects.count)
                 case .failure(let error):
                     print("error")
                 }
             }
         }
     }
     
     
     */
    
    /*let urlInput: String?

    init(url: String) {
        self.urlInput = url
    }
    
    public func makeRequest(completion: @escaping (Result<[Comic]?, Error>) -> Void) {
        let currentTimestamp = timestamp()
        guard let urlString = urlInput else { return }
        let validUrl = "\(urlString)?ts=\(currentTimestamp)&apikey=\(PUBLIC_KEY)&hash=\(getHash(timestamp: currentTimestamp))"
        print(validUrl)
        guard let url = URL(string: validUrl) else { return }
     
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
              //  let obj = try JSONDecoder().decode([Comic].self, from: data!)
               // completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }*/
    
    var urlInput = "comics"
    
    
    
    public func makeRequest(completion: @escaping (Result<[Comic]?, Error>) -> Void) {
        //guard let urlString = urlInput else { return }
        
       // let validUrl = "\(urlString)?ts=\(currentTimestamp)&apikey=\(PUBLIC_KEY)&hash=\(getHash(timestamp: currentTimestamp))"
      //  print(validUrl)
        let validUrl = addAuthCredits(url: urlInput)
        guard let url = URL(string: validUrl) else { return }
     
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            do {
              //  let obj = try JSONDecoder().decode([Comic].self, from: data!)
               // completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
