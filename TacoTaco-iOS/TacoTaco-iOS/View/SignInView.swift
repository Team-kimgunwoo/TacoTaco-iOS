import SwiftUI

struct SignInView: View {
    @StateObject var viewModel = SignInViewModel.shared
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 60)
            
            Image("logo")
            
            Text("TACOTACO")
                .font(.system(size: 30))
            
            Spacer()
                .frame(height: 60)
            
            InputField(title: "아이디", prompt: "아이디를 입력해주세요", content: $viewModel.model.email)
            
            InputField(title: "비밀번호", prompt: "비밀번호 입력해주세요", content: $viewModel.model.password)
                .padding(.top, 10)
            
            Spacer()
            
            Button {
                viewModel.signin()
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 309, height: 55)
                    .overlay {
                        Text("건우 보러가기")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    }
            }
            HStack {
                Text("아직 건우를 못보시나요?")
                
                NavigationLink(destination: SignUpView()) {
                    Text("친구하러 가기")
                }
            }
            .font(.system(size: 13))
            .padding(.bottom, 20)
            .padding(.top, 5)
        }
        .onAppear {
            print("느금마 \(viewModel.fcm)")
        }
    }
}

#Preview {
    NavigationView {
        SignInView()
    }
}
