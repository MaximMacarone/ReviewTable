//
//  ReviewCell.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 30.06.2025.
//

import UIKit

protocol ReviewCellDelegate: AnyObject {
    func reviewCell(_ cell: ReviewCell, didTapPhotoAt index: Int, in photos: [UIImage])
}

final class ReviewCell: UITableViewCell {
    
    private let ratingRenderer = RatingRenderer()
    private var photos: [UIImage] = []
    
    weak var delegate: ReviewCellDelegate?
    
    // MARK: - Subviews
    
    private let avatarView: AvatarImageView = {
        let avatarImageView = AvatarImageView()
        
        avatarImageView.widthAnchor.constraint(equalToConstant: ReviewCellLayout.Avatar.avatarSize.width).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: ReviewCellLayout.Avatar.avatarSize.height).isActive = true
        
        avatarImageView.layer.cornerRadius = ReviewCellLayout.Avatar.avatarCornerRadius
        
        avatarImageView.clipsToBounds = true
        
        return avatarImageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.username
        label.numberOfLines = 1
        
        return label
    }()
    
    private let ratingView: UIImageView = {
        let imageView = UIImageView()
        
//        imageView.setContentHuggingPriority(.required, for: .horizontal)
//        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return imageView
    }()
    
    private let reviewTextLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.reviewText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.setContentHuggingPriority(.required, for: .vertical)
//        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    private let showFullTextButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = UIFont.showMore
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
//        button.setContentHuggingPriority(.required, for: .vertical)
//        button.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.created
        label.textColor = UIColor.created
        label.numberOfLines = 1
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        label.setContentHuggingPriority(.required, for: .vertical)
//        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    private var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = ReviewCellLayout.Photo.photoSize
        layout.minimumInteritemSpacing = ReviewCellLayout.Spacing.photosSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: ReviewCellLayout.Photo.photoSize.height)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
//        collectionView.setContentHuggingPriority(.required, for: .vertical)
//        collectionView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        collectionView.backgroundColor = .clear
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(ReviewPhotoCell.self, forCellWithReuseIdentifier: ReviewPhotoCell.reuseID)
        
        return collectionView
    }()
    
    // MARK: - Stack views
    
    private let ratingPhotosStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = ReviewCellLayout.Spacing.ratingToPhotosSpacing
        
        return stackView
    }()
    
    private let createdShowFullStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = ReviewCellLayout.Spacing.showMoreToCreatedSpacing
        
        return stackView
    }()
    
    // MARK: -
    var onShowFullText: (() -> Void)?
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Cell setup
extension ReviewCell {
    private func setupLayout() {
        
        ratingPhotosStackView.addArrangedSubview(ratingView)
        ratingPhotosStackView.addArrangedSubview(photosCollectionView)
        
        photosCollectionView.widthAnchor.constraint(equalTo: ratingPhotosStackView.widthAnchor).isActive = true
        
        createdShowFullStackView.addArrangedSubview(showFullTextButton)
        createdShowFullStackView.addArrangedSubview(dateLabel)
        
        let subviews: [UIView] = [
            avatarView,
            authorLabel,
            ratingPhotosStackView,
            reviewTextLabel,
            createdShowFullStackView
        ]
        
        for subview in subviews {
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Avatar View
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ReviewCellLayout.Spacing.insets.top),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ReviewCellLayout.Spacing.insets.left),
            
            // Author Label
            authorLabel.topAnchor.constraint(equalTo: avatarView.topAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: ReviewCellLayout.Spacing.avatarToUsernameSpacing),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ReviewCellLayout.Spacing.insets.right),
            
            // Rating Photos Stack View
            ratingPhotosStackView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: ReviewCellLayout.Spacing.usernameToRatingSpacing),
            ratingPhotosStackView.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            ratingPhotosStackView.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
            
            // Review Text Label
            reviewTextLabel.topAnchor.constraint(equalTo: ratingPhotosStackView.bottomAnchor, constant: ReviewCellLayout.Spacing.photosToTextSpacing),
            reviewTextLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            reviewTextLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
            
            // Created Show Full Stack View
            createdShowFullStackView.topAnchor.constraint(equalTo: reviewTextLabel.bottomAnchor, constant: ReviewCellLayout.Spacing.reviewTextToCreatedSpacing),
            createdShowFullStackView.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            createdShowFullStackView.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ReviewCellLayout.Spacing.insets.bottom)
        ])
    }
}

//MARK: - Cell configuration
extension ReviewCell {
    func configure(with config: ReviewCellConfig) {
        
        //Avatar View
        avatarView.setImage(config.avatarImage)
        
        //Author Label
        authorLabel.text = config.reviewAuthorFirstName + " " + config.reviewAuthorSecondName
        
        //Rating View
        ratingView.image = ratingRenderer.ratingImage(config.rating)
        
        //Photos Collection View
        photos = config.reviewPhotots
        photosCollectionView.isHidden = photos.isEmpty
        photosCollectionView.reloadData()
        
        //Review Text Label
        reviewTextLabel.text = config.reviewText
        reviewTextLabel.numberOfLines = config.isExpanded ? 0 : config.maxLines
        
        
        //Show Full Text Button
        showFullTextButton.isHidden = !config.needShowFullButton || config.isExpanded
        showFullTextButton.setTitle(config.showFullTextTitle, for: .normal)
        self.onShowFullText = { config.showFullTextTapped(config.id) }
        showFullTextButton.addTarget(self, action: #selector(didTapShowFullText), for: .touchUpInside)
        
        //Date label
        dateLabel.text = config.created
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarView.setImage(nil)
        authorLabel.text = nil
        ratingView.image = nil
        reviewTextLabel.text = nil
        reviewTextLabel.numberOfLines = 3
        dateLabel.text = nil
        showFullTextButton.isHidden = true
        
        photos = []
        photosCollectionView.reloadData()
        
        onShowFullText = nil
    }
}

//MARK: - Cell buttons actions
extension ReviewCell {
    @objc
    private func didTapShowFullText() {
        onShowFullText?()
    }
}


//MARK: - Photos Collection View delegate

extension ReviewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewPhotoCell.reuseID, for: indexPath) as! ReviewPhotoCell
        
        let image = photos[indexPath.item]
        cell.setImage(image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.reviewCell(self, didTapPhotoAt: indexPath.item, in: photos)
    }
    
}

extension ReviewCell: UICollectionViewDelegate {

}

