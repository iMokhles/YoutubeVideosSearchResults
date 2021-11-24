//
//  IMResultList.swift
//  YoutubeVideosSearchResults
//
//  Created by iMokhles on 24/11/2021.
//

import SwiftUI

struct IMResultList: View {
    @Binding var results: [IMResultItem]
    
    var body: some View {
        List{
            ForEach(results) { item in
                            IMResultListCell(resultItem: item)
                        }
        }
    }
}

struct IMResultList_Previews: PreviewProvider {
    static var previews: some View {
        IMResultList(results: .constant([IMResultItem(thumbUrl: "")]))
    }
}
