Swift’s new Observation framework simplifies the way we track state changes across models. By marking a class with @Observable, we automatically get publisher-like behavior for its properties without manually wiring up @Published. But what happens when the property is private? Does the compiler still generate the boilerplate code for observation? Let’s walk through how this can be verified.

```swift
import Foundation

@Observable
final class ViewModel {
    
    var observableProperty: String = "Hello, World!"
    
    @ObservationIgnored
    var observationIgnoredProperty: String = "Hello, World!"
    
    private var privateProperty: String = "Hello, World!"
    
}
```

## Inspecting the generated ViewModel.sil reveals the following:

* The class contains a hidden field called _$observationRegistrar of type ObservationRegistrar. This is the runtime piece responsible for managing observers.
* For observableProperty, the compiler generated getter, setter, and _modify methods that wrap reads and writes with calls to access(keyPath:) and withMutation(keyPath:_:). This ensures observers are notified on every access or mutation.
* For observationIgnoredProperty, those calls are absent. Accessors directly read and write the storage without involving the registrar.
* For privateProperty, despite being marked private, the compiler still generated the same access and mutation boilerplate as for public properties. The getter and setter both interact with the registrar, which means the property participates in observation just like any other.
