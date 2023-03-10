package main

import (
	"fmt"
// 	"math"
)

func main() {
    fmt.Print("Enter value in meter units: ")
    var meters float64
    fmt.Scanf("%f", &meters)
	fmt.Printf("%f m = %f ft\n", meters, meters/0.3048)
}