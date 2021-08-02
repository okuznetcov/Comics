//
//  ComicListPresenter.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 29.07.2021.
//

import Foundation

protocol ComicsListPresenterProtocol: AnyObject {
    func selectedComicVC(at selectedRow: Int)                           // получить вью контроллер выбранного комикса
    func searchBarTextChanged(searchText: String)                       // обработчик изменения значения поля поиска
    func getComic(at index: Int) -> Comic                               // получение конкретного комикса
    func getNumberOfComics() -> Int                                     // получение количества комиксов
    func willDisplayComic(at index: Int)                                // обработчик появления i-той строки списка
}

class ComicsListPresenter: ComicsListPresenterProtocol {
    
    // обработчик появления i-той строки списка
    func willDisplayComic(at index: Int) {
        // Работаем со "страницами" — за страницу принимаем блок из 25 очередных загружаемых записей
        let page = index / (comicsToDownload - 8)                       // расчет индекса текущей страницы
        if (lastPage < page) {                                          // если индекс новой страницы больше чем последней максимальной
            lastPage = page                                             // текущая страница будет являться новой максимальной
            print("page \(lastPage)")
            let offset = lastPage * comicsToDownload                    // расчет сдвига для получения нужных записей Marvel API
            loadComics(limit: comicsToDownload, offset: offset)         // начальное обращение к Marvel API
        }
    }
    
    
    private let comicsToDownload = 25;                  // сколько комиксов загружать за раз
    private var lastPage = 0;                           // последняя наибольшая "страница" списка комиксов (за страницу принимаем блок из 25 очередных загружаемых записей
    
    private var comics = [Comic]()                 // все записи о комиксах
    private var filteredComics = [Comic]()         // все записи о комиксах
    private var router: ComicsListRouterProtocol!
    unowned let view: ComicsListViewProtocol
    var fetchedComics: [DownloadedComic] = []
    var comicCache = NSCache<NSString, ComicImage>()
    
    private let API = Networking.shared
    
    required init(view: ComicsListViewProtocol, router: ComicsListRouterProtocol) {
        self.view = view
        self.router = router
        loadComics(limit: comicsToDownload, offset: 0)        // начальное обращение к Marvel API
    }
    
    
    // Загрузить комиксы из Marvel API
    private func loadComics(limit: Int, offset: Int) {
        
        view.setActivityIndicatorState(state: true)
        API.fetchComics(url: "/comics", params: "limit=\(limit)&offset=\(offset)", completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.setActivityIndicatorState(state: false)
                switch result {
                    case .success(let apiData):
                        self.processLoadedComics(apiData: apiData)
                    case .failure(_):
                        print("error")
                 }
            }
        })
    }
    
    // Обработка загруженных комиксов и загрузка картинок
    private func processLoadedComics(apiData: APIComicResult?) {
        
        self.fetchedComics.append(contentsOf: (apiData?.data.results)!)     // поместим загруженные комиксы в fetchedComics
        
        for comic in self.fetchedComics {
            
            let newComic = Comic(marvelId: "\(comic.id)",
                                 title: comic.title,
                                 description: comic.description,
                                 pageCount: "\(comic.pageCount)",
                                 path: comic.thumbnail.path,
                                 ext: comic.thumbnail.extension)
            
            comics.append(newComic)
        }
        
        view.reloadTable()
        
        
        // ЖЕНЯ:
        // закоменть эту строку для проверки кэширования изображений: старые записи будут добавляться к уже имеющимся
        self.fetchedComics.removeAll()     // <--------------
        
        for comic in comics {
                DispatchQueue.global().async {
                    let imageData = self.API.fetchImage(url: comic.imagePath, imageExtension: comic.imageExt)
                    DispatchQueue.main.async {
                        comic.comicImage = imageData
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
            print(comics.count)
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
        filteredComics = comics.filter({$0.title.lowercased().contains(searchText.lowercased())})
        view.reloadTable()
    }
    
    func selectedComicVC(at selectedRow: Int) {
        if (isFiltering) {
            return router.navigateToPushedViewController(comic: filteredComics[selectedRow])
        } else {
            return router.navigateToPushedViewController(comic: comics[selectedRow])
        }
    }
}
