//
//  CDYelpDeepLink.swift
//  CDYelpFusionKit
//
//  Created by Christopher de Haan on 11/8/17.
//
//  Copyright (c) 2016-2017 Christopher de Haan <contact@christopherdehaan.me>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

public class CDYelpDeepLink: NSObject {
    
    func isYelpInstalled() -> Bool {
        guard let url = URL(string: CDYelpURL.deepLink) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    func addScheme(toPath path: String) {
        if self.isYelpInstalled() {
            self.openYelp(withPath: "\(CDYelpURL.deepLink):///\(path)")
        } else {
            self.openYelp(withPath: "\(CDYelpURL.web)\(path)")
        }
    }
    
    func openYelp(withPath path: String) {
        if let url = URL(string: path) {
            UIApplication.shared.openURL(url)
        }
    }
    
    public func openYelp() {
        if self.isYelpInstalled() {
            self.openYelp(withPath: CDYelpURL.deepLink)
        } else {
            self.openYelp(withPath: CDYelpURL.web)
        }
    }
    
    public func openYelpToSearch(withTerm term: String?,
                                 category: CDYelpBusinessCategoryFilter?,
                                 location: String?) {
        var path = "search"
        
        if term != nil || category != nil || location != nil {
            path += "?"
        }
        
        if let term = term?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            path += "terms=\(term)"
        }
        
        if let _ = term,
            let category = category?.rawValue {
            path += "&category=\(category)"
        } else if let category = category {
            path += "category=\(category)"
        }
        
        if let _ = term,
            let location = location?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            path += "&location=\(location)"
        } else if let _ = category,
            let location = location {
            path += "&location=\(location)"
        } else if let location = location {
            path += "location=\(location)"
        }
        
        self.addScheme(toPath: path)
    }
    
    public func openYelpToBusiness(withid id: String!) {
        assert((id != nil && id != ""), "A business id is required to open Yelp to a specific business page.")
        
        var path = "biz/"
        
        if let id = id {
            path += "\(id)"
        }
        
        self.addScheme(toPath: path)
    }
    
    public func openYelpToCheckIns() {
        self.addScheme(toPath: "check_ins")
    }
    
    public func openYelpToNearbyCheckIns() {
        self.addScheme(toPath: "check_in/nearby")
    }
    
    public func openYelpToRankedCheckIns() {
        self.addScheme(toPath: "check_in/rankings")
    }
}