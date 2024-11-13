import Foundation
import Alamofire
import SwiftUI
import Firebase
import FirebaseMessaging

class SignInViewModel: ObservableObject {
    static let shared = SignInViewModel()
    @Published var model = SignInRequest()
    @Published var fcm: String = "" {
        didSet {
            saveFCMTokenToFirestore()
        }
    }
    
    func saveFCMTokenToFirestore() {
            guard let userID = KeyChain.read() else { return } // KeyChain에서 사용자 ID를 가져옴
            let db = Firestore.firestore()
            
            // 사용자 ID로 Firestore 경로 설정
            let userDocRef = db.collection("users").document(userID)
            
            // Firestore에 FCM 토큰 저장
            userDocRef.setData(["fcmToken": fcm], merge: true) { error in
                if let error = error {
                    print("FCM 토큰 저장 중 오류 발생: \(error.localizedDescription)")
                } else {
                    print("FCM 토큰이 Firestore에 저장되었습니다.")
                }
            }
        }
    
    func signin() {
        guard let viewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        let nextVC = UIHostingController(rootView: NavigationView { HomeView() })
        nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        if (self.model.email != "") && (self.model.password != "") {
            AF.request("\(Bundle.main.url)/auth/sign-in",
                       method: .post,
                       parameters: self.model.params,
                       encoding: JSONEncoding()
                       
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
                case .failure(_):
                    break
                }
            }
        }
        
    }
}
