import UIKit
import SnapKit

struct ComicsListFactory {
    static func make() -> ComicsListView {
        let view = ComicsListView()
        let router = ComicsListRouter(view: view)
        let presenter = ComicsListPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
}
