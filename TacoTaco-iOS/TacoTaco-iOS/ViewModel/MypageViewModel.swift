//
//  MypageViewModel.swift
//  TacoTaco-iOS
//
//  Created by 김주환 on 11/11/24.
//

import Alamofire
import SwiftUI

class MypageViewModel: ObservableObject {
    @Published var user: MypageModel?
    
    func withDraw() {
        AF.request("\(Bundle.main.url)/user", method: .delete)
            .responseJSON { json in
                print(json)
            }
    }

    func fetchUserData() {
        guard let token = KeyChain.read()?.accessToken else {
            print("accessToken을 찾을 수 없습니다.")
            return
        }

        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request("\(Bundle.main.url)/user", method: .get, headers: headers).responseDecodable(of: MypageResponse.self) { response in
            switch response.result {
            case .success(let data):
                self.user = data.data
            case .failure(let error):
                print("Error fetching user data: \(error)")
            }
        }
    }
}
