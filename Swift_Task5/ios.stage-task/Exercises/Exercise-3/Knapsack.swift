import Foundation

// экстеншн для составления сочетаний
extension Array {
    var combinations: [[Element]] {
        if count == 0 {
            return [self]
        }
        else {
            let tail = Array(self[1..<endIndex])
            let head = self[0]

            let first = tail.combinations
            let rest = first.map { $0 + [head] }

            return first + rest
        }
    }
}


public typealias Supply = (weight: Int, value: Int)

public final class Knapsack {
    let maxWeight: Int
    let drinks: [Supply]
    let foods: [Supply]
    var maxKilometers: Int {
        findMaxKilometres()
    }

//    структура для "жадного" поиска - не пригодилась в итоге :(
//    struct supplyEfficiency {
//        let supply: Supply
//        let efficiency: Double
//        let index: Int
//    }
    
    struct Result {
        let distance: Int
        let wieght: Int
    }
    
    
    init(_ maxWeight: Int, _ foods: [Supply], _ drinks: [Supply]) {
        self.maxWeight = maxWeight
        self.drinks = drinks
        self.foods = foods
    }
    
    func findMaxKilometres() -> Int {
        
        if drinks == nil || drinks.isEmpty || foods == nil || foods.isEmpty {
            return 0
        }
        // создаем массивы комбинаций
        let drinksCombination = drinks.combinations
        let foodsCombination = foods.combinations
        
        //создаем массивы результатов масс и дистанций
        let drinksResult = createResultArray(array: drinksCombination)
        let foodsResult = createResultArray(array: foodsCombination)
        
        var summDistance = 0
        var maxSummDistance = 0
        
        // находим макс длину при ограниченной массе
        for drink in drinksResult {
            for food in foodsResult {
                if drink.distance <= food.distance {
                    summDistance = drink.distance
                }
                else { summDistance = food.distance }
                
                if drink.wieght + food.wieght <= maxWeight && maxSummDistance < summDistance {
                    maxSummDistance = summDistance
                }
            }
        }

        return maxSummDistance
    }
    
    // функция преобразует входящий массив массивов supply елементов в массив с суммированными массами и дистанциями
    func createResultArray(array: [[Supply]]) -> [Result] {
        var result: [Result] = []
        for elementSet in array {
            var distance = 0
            var weight = 0
            for element in elementSet {
                distance += element.value
                weight += element.weight
            }
            // сразу выбрасываем суммы с овермассой
            if weight < maxWeight {
                result.append(Result(distance: distance, wieght: weight))
            }
        }
        return result
    }
}

