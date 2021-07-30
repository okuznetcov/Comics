//
//  ViewController.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 27.07.2021.
//

import UIKit

protocol ComicsListViewProtocol: AnyObject {
    func reloadTable()                          // обновить таблицу
    func checkSearchBarIsEmpty() -> Bool        // строка поиска пуста?
    func checkSearchIsActive() -> Bool          // строка поиска активна?
}

class ComicsListView: UIViewController {
    
    var presenter: ComicsListPresenterProtocol!
    private let searchController = UISearchController(searchResultsController: nil)
    private let comicsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Комиксы"
        setupSearchBar()
        setupTableView()
    }
    
    // настройка и установка констрейнов для таблицы
    fileprivate func setupTableView() {
        view.addSubview(comicsTableView)
        comicsTableView.dataSource = self
        comicsTableView.delegate = self
        comicsTableView.register(ComicsListViewCell.self, forCellReuseIdentifier: "ComicsListViewCell")
        comicsTableView.translatesAutoresizingMaskIntoConstraints = false
        comicsTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        comicsTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        comicsTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        comicsTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        comicsTableView.rowHeight = 150
    }
    
    // настройка и установка поля поиска
    fileprivate func setupSearchBar() {
        searchController.searchResultsUpdater = self // получатель информации об изменении теста — этот VC
        searchController.obscuresBackgroundDuringPresentation = false // можем взаимодействовать с результатами поиска
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController          // добавляем строку поиска в NavBar
    }

    private var searchBarIsEmpty: Bool {            // строка поиска пуста?
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
}

// два расширения UITableViewDataSource и UITableViewDelegate которые хочет TableView
extension ComicsListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfComics()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComicsListViewCell", for: indexPath) as! ComicsListViewCell
        let selectedComic = presenter.getComic(at: indexPath.row)

        // закидываем в ячейку все данные (пока тестово их мало)
        cell.title.text = selectedComic.title
        cell.image.image = imageLoader.getImage(comic: selectedComic)
        
        return cell
    }
}

extension ComicsListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedComicVC(at: indexPath.row)
        //let dvc = presenter.selectedComicVC(at: indexPath.row)
        //self.navigationController?.pushViewController(dvc, animated: true)
        comicsTableView.deselectRow(at: indexPath, animated: true)  // снимаем выделение с выделенной ячейки таблицы (чтобы была "отжата")
    }
}

// работа с поиском
extension ComicsListView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.searchBarTextChanged(searchText: searchController.searchBar.text!)
    }
}

extension ComicsListView: ComicsListViewProtocol {
    
    // строка поиска пуста?
    func checkSearchBarIsEmpty() -> Bool {
        return searchBarIsEmpty
    }
    
    // строка поиска активна?
    func checkSearchIsActive() -> Bool {
        return searchController.isActive
    }
    
    // обновить таблицу
    func reloadTable() {
        comicsTableView.reloadData()
    }
}
