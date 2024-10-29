import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 60)
            
            Image("logo")
            
            Text("TACOTACO")
                .font(.system(size: 30))
            
            Spacer()
                .frame(height: 60)
            
            InputField(title: "이메일", prompt: "이메일을 입력해주세요", content: $viewModel.model.email)
            
            InputField(title: "이름", prompt: "이름을 입력해주세요", content: $viewModel.model.name)
                .padding(.top, 10)
            
            InputField(title: "비밀번호", prompt: "비밀번호를 입력해주세요", content: $viewModel.model.password1)
                .padding(.top, 10)
            
            InputField(title: "비밀번호 확인", prompt: "비밀번호를 다시 입력해주세요", content: $viewModel.model.password2)
                .padding(.top, 10)
            
            Spacer()
            
            Button {
                viewModel.signUp() {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(viewModel.isAvailable ? .accent : .gray)
                    .frame(width: 309, height: 55)
                    .overlay {
                        Text("건우 친구하기")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    }
            }
            .padding(.bottom, 50)
            .disabled(!viewModel.isAvailable)
        }
    }
}

#Preview {
    SignUpView()
}
