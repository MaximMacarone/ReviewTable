//
//  ReviewsViewModel.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 28.06.2025.
//

import UIKit
import Combine

final class ReviewsViewModel: NSObject {
    
    enum UpdateType {
        case pagination(newRange: Range<Int>)
        case expansion(changedIndex: Int)
        case refresh
    }
    
    //MARK: - Combine fields
    
    @Published private(set) var reviews: [ReviewCellConfig] = []
    @Published private(set) var reviewCount: Int = 0
    @Published private(set) var shouldLoad = true
    @Published private(set) var lastUpdate: UpdateType?
    
    let isLoadingPublisher = CurrentValueSubject<Bool, Never>(false)
    
    //MARK: - fields
    
    var offset: Int = 0
    let limit: Int = 20
    private let reviewsProvider: ReviewsProvider
    private let decoder: JSONDecoder
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Init
    
    init(
        reviewsProvider: ReviewsProvider = ReviewsProvider(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.reviewsProvider = reviewsProvider
        self.decoder = decoder
    }
    
}

extension ReviewsViewModel {
    func loadPageIfNeeded() {
        guard isLoadingPublisher.value == false, shouldLoad else { return }
        isLoadingPublisher.send(true)
        
        let startIndex = offset
        
        reviewsProvider
            .getReviewsPublisher(offset: offset)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap { [decoder] data in
                try decoder.decode(Reviews.self, from: data)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoadingPublisher.send(false)
                
                if case .failure = completion {
                    self.shouldLoad = true
                }
                
            } receiveValue: { [weak self] reviews in
                guard let self else { return }
                
                let newReviews = reviews.items.map(self.makeReviewItem)
                self.reviews.append(contentsOf: newReviews)
                self.reviewCount = reviews.count
                self.offset += self.limit
                self.shouldLoad = self.offset < reviews.count
                self.lastUpdate = .pagination(newRange: startIndex..<startIndex + newReviews.count)
            }
            .store(in: &cancellables)
        
    }
    
    private func computeNeedsShowMore(_ text: String) -> Bool {
        let totalWidth = UIScreen.main.bounds.width
        let horizontalInsets = ReviewCellLayout.Spacing.insets.left + ReviewCellLayout.Spacing.insets.right
        let indentFromAvatar = ReviewCellLayout.Avatar.avatarSize.width + ReviewCellLayout.Spacing.avatarToUsernameSpacing
        let availableWidth = totalWidth - horizontalInsets - indentFromAvatar

        let font = UIFont.reviewText
        let maxSize = CGSize(width: availableWidth, height: .greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]
        let bounding = (text as NSString).boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )
        return bounding.height > font.lineHeight * 3
    }
    
    func refresh() {
        guard isLoadingPublisher.value == false else { return }
        lastUpdate = .refresh
        offset = 0
        reviews = []
        reviewCount = 0
        shouldLoad = true
        loadPageIfNeeded()
    }
    
    func makeReviewItem(_ review: Review) -> ReviewCellConfig {
        let reviewText = review.text
        
        let created = review.created
        let authorFisrtName = review.firstName
        let authorSecondName = review.lastName
        let rating = review.rating
        let avatar = UIImage(named: review.avatarURL.isEmpty ? "AvatarImage" : review.avatarURL)!
        let photos = (review.photoURLs)
            .compactMap { $0.isEmpty ? nil : UIImage(named: $0) }
        
        let needShowFullButton = computeNeedsShowMore(reviewText)
        
        let showFullTextAction: (UUID) -> Void = { [weak self] id in
            guard let self = self else { return }
            
            if let index = self.reviews.firstIndex(where: { $0.id == id }) {
                self.reviews[index].isExpanded.toggle()
                self.lastUpdate = .expansion(changedIndex: index)
            }
        }
        
        let item = ReviewCellConfig(
            reviewAuthorFirstName: authorFisrtName,
            reviewAuthorSecondName: authorSecondName,
            reviewText: reviewText,
            rating: rating,
            created: created,
            avatarImage: avatar,
            reviewPhotots: photos,
            needShowFullButton: needShowFullButton,
            showFullTextTapped: showFullTextAction
        )
        return item
    }
}
