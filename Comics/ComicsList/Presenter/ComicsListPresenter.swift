//
//  ComicListPresenter.swift
//  Comics
//
//  Created by Oleg Kuznetsov on 29.07.2021.
//

import Foundation
import RealmSwift

protocol ComicsListPresenterProtocol: AnyObject {
    func selectedComicVC(at selectedRow: Int) -> SelectedComicView
    func searchBarTextChanged(searchText: String)
    func getComic(at index: Int) -> Comic
    func getNumberOfComics() -> Int
}

class ComicsListPresenter: ComicsListPresenterProtocol {
    
    private var comics: Results<Comic>!                 // все записи о комиксах
    private var filteredComics: Results<Comic>!         // все записи о комиксах
    unowned let view: ComicsListViewProtocol
    var fetchedComics: [DownloadedComic] = []
    
    required init(view: ComicsListViewProtocol) {
        //StoargeManager.saveObject(Comic(marvelId: "3421", title: "Test", description: "suprehero", pageCount: "20"))
        self.view = view
        comics = realm.objects(Comic.self)
        
        let networking = Networking(url: "/comics", limit: 5)
        networking.fetchComics(url: "/comics", params: "limit=100", completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
            switch result {
                case .success(let apiData):
                    self.fetchedComics.append(contentsOf: (apiData?.data.results)!)
                    
                    for comic in self.fetchedComics {
                        //networking.fetchImage(url: comic.thumbnail.path, imageExtension: comic.thumbnail.extension)
                        if (self.comics.filter("marvelId == %@", "\(comic.id)").count == 0) {
                            print(comic.id)
                            StoargeManager.saveObject(
                                Comic(marvelId: "\(comic.id)",
                                      title: comic.title,
                                      description: comic.description,
                                      pageCount: "\(comic.pageCount)")
                                )
                            view.reloadTable()
                        }
                    }
                case .failure(_):
                    print("error")
                }
            }
        })
    }
    
    func getNumberOfComics() -> Int {
        if (isFiltering) {
            return filteredComics.count
        } else {
            return comics.count
        }
    }
    
    private var isFiltering: Bool {                 // пользователь производит поиск?
        return view.checkSearchIsActive() && !view.checkSearchBarIsEmpty()
    }
    
    
    func getComic(at index: Int) -> Comic {
        // определяем выбранную запись (или из общего списка, или из отфильтрованных)
        if (isFiltering) {
            return filteredComics[index]
        } else {
            return comics[index]
        }
    }

    func searchBarTextChanged(searchText: String) {
        filteredComics = comics.filter("title CONTAINS[c] %@", searchText) // игнорируем регистр, ищем по названию
        view.reloadTable()
    }
    
    func selectedComicVC(at selectedRow: Int) -> SelectedComicView {
        let dvc = SelectedComicView(comic: comics[selectedRow])
        //dvc.presenter?.setComic(comic: comics[selectedRow])   // передаем информацию о выбранном комиксе другому презентеру
        return dvc
        
    }
}


/*
 
 
 
 var objects = [Comic]()
 
 func getObjects() {
     let networking = Networking(url: "/comics")
     //networking.makeRequest()
     
         networking.fetchComics { [weak self] result in
             guard let self = self else { return }
             DispatchQueue.main.async {
                 switch result {
                 case .success(let apiData):
                   print("sndfkgjndk")
                     self.fetchedComics.append(contentsOf: (apiData?.data.results)!)
                 case .failure(_):
                     print("error")
                 }
             }
         }
     
     /*networking.makeRequest { [weak self] result in
         guard let self = self else { return }
         DispatchQueue.main.async {
             switch result {
             case .success(let data):
                 self.objects = data!
                 print(self.objects.count)
             case .failure(let error):
                 print("error")
             }
         }
     }*/
 }
 */
