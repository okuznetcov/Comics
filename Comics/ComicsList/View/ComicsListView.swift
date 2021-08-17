import UIKit
import SnapKit

protocol ComicsListViewProtocol: AnyObject {
    func setActivityIndicatorVisibility(visible: Bool)  // установка видимости индикатора загрузки записей
    func setNotFoundMessageVisibility(visible: Bool)    // установка видимости сообщения о не найденных записях
    func setSearchBarVisibility(visible: Bool)          // установка видимости поля поиска
    func addComics(_ comics: [Comic])                   // добавить комиксы к имеющимся во вью-моделях ячеек
    func setComics(_ comics: [Comic])                   // заменить имеющиеся комиксы во вью-моделях ячеек на новые
    func isFilteringEnabled() -> Bool                   // включена ли фильтрация записей (поиск)?
}



// MARK: -- Вью-модели ячеек --------------------------------------------------------

// Вью-модель ячейки предупреждения (показывается на весь экран)
struct ComicsListMessageViewModel: CellModel {
    var identifier: String = "ComicsListViewMessageCell"
    let message: String                             // сообщение
    let imageName: String                           // название изображения
}

struct ComicCellViewModel: CellModel {              // Вью-модель ячейки в списке комиксов
    var identifier: String = "ComicsListViewCell"
    let title: String                               // название комикса
    let imagePath: String                           // url  изображения
    let imageExt: String                            // формат изображения (необходимо для API-запроса)
}



final class ComicsListView: UIViewController, ComicsListViewProtocol {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    // сообщения для пользователей
    private enum Messages {
        enum NotFound {                                         // сообщение об ошибке: "ничего не найдено"
            static let message: String = "По вашему запросу не нашлось результатов"
            static let imageName: String = "notFound"
        }
    }
    
    private enum Consts {
        static let rowHeight: CGFloat = 64                      // высота ячейки таблицы
        static let footerRowHeight: CGFloat = 64                // высота футера таблицы
    }
    
    private var showActivityIndicator: Bool = false {           // показ индикатора загрузки
        didSet(oldValue) {
            if (showActivityIndicator != oldValue) {
                print("activity indicator set to \(showActivityIndicator)")
            }
        }
    }
    
    private var isDisplayingNotFoundMessage: Bool = false {             // показ сообщения о 0 доступных записей
        didSet(oldValue) {                                              // для заданных параметров поиска
            if (isDisplayingNotFoundMessage) {
                renderTableViewMessage(notFoundMessage)                 // если нужно показать сообщение, передаем его на показ
            }
        }
    }
    
    private var comicCellViewModels: [ComicCellViewModel] = [] {        // массив вью-моделей для ячеек
        didSet {
            renderTableViewComicsCells(comicCellViewModels)
        }
    }
    
    private var searchBarIsEmpty: Bool {                                // строка поиска пуста?
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {                                     // пользователь производит поиск?
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let comicsTableView = UITableView(frame: CGRect.init(), style: .grouped)
    private let notFoundMessage = ComicsListMessageViewModel(message: Messages.NotFound.message, imageName: Messages.NotFound.imageName)
    private var comicsCellsDataSource: TableViewCustomDataSource?
    
    var presenter: ComicsListPresenterProtocol!
    
    // MARK: -- Точка входа --------------------------------------------------------
    
    override func viewDidLoad() {
        navigationItem.title = "Комиксы"
        setupSearchBar()
        setupTableView()
    }
    
    // MARK: -- Публичные методы ---------------------------------------------------
    
    // установка состояния индикатора активности работы с сетью
    func setActivityIndicatorVisibility(visible: Bool) {
        showActivityIndicator = visible
    }
    
    // установка состояния строки поиска
    func setSearchBarVisibility(visible: Bool) {
        searchController.searchBar.isHidden = !visible
    }
    
    // включена ли фильтрация записей (поиск)?
    func isFilteringEnabled() -> Bool {
        return isFiltering
    }
    
    // установка состояния показа сообщения о 0 доступных записей для заданных параметров поиска
    func setNotFoundMessageVisibility(visible: Bool) {
        isDisplayingNotFoundMessage = visible
    }
    
    // добавить комиксы к имеющимся во вью-моделях ячеек
    func addComics(_ comics: [Comic]) {
        for comic in comics {
            comicCellViewModels.append(ComicCellViewModel(title:     comic.title,
                                                          imagePath: comic.imagePath,
                                                          imageExt:  comic.imageExt))
        }
    }
    
    // заменить имеющиеся комиксы во вью-моделях ячеек на новые
    func setComics(_ comics: [Comic]) {
        comicCellViewModels.removeAll()
        for comic in comics {
            comicCellViewModels.append(ComicCellViewModel(title:     comic.title,
                                                          imagePath: comic.imagePath,
                                                          imageExt:  comic.imageExt))
        }
    }
    
    // MARK: -- Приватные методы ---------------------------------------------------
    
    // настройка и установка констрейнов для таблицы
    private func setupTableView() {
        view.addSubview(comicsTableView)
        comicsCellsDataSource = .make(sections: [SectionModel(header: nil, models: comicCellViewModels)])
        comicsTableView.dataSource = comicsCellsDataSource
        comicsTableView.delegate = self
        comicsTableView.register(ComicsListViewCell.self, forCellReuseIdentifier: "ComicsListViewCell")
        comicsTableView.register(ComicsListViewMessageCell.self, forCellReuseIdentifier: "ComicsListViewMessageCell")
        comicsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        comicsTableView.rowHeight = Consts.rowHeight
    }
    
    // настройка и установка поля поиска
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self // получатель информации об изменении теста — этот VC
        searchController.obscuresBackgroundDuringPresentation = false // можем взаимодействовать с результатами поиска
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController          // добавляем строку поиска в NavBar
    }
    
    // показ загруженных записей из массива вью-моделей
    private func renderTableViewComicsCells(_ viewModels: [ComicCellViewModel]) {
        comicsCellsDataSource?.updateModels(models: viewModels)
        comicsTableView.rowHeight = Consts.rowHeight
        comicsTableView.separatorColor = .separator
        comicsTableView.isScrollEnabled = true
        comicsTableView.reloadData()
    }
    
    // показ сообщения на весь экран
    private func renderTableViewMessage(_ viewModel: ComicsListMessageViewModel) {
        comicsCellsDataSource?.updateModels(models: [viewModel])
        comicsTableView.rowHeight = comicsTableView.visibleSize.height * 0.7
        comicsTableView.separatorColor = .clear
        comicsTableView.isScrollEnabled = false
        comicsTableView.reloadData()
    }
}

// MARK: -- Расширения ----------------------------------------------------------------

extension ComicsListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedComicVC(at: indexPath.row)
        comicsTableView.deselectRow(at: indexPath, animated: true)  // снимаем выделение с выделенной ячейки таблицы (чтобы была "отжата")
    }
    
    // обработчик события - будет показана ячейка с индексом indexPath.row
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayComic(at: indexPath.row)               // обработчик появления i-той строки списка
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if showActivityIndicator && !isDisplayingNotFoundMessage && !isFiltering {
            let spinner = UIActivityIndicatorView()
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            return(spinner)
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Consts.footerRowHeight
    }
}

// работа с поиском
extension ComicsListView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.searchBarTextChanged(searchText: searchController.searchBar.text ?? "")
    }
}
