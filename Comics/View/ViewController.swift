//
//  ViewController.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 27.07.2021.
//

import UIKit
import CryptoKit
import RealmSwift

class ViewController: UIViewController {
    
    private var comics: Results<Comic>!
    private var filteredComics: Results<Comic>!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {            // строка поиска пуста?
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {                 // пользователь производит поиск?
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    
    let comicsTableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        comics = realm.objects(Comic.self)
        
        navigationItem.title = "Комиксы"
        view.backgroundColor = .white
        
        setupSearchBar()
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        view.addSubview(comicsTableView)
        comicsTableView.dataSource = self
        comicsTableView.delegate = self
        comicsTableView.register(comicCell.self, forCellReuseIdentifier: "comicCell")
        comicsTableView.translatesAutoresizingMaskIntoConstraints = false
        comicsTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        comicsTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        comicsTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        comicsTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
    }
    
    
    fileprivate func setupSearchBar() {
        searchController.searchResultsUpdater = self // получатель информации об изменении теста — этот VC
        searchController.obscuresBackgroundDuringPresentation = false // можем взаимодействовать с результатами поиска
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController          // добавляем строку поиска в NavBar
    }

}

class comicCell: UITableViewCell {
    
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (isFiltering) {
            return filteredComics.count
        }
        return comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comicCell", for: indexPath)
        var selectedComic = Comic()
        if (isFiltering) {
            selectedComic = filteredComics[indexPath.row]
        } else {
            selectedComic = comics[indexPath.row]
        }
        cell.textLabel?.text = selectedComic.title
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = SelectedComicViewController()
        dvc.comic = comics[indexPath.row]
        comicsTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}



extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredComics = comics.filter("title CONTAINS[c] %@", searchText) // игнорируем регистр, ищем по адресу и имени*/
        comicsTableView.reloadData()
    }
}

