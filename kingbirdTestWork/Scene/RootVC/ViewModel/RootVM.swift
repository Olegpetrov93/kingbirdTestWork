//
//  RootVM.swift
//  kingbirdTestWork
//
//  Created by Oleg on 7/8/21.
//

import Foundation

protocol RootView: AnyObject {
    func reloadView()
}

protocol RootVMProtocol: AnyObject {
    init(view: RootView, networkService: NetworkServiceProtocol, dataSource: DataSource)
    func fetchData()
    func numberOfRows() -> Int
    func deletePhoto(indexPath: IndexPath)
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CollectionViewCellVMProtocol?
}

final class RootVM: RootVMProtocol, CategoriesDelegate {
    
    weak var view: RootView?
    let networkService: NetworkServiceProtocol
    let dataSource: DataSource
    
    private var snapshots: [PhotoCD] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.reloadView()
            }
        }
    }
    
    required init(view: RootView, networkService: NetworkServiceProtocol, dataSource: DataSource) {
        self.view = view
        self.networkService = networkService
        self.dataSource = dataSource
        dataSource.delegate = self
    }
    
    func numberOfRows() -> Int {
        return snapshots.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CollectionViewCellVMProtocol? {
        let photo = snapshots[indexPath.row]
        return CollectionViewCellVM(photo: photo)
    }
    
    func fetchData() {
        self.networkService.fetchPhoto(completion: { (result) in
            switch result {
            case .success(let snapshots):
                self.dataSource.setUpData(snapshots: snapshots)
            case .failure(let error):
                print(error)
                self.dataSource.importDataFromCoreData()
            }
        })
    }
    
    func deletePhoto(indexPath: IndexPath) {
        let photo = snapshots[indexPath.row]
        self.dataSource.deletePhoto(photo: photo)
        DispatchQueue.main.async {
            self.view?.reloadView()
        }
    }
    
    func update(snapshots: [PhotoCD]) {
        self.snapshots = snapshots
    }
}



