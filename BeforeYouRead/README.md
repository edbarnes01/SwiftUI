# Before You Read

To understand how I go about things, it's important to read this.

## Project Practices 

- [File Structure](#file-structure)
- [Service](#service)

## File Structure

It’s taken me a while to work out the best file structure when using Swift and specifically SwiftUI. Thanks to the newest SwiftUI life cycle, that has become an easier task for me. I’ve been shown many different directions to go down, especially in other languages. My friend Guy for example, was very specific in how he thought things should be laid out and I’ve learned a lot from him in terms of being pro active with making your own life easier when coding. Organisation takes a bit of time but will sae you countless hours (when added up) down the line!

*(With this in mind, and using the newest SwiftUI life cycle)*


In a new app, you are given the main app file which will be <YourAppName>App.swift and then a ContentView.swift. I leave the main app file alone at the start and delete ContentView, which I exchange for a new SwiftUI file called “Container”. Content View has been used for ages with swift but I prefer to think of our first view as a container, as it will contain the rest of our app. A simple rename but just it’s simply personal preference. And if you choose to do this, don’t forget to change the line inside your app struct in <YourAppName>App.swift that declares ContentView() and change it to Container(). 

My container will generally contain things such as login logic. It’s the first port of call where the app will have some functionality. It’s also useful if your app will have a persistent menu button, for example, which you’ll be able to create using a ZStack in the container.

The next view I like to have in the flow is called “Main”. This is called directly from Container and is used to house all the content. If you were doing a tabbed application such as one in [this](https://github.com/edbarnes01/SwiftUI/tree/main/Walkthroughs/CustomTabs) walkthrough, this is where you would have your view logic, possibly in the form of a switch statement.

It’s important that you feel organised with your file layout, and group files when possible to avoid long lists where things can get complicated when trying to find some specific code. I have and probably will continue to be guilty of this in the future but I do always think about it - and that’s what counts, eh!

## Service

This is the single most important thing I use in my apps. If we were to pretend the app we’re making was a person, a “Service” would be like a PA. It can store, fetch, run functions and generally be a service to all views that require it. 

The way I format my “service” (that name is not my idea btw, creds to whoever inspired that one) is as a class that conforms to an Observable Object. Apologies if you’re familiar to what this is but it’s important to explain. There are two very powerful protocols in Swift that you need to know about. Observable and Environment! If an object conforms to and is declared to be one of these two, any views that subscribe to them will receive and update from their information - in realtime! There are occasions that observable objects should be used - mainly for variables that we want to update and provide updates locally (within one or two views). This can be a great solution. But for our “service”, we could potentially have A LOT of data inside and therefore it starts to get very expensive in terms of memory and performance when copies of the object are being passed around different objects. This is where lovely lovely environment objects come in!

An environment object is not copied between views but is rather stored as a global object that can be accessed from any view that is passed its reference. This makes it a very useful tool when we want to store whole app information that needs to be accessed from very remote crevices of our app. 

You will see me using this tool all throughout my blog so it’s good to know how it works!

A quick example:

Create a new swift file and name it “Service”. Then let’s define a new class “Service” and make it conform to the ObservableObject protocol.

``` swift
class Service: ObservableObject {

}
```

In your main app file, create a variable which will store an instance of the Service! 

``` swift
var service = Service()
```

That’s our service created, now let’s pass it to our Container or whatever you have decided to name your primary view:

``` swift
var service = Service()
var body: some Scene {
    WindowGroup {
        Container().environmentObject(service)
    }
}
```

And then to access your service, you just need to add it as a variable in whichever view you’d like to access the service. I’ll add mine in Container:

``` swift 
struct Container: View {
    @EnvironmentObject var service: Service
    var body: some View {
        MainView()
    }
}
```

Now, in order to declare variables inside your service for other views to receive updates on, you will need to use certain wrappers, which I explain here. This is very important.

There ya go! Access to your service and whatever you may decide to put in there! Have a look at some of my other posts to see just how useful this can be! 
