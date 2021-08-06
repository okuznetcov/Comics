import UIKit

// формирование ячейки текстового поля
extension TableViewCustomDataSource where Model == TextCellViewModel {
    
    static func make(for itemLists: [Model], withCellIdentifier reuseIdentifier: String) -> TableViewCustomDataSource {
        return TableViewCustomDataSource(models: itemLists,
                                         reuseIdentifier: reuseIdentifier,
                                         cellConfigurator: { (viewModel, cell ) in
            let cell: TextCell = cell as! TextCell
            cell.configure(with: viewModel)
        })
    }
}

// формирование ячейки-изобаржения
extension TableViewCustomDataSource where Model == ImageViewModel {
    
    static func make(for itemLists: [Model], withCellIdentifier reuseIdentifier: String) -> TableViewCustomDataSource {
        return TableViewCustomDataSource(models: itemLists,
                                         reuseIdentifier: reuseIdentifier,
                                         cellConfigurator: { (viewModel, cell ) in
            let cell: ImageCell = cell as! ImageCell
            cell.configure(with: viewModel)
        })
    }
}
