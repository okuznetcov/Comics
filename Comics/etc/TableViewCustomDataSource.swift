import UIKit

protocol CellModel {
    var identifier: String { get }
}

protocol HeaderModel {
    var identifier: String { get }
}

// ЖЕНЕ: напипши в поиске по проекту "Женя" чтобы увидеть где меняется код для различных реализаций

// MARK: ЖЕНЯ - инициализация через Generics
/*
 struct Section<Header, Model> {
 let header: HeaderModel?
 let models: [CellModel]
 }*/

// MARK: ЖЕНЯ - инициализация через структуру

protocol SectionHeader { }

// ЖЕНЯ - реализация через SectionModel
struct SectionModel {
    let header: SectionHeader?
    let models: [CellModel]
}


// MARK: ЖЕНЯ - реализация через стуктуру

final class TableViewCustomDataSource<Header, Model>: NSObject, UITableViewDataSource {
    
    typealias CellConfigurator = (CellModel, UITableViewCell) -> Void
    var models: [SectionModel]
    
    private let cellConfigurator: CellConfigurator
    
    init(models: [SectionModel], cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.cellConfigurator = cellConfigurator
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].models.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: models[indexPath.section].models[indexPath.row].identifier, for: indexPath)
        cellConfigurator(model, cell)
        return cell
    }
}


// одна секция без Header
extension TableViewCustomDataSource where Model == CellModel, Header == CellModel {
    
    static func make(models: [Model]) -> TableViewCustomDataSource {
        return TableViewCustomDataSource(models: [SectionModel(header: nil, models: models)],
                                         cellConfigurator: { (viewModel, cell ) in
                                            guard let cell = cell as? ConfigurableCell else { return }
                                            cell.configure(with: viewModel)
                                         })
    }
}

// много секций
extension TableViewCustomDataSource where Model == CellModel, Header == CellModel {
    
    static func make(sections: [SectionModel]) -> TableViewCustomDataSource {
        return TableViewCustomDataSource(models: sections,
                                         cellConfigurator: { (viewModel, cell ) in
                                            guard let cell = cell as? ConfigurableCell else { return }
                                            cell.configure(with: viewModel)
                                         })
    }
}



// MARK: ЖЕНЯ: Дженерики - без Header'а

/*
 
final class TableViewCustomDataSource<Header, Model>: NSObject, UITableViewDataSource {
     
     typealias CellConfigurator = (CellModel, UITableViewCell) -> Void
     var models: [Section<Header, Model>]
     
     private let cellConfigurator: CellConfigurator
     
     init(models: [Section<Header, Model>], cellConfigurator: @escaping CellConfigurator) {
         
        self.models = models
        self.cellConfigurator = cellConfigurator
         
     }
     
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return models[section].models.count
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return models.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let model = models[indexPath.section].models[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: models[indexPath.section].models[indexPath.row].identifier, for: indexPath)
         cellConfigurator(model, cell)
         return cell
     }
 }


 // одна секция без Header
 extension TableViewCustomDataSource where Model == CellModel, Header == CellModel {

     static func make(models: [Model]) -> TableViewCustomDataSource {
         return TableViewCustomDataSource(models: [Section(header: nil, models: models)],
                                          cellConfigurator: { (viewModel, cell ) in
                                             guard let cell = cell as? ConfigurableCell else { return }
                                             cell.configure(with: viewModel)
                                          })
     }
 }

 // много секций
 extension TableViewCustomDataSource where Model == CellModel, Header == CellModel {
     
     static func make(sections: [Section<Header, Model>]) -> TableViewCustomDataSource {
         return TableViewCustomDataSource(models: sections,
                                          cellConfigurator: { (viewModel, cell ) in
                                             guard let cell = cell as? ConfigurableCell else { return }
                                             cell.configure(with: viewModel)
                                          })
     }
 }


*/




// MARK: ЖЕНЯ: Дженерики - версия с Header'ом

/*
 
 final class TableViewCustomDataSource<Header, Model>: NSObject, UITableViewDataSource {
     
     typealias CellConfigurator = (CellModel, UITableViewCell) -> Void
     typealias HeaderConfigurator = (HeaderModel, UITableViewHeaderFooterView) -> Void
     var sections: [Section<Header, Model>]
     
     private let cellConfigurator: CellConfigurator
     private let headerConfigurator: HeaderConfigurator
     
     init(sections: [Section<Header, Model>], cellConfigurator: @escaping CellConfigurator, headerConfigurator: @escaping HeaderConfigurator) {
        self.sections = sections
        self.cellConfigurator = cellConfigurator
        self.headerConfigurator = headerConfigurator
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return sections[section].models.count
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return sections.count
     }
     
     private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         guard let model = sections[section].header else { return nil }
         let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: model.identifier)
         guard let header = header else { return nil }
         headerConfigurator(model, header)
         return header
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let model = sections[indexPath.section].models[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath)
         cellConfigurator(model, cell)
         return cell
     }
 }


 // одна секция без Header
 extension TableViewCustomDataSource where Model == CellModel, Header == CellModel {

     static func make(models: [Model], withCellIdentifier reuseIdentifier: String) -> TableViewCustomDataSource {
         return TableViewCustomDataSource(sections: [Section(header: nil, models: models)],
                                          
                                          cellConfigurator: { (viewModel, cell ) in
                                             guard let cell = cell as? ConfigurableCell else { return }
                                             cell.configure(with: viewModel)
                                          },
                                          
                                          headerConfigurator: { (viewModel, cell) in
                                             guard let cell = cell as? ConfigurableCell else { return }
                                         //    cell.configure(with: viewModel)
                                          })
     }
 }

 // много секций
 extension TableViewCustomDataSource where Model == CellModel, Header == CellModel {
     
     static func make(sections: [Section<Header, Model>], withCellIdentifiers reuseIdentifiers: [String]) -> TableViewCustomDataSource {
         return TableViewCustomDataSource(sections: sections,
                                          
                                          cellConfigurator: { (viewModel, cell ) in
                                             print(cell)
                                             guard let cell = cell as? ConfigurableCell else { return }
                                             cell.configure(with: viewModel)
                                          },
                                          
                                          headerConfigurator: { (viewModel, cell) in
                                             print(cell)
                                             guard let cell = cell as? ConfigurableCell else { return }
                                         //    cell.configure(with: viewModel)
                                          })
     }
 }

 */
