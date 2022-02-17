import UIKit

class Shape{
    
    var numberOfSides = 3
    var name: String = ""
    
    init(){
        
    }
    
    init(nameOfTheShape: String){
        name = nameOfTheShape
    }
    
    init(_ name: String, _ sideCount: Int){
        self.name = name
        numberOfSides = sideCount
    }
    
    
    func description(){
        print("I have \(numberOfSides) sides")
    }
}

var s = Shape()//(nameOfTheShape: "Some shape")
s.description()

var s2 = s

s.numberOfSides = 4

s2.description()

var newShape = Shape("hexagon", 6)

class Person{
    var name: String?
    var age: Int?
    
    init(){
        
    }
    
    init(name: String, age: Int){
        self.name = name
        self.age = age
    }
}

var p = Person(name: "Adam", age: 5)

if let n = p.name, let age = p.age{
    print("This is a real person with name \(n) and age \(age)")
}

class Student: Person{
    
    var school: String = "default"
    
    var ID: String{
        get{
            return self.name!+" "+school
        }
        set{
            let ind = newValue.firstIndex(of: " ")!
            self.name = String(newValue[..<ind])
            school = String(newValue[ind...])
       }
    }
    
    init?(school: String){
        if school.isEmpty{ return nil}
        self.school = school
        super.init()
    }
    
    override init(name: String, age: Int){
        school = "Not decided yet"
        super.init(name: name, age: age)
        
    }
    
    
    func printSchool(){
        print("I go to \(school)")
    }
}



var st = Student(name: "Eve", age: 30)

st.name
st.school

st.ID = "Mike GMU"

st.name
st.school


var st2 = Student(school: "VCU")

st2!.age

if let stt = st2{
    print(stt.age)
}







struct Size {
    var height: Int
    var depth: Int = 2
    var width: Int
}

var sz = Size(height: 5, width: 6)

sz.depth







