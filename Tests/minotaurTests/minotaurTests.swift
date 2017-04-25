import XCTest
import LogicKit
@testable import minotaur

struct Wrapper : Equatable, CustomStringConvertible {
  let term : Term

  var description: String {
      return "\(self.term)"
  }

  static func ==(lhs: Wrapper, rhs: Wrapper) -> Bool {
    return (lhs.term).equals (rhs.term)
  }

}

func resultsOf (goal: Goal, variables: [Variable]) -> [[Variable: Wrapper]] {
    var result = [[Variable: Wrapper]] ()
    for s in solve (goal) {
        let solution  = s.reified ()
        var subresult = [Variable: Wrapper] ()
        for v in variables {
            subresult [v] = Wrapper (term: solution [v])
        }
        if !result.contains (where: { x in x == subresult }) {
            result.append (subresult)
        }
    }
    return result
}

class minotaurTests: XCTestCase {

    func testDoors() {
        let from = Variable (named: "from")
        let to   = Variable (named: "to")
        let goal = doors (from: from, to: to)
        XCTAssertEqual(resultsOf (goal: goal, variables: [from, to]).count, 18, "number of doors is incorrect")
    }

    func testEntrance() {
        let location = Variable (named: "location")
        let goal     = entrance (location: location)
        XCTAssertEqual(resultsOf (goal: goal, variables: [location]).count, 2, "number of entrances is incorrect")
    }

    func testExit() {
        let location = Variable (named: "location")
        let goal     = exit (location: location)
        XCTAssertEqual(resultsOf (goal: goal, variables: [location]).count, 2, "number of exits is incorrect")
    }

    func testMinotaur() {
        let location = Variable (named: "location")
        let goal     = minotaur (location: location)
        XCTAssertEqual(resultsOf (goal: goal, variables: [location]).count, 1, "number of minotaurs is incorrect")
    }

    func testPath() {
        let through = Variable (named: "through")
        let goal    = path (from: room (4,4), to: room (3,2), through: through)
        XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 2, "number of paths is incorrect")
    }


    func testPath2() {
        let through = Variable (named: "through")
        let goal    = path (from: room (4,4), to: room (3,4), through: through)
        XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
    }

    func testPath3() {
        let through = Variable (named: "through")
        let goal    = path (from: room (4,4), to: room (4,4), through: through)
        XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
    }


    func testBattery() {
        let through = Variable (named: "through")
        let goal    = path (from: room (4,4), to: room (3,2), through: through) &&
                      battery (through: through, level: toNat (7))
        XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
    }

    func testLosing() {
        let through = Variable (named: "through")
        let goal    = winning (through: through, level: toNat (6))
        XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 0, "number of paths is incorrect")
    }

    func testWinning() {
        let through = Variable (named: "through")
        let goal    = winning (through: through, level: toNat (7))
        XCTAssertEqual(resultsOf (goal: goal, variables: [through]).count, 1, "number of paths is incorrect")
    }


    static var allTests : [(String, (minotaurTests) -> () throws -> Void)] {
        return [
          ("testDoors", testDoors),
          ("testEntrance", testEntrance),
          ("testExit", testExit),
          ("testMinotaur", testMinotaur),
          ("testPath", testPath),

          ("testPath2", testPath2),
          ("testPath3", testPath3),

          ("testBattery", testBattery),
          ("testLosing", testLosing),
          ("testWinning", testWinning)
        ]
    }
}
