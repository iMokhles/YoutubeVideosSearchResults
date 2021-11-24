//
//  IMSearchBar.swift
//  YoutubeVideosSearchResults
//
//  Created by iMokhles on 24/11/2021.
//

import SwiftUI

struct IMSearchBar: View {
    @Binding var query: String
    
    var onSubmit: () -> Void = { }
    var body: some View {
        HStack {
                    
            TextField("Search ...", text: $query, onCommit: onSubmit)
                        .keyboardType(.webSearch)
                        .padding(7)
                        .padding(.horizontal, 5)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                    
                }
    }
}

struct IMSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        IMSearchBar(query: .constant(""), onSubmit: {
            
        })
    }
}

