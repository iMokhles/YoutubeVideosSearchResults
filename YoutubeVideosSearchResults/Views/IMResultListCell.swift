//
//  IMResultListCell.swift
//  YoutubeVideosSearchResults
//
//  Created by iMokhles on 24/11/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct IMResultListCell: View {
    @ObservedObject var resultItem: IMResultItem
    
    var body: some View {
        WebImage(url: URL(string: resultItem.thumbUrl))
            // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
            .onSuccess { image, data, cacheType in
                // Success
                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
            }
            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
            // Supports ViewBuilder as well
            .placeholder {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .scaledToFit()
            .frame(width: 300, height: 300, alignment: .center)
    }
}

struct IMResultListCell_Previews: PreviewProvider {
    static var previews: some View {
        IMResultListCell(resultItem: IMResultItem(thumbUrl: ""))
    }
}
