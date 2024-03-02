//1.Реализовать структуру IOSCollection и создать в ней copy on write
struct Identifier {
    var id = 1
}

class Ref<T> {
    var value: T
    init(value: T) {
        self.value = value
    }
}

struct IOSCollection<T> {
  var ref: Ref<T>
  init(value: T) {
    self.ref = Ref(value: value)
  }
    
  var value: T {
    get {
          ref.value
        }
    set {
          guard isKnownUniquelyReferenced(&ref) else {
              ref = Ref(value: newValue)
              return
          }
          ref.value = newValue
        }
  }
}

var id = Identifier()
var collection1 = IOSCollection(value: id)
var collection2 = collection1

func address<T>(off object: T) {
    print(Unmanaged.passUnretained(object as AnyObject).toOpaque())
}

print("Исходные ссылки:")
address(off: collection1.ref)
address(off: collection2.ref)

collection1.value.id = 3

print("Изменение ссылки коллекции 1:")
address(off: collection1.ref)
address(off: collection2.ref)

//2. Создать протокол *Hotel* с инициализатором, который принимает roomCount, после создать class HotelAlfa добавить свойство roomCount и подписаться на этот протокол
protocol Hotel {
    init(roomCount: Int)
    func info()
}

class HotelAlfa: Hotel {
    var roomCount: Int
    
    required init(roomCount: Int) {
        self.roomCount = roomCount
    }
    
    func info() {
        print("Количество комнат в Hotel Alfa: \(roomCount)")
    }
}

let hotelInstance = HotelAlfa(roomCount: 120)
hotelInstance.info()

//3. Создать protocol GameDice, создать у него {get} свойство numberDice и расширить Int
protocol GameDice {
    var numberDice: Int { get }
}

extension Int: GameDice {
    var numberDice: Int {
        return self
    }
}

let diceCoub = 4
print("Выпало \(diceCoub.numberDice) на кубике")

//4. Создать протокол с одним методом и 2 свойствами одно из них сделать явно optional, 
// создать класс, подписать на протокол и реализовать только 1 обязательное свойство

protocol MyProtocol {
    func message()
    var requiredProperty: String { get }
    var optionalProperty: Int? { get set }
}


class MyClass: MyProtocol {
    var requiredProperty: String = "Обязательное свойство" 
    var optionalProperty: Int? 
    
    func message() {
        print("Метод класса вызван")
    }
}


let myObject = MyClass()
myObject.message() 
print("myObject.requiredProperty: ", myObject.requiredProperty) 
// print("myObject.optionalProperty: ", myObject.optionalProperty) -- возвратит nil, т.к. свойство необязательно
myObject.optionalProperty = 42 
print("myObject.optionalProperty: ", myObject.optionalProperty)

//5. Создать 2 протокола: со свойствами время, количество кода и функцией writeCode(platform: Platform, numberOfSpecialist: Int); и другой с функцией: stopCoding().
// Создайте класс: Компания, у которого есть свойства - количество программистов, специализации(ios, android, web)
// Компании подключаем два этих протокола
// Задача: вывести в консоль сообщения - 'разработка началась.
// пишем код <такой-то>' и 'работа закончена. Сдаю в тестирование', попробуйте обработать крайние случаи.
enum Platform {
    case iOS
    case Android
    case Web
}

protocol Coding {
    var time: String { get }
    var codeCount: Int { get }
    
    func writeCode(platform: Platform, numberOfSpecialist: Int)
}

protocol CodingStopper {
    func stopCoding()
}

class Company: Coding, CodingStopper {
    var programmersCount: Int
    var specializations: [String]
    
    init(programmersCount: Int, specializations: [String]) {
        self.programmersCount = programmersCount
        self.specializations = specializations
    }
    
    var time: String {
        return "20:00"
    }
    
    var codeCount: Int {
        return 1000
    }
    
    func writeCode(platform: Platform, numberOfSpecialist: Int) {
        print("Разработка началась. Пишем код для \(platform) с \(numberOfSpecialist) специалистами.")
    }
    
    func stopCoding() {
        print("Работа закончена. Сдаю в тестирование.")
    }
}

let myCompany = Company(programmersCount: 50, specializations: ["iOS", "Android", "Web"])
myCompany.writeCode(platform: .Android, numberOfSpecialist: 12)
myCompany.stopCoding()