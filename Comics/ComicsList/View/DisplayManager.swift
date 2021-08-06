import UIKit

class TableViewCustomDataSource<Model>: NSObject, UITableViewDataSource {
    
    typealias CellConfigurator = (Model, UITableViewCell)-> Void
    var models: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        
       self.models = models
       self.reuseIdentifier = reuseIdentifier
       self.cellConfigurator = cellConfigurator
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cellConfigurator(model, cell)
        return cell
    }
    
}

// показ загруженных записей из массива вью-моделей
extension TableViewCustomDataSource where Model == ComicCellViewModel {
    
    static func displayData(for itemLists: [Model], withCellidentifier reuseIdentifier: String) -> TableViewCustomDataSource {
        return TableViewCustomDataSource(models: itemLists,
                                         reuseIdentifier: reuseIdentifier,
                                         cellConfigurator: { (viewModel, cell ) in
            let cell: ComicsListViewCell = cell as! ComicsListViewCell
            cell.configure(with: viewModel)
        })
    }
}

// показ сообщения на весь экран
extension TableViewCustomDataSource where Model == ComicsListMessageViewModel {
    
    static func displayData(for itemLists: [Model], withCellidentifier reuseIdentifier: String) -> TableViewCustomDataSource {
        return TableViewCustomDataSource(models: itemLists,
                                         reuseIdentifier: reuseIdentifier,
                                         cellConfigurator: { (viewModel, cell ) in
            let cell: ComicsListViewMessageCell = cell as! ComicsListViewMessageCell
            cell.configure(with: viewModel)
        })
    }
}

