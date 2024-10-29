//
//  TacoTaco_iOSApp.swift
//  TacoTaco-iOS
//
//  Created by hyk on 10/28/24.
//

import SwiftUI

@main
struct TacoTaco_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Group {
                    if KeyChain.read() != nil {
                        HomeView()
                    } else {
                        SignInView()
                    }
                }
                .navigationBarBackButtonHidden()
            }
        }
    }
}
