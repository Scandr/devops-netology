package main

import (
	"fmt"
// 	"math"
)

func main() {
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    min := x[0]
//     fmt.Print("len(x) = ", len(x))
    for i := 1; i < len(x); i++ {
        fmt.Print("x[i] = ", x[i], "\t")
        if min > x[i]{
            min = x[i]
        }
    }
    fmt.Print("\nmin = ", min, "\n")
}