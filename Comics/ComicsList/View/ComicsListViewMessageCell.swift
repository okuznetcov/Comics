import UIKit

final class ComicsListViewMessageCell: UITableViewCell {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    static  let identifier = "ComicsListViewMessageCell"
    private let image = UIImageView()       // изображение
    private let text = UILabel()
    
    // MARK: -- Инициализатор -----------------------------------------------------------------
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        
        addSubview(image)
        addSubview(text)
        
        configureImage()
        configureTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -- Публичные методы ---------------------------------------------------------------
    
    // конфигуратор: принимает вью-модель как аргумент и сеттит ячейку
    func configure(with viewModel: ComicsListMessageViewModel) {
        image.image = UIImage(named: viewModel.imageName)
        text.text = viewModel.message
    }
    
    // MARK: -- Приватные методы ---------------------------------------------------------------
    
    private func configureImage() {
        image.alpha = 0.5
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 48),
            image.widthAnchor.constraint(equalTo: image.heightAnchor)
        ])
    }
    
    private func configureTitle() {
        text.numberOfLines = 2
        text.textAlignment = .center
        text.textColor = .gray
        text.adjustsFontSizeToFitWidth = false  // текст будет уменьшаться, чтобы влезать по ширине экрана
        text.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                text.centerXAnchor.constraint(equalTo: centerXAnchor),
                text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
                text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
                text.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
        ])
    }
}
