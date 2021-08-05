import UIKit

final class ImageExtractor {
    
    static let defaultImage = UIImage(named: "defaultComicImage")!
    
    static func getImage(from image: ComicImage?) -> UIImage {
        if let imageData = image?.imageData {            // если у комикса есть изображение, возвращаем его
            return UIImage(data: imageData) ?? defaultImage
        } else {                                        // иначе возвращаем стандартное
            return defaultImage
        }
    }
}

