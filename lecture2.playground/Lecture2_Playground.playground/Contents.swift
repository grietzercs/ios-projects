

var x = 4.0

let y = 5

print(x, y, separator: "--", terminator: "p")


var sum = Int(x) + y

print(x)

var str = "Hello class"

var sInd = str.startIndex
var eInd = str.endIndex

var anotherInd = str.index(eInd, offsetBy: -3)

var substr = str[sInd..<anotherInd]

str = "Hello today"

print(substr)

var num = "six"
var intNum = Int(num)

var out = intNum ?? 5


if let intNum = Int(num){
    
    print(intNum)
}

x += 1 // no ++

print(x)

-9 % 4


var s1 = "short"
var s2 = s1

s1 = "longerrrrr"

print(s2)

var myT = (5, 9)
var myT2 = (6, 8)

if myT < myT2 {
    print("yes")
}


1...5

s1[..<s1.endIndex]

var arr = Array<String>()

var items = ["Milk" ,"lettuce", "apple", "bread"]

items.count

items[1..<3] = ["doordash"]

var mySet: Set<String> = ["Milk" ,"lettuce", "apple", "bread"]

for e in mySet {
    print(e)

}

for _ in 1...5
{
    print("item")
}

for i in stride(from: 1, to: 7, by: 3){
    print(i)
}



















