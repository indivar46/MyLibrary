import Foundation
public struct GenericNetworkClass {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
  public enum ApiError: Error {
        case decodingError
        case resultError
    }
    
   public func callGetApi<T: Decodable>(apiUrl: URL?, dataType: T.Type, OnCompletion: @escaping(Result<T,Error>) -> Void) {
        
        guard let url = apiUrl else {
            OnCompletion(.failure(ApiError.resultError))
            return
        }
        URLSession.shared.dataTask(with: url) { data, responseStatus, error in
            guard let data = data else {
                OnCompletion(.failure(ApiError.decodingError))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                OnCompletion(.success(result))
            }
            catch {
                OnCompletion(.failure(ApiError.decodingError))
            }
        }.resume()
    }
}
