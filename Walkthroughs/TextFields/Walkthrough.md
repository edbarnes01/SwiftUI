# Text Fields

Hi all! In this walkthrough I’ll be showcasing some simple text fields and how to use them! For this example, I will be creating a simple login page. 

* [Preview](#preview)
* [Setup](#setup)
* [TextField Bindings](#textfield-bindings)
* [Custom Alert](#custom-alert)

## Preview


## Setup

If you know how I like to set up my projects then you'll be familiar with these file names. If not, maybe check [this](https://github.com/edbarnes01/SwiftUI/tree/main/BeforeYouRead#file-structure) out.

These are the files you're going to need and which option you should choose for each:

- Container (SwiftUI)
- Login     (SwiftUI)
- Main      (SwiftUI)
- Service   (Swift)
- Themes    (Swift)

### Service

Let's set up our service. We'll create 3 variables:
``` swift 
class Service: ObservableObject {
    @Published private(set) var loggedIn = false
    var testEmail = "ed@test.com"
    var testPassword = "password"
}
```
We have our ```loggedIn``` variable which we will change when there is a successful login. Note - I would typically put this inside a ```User()``` object but to simplify, I'm using a standalone variable and wrapping it in ```private(set)``` so it can only be modified from within the service. Also I've created some credentials for testing.

Before we add some functions, in the same file, just above our ```Service``` class, let's create a new enum:

``` swift 
enum LoginError: String {
    case wrongFields = "One or more fields was incorrect. Please try again."
}
```

This is a simple enum in which the cases have a raw value, which will be a description of a particular login error.

So we also need two functions for our basic functionality within the service - login and logout! Here they are:

``` swift
class Service: ObservableObject {
    @Published private(set) var loggedIn = false
    var testEmail = "ed@test.com"
    var testPassword = "password"
    
    func login(email: String, password: String, failure: @escaping (LoginError?) -> Void) {
        // You would send a request to your backend here
        // but in the meantime:
        if email == testEmail && password == testPassword {
            self.loggedIn = true
        } else {
            failure(.wrongFields)
        }
    }
    
    func logOut() {
        self.loggedIn = false
    }
}
```

The ```logOut()``` function is fairly self explanatory! The ```login```, slightly more advanced. It takes 3 arguments, an email, a password and then an escaping closure. This is a function that will be passed to the function and will be called when we write ```failure()```. This is useful in our situation because we want an alert to appear when the user gets their credentials wrong. The service won't have a reference of our alert, so we can send the alert trigger to our login function so it can be called and thus shown whenever the credentials are wrong. I hope this makes sense! In our case, we (might - hence the optional -> "?") pass the closure a ```LoginError``` of which we've only got ```wrongFields``` at the moment. 

And so, within this function, we check that the credentials they have entered are equal to our test ones, and if not, we call our escaping function and run whatever code has been passed.

Glad that's done! Let's move on.

### Page Logic
Our page logic will be dependant on our ```loggedIn``` value within our service. Let's open up ```Container.swift```. Make sure you define the service and then we'll create a switch statement to show the correct page:

``` swift
struct Container: View {
    @EnvironmentObject var service: Service
    
    var body: some View {
        switch self.service.loggedIn {
        case true:
            Main().environmentObject(service)
        case false:
            Login().environmentObject(service)
        }
        
    }
}
```
Awesome!

### Modifiers

Next we're gonna make some ```ViewModifiers``` which are some clever pieces of code we can run views through and apply affects to them. These are extremely useful for creating themes and using them throughout your app. Make sure to import SwiftUI and then let's make 3 modifiers:

``` swift 
import SwiftUI

struct CustomTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .autocapitalization(.none)
            .foregroundColor(.black)
            .padding(10)
            .frame(width: UIScreen.main.bounds.width / 5 * 3)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .clipped()
            .shadow(color: .white, radius: 2)
    }
}

struct CustomButton: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color == .white ? Color.black : .white )
            .padding(10)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .clipped()
    }
}

struct BackgroundGradient: ViewModifier {
    func body(content: Content) -> some View {
        content
        .background(
            LinearGradient(gradient: Gradient(colors: [.yellow, .purple, .yellow, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
    }
}

```

Now, these modifiers' styles are just what I thought looked okay. Please feel free to mess around and create your own! In general, modifiers are passed some content (a ```View``` for a ```ViewModifier```) into a body function which returns the altered View (the ```return``` keyword is assumed, and therefore not needed in this function). As you can see in the ```CustomButton``` modifier, variables (```color``` in this case) can also be passed in order to add some properties that can be controlled wherever the modifier is applied. 

Another thing I'd like to point out is the use of ```.autocapitalization(.none)``` which for me, is so helpful. ***IT REALLY FRUSTRATES ME WHEN APPS DON'T HAVE AUTOCAPITALIZATION SET TO NONE BECAUSE A LOT OF EMAILS START WITH A LOWERCASE LETTER.***

Rant over! I digress and we move on...

## TextField Bindings

Open up ```Login.swift``` and let's create our login page. We'll need some variables:

``` swift 
struct Login: View {
    @EnvironmentObject var service: Service
    @State var email = ""
    @State var password = ""
    @State var showAlert = false
    @State var alertText = ""

    var body: some View {
        Text("Hello World!")
    }
}
```

Our ```showAlert``` will control wether our alert is shown and the ```alertText``` will be the error message for the user. 
We're going to create our TextFields now but we need some bindings for the text. Inside ```body```, create the following:

``` swift 
struct Login: View {
    @EnvironmentObject var service: Service
    @State var email = ""
    @State var password = ""
    @State var showAlert = false
    @State var alertText = ""

    var body: some View {
        let emailBind = Binding(
            get: {self.email},
            set: {self.email = $0}
        )
        let passwordBind = Binding(
            get: {self.password},
            set: {self.password = $0}
        )
    ...
```
Our custom bindings have two functions, a ```get``` and a ```set```, which define how our text value is grabbed and set. Within these functions, you could add things to process the new value, for example - adding ```.prefix(8)``` to the set would limit the characters of the new value to the first 8. 

Now let's make our login UI:

``` swift
VStack(spacing: 20) {
    Spacer()

    Text("BEST APP")
        .font(.system(size: 40))
        .fontWeight(.heavy)
        .foregroundColor(.white)
        .padding()
        .clipped()

    TextField("Email", text: emailBind)
        .modifier(CustomTextField())

    SecureField("Password", text: passwordBind)
        .modifier(CustomTextField())

    Text("Login")
        .fontWeight(.bold)
        .modifier(CustomButton(color: fieldsValid() ? .blue : .gray))
        .shadow(color: .white, radius: 2)
        .padding(.top, 20)
        .disabled(!fieldsValid())

    Spacer()
}
.frame(width: UIScreen.main.bounds.width)
.background(
    EmptyView()
        .modifier(BackgroundGradient())
        .blur(radius: 20)
)
.edgesIgnoringSafeArea(.all)
```

So as you can see, we've got a title, a text field for the email and a secure text field for the password. A secure text field uses the black dots that you see in most password fields. When defining a TextField in this way, the first parameter is the placeholder text. These both have our modifier we made in [setup](https://github.com/edbarnes01/SwiftUI/blob/main/Walkthroughs/TextFields/Walkthrough.md#modifiers) applied to them. Last of all we have our login button which is currently some text before we add a tap gesture in a minute. 

Your XCode is probably screaming at you because it doesn't know what ```fieldsValid()``` means so let's go ahead and create that function shall we! We'll use it to check wether the user can login or not (check the fields aren't empty). 

Underneath the body, create a new function that simply returns wether the email and password variables are empty:
``` swift 
func fieldsValid() -> Bool {
    return (self.email != "" && self.password != "")
}
```
Now XCode should have stopped moaning...

## Custom Alert

SwiftUI has an api for an alert but I find it easier to create my own most of the time. In order to do this, we need to wrap our body in a ZStack and then show our alert on-top when we want to. Let's create our alert as a separate view:

``` swift 
struct Alert: View {
    var text: String
    var close: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text(text)
            Text("Close")
                .modifier(CustomButton(color: .red))
                .onTapGesture {
                    self.close()
                }
        }
        .frame(width: UIScreen.main.bounds.width * 2 / 3)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .clipped()
        .shadow(color: .white, radius: 3)
    }
}
```

So we've got two variables, the text for our alert and then a function called close, which will just be changing ```showAlert``` to false. In a VStack, we have our text and a dismiss button. Simples!

Back in ```Login```, let's make a function that changes our alert text and then shows the alert:

``` swift 
...

func fieldsValid() -> Bool {
    return (self.email != "" && self.password != "")
}

func showAlert(_ message: LoginError) {
    self.alertText = message.rawValue
    self.showAlert = true
}

```
This function takes a parameter ```message``` of a LoginError type and makes the ```alertText``` variable it's raw value (the error description), then shows the alert.

Next we need to actually add our new Alert view in. Let's make the ZStack and add our view in:

``` swift 
var body: some View {
    let emailBind = Binding(
        get: {self.email},
        set: {self.email = $0}
    )
    let passwordBind = Binding(
        get: {self.password},
        set: {self.password = $0}
    )

    ZStack {
        VStack(spacing: 20) {
            Spacer()

            Text("BEST APP")
                .font(.system(size: 40))
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding()
                .clipped()

            TextField("Email", text: emailBind)
                .modifier(CustomTextField())

            SecureField("Password", text: passwordBind)
                .modifier(CustomTextField())

            Text("Login")
                .fontWeight(.bold)
                .modifier(CustomButton(color: fieldsValid() ? .blue : .gray))
                .shadow(color: .white, radius: 2)
                .padding(.top, 20)
                .disabled(!fieldsValid())

            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(
            EmptyView()
                .modifier(BackgroundGradient())
                .blur(radius: 20)
        )
        .edgesIgnoringSafeArea(.all)
        .disabled(self.showAlert)
        .blur(radius: self.showAlert ? 2 : 0)

        if showAlert {
            Alert(text: self.alertText, close: {self.showAlert = false})
        }
    }
}
```
 As you can see, after the main VStack and within the ZStack, we've added our ```Alert``` view if showAlert is true. All that's left to do now is add our login function to the login button:
 
 ``` swift 
 Text("Login")
    .fontWeight(.bold)
    .modifier(CustomButton(color: fieldsValid() ? .blue : .gray))
    .shadow(color: .white, radius: 2)
    .padding(.top, 20)
    .onTapGesture {
        self.service.login(email: self.email, password: self.password) { fail in
            if (fail != nil) {
                self.showAlert(fail!)
            }
        }
    }
    .disabled(!fieldsValid())
```
So remember the function ```failure``` in our login [function](https://github.com/edbarnes01/SwiftUI/blob/main/Walkthroughs/TextFields/Walkthrough.md#service)? Well here we are defining that function we pass using a trailing closure. If you also remember, that function was to be passed A ```LoginError?``` and the way we access that is by saying ```fail in``` at the start of our closure. Now we have to check that there was indeed an error, and if so, call our ```showAlert``` function!

So there we have it! Hope you've enjoyed this Walkthrough and as always, please feel free to leave some feedback or serious criticism and I'll be happy to reply or amend. Please also check out some of my other Walkthroughs if you had a blast!
