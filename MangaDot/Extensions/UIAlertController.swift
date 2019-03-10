//
//  UIAlertController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 5/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit

extension UIAlertController {
    public struct MangaDot {
        public static func feedErrorAlert(of error: Error) -> UIAlertController {
            // Helpers
            let title: String
            let message: String

            if error._domain == NSURLErrorDomain {
                title = "Unable to Fetch Feed Data"
                message = "The application is unable to fetch manga data. Please make sure your device is connected over Wi-Fi or cellular."
            } else {
                switch (error) {
                case Mangadex.Errors.invalidHttpResponse:
                    title = "Received invalid response from Mangadex"
                    message = "Mangadex may be down/offline. Please try again later."
                case Mangadex.Errors.cloudflareProtection:
                    title = "Protected by CloudFlare"
                    message = "Mangadex may be under a DDOS attack. Please try again later."
                default:
                    title = "Unable to Parse Feed Data"
                    message = "The application is unable to process feed data. Please make sure the application is up to date, you can find the latest release on the App Store."
                }
                
            }

            // Initialize Alert Controller
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // Add Cancel Action
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            return alertController
        }
    }
}
