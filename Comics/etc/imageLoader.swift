import UIKit

class imageLoader {
    static func getImage(comic: Comic) -> UIImage {
        if let imageData = comic.imageData {
            return UIImage(data: imageData)!
        } else {
            return UIImage(named: "defaultComicImage")!
        }
    }
}

extension UIImageView {
    func makeRounded() {
        print("ffff")
    }
}


