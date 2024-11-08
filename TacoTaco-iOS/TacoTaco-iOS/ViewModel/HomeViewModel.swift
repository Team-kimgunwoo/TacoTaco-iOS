import SwiftUI
import MapKit
import CoreLocation
import Alamofire

class HomeViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion
    @Published var serverCoordinate: CLLocationCoordinate2D?
    @Published var annotationItems: [Item] = []

    struct Item: Identifiable {
        var id = UUID()
        var coordinate: CLLocationCoordinate2D
        var isUserLocation: Bool
    }

    private let phoneNumber = "010-3009-0642"
    private let messageNumber = "010-3009-0642"

    init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    }

    func updateUserLocation(_ coordinate: CLLocationCoordinate2D) {
        let userLocation = Item(coordinate: coordinate, isUserLocation: true)
        annotationItems.append(userLocation)
        region.center = coordinate
    }

    func updateServerLocation(_ coordinate: CLLocationCoordinate2D) {
        let serverLocation = Item(coordinate: coordinate, isUserLocation: false)
        annotationItems.append(serverLocation)
        serverCoordinate = coordinate
        region.center = coordinate
    }

    func fetchServerLocation() {
        guard let token = KeyChain.read()?.accessToken else {
            print("accessToken을 찾을 수 없습니다.")
            return
        }

        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        AF.request("\(Bundle.main.url)/geo", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any],
                   let responseData = json["data"] as? [String: Any],
                   let latitude = responseData["latitude"] as? String,
                   let longitude = responseData["longitude"] as? String,
                   let latitudeValue = Double(latitude), let longitudeValue = Double(longitude) {
                    let coordinate = CLLocationCoordinate2D(latitude: latitudeValue, longitude: longitudeValue)
                    self.updateServerLocation(coordinate)
                } else {
                    print("오류: JSON에서 위도와 경도를 찾을 수 없습니다.")
                }
            case .failure(let error):
                print("위치 데이터를 가져오는 중 오류 발생:", error)
            }
        }
    }

    func makeCall() {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func sendMessage() {
        if let url = URL(string: "sms:\(messageNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
