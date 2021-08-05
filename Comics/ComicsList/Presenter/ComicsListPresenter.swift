import Foundation

protocol ComicsListPresenterProtocol: AnyObject {
    func selectedComicVC(at selectedRow: Int)                           // получить вью контроллер выбранного комикса
    func searchBarTextChanged(searchText: String)                       // обработчик изменения значения поля поиска
    func willDisplayComic(at index: Int)                                // обработчик появления i-той строки списка
}

final class ComicsListPresenter: ComicsListPresenterProtocol {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    private enum Consts {
        static let comicsToDownload = 25                // сколько комиксов загружать за раз (величина "страницы")
        static let triggerLoadingAtLast = 8             // за какое число ячеек до низа таблицы начинать загрузку
    }
    
    private var lastPage = 0;                           // последняя наибольшая "страница" списка комиксов
    private var comics: [Comic] = []                    // все записи о комиксах
    private var filteredComics: [Comic] = []            // отфильтрованные записи о комиксах (для работы с поиском)
    private var isFirstLoadComplete = false             // завершена ли первая загрузка комиксов?
    
    /*private var isFiltering: Bool {                     // пользователь производит поиск?
        return view.checkSearchIsActive() && !view.checkSearchBarIsEmpty()
    }*/
    
    private var router: ComicsListRouterProtocol!
    unowned let view: ComicsListViewProtocol
   
    // MARK: -- Инициализатор -----------------------------------------------------------------
    
    required init(view: ComicsListViewProtocol, router: ComicsListRouterProtocol) {
        self.view = view
        self.router = router
        self.view.setSearchBarVisibility(visible: false)    // скрываем строку поиска, т. к. записи еще не загружены
        loadComics(offset: 0)                               // первое обращение к API (отступ от начала 0)
    }
    
    // MARK: -- Публичные методы ---------------------------------------------------------------
    
    // обработчик появления i-той строки списка
    func willDisplayComic(at index: Int) {
        // Работаем со "страницами" — за страницу принимаем блок из очередных загружаемых записей
        let page = index / (Consts.comicsToDownload - Consts.triggerLoadingAtLast)         // расчет индекса текущей страницы
        if (lastPage < page) {                                          // если индекс новой страницы больше чем последней максимальной
            lastPage = page                                             // текущая страница будет являться новой максимальной
            print("page \(lastPage)")
            let offset = lastPage * Consts.comicsToDownload             // расчет сдвига для получения нужных записей Marvel API
            loadComics(offset: offset)                                  // загрузка комиксов с полученным отступом
        }
    }
    
    // обработчик изменения текста в строке поиска
    func searchBarTextChanged(searchText: String) {
        
        filteredComics = comics.filter({$0.title.lowercased().contains(searchText.lowercased())})
        
        // если производим поиск и ничего не нашлось
        if (view.isFilteringEnabled() && filteredComics.count == 0) {
            
            view.setNotFoundMessageVisibility(visible: true)            // показываем сообщение о 0 результатах
            
        // если производим поиск и нашлись результаты
        } else if (view.isFilteringEnabled() && filteredComics.count != 0) {
            
            view.setNotFoundMessageVisibility(visible: false)           // скрываем сообщение о 0 результатах
            view.setComics(filteredComics)                              // заменяем комиксы во вью на отфильтрованные
        
        // если не производим поиск
        } else {
            
            view.setNotFoundMessageVisibility(visible: false)           // скрываем сообщение о 0 результатах
            view.setComics(comics)                                      // заменяем комиксы во вью на все доступные
            
        }
    }
    
    // обработчик нажатия на комикс
    func selectedComicVC(at selectedRow: Int) {
        if (view.isFilteringEnabled()) {
            return router.navigateToPushedViewController(comic: filteredComics[selectedRow])
        } else {
            return router.navigateToPushedViewController(comic: comics[selectedRow])
        }
    }
    
    // MARK: -- Приватные методы ---------------------------------------------------------------
    
    private func loadComics(offset: Int) {
        
        view.setActivityIndicatorVisibility(visible: true)
        
        ComicsRepository.loadComics(limit: Consts.comicsToDownload, offset: offset) { fetchedComics in
            
            self.comics.append(contentsOf: fetchedComics)
            self.view.addComics(fetchedComics)
            self.view.setActivityIndicatorVisibility(visible: false)
            
            if (!self.isFirstLoadComplete) {                            // если первая загрузка комиксов еще не была выполнена
                self.view.setSearchBarVisibility(visible: true)         // показываем строку поиска
                self.isFirstLoadComplete = true                         // первая загрузка комиксов была выполнена
            }
        }
        
    }
}
