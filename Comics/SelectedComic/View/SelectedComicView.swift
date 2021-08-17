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
    private var dataSource: TableViewCustomDataSource?
    
    private var textCellViewModels: [TextCellViewModel] = [] {        // массив вью-моделей для текстовых ячеек
        didSet {
            renderTableView(imageCellViewModels: imageCellViewModels, textCellViewModels: textCellViewModels)
        }
    }
    
    private var imageCellViewModels: [ImageViewModel] = [] {        // массив вью-моделей для ячеек изображений (обложки)
        didSet {
            renderTableView(imageCellViewModels: imageCellViewModels, textCellViewModels: textCellViewModels)
        }
    }
    
    var presenter: SelectedComicPresenterProtocol!
    
    // MARK: -- Точка входа -------------------------------------------------------------------
    
    override func viewDidLoad() {
        navigationItem.title = "Комикс"
        setupTableView()
        presenter.didFinishedLoading()
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
        dataSource = .make(sections: [SectionModel(header: nil, models: textCellViewModels)])
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 68
        tableView.separatorColor = .white
        tableView.allowsSelection = false
        tableView.register(TextCell.self, forCellReuseIdentifier: "SelectedComicViewTextCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "SelectedComicViewImageCell")
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func renderTableView(imageCellViewModels: [ImageViewModel], textCellViewModels: [TextCellViewModel]) {
        
        let sections = [SectionModel(header: nil, models: imageCellViewModels),
                        SectionModel(header: nil, models: textCellViewModels)]
        
        dataSource?.updateSections(sections: sections)
        tableView.reloadData()
    }
}


// MARK: -- Расширения ----------------------------------------------------------------

extension SelectedComicView: UITableViewDelegate {
    
}

