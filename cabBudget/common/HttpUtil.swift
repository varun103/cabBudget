//
//  HttpUtil.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/17/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//


/// Return a url with query parameters
///
/// - Parameters:
///   - url: base url
///   - parameters: parameters to be added
func addQueryParams(url:String, parameters:[String:String]) -> String {
    return url + "?" + urlEncode(parameters: parameters)
}

/// Takes in the param string of a url - everthing after the "?"
/// and converts them to a map
func extractParams(paramString: String) -> [String:String] {
    var params:[String:String] = [:]
    
    let _paramList = paramString.components(separatedBy: "&")
    
    _paramList.forEach() { param in
        let _param = param.components(separatedBy: "=")
        params[_param[0]] = _param[1]
    }
    return params
}

/// - Returns: the basic Auth header value
///   something like Basic <encoded credentials>
func basicAuthHeader(username:String, password:String) -> String {
    return ("Basic " + base64Encoded(string: username + ":" + password) )
}

/// Base 64 encoded string
///
/// - Parameter string: the string to be encoded
/// - Returns: the encoded string
func base64Encoded(string:String)-> String {
    let data = string.data(using: String.Encoding.utf8)
    let base64 = data?.base64EncodedString()
    return base64 ?? ""
}

private func urlEncode(parameters:[String:String]) -> String {
    var paramList: [String] = []
    parameters.forEach { (key,value) in
        paramList.append(key + "=" + value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
    }
    return paramList.joined(separator: "&")
}

