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
struct TextCellViewModel {
    let text: String                            // сообщение
    let title: String                           // название изображения
}

// вью-модель ячейки изображения (обложки)
struct ImageViewModel {
    let imagePath: String                       // url  изображения
    let imageExt: String                        // формат изображения (необходимо для API-запроса)
}

final class SelectedComicView: UIViewController, SelectedComicViewProtocol {

    // MARK: -- Переменные и константы --------------------------------------------------------
   
    private var tableView = UITableView()
    private var dataSource: SectionedTableViewDataSource?
    
    private var textCellViewModels: [TextCellViewModel] = [] {        // массив вью-моделей для текстовых ячеек
        didSet {
            print(textCellViewModels.count)
            renderTableViewImageCell(imageCellViewModels: imageCellViewModels, textCellViewModels: textCellViewModels)
        }
    }
    
    private var imageCellViewModels: [ImageViewModel] = [] {        // массив вью-моделей для ячеек изображений (обложки)
        didSet {
            print(imageCellViewModels.count)
            renderTableViewImageCell(imageCellViewModels: imageCellViewModels, textCellViewModels: textCellViewModels)
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
        tableView.register(TextCell.self, forCellReuseIdentifier: "TextCell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func renderTableViewImageCell(imageCellViewModels: [ImageViewModel], textCellViewModels: [TextCellViewModel]) {
        
        dataSource = SectionedTableViewDataSource(dataSources: [
                TableViewCustomDataSource.make(for: imageCellViewModels, withCellIdentifier: "ImageCell"),
                TableViewCustomDataSource.make(for: textCellViewModels, withCellIdentifier: "TextCell")])

        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}


// MARK: -- Расширения ----------------------------------------------------------------

extension SelectedComicView: UITableViewDelegate {

}

