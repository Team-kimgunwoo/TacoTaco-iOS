import SwiftUI
import MapKit
import CoreLocation
import Alamofire

struct Location: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = HomeViewModel()
    @State var showProfile: Bool = false

    var body: some View {
        ZStack {
            VStack {
                if locationManager.isAuthorized, let coordinate = locationManager.location {
                    Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.annotationItems) { item in
                        MapAnnotation(coordinate: item.coordinate) {
                            VStack {
                                Circle()
                                    .fill(item.isUserLocation ? Color.accentColor : Color.red)
                                    .frame(width: 20, height: 20)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 5)
                                
                                Text(item.isUserLocation ? "내 위치" : "건우 위치")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        }
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
                        showProfile = true
                    } label: {
                        Image("baseProfile")
                    }
                    .sheet(isPresented: $showProfile) {
                        MypageView()
                            .presentationDetents([.height(650)])
                    }
                }
                .padding(.horizontal, 30)
                Spacer()
            }

            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 365, height: 85)
                    .foregroundColor(.white)
                    .shadow(radius: 10, y: 4)
                    .overlay {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("지금 건우는?")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.accentColor)
                                Text(viewModel.distanceText)
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            Button { viewModel.sendTouchRequest() } label: { Image("touch") }
                            Button { viewModel.makeCall() } label: { Image("call") }
                            Button { viewModel.sendMessage() } label: { Image("message") }
                        }
                        .padding(.horizontal)
                    }
            }
        }
        .onAppear {
            if let coordinate = locationManager.location {
                viewModel.updateUserLocation(coordinate)
            }
            viewModel.fetchServerLocation()
            if locationManager.isAuthorized, let coordinate = locationManager.location {
                viewModel.updateUserLocation(coordinate)
            }
        }
    }
}


#Preview {
    NavigationView {
        HomeView()
    }
}
