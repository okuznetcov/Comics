import UIKit

final class ImageExtractor {
    static func getImage(from image: ComicImage?) -> UIImage {
        if let imageData = image?.imageData {            // если у комикса есть изображение, возвращаем его
            return UIImage(data: imageData)!
        } else {                                        // иначе возвращаем стандартное
            return UIImage(named: "defaultComicImage")!
        }
    }
}

