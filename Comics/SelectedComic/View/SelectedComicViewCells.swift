import UIKit

// ячейка обложки комикса
class imageCell: UITableViewCell {
    
    static let identifier = "imageCell"
    
    var image = UIImageView()       // обложка
    
    // инициализируем ячейка
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(image)
        configureImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureImage() {
        image.layer.cornerRadius = 10       // сглаженные углы
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.widthAnchor.constraint(equalTo: image.heightAnchor, multiplier: 2/3).isActive = true
    }
}


// Ячейка текстового значения
class textCell: UITableViewCell {
    
    static let identifier = "textCell"
    
    var title = UILabel()                       // значение поля
    var cellDescription = UILabel()             // описание поля
    
    // инициализируем ячейка
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(title)
        addSubview(cellDescription)
        cellDescription.textColor = .gray         // сделаем описание поля серым цветом и меньшего размера, чем значение
        cellDescription.font = cellDescription.font.withSize(13)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupConstraints() {
        cellDescription.numberOfLines = 0
        cellDescription.adjustsFontSizeToFitWidth = true  // текст будет уменьшаться, чтобы влезать по ширине экрана
        cellDescription.translatesAutoresizingMaskIntoConstraints = false
        cellDescription.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        cellDescription.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        cellDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true  // текст будет уменьшаться, чтобы влезать по ширине экрана
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        title.topAnchor.constraint(equalTo: cellDescription.bottomAnchor, constant: 3).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}

