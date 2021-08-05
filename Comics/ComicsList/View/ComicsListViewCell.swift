import UIKit

final class ComicsListViewCell: UITableViewCell {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    static  let identifier = "ComicsListViewCell"
    private let image      = UIImageView()
    private let title      = UILabel()
    
    // MARK: -- Инициализатор -----------------------------------------------------------------
    
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
    
    // MARK: -- Публичные методы ---------------------------------------------------------------
    
    // конфигуратор: принимает вью-модель как аргумент и сеттит ячейку
    func configure(with viewModel: ComicCellViewModel) {
        
        title.text = viewModel.title
        
        // non-kf
        /*ComicsRepository.loadImage(imagePath: viewModel.imagePath,
                                   imageExtension: viewModel.imageExt,
                                   completion: { downloadedImageData in
                                        self.image.image = ImageExtractor.getImage(from: downloadedImageData)
                                   })*/
        
        
        // kf
        ComicsRepository.loadImageKf(for: image,
                                     imagePath: viewModel.imagePath,
                                     imageExtension: viewModel.imageExt)
    }
    
    override func prepareForReuse() {
        ComicsRepository.stopLoadingKf(for: image)
    }
    
    // MARK: -- Приватные методы ---------------------------------------------------------------
    
    private func configureImage() {
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            image.heightAnchor.constraint(equalToConstant: 40),
            image.widthAnchor.constraint(equalTo: image.heightAnchor),
        ])
        
        image.layer.cornerRadius = 20
    }
    
    private func configureTitle() {
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true  // текст будет уменьшаться, чтобы влезать по ширине экрана
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                title.centerYAnchor.constraint(equalTo: centerYAnchor),
                title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
                title.heightAnchor.constraint(equalToConstant: 40),
                title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
}
