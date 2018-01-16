## Swift - the reconciliation of simplicity and complexity
### This is my (Adalbert Hermann) web page about Swift 4, although experimental but useful for the programmer's reader.


Swift 4 hasn't got incrementation (++) and decrementation (--) operator but you can define these operators

```swift
postfix func ++ (value: Int) -> Int {
    return value + 1
}
var v = 4
print( v++ ) // shows 5
```

How to define the mathematical divisibility operator?

```swift
func || (lhs: Int, rhs: Int) -> Bool {
    return rhs % lhs == 0 ? true : false
}
print( 3 || 12 ) // shows true because exist integer number k which satisfies condition: 3 * k = 12.
                 // This number is 4 but the value is irrelevant information.
```

Some operators are better defined as classic functions e.g. Knuth's up-arrow

```swift
func arrow(_ a: UInt64, _ n: UInt64, _ b: UInt64) -> UInt64 {
    if n == 0 { return a * b }
    if b == 0, n >= 1 { return 1 }
    return arrow(a, n - 1, arrow(a, n, (b - 1)))
}
print(arrow(2, 3, 3)) // shows 65536
```

Swift includes many mathematical abstractions e.g. you can define functions whose arguments
are functions i.e. treating the function as an element of some set.

I love this funny-crazy construction

```swift
func say() -> String {
    return "Hello "
}

class Greet {
    private let g:(() -> String) -> String = { f in return f() + "Adal" }
    var h: String { get { return g(say) } }
}

let me = Greet()
print(me.h) // shows Hello Adal
```

say() it's function without arguments (zero-argument constant function)
Private constant g is really function defined by Closure construct.
Variable h is lazy - computed only when is needed.

There is more complicated version:

```swift
func sayAtBegin() -> String {
    return "Hello "
}

func sayAtEnd() -> String {
    return "Bye "
}

class Greet {
    private var name: String
    private var stageOfLife: () -> String

    init(_ name: String, _ stageOfLife: @escaping () -> String) {
        self.name = name
        self.stageOfLife = stageOfLife
    }

    private let g:(() -> String, String) -> String = {
                                                       f, somebody in return f() + somebody
                                                     }
    var h: String {
                    get {
                          return g(stageOfLife, name)
                        }
                  }
}

var me = Greet("Adal", sayAtBegin)
print(me.h) // shows Hello Adal
me = Greet("Adal", sayAtEnd)
print(me.h) // shows Bye Adal
```
_______________________________________________________________________________________

We can attach our functionality to objects by extension mechanism even embedded ones.
Fast check if Int number is odd or even:

```swift
extension Int {
    var isOdd: Bool {
        get {
            return self % 2 != 0 ? true : false
        }
    }
    var isEven: Bool {
        get {
            return !self.isOdd
        }
    }
}

let n = 7
print(n.isOdd, n.isEven, separator: "\n")
```
_________________________________________________________________________________

We can create more flexible function with general arguments types and result type

```swift
func sgn<T>(_ x: T) -> Int
    where T: Comparable,
          T: SignedNumeric
{
    return x > 0 ?  1:
           x < 0 ? -1:
                    0
}

let u: Float80 = -9.3
let v: Int8 = 4
print(sgn(u), sgn(v), sgn(0))
print([-1, 0, 1].map { sgn($0) })
```
here, the general type is limited by conditions: variables should be comparable and have sign.
This conditions are delivered by embeded protocols Comparable and SignedNumeric.
__________________________________________________________________________


In this more complicated example is defined function composition for different domains.

```swift
infix operator • //press option 8
func • <T,U,V> (g:@escaping (U) -> V, f:@escaping (T) -> U) -> (T) -> V {
    let h: (T) -> V = { x in return g(f(x)) }
    return h
}

func fraction(_ n: (Int, Int)) -> Float {
    return Float(n.0) / Float(n.1)
}

func entier(_ x: Float) -> Int {
    return Int(x)
}

let num = (7,3)
let foo = entier • fraction
print(foo(num)) // shows 2
```
______________________________________________________________________________


Function could has non definite amount of arguments

```swift
func countdown(_ num: Int ... ) -> String {
    if num == [10,9,8,7,6,5,4,3,2,1] {
        return "Start! Go to Mars!"
    } else {
        return "Alarm! Evacuation!"
    }
}

print(countdown(10,9,8,6,5,7))
print(countdown(10,9,8,7,6,5,4,3,2,1))
```
________________________________________________________________________


Singleton

```swift
class A {
    static let a = A()

    init() {
        print("I'm initialized)
    }

    func f() {
        print("I'm doing something")
    }
}

A.a.f()
let b = A()
b.f()
```
______________________________________________________________________________

More complicated example of singleton
This (Flip-Flop function) object remembers its state

```swift
class Say {
    private static var text: String = "unknown"
    static let greet = Say()

    func person(_ name: String = Say.text) {
        Say.text = name
        print("Hello \(Say.text)")
    }
}

Say.greet.person()
Say.greet.person("Adal")
Say.greet.person()
Say.greet.person("Gala")
Say.greet.person()
Say.greet.person()

The program prints

Hello unknown
Hello Adal
Hello Adal
Hello Gala
Hello Gala
Hello Gala
```
