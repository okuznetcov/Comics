import UIKit

class imageLoader {
    static func getImage(comic: Comic) -> UIImage {
        if let imageData = comic.imageData {            // если у комикса есть изображение, возвращаем его
            return UIImage(data: imageData)!
        } else {                                        // иначе возвращаем стандартное
            return UIImage(named: "defaultComicImage")!
        }
    }
}

