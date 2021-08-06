import UIKit

// формирование ячеек массива вью-моделей
extension TableViewCustomDataSource where Model == ComicCellViewModel {
    
    static func displayData(for itemLists: [Model], withCellIdentifier reuseIdentifier: String) -> TableViewCustomDataSource {
        return TableViewCustomDataSource(models: itemLists,
                                         reuseIdentifier: reuseIdentifier,
                                         cellConfigurator: { (viewModel, cell ) in
            let cell: ComicsListViewCell = cell as! ComicsListViewCell
            cell.configure(with: viewModel)
        })
    }
}

// формирование ячейки-сообщения
extension TableViewCustomDataSource where Model == ComicsListMessageViewModel {
    
    static func displayData(for itemLists: [Model], withCellIdentifier reuseIdentifier: String) -> TableViewCustomDataSource {
        return TableViewCustomDataSource(models: itemLists,
                                         reuseIdentifier: reuseIdentifier,
                                         cellConfigurator: { (viewModel, cell ) in
            let cell: ComicsListViewMessageCell = cell as! ComicsListViewMessageCell
            cell.configure(with: viewModel)
        })
    }
}

