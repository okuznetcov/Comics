import Foundation

protocol SelectedComicPresenterProtocol {
   func getComic() -> Comic
   func getNumOfRows() -> Int
}

final class SelectedComicPresenter: SelectedComicPresenterProtocol {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    let comic: Comic
    unowned let view: SelectedComicViewProtocol
    
    // MARK: -- Инициализатор -----------------------------------------------------------------
    
    required init(view: SelectedComicViewProtocol, comic: Comic) {
        self.view = view
        self.comic = comic
    }
    
    // MARK: -- Публичные методы ---------------------------------------------------------------
    
    func getNumOfRows() -> Int {
        return 4
    }
    
    func getComic() -> Comic {
        return comic
    }
}
