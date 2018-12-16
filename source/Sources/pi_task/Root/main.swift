import Foundation

print("HIIIIIIIII")

do {
    let server = try ServerFactory.create(port: 80)
    server.start()
} catch let error as NSError {
    print(error.localizedDescription)
}
