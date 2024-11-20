import SwiftUI
import MapKit
import CoreLocation
import Alamofire

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = HomeViewModel()
    @State var showProfile: Bool = false
    @State var emotionMessage: String = "알 수 없음"

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
                            VStack(alignment: .leading, spacing: 10) {
                                Text("지금 건우는?")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.accentColor)

                                // emotionType에 따른 메시지
                                let emotionType = viewModel.emotionModel.data.emotionType
                                Text("\(emotionMessage(for: emotionType))")
                                    .font(.system(size: 15, weight: .light))
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
            viewModel.sendFCMTokenToServer()
            viewModel.getEmotion()
        }
    }

    // Helper function for emotion message
    private func emotionMessage(for emotionType: String) -> String {
        switch emotionType {
        case "WAR":
            return "계엄령 선포!!"
        case "BASEBALL":
            return "야구할 사람 찾는중..."
        case "MART":
            return "마트갈 사람 찾는중..."
        case "OUTING":
            return "외출중..."
        case "COUNSEL":
            return "상담 하는중..."
        case "DROP":
            return "자퇴 고민중..."
        default:
            return emotionType
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
