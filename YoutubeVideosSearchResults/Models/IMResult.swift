//
//  IMResult.swift
//  YoutubeVideosSearchResults
//
//  Created by iMokhles on 24/11/2021.
//

import Foundation

class IMResultItem: ObservableObject, Identifiable {
    var id: String = UUID().uuidString
  var thumbUrl: String
  
    init(thumbUrl: String = "") {
    self.thumbUrl = thumbUrl
  }
}

class IMResult: ObservableObject {
    @Published var queryText: String = ""
    @Published var results: [IMResultItem] = []
    
    private let userAgent: String = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15"
    
    init(queryText: String = "", results: [IMResultItem] = []) {
      self.queryText = queryText
      self.results = results
    }
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            guard let result = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length)) else {
                return [] // pattern does not match the string
            }
            return (1 ..< result.numberOfRanges).map {
                nsString.substring(with: result.range(at: $0))
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchData() -> Void {
        let url = "https://www.youtube.com/results?search_query=\(queryText)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) {data,response,error in
            if let data = data {
               let contents = String(data: data, encoding: .utf8)
                
                let pattern = "ytInitialData[^{]*(.*?);*</script>"
                let regex = self.matchesForRegexInText(regex: pattern, text: contents!)
                let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: Data(regex[0].utf8), options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let content1 = jsonResult["contents"] as! NSDictionary;
                let twoColumnSearchResultsRenderer = content1["twoColumnSearchResultsRenderer"] as! NSDictionary;
                let primaryContents = twoColumnSearchResultsRenderer["primaryContents"] as! NSDictionary;
                let sectionListRenderer = primaryContents["sectionListRenderer"] as! NSDictionary;
                let contents2 = sectionListRenderer["contents"] as! NSArray;
                let itemSectionRenderer = contents2[0] as! NSDictionary;
                let contents3 = itemSectionRenderer["itemSectionRenderer"] as! NSDictionary;
                let contentsFinal = contents3["contents"] as! NSArray
                for resultItem in contentsFinal {
                    // Do this
                    let videoRenderer = (resultItem as! NSDictionary)["videoRenderer"]
                    if ((videoRenderer) != nil) {
                        let thumbnail = (videoRenderer as! NSDictionary)["thumbnail"]
                        let thumbnails = (thumbnail as! NSDictionary)["thumbnails"] as! NSArray
                        let bigThumb = thumbnails.lastObject;
                        let bigThumbUrl = (bigThumb as! NSDictionary)["url"];

                        let nResultItem = IMResultItem(thumbUrl: bigThumbUrl as! String);
                        self.results.append(nResultItem);
                    }

                }
                
                print(self.results)
            }
        }.resume()
    }
    
}

