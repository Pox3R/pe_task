//
//  ServerDefault.swift
//
//  Created by Eldar Goloviznin on 12/12/2018.
//

import Foundation
import Kitura

/// Class for handling HTTP POST requests.
final class ServerDefault: Server {
    
    // MARK: - Private properties
    
    /**
     Kitura.Router instance.
     
     - SeeAlso:
        [Kitura.Router](https://ibm-swift.github.io/Kitura/Classes/Router.html)
     */
    private let router = Router()
    
    /// Bound port
    private let port: Int
    
    // MARK: - Initializers
    
    /**
     This initializer does nothing but configure routes.
     Please use `ServerDefault.start()` to run your server.
     
     ### Usage Example: ###
     Initialize a `ServerDefault` instance.
     ```swift
     let server = ServerDefault(port: 80)
     server.start()
     ```
     ### Parameters:
        - `port`: An integer value corresponds to the port you are willing to bind.
     */
    init(port: Int) {
        self.port = port
        
        configureRouter()
        configureXMLAcceptRoute()
    }
    
    // MARK: - Public methods
    
    /**
     Use it to start the server. You can use it directly after creating `ServerDefault` instance.
     
     ### Usage Example: ###
     Initialize a `ServerDefault` instance and run it.
     ```swift
     let server = ServerDefault(port: 80)
     server.start()
     ```
     */
    func start() {
        Kitura.addHTTPServer(onPort: port, with: router)
        Kitura.run()
    }
    
    /// Use it to stop the server. Reasonable to call after `ServerDefault.start()`.
    func stop() {
        Kitura.stop()
    }
    
}

// MARK: - Private routes implementation

private extension ServerDefault {
    
    /**
     Used to make some preparaion:
     - adding [Kitura.BodyParser](https://github.com/IBM-Swift/Kitura/blob/master/Sources/Kitura/bodyParser/BodyParser.swift) for incoming POST requests
     */
    func configureRouter() {
        router.post(middleware: BodyParser())
    }
    
    /**
     Used to configure accept incomming POST on `/convert` requests with XML body.
     Response contains `200 - OK` code and YAML-formatted data if XML is valid. Otherwise, it returns `400 - Bad Request` code.
     
     ### Example: ###
     #### Request ####
     ```
     POST /
     ```
     Body:
     ```xml
     <person>
         <name>Eldar Goloviznin</name>
         <email>radleweird@gmail.com</email>
     </person>
     ```
     #### Response ####
     ```
     Status: 200 - OK
     ```
     Body:
     ```yaml
     person:
      email: radleweird@gmail.com
      name: Eldar Goloviznin
     ```
    */
    func configureXMLAcceptRoute() {
        router.post("/convert") { request, response, next in
            defer {
                next()
            }
            
            guard let body = request.body?.asRaw, let xmlString = String(data: body, encoding: .utf8) else {
                response.status(.badRequest)
                return
            }
            
            var yaml: String
            do {
                yaml = try XMLToYAMLConverter.convertToYAML(fromXML: xmlString)
            } catch _ {
                response.status(.badRequest)
                return
            }
            
            response.send(yaml)
        }
    }
    
}
