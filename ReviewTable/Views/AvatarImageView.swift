//
//  AvatarImageView.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 26.06.2025.
//

import UIKit

class AvatarImageView: UIImageView {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Avatar setup
private extension AvatarImageView {
    func setup() {
        
        //TODO: - Bad style
        layer.cornerRadius = ReviewCellLayout.Avatar.avatarCornerRadius
        
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
}

extension AvatarImageView {
    func setImage(_ image: UIImage?) {
        self.image = image
    }
}
