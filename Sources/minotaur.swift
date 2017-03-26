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
//   ...         ...
// x:1,y:m ... x:n,y:m

func room (_ x: Int, _ y: Int) -> Term {
  return Value (Position (x: x, y: y))
}

/* Gives all the doors that exist */
func doors (from: Term, to: Term) -> Goal {
  /* From the top to the bottom, and from the left to the right */
  return
    (from === room(2,1) && to === room(1,1)) ||
    (from === room(3,1) && to === room(2,1)) ||
    (from === room(4,1) && to === room(3,1)) ||

    (from === room(1,2) && to === room(1,1)) ||
    (from === room(4,2) && to === room(4,1)) ||

    (from === room(1,2) && to === room(2,2)) ||
    (from === room(2,2) && to === room(3,2)) ||
    (from === room(3,2) && to === room(4,2)) ||

    (from === room(1,3) && to === room(1,2)) ||
    (from === room(2,3) && to === room(2,2)) ||
    (from === room(3,2) && to === room(3,3)) ||
    (from === room(4,2) && to === room(4,3)) ||

    (from === room(2,3) && to === room(1,3)) ||

    (from === room(1,4) && to === room(1,3)) ||
    (from === room(2,4) && to === room(2,3)) ||
    (from === room(3,4) && to === room(3,3)) ||

    (from === room(3,4) && to === room(2,4)) ||
    (from === room(4,4) && to === room(3,4))
}

/* Gives all the rooms that are entrances */
func entrance (location: Term) -> Goal {
  return
    location === room(1,4) || location === room(4,4)
}

/* Gives all the rooms that exits */
func exit (location: Term) -> Goal {
  return
    location === room(1,1) || location === room(4,3)
}

/* Gives the room where the minautor is */
func minotaur (location: Term) -> Goal {
  return
    location === room(3,2)
}

/* Gives all the paths that exits */
func path (from: Term, to: Term, through: Term) -> Goal {
  return
  /* When the two rooms are the same, and where the path between the two is
  empty */
    (from === to && through === List.empty) ||

  /* When the to rooms are separate by a path which is a list of other rooms
  (can also be empty - if the two rooms are next to each other) */
    delayed (
      fresh { first in
        fresh { rest in
          (through === List.cons(first, rest) &&
          doors(from: from, to: first) &&
          path(from: first, to: to, through: rest))
        }
      }
    )
}

/* Gives all the paths which can be taken according to number of bars in the
battery */
func battery (through: Term, level: Term) -> Goal {
  return
    delayed (
      fresh { a in

        /* This is for the battery used in the first room, we need to take it
        off at the beginning */
        level === succ(a) &&

        /* Then we have the case where there is no path */
        ( (through === List.empty) ||

        /* And the case where we take off a bar of battery for each room crossed */
            delayed (
              fresh { x in
                fresh { y in
                  fresh { z in
                    (through === List.cons(x,y) &&
                    level === succ(z) &&
                    battery(through: y, level: z))
                  }
                }
              }
            )
          )
      }
    )
}

/* Checks if the Minautor is in the path */
func minotaurInPath (path: Term) -> Goal {
  return
    (delayed (
      fresh { x in
        fresh { y in
          (path === List.cons(x,y) &&

          /* We check if the minautor is in the first room of the path */
          (minotaur(location: x) ||

          /* And if not, we repeat the test with the rest of the path */
          minotaurInPath (path: y)))
        }
      }
    )
  )
}

/* Checks if there is a path that we can take with the condition of the battery,
 and where we will go in the room of the minautor */
func winning (through: Term, level: Term) -> Goal {
  return
    /* We check if the minautor is in the path */
    minotaurInPath(path: through) &&

    /* We chaeck if the battery will be okay */
    battery(through: through, level: level) &&

    /* And we check if there is an entrance and an exit in the path */
    delayed (
      fresh { start in
        fresh { end in
          (entrance(location: start) &&
          exit(location: end) &&
          path(from: start, to: end, through: through))
        }
      }
    )
}
