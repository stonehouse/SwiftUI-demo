# SwiftUI Demo App 🥳

This is a demo app built using SwiftUI that works with the Public Transport Victoria (PTV) API. This is a demo both of building UI in SwiftUI as well as managing data flow with Combine. This repo is intended to serve as a playground for trying out SwiftUI.

#### Getting Started

This repo contains an Xcode project with some basic SwiftUI views that show PTV services, routes, stops and departure times, and yes, this is real data! Feel free to fork this repo, or download the zip to get started!

## Ideas
Not sure what you want to get started with? Here are some possible things you could look into:

##### SwiftUI Views
- Change the text styling (see [How to style text views with fonts, colors, line spacing & more](https://www.hackingwithswift.com/quick-start/swiftui/how-to-style-text-views-with-fonts-colors-line-spacing-and-more))
- Change a view with a `List` to use custom views in `ForEach` (see [How to create views in a loop using ForEach](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-views-in-a-loop-using-foreach))
- Add some images or icons (perhaps an icon to show the service type, see [SF Symbols](https://developer.apple.com/design/))
- Build some [ViewModifiers](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-custom-modifiers) for common UI styles
- Add loading state to each screen (the search screen especially)
- Add a `TabView ` that includes "Services" and "Search" (see [Adding TabView and tab item](https://www.hackingwithswift.com/quick-start/swiftui/adding-tabview-and-tabitem))
- Add a complex animation (see [Animating Views & Transitions](https://developer.apple.com/tutorials/swiftui/animating-views-and-transitions))
- Add an MKMapView to see PTV stops (see [Creating and combining views](https://developer.apple.com/tutorials/swiftui/creating-and-combining-views))
- Build a different layout for different size classes (see [How to create different layouts using size classes](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-different-layouts-using-size-classes))

##### Model
- Add the ability to favourite different routes or stops
- Improve the `Search` class to use complex Combine operators, i.e. throttle user input every 300 milliseconds
- Build a Core Data model which drives the views, and update the model when PTV content loads (see [How to configure Core Data to work with SwiftUI](https://www.hackingwithswift.com/quick-start/swiftui/how-to-configure-core-data-to-work-with-swiftui))

##### Watch App
WatchOS also supports SwiftUI, which could give you a lot more flexibility than the existing WatchKit API. See [Building watchOS App Interfaces with SwiftUI](https://developer.apple.com/documentation/watchkit/building_watchos_app_interfaces_with_swiftui)

## Notes
- To switch to fixture data, just change the `ptv` constant to `.fixtures` in `PTV.swift`
- To run the app on your device, open the project settings, go to "Signing & Capabilities", and in the "Team" drop down, select a valid team. If you are having trouble with this feel free to ask any of the hosts to help you out.

## Resources

#### SwiftUI

[Hacking with Swift - Get Started](https://www.hackingwithswift.com/quick-start/swiftui)

[Apple's SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui/tutorials)

[Ray Wenderlich Screencats](https://www.raywenderlich.com/ios/videos)

[WWDC 2019 Videos](https://developer.apple.com/videos/wwdc2019/)

#### Design

[SF Symbols](https://developer.apple.com/design/)

#### Combine

[Receiving and Handling Events with Combine](https://developer.apple.com/documentation/combine/receiving_and_handling_events_with_combine)

[SwiftUI Notes (Combine)](https://heckj.github.io/swiftui-notes/)

#### PTV

[PTV API Documentation](https://timetableapi.ptv.vic.gov.au/swagger/ui/index#!/Routes/Routes_OneOrMoreRoutes)

#### Take Home Resources

[Hacking with Swift - 100 Days of SwiftUI](https://www.hackingwithswift.com/100/swiftui)

[SwiftUI by Tutorials - Ray Wenderlich](https://store.raywenderlich.com/products/swiftui-by-tutorials)

[Combine: Asynchronous Programming with Swift - Ray Wenderlich](https://store.raywenderlich.com/products/combine-asynchronous-programming-with-swift)



