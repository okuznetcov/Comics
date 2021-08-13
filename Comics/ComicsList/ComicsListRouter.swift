import UIKit

protocol ComicsListRouterProtocol {
    func navigateToPushedViewController(comic: Comic)
}

final class ComicsListRouter: ComicsListRouterProtocol {
    
    weak var view: ComicsListView?
    
    init(view: ComicsListView) {
        self.view = view
    }
    
    func navigateToPushedViewController(comic: Comic) {
        let dvc = SelectedComicFactory.makeViewDetail(comic: comic)
        view?.navigationController?.pushViewController(dvc, animated: true)
    }
}
