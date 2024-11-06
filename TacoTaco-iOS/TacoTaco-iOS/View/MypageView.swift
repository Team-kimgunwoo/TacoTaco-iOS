//
//  MypageView.swift
//  TacoTaco-iOS
//
//  Created by 김주환 on 11/6/24.
//

import SwiftUI

struct MypageView: View {
    var body: some View {
        VStack {
            HStack(spacing:19) {
                Image("baseProfile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 79, height: 79)
                VStack(alignment: .leading) {
                    Text("환영합니다 !")
                        .font(.system(size: 20, weight: .bold))
                    Text("김주환님")
                        .font(.system(size: 17, weight: .light))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 49)
            Rectangle()
                .frame(width:500,height: 1)
                .padding(.bottom,108)
                .padding(.top, 37)
            Image("Tacos")
                .resizable()
                .scaledToFit()
                .frame(width: 164)
                .padding(.bottom, 33)
            Text("지금 건우의 위치를 확인하세요")
                .font(.system(size: 20, weight: .light))
                .padding(.bottom, 238)
            
            VStack(alignment: .leading) {
                Button {
                    
                } label: {
                    Text("개인정보 처리 방침")
                        .font(.system(size: 12, weight: .regular))
                }
                HStack {
                    Text("앱 버전")
                        .font(.system(size: 12, weight: .regular))
                    Text("1.0")
                        .font(.system(size: 12, weight: .regular))
                }
                Button {
                    
                } label: {
                    Text("회원탈퇴")
                        .font(.system(size: 12, weight: .regular))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 32)
        }
    }
}

#Preview {
    MypageView()
}
