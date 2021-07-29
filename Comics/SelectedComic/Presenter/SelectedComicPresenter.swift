//
//  SelectedComicPresenter.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 29.07.2021.
//

import Foundation

protocol SelectedComicPresenterProtocol {
   func getComic() -> Comic
   func getNumOfRows() -> Int
}

class SelectedComicPresenter: SelectedComicPresenterProtocol {

    unowned let view: SelectedComicViewProtocol
    var comic: Comic!
    
    required init(view: SelectedComicViewProtocol, comic: Comic) {
        self.view = view
        self.comic = comic
    }
    
    func getNumOfRows() -> Int {
        return 4
    }
    
    func getComic() -> Comic {
        return comic
    }
}
