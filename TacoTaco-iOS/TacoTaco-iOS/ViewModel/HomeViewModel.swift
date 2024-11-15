import SwiftUI
import MapKit
import CoreLocation
import Alamofire

class HomeViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion
    @Published var serverCoordinate: CLLocationCoordinate2D?
    @Published var annotationItems: [Item] = []
    @Published var distanceText: String = ""
    
    struct Item: Identifiable {
        var id = UUID()
        var coordinate: CLLocationCoordinate2D
        var isUserLocation: Bool
    }
    
    private let phoneNumber = "010-3009-0642"
    private let messageNumber = "010-3009-0642"
    
    // 초기화 메서드
    init() {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    }
    
    // 사용자 위치 업데이트
    func updateUserLocation(_ coordinate: CLLocationCoordinate2D) {
        let userLocation = Item(coordinate: coordinate, isUserLocation: true)
        annotationItems.append(userLocation)
        region.center = coordinate
        calculateDistance(from: coordinate)
    }
    
    // 서버 위치 업데이트
    func updateServerLocation(_ coordinate: CLLocationCoordinate2D) {
        let serverLocation = Item(coordinate: coordinate, isUserLocation: false)
        annotationItems.append(serverLocation)
        serverCoordinate = coordinate
        region.center = coordinate
        if let userLocation = annotationItems.first(where: { $0.isUserLocation })?.coordinate {
            calculateDistance(from: userLocation)
        }
    }
    
    // 거리 계산 메서드
    private func calculateDistance(from userCoordinate: CLLocationCoordinate2D) {
        guard let serverCoordinate = serverCoordinate else { return }
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let serverLocation = CLLocation(latitude: serverCoordinate.latitude, longitude: serverCoordinate.longitude)
        let distance = userLocation.distance(from: serverLocation) / 1000 // km 단위로 변환
        distanceText = String(format: "내 위치로부터 %.1f km", distance)
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
    
    func sendFCMTokenToServer() {
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
            guard let token = KeyChain.read()?.accessToken else {
                print("accessToken을 찾을 수 없습니다.")
                return
            }
            
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            let parameters: [String: String] = ["fcmToken": fcmToken]
            
            AF.request("\(Bundle.main.url)/fcm/token?fcmToken=\(fcmToken)",
                       method: .post,
                       encoding: JSONEncoding.default,
                       headers: headers
            ).response { response in
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 200:
                        print("FCM 토큰 전송 성공: 상태 코드 200")
                    default:
                        print("서버 응답 실패: 상태 코드 \(statusCode)")
                    }
                } else {
                    print("서버 응답 없음")
                }
                
                if let error = response.error {
                    print("FCM 토큰 전송 실패: \(error.localizedDescription)")
                }
            }
        } else {
            print("FCM 토큰을 찾을 수 없습니다.")
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
    
    func sendTouchRequest() {
        guard let token = KeyChain.read()?.accessToken else {
            print("accessToken을 찾을 수 없습니다.")
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        AF.request("\(Bundle.main.url)/fcm", method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("터치 요청 성공:", data)
            case .failure(let error):
                print("터치 요청 중 오류 발생:", error)
            }
        }
    }
}
