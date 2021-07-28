//
//  SelectedComicViewController.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 28.07.2021.
//

import UIKit

class SelectedComicViewController : UIViewController {
    
    var comic: Comic!
    
    override func viewDidLoad() {
        navigationItem.title = "Комикс"
        view.backgroundColor = .red
        guard let comic = comic else { return }
        print(comic.title)
    }
}
