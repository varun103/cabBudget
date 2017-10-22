//
//  HttpClient.swift
//  cabBudget
//
//  Created by Varun Ajmera on 9/19/17.
//  Copyright © 2017 Varun Ajmera. All rights reserved.
//
import Foundation

/// Make Http Requests
protocol HttpClient {
    
    /// Executes a GET Request
    /// Method creates a separate task which executes the request. The completion handler takes two arguments
    /// HttpResponse which is returned if the request is executed successfully
    /// HttpError if the request fails for any reason
    ///
    /// - Parameters:
    ///   - url: url of the request
    ///   - headers: request headers
    ///   - completion: completion handler
    func get(url:String, headers:[String:String], completion: @escaping (HttpResponse?, HttpError?) -> Void)
    
    /// Executes a POST Request
    /// Method creates a separate task which executes the request. The completion handler takes two arguments
    /// HttpResponse which is returned if the request is executed successfully
    /// HttpError if the request fails for any reason
    ///
    /// - Parameters:
    ///   - url: url of the request
    ///   - headers: request headers
    ///   - body: request body
    ///   - completion: completion handler
    func post(url:String, headers:[String:String], body: Data, completion: @escaping (HttpResponse?, HttpError?) -> Void)
}

/// Http Response
struct HttpResponse {
    /// Http Status Code
    let status: Int
    /// Json Response body
    let responseBody: [String: Any]?
}

/// Http Error
struct HttpError {
    /// Error Code
    let status: Int
    /// Error Message
    let message: String
}

// Initialize http-error
extension HttpError {
    init(status:Int, message:[String:Any]?) {
        self.status = status
        self.message = message?.description ?? "No error message found"
    }
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
}

/// Implementation
class HttpClientImpl: HttpClient {
    
    private var session:URLSession
    private let errorCode = -1
    private let noResponse = ["error":"no data in response"]
    
    init(){
        self.session = URLSession(configuration: .default)
    }
    
    public func get(url:String, headers:[String:String], completion: @escaping (HttpResponse?, HttpError?) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HttpMethod.GET.rawValue
        request.allHTTPHeaderFields = headers
        
        self.executeRequest(request: request) { httpResponse, error in
            completion(httpResponse, error)
        }
    }
    
    public func post(url:String, headers:[String:String], body: Data, completion: @escaping (HttpResponse?, HttpError?) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HttpMethod.POST.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        self.executeRequest(request: request) { httpResponse, error in
            completion(httpResponse, error)
        }
    }
    
    private func executeRequest(request:URLRequest, completion: @escaping (HttpResponse?, HttpError?) -> Void ) {
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            var httpError: HttpError?
            var httpResponseBody:[String:Any]?
            
            // If http request fails return an error
            if (error != nil) {
                httpError = HttpError(status: -1, message: error.debugDescription)
                completion(nil, httpError)
            }
                
            // If no data in response return an error
            else if (data == nil) {
                httpError = HttpError(status: -1, message: "No data in response")
                completion(nil, httpError)
            }
                
            else {
                httpResponseBody = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                
                if let httpStatus = (response as? HTTPURLResponse)?.statusCode {
                    if (httpStatus < 200 || httpStatus >= 400) {
                        completion(nil, HttpError(status: httpStatus, message: httpResponseBody))
                    } else {
                        completion(HttpResponse(status: httpStatus, responseBody: httpResponseBody), nil)
                    }
                }
            }
        }
        task.resume()
    }
}

