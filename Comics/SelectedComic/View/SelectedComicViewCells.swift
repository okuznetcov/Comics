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
        
        image.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(UIScreen.main.bounds.height / 2.5)
            make.width.equalTo(self.snp.height).dividedBy(1.6)
            make.bottom.equalToSuperview().inset(10)
        }
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
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(12)
        }
        
        text.numberOfLines = 0
        text.adjustsFontSizeToFitWidth = true  // текст будет уменьшаться, чтобы влезать по ширине экрана
        
        text.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(3)
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

