import UIKit

class ComicsListViewCell: UITableViewCell {
    
    static let identifier = "ComicsListViewCell"
    
    var image = UIImageView()       // пока что я ячейке будет название и обложка
    var title = UILabel()
    
    // инициализируем ячейку
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(image)
        addSubview(title)
        
        configureImage()
        configureTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureImage() {
        image.layer.cornerRadius = 10       // сглаженные углы
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        image.heightAnchor.constraint(equalToConstant: 130).isActive = true
        image.widthAnchor.constraint(equalTo: image.heightAnchor, multiplier: 2/3).isActive = true
    }
    
    fileprivate func configureTitle() {
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true  // текст будет уменьшаться, чтобы влезать по ширине экрана
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20).isActive = true
        title.heightAnchor.constraint(equalToConstant: 130).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}
