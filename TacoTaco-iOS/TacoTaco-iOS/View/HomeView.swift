import SwiftUI
import MapKit
import CoreLocation

struct Location: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    @State var showProfile: Bool = false
    
    let phoneNumber = "010-3009-0642"
    let messageNumber = "010-3009-0642"
    
    var body: some View {
        ZStack {
            VStack {
                if locationManager.isAuthorized, let coordinate = locationManager.location {
                    let userLocation = Location(coordinate: coordinate)
                    
                    Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [userLocation]) { item in
                        MapAnnotation(coordinate: item.coordinate) {
                            VStack {
                                Circle()
                                    .fill(Color.accentColor)
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                    .shadow(radius: 5)
                                Text("내 위치")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .onAppear {
                        region.center = coordinate
                    }
                    .edgesIgnoringSafeArea(.all)
                } else {
                    Text("위치 권한이 필요합니다.")
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        self.showProfile = true
                    } label: {
                        Image("baseProfile")
                    }
                    .sheet(isPresented: $showProfile) {
                        MypageView()
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 365, height: 85)
                    .foregroundStyle(.white)
                    .shadow(radius: 10, y: 4)
                    .overlay {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("지금 건우는?")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.accent)
                                
                                Text("내 위치로부터 1.7km")
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundStyle(.black)
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image("touch")
                            }
                            
                            Button {
                                if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Image("call")
                            }
                            
                            Button {
                                if let url = URL(string: "sms:\(messageNumber)"), UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Image("message")
                            }
                        }
                        .padding(.horizontal)
                    }
            }
            
        }
        .onAppear {
            if let coordinate = locationManager.location {
                region.center = coordinate
            }
        }
    }
}

#Preview {
    HomeView()
}
