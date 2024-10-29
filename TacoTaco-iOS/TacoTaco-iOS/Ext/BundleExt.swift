import Foundation

extension Bundle {
    var url: String {
        if let path = Bundle.main.url(forResource:"ApiContent", withExtension: "plist") {
           do {
             let data = try Data(contentsOf: path)
             let resource = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String:Any]
               
               let url = "\(resource["URL"]!):\(resource["PORT"]!)"
               
               return url
           } catch {
              
           }
        }
        return ""
    }
}
