//
//  EmotionModel.swift
//  TacoTaco-iOS
//
//  Created by hyk on 11/20/24.
//

import Foundation

struct EmotionModel: Codable {
    var status: Int = 0
    var message: String = ""
    var data: EmotionData = EmotionData()
}

struct EmotionData: Codable {
    var emotionType: String = ""
    var modifiedDate: String?
}
