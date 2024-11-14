import Foundation
import Alamofire
import SwiftUI
import Firebase
import FirebaseMessaging

class SignInViewModel: ObservableObject {
    static let shared = SignInViewModel()
    @Published var model = SignInRequest()
    
    func signin() {
        guard let viewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        let nextVC = UIHostingController(rootView: NavigationView { HomeView() })
        nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        if (self.model.email != "") && (self.model.password != "") {
            AF.request("\(Bundle.main.url)/auth/sign-in",
                       method: .post,
                       parameters: self.model.params,
                       encoding: JSONEncoding.default
                       
            )
            .validate()
            .responseDecodable(of: StatusModel<TokenModel>.self) { response in
                switch response.result {
                case .success(let result):
                    if let data = result.data {
                        if KeyChain.create(token: data) {
                            viewController.present(nextVC, animated: true)
                        }
                        else {
                            
                        }
                    }
                case .failure(let error):
                    if let data = response.data,
                                   let errorMessage = String(data: data, encoding: .utf8) {
                                    print("Error: \(error.localizedDescription), Response: \(errorMessage)")
                                }
                }
            }
        }
        
    }
}
