//
//  PhotoViewerCell.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 30.06.2025.
//

import UIKit

final class PhotoViewerCell: UICollectionViewCell {
    
    static let reuseID = String(describing: PhotoViewerCell.self)
    
    private let imageView = UIImageView()
    private let scrollView = UIScrollView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.backgroundColor = .black
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage) {
        imageView.image = image
        scrollView.zoomScale = 1.0
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        scrollView.zoomScale = 1.0
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.backgroundColor = .black
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
    }
}

extension PhotoViewerCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
