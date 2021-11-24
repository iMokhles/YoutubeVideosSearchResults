//
//  ContentView.swift
//  YoutubeVideosSearchResults
//
//  Created by iMokhles on 24/11/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var result: IMResult = IMResult()
    
    func fetchingData() {
        print("QUERY:: \(result.queryText)")
        result.fetchData();
    }
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("YouTube Seach").font(.system(size: 40, weight: .black, design: .rounded))
                }
                .padding()
                IMSearchBar(query: $result.queryText, onSubmit: {
                    self.fetchingData()
                })
                .padding(.top, -20)
                IMResultList(results: $result.results)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

