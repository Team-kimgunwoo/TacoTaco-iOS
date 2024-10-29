import SwiftUI

struct InputField: View {
    let title: String
    let prompt: String
    @Binding var content: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.accent)
                
                Spacer()
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 5)
            
            TextField(text: $content, prompt: Text(prompt).font(.system(size: 12))) {
                
            }
            .frame(width: 300, height: 30)
            .textInputAutocapitalization(.never)
            
            Rectangle()
                .frame(width: 309, height: 1)
        }
    }
}

#Preview {
    InputField(title: "아이디", prompt: "아이디를 입력하세요.", content: .constant(""))
}
