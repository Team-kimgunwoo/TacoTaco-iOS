import Foundation
import Alamofire

class SignUpViewModel: ObservableObject {
    @Published var model = SignUpRequest()
    
    var isAvailable: Bool {
        get {
            return !model.email.isEmpty && !model.name.isEmpty && !model.password1.isEmpty && !model.password2.isEmpty && model.password1 == model.password2
        }
    }
    
    func signUp(completion: @escaping () -> ()) {
        AF.request("\(Bundle.main.url)/auth/sign-up", method: .post, parameters: model.params, encoding: JSONEncoding.default)
            .response { response in
                switch response.response?.statusCode {
                case 201:
                    completion()
                default:
                   print("실패임 ㅅㄱ")
                }
            }
    }
}
