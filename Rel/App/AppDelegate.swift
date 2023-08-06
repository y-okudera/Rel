//
//  AppDelegate.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        print("HomeDirectory", NSHomeDirectory())
        dump(KeychainAccess.getAllKeyChainItemsOfClass(), name: "AllKeyChainItems")

        return true
    }
}
