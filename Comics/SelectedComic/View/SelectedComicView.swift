//
//  SelectedComicViewController.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 28.07.2021.
//

import UIKit

protocol SelectedComicViewProtocol: AnyObject {
    
}

class SelectedComicView: UIViewController, SelectedComicViewProtocol{
    
    var presenter: SelectedComicPresenterProtocol!
    var image = UIImageView()
    let tableView = UITableView()
    
    /*init(comic: Comic) {                            // инициализатор служит для передачи комикса в презентер
        super.init(nibName: nil, bundle: nil)
        presenter = SelectedComicPresenter(view: self, comic: comic)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func viewDidLoad() {
        navigationItem.title = "Комикс"
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

extension SelectedComicView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let comic = presenter.getComic()
        let cell: UITableViewCell!
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 68.0;
        
        // в зависимости от id строки таблицы, показываем нужные данные в порядке
        switch indexPath.row {
        case 0:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! imageCell
            currentCell.image.image = imageLoader.getImage(comic: comic)
            cell = currentCell
            tableView.rowHeight = 230       // для картинки задаем большую высоту строки
        case 1:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! textCell
            currentCell.title.text = comic.title
            currentCell.cellDescription.text = "Название"
            cell = currentCell
        case 2:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! textCell
            currentCell.title.text = comic.pageCount
            currentCell.cellDescription.text = "Количество страниц"
            cell = currentCell
        case 3:
            let currentCell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! textCell
            currentCell.title.text = comic.descr
            currentCell.cellDescription.text = "Описание"
            cell = currentCell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! textCell
        }

        return cell
    }
}

extension SelectedComicView: UITableViewDelegate {

}

