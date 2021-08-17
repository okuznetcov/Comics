import UIKit

// MARK: -- Протоколы --------------------------------------------------------

protocol CellModel {                            // ячейка таблицы
    var identifier: String { get }
}

protocol SectionHeader { }

struct SectionModel {
    let header: SectionHeader?
    let models: [CellModel]
}


final class TableViewCustomDataSource: NSObject, UITableViewDataSource {
    
    // MARK: -- Переменные и константы --------------------------------------------------------
    
    typealias CellConfigurator = (CellModel, UITableViewCell) -> Void
    private var sections: [SectionModel]
    private let cellConfigurator: CellConfigurator
    
    // MARK: -- Инициализатор -----------------------------------------------------------------
    
    init(sections: [SectionModel], cellConfigurator: @escaping CellConfigurator) {
        self.sections = sections
        self.cellConfigurator = cellConfigurator
    }
    
    // MARK: -- Публичные методы ---------------------------------------------------------------
    
    func updateModels(models: [CellModel]) {
        self.sections = [SectionModel(header: nil, models: models)]
    }
    
    func updateSections(sections: [SectionModel]) {
        self.sections = sections
    }
    
    static func make(sections: [SectionModel]) -> TableViewCustomDataSource {
        return TableViewCustomDataSource(sections: sections, cellConfigurator: { (viewModel, cell ) in
            guard let cell = cell as? ConfigurableCell else { return }
            cell.configure(with: viewModel)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.models.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = sections[safe: indexPath.section] else { return UITableViewCell() }
        let model = section.models[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath)
        
        cellConfigurator(model, cell)
        return cell
    }
}

// MARK: -- Расширения ----------------------------------------------------------------

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
