

func sayHi(times: Int, retThis: Int = 6)-> Int{
    for _ in 1...times{
        print("Hi")
    }
    
    return retThis+1
}

var ress = sayHi(times: 1)


func sayHi2(){
    print("second hi")
}

sayHi2



func add(num1: Int, num2: Int)-> Int{
     num1+num2
}
add(num1: 5, num2: 9)

func multiply(num1: Int, num2: Int)-> Int{
    return num1*num2
}

var ret = sayHi(times: 3, retThis: 5)

var myF = sayHi

myF = add

func applyFun(funToApply: (Int, Int)->Int, n1:Int, n2: Int){

    funToApply(n1, n2)
    
}

applyFun(funToApply: multiply, n1: 4, n2: 5)



print(ret)


func findBiggerAndSmaller(num1: Int,number2 num2: Int)->(Int, Int){
    
    if num1 < num2{
        return (num1,num2)
    }
    else{
        return (num2, num1)
    }
}

var retTuple = findBiggerAndSmaller(num1: 4, number2: 5)

print(retTuple.1)

var str = "5f"

if let num = Int(str){
    let rr = num+1
    print(rr)
}


func compare(_ str1: String,  str2: String){
    
}

var closure = { (str: Int) in
    
}




compare("s", str2: "k")

func takeTheSum(_ numbers: Int...){
    
    var sum = 0
    for n in numbers{
        sum += n
    }
    print(sum)
}

takeTheSum(1,2,3)







