//
//  PhotoViewerViewController.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 30.06.2025.
//

import UIKit

final class PhotoViewerViewController: UIViewController {
    
    //MARK: - Subviews
    
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var closeButton: UIButton!
    
    //MARK: - Private fields
    
    private var images: [UIImage]
    private var startIndex: Int

    //MARK: - Init
    
    init(images: [UIImage], startIndex: Int) {
        self.images = images
        self.startIndex = startIndex
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        setupPageControl()
        setupCloseButton()
    }

    
}

//MARK: - Setup
extension PhotoViewerViewController {
    
    private func setupCloseButton() {
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
    }

    private func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PhotoViewerCell.self, forCellWithReuseIdentifier: PhotoViewerCell.reuseID)
        collectionView.backgroundColor = .black

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: self.startIndex, section: 0), at: .centeredHorizontally, animated: false)
            self.pageControl.currentPage = self.startIndex
        }
        
    }

    private func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.currentPage = startIndex
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        
        pageControl.isUserInteractionEnabled = false
        
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

//MARK: - objc methods
extension PhotoViewerViewController {
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
}

//MARK: - Collection View delegate

extension PhotoViewerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewerCell.reuseID, for: indexPath) as! PhotoViewerCell
        
        cell.setImage(images[indexPath.item])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
    }

}

extension PhotoViewerViewController: UICollectionViewDelegate {
    
}
