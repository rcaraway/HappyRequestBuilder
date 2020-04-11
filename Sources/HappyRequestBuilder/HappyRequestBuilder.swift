import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

public enum RequestParameters {
    case host(String)
    case scheme(String)
    case pathExtension(String)
    case path(String)
    case query(String, String)
    case queryItems([URLQueryItem])
    case header(String, String)
    case headers([String: String])
    case body(Data)
    case method(HTTPMethod)
}

open class RequestBuilder {
    var scheme = "https"
    var host: String = ""
    var pathExtension = ""
    var path = ""
    var queryItems = [URLQueryItem]()
    var headers = [String: String]()
    var method = HTTPMethod.get
    var body: Data?
    var timeout = 20.0
    var cachePolicy = URLRequest.CachePolicy.reloadRevalidatingCacheData
    
    static var defaultBuild: RequestBuilder = RequestBuilder()
    
    init() {}
    
    init(scheme: String,
         host: String,
         path: String,
         headers: [String: String],
         method: HTTPMethod,
         items: [URLQueryItem] = [URLQueryItem](),
         body: Data? = nil) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.headers = headers
        self.method = method
        self.body = body
    }
    
    @discardableResult
    func set(_ params: RequestParameters) -> RequestBuilder {
        switch params {
        case .scheme(let scheme):
            self.scheme = scheme
        case .host(let host):
            self.host = host
        case .path(let path):
            self.path = path
        case .query(let key, let value):
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        case .pathExtension(let string):
            pathExtension = string
        case .queryItems(let items):
            self.queryItems = items
        case .header(let key, let value):
            headers[key] = value
        case .headers(let headers):
            self.headers = headers
        case .method(let method):
            self.method = method
        case .body(let data):
            body = data
        }
        return RequestBuilder(scheme: scheme, host: host, path: path, headers: headers, method: method, items: queryItems, body: body)
    }
    
    func commitDefault() {
        RequestBuilder.defaultBuild = RequestBuilder(scheme: scheme,
                                                     host: host,
                                                     path: path,
                                                     headers: headers,
                                                     method: method,
                                                     body: body)
    }
    
    func build() -> URLRequest? {
        var components = URLComponents()
        components.host = host
        components.scheme = scheme
        components.path = "\(pathExtension)\(path)"
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10)
        request.httpMethod = method.rawValue
        for (_, value) in headers.enumerated() {
            request.addValue(value.value, forHTTPHeaderField: value.key)
        }
        request.httpBody = body
        return request
    }
}

public extension RequestBuilder {
    
    @discardableResult
    func addAuth(token: String) -> RequestBuilder {
        return set(.header("Authorization", "Bearer \(token)"))
    }
    
    @discardableResult
    func addCredentials(username: String, password: String) -> RequestBuilder {
        guard let credentialData = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else { return self }
        return set(.header("Authorization", "Basic \(credentialData)"))
    }
    
    @discardableResult
    func addJsonContentType() -> RequestBuilder {
        return set(.header("Content-Type", "application/json"))
    }
}

