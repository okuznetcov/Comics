//
//  SelectedComicViewController.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 28.07.2021.
//

import UIKit
import SnapKit

protocol SelectedComicViewProtocol: AnyObject {
    func setTextCell(text: String, title: String)            // заменить имеющиеся комиксы во вью-моделях ячеек на новые
    func setImageCell(imagePath: String, imageExt: String)            // заменить имеющиеся комиксы во вью-моделях ячеек на новые
}

// MARK: -- Вью-модели ячеек --------------------------------------------------------

// Вью-модель текстовой ячейки (поле)
struct TextCellViewModel: CellModel {
    var identifier: String = "SelectedComicViewTextCell"
    let text: String                            // сообщение
    let title: String                           // название изображения
}

// вью-модель ячейки изображения (обложки)
struct ImageViewModel: CellModel {
    var identifier: String = "SelectedComicViewImageCell"
    let imagePath: String                       // url  изображения
    let imageExt: String                        // формат изображения (необходимо для API-запроса)
}


final class SelectedComicView: UIViewController, SelectedComicViewProtocol {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    private var tableView = UITableView()
    //private var dataSource: SectionedTableViewDataSource?
    private var dataSource: TableViewCustomDataSource<CellModel, CellModel>?
    
    private var textCellViewModels: [TextCellViewModel] = [] {        // массив вью-моделей для текстовых ячеек
        didSet {
            print(textCellViewModels.count)
            renderTableView(imageCellViewModels: imageCellViewModels, textCellViewModels: textCellViewModels)
        }
    }
    
    private var imageCellViewModels: [ImageViewModel] = [] {        // массив вью-моделей для ячеек изображений (обложки)
        didSet {
            print(imageCellViewModels.count)
            renderTableView(imageCellViewModels: imageCellViewModels, textCellViewModels: textCellViewModels)
        }
    }
    
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
    
    func setTextCell(text: String, title: String) {
        textCellViewModels.append(TextCellViewModel(text: text,
                                                    title: title))
    }
    
    func setImageCell(imagePath: String, imageExt: String) {
        imageCellViewModels.append(ImageViewModel(imagePath: imagePath,
                                                  imageExt:  imageExt))
    }
    
    // MARK: -- Приватные методы ---------------------------------------------------------------
    
    // настройка и установка констрейнов для таблицы
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 68
        tableView.separatorColor = .white
        tableView.allowsSelection = false
        tableView.register(TextCell.self, forCellReuseIdentifier: "SelectedComicViewTextCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "SelectedComicViewImageCell")
        //tableView.register(ImageCell.self, forHeaderFooterViewReuseIdentifier: "SelectedComicViewImageCell")
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func renderTableView(imageCellViewModels: [ImageViewModel], textCellViewModels: [TextCellViewModel]) {
        
        // реализация 1: ДЖЕНЕРИКИ: две секции без header'ов
        //let sections = [Section<CellModel, CellModel>(header: nil, models: imageCellViewModels), Section(header: nil, models: textCellViewModels)]
        
        // реализация 2: ДЖЕНЕРИКИ: одна секция с хэдером
        //let sections = [Section<CellModel, CellModel>(header: imageCellViewModels[0], models: textCellViewModels)]
        //let cellIdentifiers = ["SelectedComicViewTextCell", "SelectedComicViewImageCell"]
        
        // реализация 3: Структура: две секции без header'ов`
        let sections = [SectionModel(header: nil, models: imageCellViewModels), SectionModel(header: nil, models: textCellViewModels)]
        
        dataSource = .make(sections: sections)
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}


// MARK: -- Расширения ----------------------------------------------------------------

extension SelectedComicView: UITableViewDelegate {
    
}

