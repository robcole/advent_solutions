import input from './input';

interface ColumnCharacters {
  [key: string]: number;
}

interface ColumnData {
  characters: ColumnCharacters;
  mostFrequent: string;
}

interface Columns {
  [key: number]: ColumnData
}

function createCounters(text: string, wordLength: number): Columns {
  let columns: Columns = {};

  for(var i = 0; i < text.length; i++) {

    var position = i % wordLength;
    var char = text.charAt(i);
    var currentColumn = columns[position] || { characters: { "": 0 }, mostFrequent: "" };
    var currentLeader = currentColumn.mostFrequent;
    currentColumn.characters[char] = increment_counter(currentColumn, char);

    if (currentColumn.characters[currentLeader] < currentColumn.characters[char]) {
      currentColumn.mostFrequent = char;
    }

    columns[position] = currentColumn;
  }

  return columns;
}

function increment_counter(column: ColumnData, char: string) {
  let currentCount: number = column.characters[char] || 0;
  return currentCount + 1;
}

let results = createCounters(input, 8);
for (var key in results) {
  console.log(results[key].mostFrequent);
}