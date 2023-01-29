import Foundation

protocol GiphyApiClient {
    
    func fetchTrendingGifs(completion: @escaping ([GIF]) -> Void)
    
}
