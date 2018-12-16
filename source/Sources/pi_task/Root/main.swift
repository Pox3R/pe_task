import Foundation

do {
    let server = try ServerFactory.create(port: 80)
    print("Server started")
    server.start()
} catch let error as NSError {
    print(error.localizedDescription)
}
