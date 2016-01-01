function nextFloor(previousFloor, instruction, index) {
  return {
    floorNumber: previousFloor.floorNumber + convertInstruction(instruction),
    index: index
  }
}

function convertInstruction(text) {
  if (text === '(') {
    return 1;
  } else if (text === ')') {
    return -1;
  } else {
    return 0;
  }
}

var results = input.split('').reduce(function(floors, instruction, index, arr) {
  var currFloor = floors[index];
  var nf = nextFloor(currFloor, instruction, index + 1);
  floors.push(nf);
  return floors;
}, [{ floorNumber: 0, index: 0 }]);

var part1 = results.slice(-1)[0].floorNumber
var part2 = results.find(function(element, index, array) {
  return (element.floorNumber === -1);
});
