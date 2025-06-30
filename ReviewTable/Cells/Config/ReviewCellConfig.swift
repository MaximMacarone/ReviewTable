//
//  ReviewCellConfig.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 28.06.2025.
//

import UIKit

struct ReviewCellConfig {
    static let reuseID = String(describing: ReviewCellConfig.self)
    
    let id = UUID()
    
    let reviewAuthorFirstName: String
    let reviewAuthorSecondName: String
    
    let reviewText: String
    
    let rating: Int
    
    let maxLines = 3
    
    let created: String
    
    let avatarImage: UIImage
    let reviewPhotots: [UIImage]
    
    var isExpanded = false
    
    let needShowFullButton: Bool
    let showFullTextTitle = "Показать полностью..."
    let showFullTextTapped: (UUID) -> Void
}

enum ReviewCellLayout {
    // MARK: - Отступы
    enum Spacing {
        /// Отступы от краёв ячейки до её содержимого.
        static let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)
        /// Горизонтальный отступ от аватара до имени пользователя.
        static let avatarToUsernameSpacing = 10.0
        /// Вертикальный отступ от имени пользователя до вью рейтинга.
        static let usernameToRatingSpacing = 6.0
        /// Вертикальный отступ от вью рейтинга до текста (если нет фото).
        static let ratingToTextSpacing = 6.0
        /// Вертикальный отступ от вью рейтинга до фото.
        static let ratingToPhotosSpacing = 10.0
        /// Горизонтальные отступы между фото.
        static let photosSpacing = 8.0
        /// Вертикальный отступ от фото (если они есть) до текста отзыва.
        static let photosToTextSpacing = 10.0
        /// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
        static let reviewTextToCreatedSpacing = 6.0
        /// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
        static let showMoreToCreatedSpacing = 6.0
    }
    
    enum Avatar {
        static let avatarSize = CGSize(width: 36.0, height: 36.0)
        static let avatarCornerRadius = 18.0
    }
    
    enum Photo {
        static let photoSize = CGSize(width: 55.0, height: 66.0)
        static let photoCornerRadius = 8.0
    }
}
