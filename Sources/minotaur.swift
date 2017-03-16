import LogicKit

let zero = Value (0)

func succ (_ of: Term) -> Map {
    return ["succ": of]
}

func toNat (_ n : Int) -> Term {
    var result : Term = zero
    for _ in 1...n {
        result = succ (result)
    }
    return result
}

struct Position : Equatable, CustomStringConvertible {
    let x : Int
    let y : Int

    var description: String {
        return "\(self.x):\(self.y)"
    }

    static func ==(lhs: Position, rhs: Position) -> Bool {
      return lhs.x == rhs.x && lhs.y == rhs.y
    }

}


// rooms are numbered:
// x:1,y:1 ... x:n,y:1
// ...             ...
// x:1,y:m ... x:n,y:m
func room (_ x: Int, _ y: Int) -> Term {
  return Value (Position (x: x, y: y))
}

func doors (from: Term, to: Term) -> Goal {
    // TODO
}

func entrance (location: Term) -> Goal {
    // TODO
}

func exit (location: Term) -> Goal {
    // TODO
}

func minotaur (location: Term) -> Goal {
    // TODO
}

func path (from: Term, to: Term, through: Term) -> Goal {
    // TODO
}

func battery (through: Term, level: Term) -> Goal {
    // TODO
}

func winning (through: Term, level: Term) -> Goal {
    // TODO
}
