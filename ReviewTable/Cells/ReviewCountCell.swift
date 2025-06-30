//
//  ReviewCountCell.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 29.06.2025.
//

import UIKit

final class ReviewCountCell: UITableViewCell {
    
    static let reuseID = String(describing: ReviewCountCell.self)
    
    private var reviewCountLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ReviewCountCell {
    
    private func setup() {
        
        reviewCountLabel = {
            let label = UILabel()
            
            label.textAlignment = .center
            label.font = UIFont.reviewCount
            label.textColor = UIColor.reviewCount
            
            label.numberOfLines = 1
            
            return label
        }()
        
        reviewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reviewCountLabel)
        
        NSLayoutConstraint.activate([
            reviewCountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ReviewCellLayout.Spacing.insets.top),
            reviewCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ReviewCellLayout.Spacing.insets.bottom),
            reviewCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ReviewCellLayout.Spacing.insets.left),
            reviewCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ReviewCellLayout.Spacing.insets.right)
        ])
    }
    
    func configure(with reviewCount: Int) {
        reviewCountLabel.text = "\(reviewCount) отзывов"
    }
}
