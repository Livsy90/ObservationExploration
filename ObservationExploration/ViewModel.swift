import Foundation

@Observable
final class ViewModel {
    
    var observableProperty: String = "Hello, World!"
    
    @ObservationIgnored
    var observationIgnoredProperty: String = "Hello, World!"
    
    private var privateProperty: String = "Hello, World!"
    
}
