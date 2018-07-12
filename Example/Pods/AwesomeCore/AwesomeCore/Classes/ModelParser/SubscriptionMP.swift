//
//  SubscriptionMP.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 11/09/2017.
//

import Foundation

struct SubscriptionMP {
    
    static func parseSubscriptionsFrom(_ subscriptionJSON: [String: AnyObject], key: String) -> [Subscription] {
        var subscriptions = [Subscription]()
        guard let subscriptionsJSON = subscriptionJSON[key] as? [[String: AnyObject]] else {
            return subscriptions
        }
        for subscriptionJSON in subscriptionsJSON {
            subscriptions.append(parseSubscriptionFrom(subscriptionJSON))
        }
        return subscriptions
    }
    
    static func parseSubscriptionFrom(_ subscriptionJSON: [String: AnyObject]) -> Subscription {
        return Subscription(
            academyId: AwesomeCoreParser.intValue(subscriptionJSON, key: "academy_id"),
            awcProductId: AwesomeCoreParser.stringValue(subscriptionJSON, key: "awc_product_id"),
            title: AwesomeCoreParser.stringValue(subscriptionJSON, key: "title"),
            themeColor: AwesomeCoreParser.stringValue(subscriptionJSON, key: "theme_color"),
            productUrl: AwesomeCoreParser.stringValue(subscriptionJSON, key: "product_url"),
            backgroundCover:AwesomeCoreParser.stringValue(subscriptionJSON, key: "background_cover"),
            coursesCovers: AwesomeCoreParser.stringValues(subscriptionJSON, key: "courses_covers"),
            courseUrls: AwesomeCoreParser.stringValues(subscriptionJSON, key: "courses_urls")
        )
    }
    
}
