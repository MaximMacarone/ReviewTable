/// Модель отзыва.
struct Review: Decodable {
    
    let firstName: String
    let lastName: String
    let text: String
    let created: String
    let rating: Int
    let avatarURL: String
    let photoURLs: [String]
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case text
        case created
        case rating
        case avatarURL = "avatar_url"
        case photoURLs = "photo_urls"
    }

}
