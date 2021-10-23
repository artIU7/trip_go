//
//  AppDelegate.swift
//  trip_go
//
//  Created by Артем Стратиенко on 23.10.2021.
//

import UIKit
import NMAKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let credentials = (
                          appId: "KKo6UCgA4Z8alSgWjAkV",
                          appCode: "_tBymmu0CW1i3TvQgmz_hg",
                          licenseKey: "S80y37hYFoiBg+wqwxMgrpFnsjgyywCK9237Ae1gJbS+fyeQvGK02ulEsn4LbWWlSVmvcXwrLl32I19f+O0w3T6tEZkZw09WHA49IjqJ7fQdK0ZHeOED2VDNaIaB4gu3Kg2yS7u/QUpEcogentX3ehtBNymky6JZrm80kkAjK8OQJjAZ9Canp7qm+2gcYyo+J3btMFarpN7YZ2Xz3dfMIh16Gfuuqe31PStg0yvvCgm2NZvQQhb/prFQ46+OUj7AWQbTonN4pIbg301fpYSmbxN1KyieycDL8LN/puNSwIEsrH4EsjYO9cgip3xzPUh+PaIyBvkKA83bZbnuMH/ZKWtbxwA3h2UZH8MADxiM92urc6rXSzpD90sAGkqo6B3wqziOPAkjn7Ig/Zkoem03T4DybajNrE5/pmposs9TM9MiZk1PJNyCu46vnl1+Jvby/He9V3R1nXD+ftvAarYx1dKV7H9NGTk0eW8Ijx1TA6QctL93XwD+y75XR0d6d4lo8lRkzNdGEpshu4Z8ZBdVqNavEg62+FxxD9Cqk96eYkyJejQrPOfeNpdiARo7Ms3nF/PtYrmVra9NgyH398CjdrBe9FGTGYEs/0g5aeK08Zxj9UHCHXfbdorKqKF/pzDccXOIJqwDluzOOHNnLaZzlbh2Dvwlpv7f1sjVo+p4pjk="
                      )


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NMAApplicationContext.setAppId(credentials.appId,
                                       appCode: credentials.appCode,
                                       licenseKey: credentials.licenseKey)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

