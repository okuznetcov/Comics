import Foundation

protocol SelectedComicPresenterProtocol {
    func didFinishedLoading()                       // вью полностью загрузилось
}

final class SelectedComicPresenter: SelectedComicPresenterProtocol {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    private let comic: Comic
    unowned let view: SelectedComicViewProtocol
    
    // MARK: -- Инициализатор -----------------------------------------------------------------
    
    required init(view: SelectedComicViewProtocol, comic: Comic) {
        self.view = view
        self.comic = comic
    }
    
    func didFinishedLoading() {
        view.setImageCell(imagePath: comic.imagePath,
                          imageExt: comic.imageExt)
        
        view.setTextCell(text: comic.title,
                         title: "Название")
        
        view.setTextCell(text: comic.pageCount ?? "0",
                         title: "Количество страниц")
        
        view.setTextCell(text: comic.descr ?? "Недоступно",
                         title: "Описание")
    }
}
