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

func (m *Mull) part1() (int, error) {
	data, err := m.parseData()
	if err != nil {
		return 0, err
	}

	matches := regMul.FindAllSubmatch(data, -1)
	var result int = 0
	for _, match := range matches {
		a, err := strconv.Atoi(string(match[1]))
		if err != nil {
			return result, err
		}
		b, err := strconv.Atoi(string(match[2]))
		if err != nil {
			return result, err
		}
		result += a * b
	}
	return result, nil
}

func main() {

	m := Mull{
		filename: testData(),
	}

	// Part 1
	result, err := m.part1()
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(result)

	// Part 2
}
