//
//  PhotoViewerViewController.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 30.06.2025.
//

import UIKit

final class PhotoViewerViewController: UIViewController {
    private var images: [UIImage]
    private var startIndex: Int

    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var closeButton: UIButton!

    init(images: [UIImage], startIndex: Int) {
        self.images = images
        self.startIndex = startIndex
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        setupPageControl()
        setupCloseButton()
    }
    
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
        collectionView.register(PhotoViewerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .black

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Scroll to selected
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
        
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
}

extension PhotoViewerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoViewerCell
        cell.setImage(images[indexPath.item])
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
    }
}
