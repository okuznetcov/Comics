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
    
    private var comics: Results<Comic>!                 // все записи о комиксах
    private var filteredComics: Results<Comic>!         // отфильтрованные записи с помощью поиска
    
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
    
        // заглушка для добавления новых тестовых записей в Realm
        //StoargeManager.saveObject(Comic(title: "Iron Man", pageCount: "20", imageData: UIImage(named: "portrait_xlarge")?.pngData()))
        
        
        comics = realm.objects(Comic.self)
        
        navigationItem.title = "Комиксы"
        view.backgroundColor = .white
        
        getObjects()
        
        setupSearchBar()
        setupTableView()
    }
    
    
// отладочный код, его здесь быть не должно, нужен чтобы пробовать выполнять веб-реквест при запуске из viewDidLoad()
    var objects = [Comic]()
    func getObjects() {
        let networking = Networking(url: "/comics")
        //networking.makeRequest()
        networking.makeRequest { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.objects = data!
                    print(self.objects.count)
                case .failure(let error):
                    print("error")
                }
            }
        }
    }
    
    
    // настройка и установка констрейнов для таблицы
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
        
        comicsTableView.rowHeight = 150
    }
    
    // настройка и установка поля поиска
    fileprivate func setupSearchBar() {
        searchController.searchResultsUpdater = self // получатель информации об изменении теста — этот VC
        searchController.obscuresBackgroundDuringPresentation = false // можем взаимодействовать с результатами поиска
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController          // добавляем строку поиска в NavBar
    }

}


// два расширения UITableViewDataSource и UITableViewDelegate которые хочет TableView

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // если пользователь ищет записи, возвращаем TableView число отфильтрованных записей
        if (isFiltering) {
            return filteredComics.count
        }
        return comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comicCell", for: indexPath) as! comicCell
        var selectedComic = Comic()
        
        // определяем выбранную запись (или из общего списка, или из отфильтрованных)
        if (isFiltering) {
            selectedComic = filteredComics[indexPath.row]
        } else {
            selectedComic = comics[indexPath.row]
        }

        // закидываем в ячейку все данные (пока тестово их мало)
        cell.title.text = selectedComic.title
        cell.image.image = UIImage(data: selectedComic.imageData!)
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = SelectedComicViewController()
        dvc.comic = comics[indexPath.row]       // передаем информацию о выбранном комиксе другому контроллеру
        comicsTableView.deselectRow(at: indexPath, animated: true)  // снимаем выделение с выделенной ячейки таблицы (чтобы была "отжата")
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}


// работа с поиском
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)   // обновляем результаты поиска
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredComics = comics.filter("title CONTAINS[c] %@", searchText) // игнорируем регистр, ищем по названию
        comicsTableView.reloadData()                // апдейтим данные в таблице
    }
}

