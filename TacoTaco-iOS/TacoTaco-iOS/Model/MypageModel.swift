//
//  MypageModel.swift
//  TacoTaco-iOS
//
//  Created by 김주환 on 11/11/24.
//

import Foundation

struct MypageResponse: Codable {
    let status: Int
    let message: String
    let data: MypageModel
}

struct MypageModel: Codable {
    let email: String?
    let name: String
}
