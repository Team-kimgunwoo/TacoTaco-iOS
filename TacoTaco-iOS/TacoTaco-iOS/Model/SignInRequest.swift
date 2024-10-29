import Foundation

struct SignInRequest: Codable {
    var email: String = ""
    var password: String = ""
    
    var params: [String: Any] {
        return [
            "email": email,
            "password": password
        ]
    }
}
