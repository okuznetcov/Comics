import UIKit

final class ComicsListViewCell: UITableViewCell {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    private enum Consts {
        static let imageSideSize = 56
    }
    
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
        
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(Consts.imageSideSize)
        }
        
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.layer.cornerRadius = CGFloat(Consts.imageSideSize / 2)
        image.layer.masksToBounds = false
        image.clipsToBounds = true
    }
    
    private func configureTitle() {
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true  // текст будет уменьшаться, чтобы влезать по ширине экрана
        
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(image.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        
    }
}
