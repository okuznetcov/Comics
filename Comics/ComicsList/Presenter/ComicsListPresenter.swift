//
//  ComicListPresenter.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 29.07.2021.
//

import Foundation
import RealmSwift

protocol ComicsListPresenterProtocol: AnyObject {
    func selectedComicVC(at selectedRow: Int)                           // получить вью контроллер выбранного комикса
    func searchBarTextChanged(searchText: String)                       // обработчик изменения значения поля поиска
    func getComic(at index: Int) -> Comic                               // получение конкретного комикса
    func getNumberOfComics() -> Int                                     // получение количества комиксов
}

class ComicsListPresenter: ComicsListPresenterProtocol {
    
    private var comics: Results<Comic>!                 // все записи о комиксах
    private var filteredComics: Results<Comic>!         // все записи о комиксах
    private var router: ComicsListRouterProtocol!
    unowned let view: ComicsListViewProtocol
    var fetchedComics: [DownloadedComic] = []
    
    private let API = Networking.shared
    
    required init(view: ComicsListViewProtocol, router: ComicsListRouterProtocol) {
        //StoargeManager.saveObject(Comic(marvelId: "3421", title: "Test", description: "suprehero", pageCount: "20"))
        self.view = view
        self.router = router
        comics = realm.objects(Comic.self)
        loadComics()                                    // обращение к Marvel API
    }
    
    
    // Загрузить комиксы из Marvel API
    private func loadComics() {
        API.fetchComics(url: "/comics", params: "limit=100", completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
            switch result {
                case .success(let apiData):
                    self.processLoadedComics(apiData: apiData)
                case .failure(_):
                    print("error")
                }
            }
        })
    }
    
    // Кэширование загруженных комиксов в БД Realm и загрузка картинок
    private func processLoadedComics(apiData: APIComicResult?) {
        
        self.fetchedComics.append(contentsOf: (apiData?.data.results)!)     // поместим загруженные комиксы в fetchedComics
        
        for comic in self.fetchedComics {
            // если очередной загруженный комикс отсутсвутет в БД Realm
            if (self.comics.filter("marvelId == %@", "\(comic.id)").count == 0) {
                print(comic.id)
                StoargeManager.saveObject(              // сохранение комикса в Realm
                    Comic(marvelId: "\(comic.id)",
                          title: comic.title,
                          description: comic.description,
                          pageCount: "\(comic.pageCount)")
                    )
                view.reloadTable()          // обновление таблицы
            }
        }
        
        for comic in self.comics {
            if (comic.imageData != nil) { continue }        // будем загружать картинки для комиксов, у которых картинки отсуствуют
            // 
            let fetchedComicWithImageURL = self.fetchedComics.first(where: {"\($0.id)" == comic.marvelId})
            guard let fetchedComicWithImageURL = fetchedComicWithImageURL else { continue }
            let imagePath = fetchedComicWithImageURL.thumbnail.path
            let imageEx = fetchedComicWithImageURL.thumbnail.extension
                
            DispatchQueue.global().async {
                let imageData = self.API.fetchImage(url: imagePath, imageExtension: imageEx)
                guard let imageData = imageData else { return }
                DispatchQueue.main.async {
                    StoargeManager.editObjectImage(comic, imageData: imageData)
                    self.view.reloadTable()
                }
            }
        }
    }
    
    // получить список комиксов
    func getNumberOfComics() -> Int {
        if (isFiltering) {
            return filteredComics.count
        } else {
            return comics.count
        }
    }
    
    private var isFiltering: Bool {                 // пользователь производит поиск?
        return view.checkSearchIsActive() && !view.checkSearchBarIsEmpty()
    }
    
    
    func getComic(at index: Int) -> Comic {
        // определяем выбранную запись (или из общего списка, или из отфильтрованных)
        if (isFiltering) {
            return filteredComics[index]
        } else {
            return comics[index]
        }
    }

    func searchBarTextChanged(searchText: String) {
        filteredComics = comics.filter("title CONTAINS[c] %@", searchText) // игнорируем регистр, ищем по названию
        view.reloadTable()
    }
    
    func selectedComicVC(at selectedRow: Int) {
        router.navigateToPushedViewController(comic: comics[selectedRow])
    }
}
