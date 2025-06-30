//
//  ReviewsViewController.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 28.06.2025.
//

import UIKit
import Combine

class ReviewsViewController: UIViewController {
    
    //MARK: - Subviews
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    //MARK: - private fields
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: ReviewsViewModel
    
    //MARK: - Init
    
    init(viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        
        configureReviewsSubscription()
        configureIsLoadingSubscription()
        
        viewModel.loadPageIfNeeded()
        
    }
    
}

//MARK: - Setup
extension ReviewsViewController {
    
    func setupView() {
        title = "Отзывы"
        view.backgroundColor = .systemBackground
    }
    
    func setupTableView() {
        
        //MARK: - Table View setup
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseID)
        tableView.register(ReviewCountCell.self, forCellReuseIdentifier: ReviewCountCell.reuseID)
        
        //MARK: - Table View layout
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

//MARK: - objc methods
extension ReviewsViewController {
    
    @objc
    private func refresh() {
        viewModel.refresh()
    }
    
}


//MARK: - Combine subscriptions
extension ReviewsViewController {
    
    private func configureReviewsSubscription() {
        viewModel.$lastUpdate
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] update in
                guard let self = self else { return }
                
                switch update {
                    
                case .refresh:
                    
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                    
                case .pagination(let newRange):
                    
                    let indexPaths = newRange.map { IndexPath(row: $0, section: 0) }
                    UIView.performWithoutAnimation {
                        self.tableView.performBatchUpdates({
                            self.tableView.insertRows(at: indexPaths, with: .none)
                        }, completion: nil)
                    }
                    
                case .expansion(let index):
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    
                }
                
            }
            .store(in: &cancellables)
    }
    
    private func configureIsLoadingSubscription() {
        
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] isLoading in
                guard let self else { return }
                
                if isLoading {
                    showNavBarLoadingIndicator(animated: true)
                } else {
                    self.refreshControl.endRefreshing()
                    dismissNavBarLoadingIndicator(animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
}

//MARK: - Review Cell delegate
extension ReviewsViewController: ReviewCellDelegate {
    
    func reviewCell(_ cell: ReviewCell, didTapPhotoAt index: Int, in photos: [UIImage]) {
        let photoViewerVC = PhotoViewerViewController(images: photos, startIndex: index)
        present(photoViewerVC, animated: true, completion: nil)
    }
    
}

extension ReviewsViewController: UITableViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let viewHeight = scrollView.bounds.height
        let contentHeight = scrollView.contentSize.height
        let remainingHeight = contentHeight - viewHeight - targetContentOffset.pointee.y
        
        if remainingHeight <= viewHeight * 2 {
            viewModel.loadPageIfNeeded()
        }
        
    }
    
}

extension ReviewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // +1 for ReviewCountCell
        viewModel.reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel.reviews.count {
            let config = viewModel.reviews[indexPath.row]
            
            guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: ReviewCellConfig.reuseID, for: indexPath) as? ReviewCell else {
                fatalError()
            }
            
            reviewCell.configure(with: config)
            reviewCell.delegate = self
            return reviewCell
            
        } else {
            guard let countCell = tableView.dequeueReusableCell(withIdentifier: ReviewCountCell.reuseID, for: indexPath) as? ReviewCountCell else {
                fatalError()
            }
            
            countCell.configure(with: viewModel.reviewCount)
            return countCell
        }
        
    }
    
}
