//
//  PhotoCell.swift
//  kingbirdTestWork
//
//  Created by Oleg on 7/8/21.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    
    weak var viewModel: PhotoCellViewModelProtocol? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            name.text = viewModel.author
            autoreleasepool {
                DispatchQueue.main.async {
                    self.profileImageView.image = viewModel.photoImageSmall
                }
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let name: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        ddConstraints()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(activityIndicator)
        contentView.addSubview(profileImageView)
        contentView.addSubview(name)
    }
    
    private func ddConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            profileImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            
            name.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            name.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
