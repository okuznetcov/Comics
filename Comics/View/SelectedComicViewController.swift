//
//  SelectedComicViewController.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 28.07.2021.
//

import UIKit

class SelectedComicViewController : UIViewController {
    
    var comic: Comic!
    var image = UIImageView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        navigationItem.title = "Комикс"
        guard let comic = comic else { return }       // извлекаем опционал со значением комикса
        setupTableView()
    }
    
    // при перевороте устройства обновляем TableView, чтобы заново рассчиать высоту строк
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
    fileprivate func configureImage() {
        image.layer.cornerRadius = 10       // сглаженные углы
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
       // image.leadingAnchor.constraint(equalTo: vieleadingAnchor, constant: 12).isActive = true
        image.heightAnchor.constraint(equalToConstant: 300).isActive = true
        image.widthAnchor.constraint(equalTo: image.heightAnchor, multiplier: 2/3).isActive = true
    }
    
    // настройка и установка констрейнов для таблицы
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 68
        tableView.separatorColor = .white
        tableView.allowsSelection = false
        tableView.register(textCell.self, forCellReuseIdentifier: "textCell")
        tableView.register(imageCell.self, forCellReuseIdentifier: "imageCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
    }
}

// два расширения UITableViewDataSource и UITableViewDelegate которые хочет TableView

extension SelectedComicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4        // количество свойств комикса, пока тестово 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        tableView.rowHeight = 68
        
        // в зависимости от id строки таблицы, показываем нужные данные в порядке
        switch indexPath.row {
        case 0:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! imageCell
            currentCell.image.image = UIImage(data: comic.imageData!)
            cell = currentCell
            tableView.rowHeight = 230       // для картинки задаем большую высоту строки
        case 1:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! textCell
            currentCell.title.text = comic.title
            currentCell.cellDescription.text = "Название"
            cell = currentCell
        case 2:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! textCell
            currentCell.title.text = comic.title
            currentCell.cellDescription.text = "Количество страниц"
            cell = currentCell
        case 3:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! textCell
            currentCell.title.text = comic.title
            currentCell.cellDescription.text = "Год"
            cell = currentCell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! textCell
        }

        return cell
    }
}

extension SelectedComicViewController: UITableViewDelegate {

}


// КЛАССЫ ВСПОМОГАТЕЛЬНЫХ ЯЧЕЕК НАДО ПЕРЕНЕСТИ В ОТДЕЛЬНЫЕ ФАЙЛЫ

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
