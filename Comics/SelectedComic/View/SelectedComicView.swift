//
//  SelectedComicViewController.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 28.07.2021.
//

import UIKit

protocol SelectedComicViewProtocol: AnyObject {
    
}

final class SelectedComicView: UIViewController, SelectedComicViewProtocol {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
   
    private let image = UIImageView()
    private let tableView = UITableView()
    
    var presenter: SelectedComicPresenterProtocol!
    
    // MARK: -- Точка входа -------------------------------------------------------------------
    
    override func viewDidLoad() {
        navigationItem.title = "Комикс"
        setupTableView()
    }
    
    // MARK: -- Публичные методы ---------------------------------------------------------------
    
    // при перевороте устройства обновляем TableView, чтобы заново рассчиать высоту строк
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
    // MARK: -- Приватные методы ---------------------------------------------------------------
    
    private func configureImage() {
        image.layer.cornerRadius = 10       // сглаженные углы
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor),
            image.heightAnchor.constraint(equalToConstant: 300),
            image.widthAnchor.constraint(equalTo: image.heightAnchor, multiplier: 2/3)
        ])
    }
    
    // настройка и установка констрейнов для таблицы
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 68
        tableView.separatorColor = .white
        tableView.allowsSelection = false
        tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo:view.topAnchor),
            tableView.leftAnchor.constraint(equalTo:view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo:view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        ])
    }
}


// MARK: -- Расширения ----------------------------------------------------------------
// два расширения UITableViewDataSource и UITableViewDelegate которые хочет TableView
extension SelectedComicView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let comic = presenter.getComic()
        let cell: UITableViewCell
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 68.0;
        
        // в зависимости от id строки таблицы, показываем нужные данные в порядке
        switch indexPath.row {
        case 0:
            guard let currentCell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UITableViewCell() }
            currentCell.configure(path: comic.imagePath, ext: comic.imageExt)
            cell = currentCell
            tableView.rowHeight = 230       // для картинки задаем большую высоту строки
        case 1:
            guard let currentCell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as? TextCell else { return UITableViewCell() }
            currentCell.configure(text: comic.title, title: "Название")
            cell = currentCell
        case 2:
            guard let currentCell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as? TextCell else { return UITableViewCell() }
            currentCell.configure(text: comic.pageCount ?? "Недоступно", title: "Количество страниц")
            cell = currentCell
        case 3:
            guard let currentCell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as? TextCell else { return UITableViewCell() }
            currentCell.configure(text: comic.descr ?? "Недоступно", title: "Описание")
            cell = currentCell
        default:
            cell = UITableViewCell()
        }

        return cell
    }
}

extension SelectedComicView: UITableViewDelegate {

}

