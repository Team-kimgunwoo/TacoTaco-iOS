import Foundation
import Alamofire

final class Interceptor: RequestInterceptor {
    static let shared = Interceptor()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(Bundle.main.url) == true,
              let keychain = KeyChain.read()
        else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        
        urlRequest.setValue("Bearer \(String(describing: keychain.accessToken))", forHTTPHeaderField: "Authorization")
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let keychain = KeyChain.read() else {
            completion(.doNotRetry)
            return
        }
        
        AF.request("\(Bundle.main.url)/auth/refresh", method: .post, parameters: ["refreshToken": keychain.refreshToken], encoding: JSONEncoding.default)
            .responseDecodable(of: StatusModel<RefreshModel>.self) { response in
                switch response.result {
                case .success(let result):
                    guard let accessToken = result.data?.accessToken else { return }
                    
                    if KeyChain.update(token: .init(accessToken: accessToken, refreshToken: keychain.refreshToken)) {
                        SignInViewModel.shared.objectWillChange.send()
                        completion(.retry)
                    } else {
                        if KeyChain.delete() {
                            SignInViewModel.shared.objectWillChange.send()
                            completion(.doNotRetry)
                        }
                    }
                case .failure(let error):
                    if KeyChain.delete() {
                        SignInViewModel.shared.objectWillChange.send()
                    }
                                    
                    completion(.doNotRetryWithError(error))
                }
            }
    }
}
