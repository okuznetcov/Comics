import UIKit

struct SelectedComicFactory {
    static func makeViewDetail(comic: Comic) -> SelectedComicView {
        let view = SelectedComicView()
        let presenter = SelectedComicPresenter(view: view, comic: comic)
        view.presenter = presenter
        return view
    }
}
