package main

import (
	"fmt"
	"os"
	"path"
	"regexp"
	"runtime"
	"strconv"
)

func testData() string {
	_, filename, _, ok := runtime.Caller(1)
	if ok {
		dir := path.Join(path.Dir(filename), "..")
		return path.Join(dir, "data")
	}
	panic("couldn't find test data")
}

type Mull struct {
	filename string
}

// var regMul = regexp.MustCompile(`mul\((\d+,\d+)\)`)
var regMul = regexp.MustCompile(`mul\((?P<one>\d+),(?P<two>\d+)\)`)

func (m *Mull) parseData() ([]byte, error) {
	data, err := os.ReadFile(m.filename)
	if err != nil {
		return nil, err
	}
	return data, nil
}

func main() {

	m := Mull{
		filename: testData(),
	}

	data, err := m.parseData()
	if err != nil {
		fmt.Println(err)
		return
	}

	matches := regMul.FindAllSubmatch(data, -1)
	//fmt.Printf("%q\n", matches)
	var result = 0
	for _, match := range matches {
		fmt.Printf("%v\n", match)
		a, err := strconv.Atoi(string(match[1]))
		if err != nil {
			fmt.Println(err)
			return
		}
		b, err := strconv.Atoi(string(match[2]))
		if err != nil {
			fmt.Println(err)
			return
		}
		result += a * b
	}
	fmt.Println(result)
}
