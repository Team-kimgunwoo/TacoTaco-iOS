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

    var body: some View {
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
