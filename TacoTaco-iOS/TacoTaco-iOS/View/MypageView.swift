//
//  MypageView.swift
//  TacoTaco-iOS
//
//  Created by 김주환 on 11/6/24.
//

import SwiftUI

struct MypageView: View {
    var body: some View {
        VStack(spacing:146) {
            HStack(spacing:13) {
                Image("myprofile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 73, height: 73)
                VStack(alignment: .leading, spacing: 6) {
                    Text("환영합니다, 김주환님")
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundColor(.accent)
                    Text("bibiga@dgsw.hs.kr")
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 36)
            Image("Tacos")
                .resizable()
                .scaledToFit()
                .frame(width: 159)
            VStack(alignment: .leading, spacing: 8) {
                Button {
                    
                } label: {
                    Text("개인정보 처리 방침")
                        .font(.system(size: 19, weight: .regular))
                        .foregroundColor(.black)
                }
                HStack {
                    Text("앱 버전")
                        .font(.system(size: 19, weight: .regular))
                    Text("1.0")
                        .font(.system(size: 19, weight: .regular))
                }
                Button {
                    
                } label: {
                    Text("회원탈퇴")
                        .font(.system(size: 19, weight: .regular))
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 36)
        }
        .padding(.vertical, 50)
        .cornerRadius(30)
    }
}

#Preview {
    MypageView()
}
