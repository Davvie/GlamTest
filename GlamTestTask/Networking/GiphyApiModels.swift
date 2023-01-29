import Foundation

struct GIFData: Codable {
    let data: [GIF]
}

struct GIF: Codable {
    let id: String
    let title: String
    let url: URL
    let images: Images
}

struct Images: Codable {
    let fixedHeight: Image
    let original: Image
}

struct Image: Codable {
    let url: URL
    let width: String
    let height: String
}
