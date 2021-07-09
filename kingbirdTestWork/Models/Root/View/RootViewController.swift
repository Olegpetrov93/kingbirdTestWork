//
//  RootViewController.swift
//  kingbirdTestWork
//
//  Created by Oleg on 7/7/21.
//

import UIKit

final class RootViewController: UIViewController {
    
    // MARK: - ViewModel
    
    var viewModel: RootViewModelProtocol?
    
    // MARK: - Properties
    private enum LayoutConstant {
        static let spacing: CGFloat = 9.0
        static let itemHeight: CGFloat = 180.0
    }
    
    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorRect = CGRect(x: 0, y: 0, width: 20, height: 20)
        let indicator = UIActivityIndicatorView(frame: activityIndicatorRect)
        indicator.startAnimating()
        indicator.isHidden = false
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Фотографии NASA"
        loadData()
        
        DispatchQueue.global().async {
            self.viewModel?.fetchData()
        }
    }
    // MARK: - Set up views
    private func loadData() {
        setupViews()
        setupLayouts()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }
    // MARK: - Set up layouts
    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // Layout constraints for `collectionView`
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0)
        ])
    }
}
// MARK: - CollectionView dataSource, delegate
extension RootViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier,
                                                      for: indexPath) as! PhotoCell
        let collectionViewCellVM = viewModel?.cellViewModel(forIndexPath: indexPath)
        
        cell.viewModel = collectionViewCellVM
        cell.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collectionViewCellVM = viewModel?.cellViewModel(forIndexPath: indexPath)
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
        openImage(image: collectionViewCellVM?.photoImage, imageView: cell.profileImageView)
    }
    
    func openImage(image: UIImage?, imageView: UIImageView) {
        guard let image = image else {
            return
        }
        let imageInfo = GSImageInfo(image: image, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: imageView)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        
        present(imageViewer, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(indexPath: indexPath)
    }
    
    func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                self.viewModel?.deletePhoto(indexPath: indexPath)
            }
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])
        }
        return context
    }
}
// MARK: - CollectionView delegate flow layout
extension RootViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.width - LayoutConstant.spacing * 3) / 2, height: LayoutConstant.itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing,
                            bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
}
// MARK: - Date source delegate
extension RootViewController: RootView {
    func reloadView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.activityIndicator.isHidden = true
        }
    }
}
