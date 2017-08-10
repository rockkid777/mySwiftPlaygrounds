/*:
# Inductive and Algebraic Data Types in Swift

 Ádám, Révész [@imind](http://imind.eu)
 
## Goals
 
 * Introduce some basic type theory to leverage the quality and safety of our programs
 * Show the ease of composing simple type constructions
 

## Types
 
 A type of an expression tells us the values it can hold and the operations
 we can do with it.
 
## Inductive Types

 All values of an inductive type can be created by composing it's constructors

 Some example for inductive types: Peano numbers (Natural), List, Binary Tree, Boolean, Optional

*/

enum Boolean {
    case trueB
    case falseB
}

func and(lhs: Boolean, rhs: Boolean) -> Boolean {
    switch (lhs, rhs) {
    case (.falseB, _), (_, .falseB):
        return .falseB
//    case (let x, _ ) where x == .false:
//        if ...
    default:
        return .trueB
    }
}


indirect enum Nat {
    case zero
    case suc(Nat)
}

func +(lhs: Nat, rhs: Nat) -> Nat {
    switch lhs {
    case .zero:
        return rhs
    case .suc(let x):
        return .suc(x + rhs)
    }
}

func show(_ num: Nat) -> String {
    switch num {
    case .zero:
        return ".zero"
    case .suc(let x):
        return ".suc(\(show(x)))"
    }
}

func >(lhs: Nat, rhs: Nat) -> Bool {
    switch (lhs, rhs) {
    case (.zero, .zero):
        return false
    case (.zero, .suc(_)):
//    case (.zero, _):
        return false
    case (.suc(_), .zero):
        return true
    case (.suc(let x), .suc(let y)):
        return (x > y)
    }
}

let a: Nat = .suc(.suc(.suc(.suc(.zero))))
let b: Nat = .zero
print(show(a))

print(show(b + a))


/*:
 
### Product Types
 
 t is product type of t' and t'' when it has t' and t'' at the same time
 
 t has only one constructor, where both t' and t'' have to be provided.
 
 t has two eliminator (proj' and proj'')
 
 
*/

struct Person {
    let name: String
    let age: Int
}

// Constructor usage

let p = Person(name: "Alaric", age: 42)

// Eliminators usage

let name = p.name
let age = p.age
/*:

 - Note: Since type theory is some kind of set theory (but it's not, see Russel-paradoxon) it can be used for logical computations
 \
 \
 A + B -> A or B
 \
 A * B -> A and B
 
*/
enum JValue {
    case bool(Bool)
    case num(Float)
    case string(String)
    case array([JValue])
    case object([(String, JValue)])
    case null
}

let ex: JValue = .object([
    ("isOk", .bool(true)),
    ("nr", .num(5)),
    ("friends", .array([.string("Aladar"), .string("Bela"), .string("Cecil")]))
    ])

func stringify(_ val: JValue) -> String {
    switch val {
    case .bool(let x) where x:
        return "true"
    case .bool(_):
        return "false"
    case .num(let x):
        return "\(x)"
    case .string(let x):
        return "\"\(x)\""
    case .array(let arr):
        let content: String = arr.reduce("", {(prev: String, elem: JValue) -> String in
            return prev + stringify(elem) + ","
        })
        return "[\(content)]"
    case .object(let dict):
        let content:String = dict.reduce("", {(prev: String, elem: (String, JValue)) -> String in
            let (name, val) = elem
            return prev + "\"\(name)\": " + stringify(val) + ","
        })
        return "{\(content)}"
    case .null:
        return "null"
    }
}


