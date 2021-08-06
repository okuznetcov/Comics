import UIKit

// ячейка обложки комикса
final class ImageCell: UITableViewCell {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    static  let identifier = "ImageCell"
    private let image = UIImageView()       // обложка
    
    // MARK: -- Инициализатор -----------------------------------------------------------------
    
    // инициализируем ячейку
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(image)
        configureImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -- Публичные методы ---------------------------------------------------------------
    
    // конфигуратор: принимает ссылку и формат изображения для запроса
    func configure(with viewModel: ImageViewModel) {

        // non-kf
        /*ComicsRepository.loadImage(imagePath: path,
                                   imageExtension: ext,
                                   completion: { downloadedImageData in
                                        self.image.image = ImageExtractor.getImage(from: downloadedImageData)
                                   })*/
        
        // kf
        ComicsRepository.loadImageKf(for: image,
                                     imagePath: viewModel.imagePath,
                                     imageExtension: viewModel.imageExt)
    }
    
    // MARK: -- Приватные методы ---------------------------------------------------------------
    
    private func configureImage() {
        image.layer.cornerRadius = 10       // сглаженные углы
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10),
            image.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: -10),
        ])
    }
}

// Ячейка текстового значения
final class TextCell: UITableViewCell {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    static  let identifier = "TextCell"
    private let text = UILabel()                       // значение поля
    private let title = UILabel()                      // описание поля
    
    // MARK: -- Инициализатор -----------------------------------------------------------------
    
    // инициализируем ячейку
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(text)
        addSubview(title)
        title.textColor = .gray         // сделаем описание поля серым цветом и меньшего размера, чем значение
        title.font = title.font.withSize(13)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -- Публичные методы ---------------------------------------------------------------
    
    // конфигуратор: принимает на вход текст и описание текстового поля
    func configure(with viewModel: TextCellViewModel) {
        self.text.text = viewModel.text
        self.title.text = viewModel.title
    }
    
    // MARK: -- Приватные методы ---------------------------------------------------------------
    
    private func setupConstraints() {
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true  // текст будет уменьшаться, чтобы влезать по ширине экрана
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
        
        text.numberOfLines = 0
        text.adjustsFontSizeToFitWidth = true  // текст будет уменьшаться, чтобы влезать по ширине экрана
        text.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            text.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3),
            text.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            text.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}

