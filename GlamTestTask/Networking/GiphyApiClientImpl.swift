import Foundation

final class GiphyApiClientImpl: GiphyApiClient {
    
    private struct Constants {
        static let apiKey = "INSERT_GIPHY_API_KEY_HERE"
        static let apiBaseUrl = "https://api.giphy.com"
        static let trendingEndpoint = "/v1/gifs/trending"
        static let logPrefix = "GiphyApiClient"
        static let defaultPageSize = 100
    }
    
    func fetchTrendingGifs(completion: @escaping ([GIF]) -> Void) {
        var components = URLComponents(string: Constants.apiBaseUrl)
        components?.path = Constants.trendingEndpoint
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.apiKey),
            URLQueryItem(name: "limit", value: "\(Constants.defaultPageSize)")
        ]
        
        guard let url = components?.url else {
            print("\(Constants.logPrefix): Error creating URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("\(Constants.logPrefix): \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("\(Constants.logPrefix): No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let gifData = try decoder.decode(GIFData.self, from: data)
                completion(gifData.data)
            } catch {
                print("\(Constants.logPrefix): \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
}
