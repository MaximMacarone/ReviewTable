//
//  ReviewPhotoCell.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 30.06.2025.
//

import UIKit

final class ReviewPhotoCell: UICollectionViewCell {
    
    static let reuseID = String(describing: ReviewPhotoCell.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = ReviewCellLayout.Photo.photoCornerRadius
        
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "AvatarImage")
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = UIImage(named: "AvatarImage")
    
    }
}
