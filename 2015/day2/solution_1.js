function zip(array1, array2) {
  return array1.map(function(_, i) {
    var newArr = [array1[i], array2[i]];
    return newArr;
  });
}

function keyMash(array1, array2) {
  return array1.reduce(function(memo, dimension, i) {
    memo[array1[i]] = array2[i];
    return memo;
  }, {})
}

function sortOrder(a, b) {
  return a - b;
}

function minArr(arr, size) {
  return arr.sort(sortOrder).slice(0, size);
}

function Box(dimensions) {
  this.size = dimensions
                  .split('x')
                  .map(function(elem) {
                    return parseInt(elem);
                  });

  this.l = this.size[0];
  this.w = this.size[1];
  this.h = this.size[2];

  this.surface_area = function() {
    console.log(test);
    return (2*this.l*this.w) + (2*this.w*this.h) + (2*this.h*this.l);
  };

  this.extra_paper = function() {};
}

var box = new Box("1x1x5");

var Boxes = function() {
  return input.split(' ').map(function(elem) {
    return Box(elem);
  });
}
