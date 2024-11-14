import Foundation

struct SignInRequest: Codable {
    var email: String = ""
    var password: String = ""
    
    var params: [String: Any] {
        guard let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") else {
                return [:]
            }
        return [
            "email": email,
            "password": password,
            "fcmToken":  UserDefaults.standard.string(forKey: "fcmToken")!
        ]
    }
}
