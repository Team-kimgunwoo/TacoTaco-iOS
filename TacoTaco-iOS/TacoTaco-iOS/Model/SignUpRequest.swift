import Foundation

struct SignUpRequest: Codable {
    var email: String = ""
    var password1: String = ""
    var password2: String = ""
    var name: String = ""
    
    var params: [String: Any]  {
        return [
            "email": email,
            "password": password1,
            "name": name
        ]
    }
}
