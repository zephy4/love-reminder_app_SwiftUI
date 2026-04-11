//
//  QuoteWidgetBundle.swift
//  QuoteWidget
//
//  Created by Ismaeel Shahbaz on 3/9/26.
//

import WidgetKit
import SwiftUI

@main
struct QuoteWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuoteWidget()
        QuoteWidgetControl()
        QuoteWidgetLiveActivity()
    }
}
