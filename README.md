# Set.js - Efficient Sets for Javascript

*Author*: Brian T Maurer • [Website](https://briantmaurer.com)

This is simply a library to manage sets of anything in javascript.

##### Contents
[Methods](https://github.com/BrianTMaurer/Set.js#methods) <br>
[Examples](https://github.com/BrianTMaurer/Set.js#examples)

## Methods

Given `A = new Set(...)`, and `B = new Set(...)`:

Method | Description | Runtime
-------: | :--------------- | :---------
`A.difference(B)` | Returns a new Set(A \ B) = {x: x∈A ∧ x∉B} | Θ(n)  
`A.find(key)` | Returns the array index for the element with the given key. Returns -1 if the corresponding element is found. | Θ(lg n) 
`A.get(key)` | Returns the element with the given key. Returns -1 if the corresponding element is not found. | Θ(lg n) 
`A.has(key)` | Returns true if an element with the given key is in the Set A, false otherwise. | Θ(lg n) 
`A.insert(ele)` | Returns the Set A with the newly added element. | Θ(lg n) 
`A.intersect(B)` | Returns a new Set(A ⋂ B) = {x: x∈A ∧ x∈B} | Θ(n) 
`A.isEmpty()` | Returns true if empty, false otherwise. | Θ(1) 
`A.remove(key)` | Returns the Set A without the element with the given key. | Θ(lg n) 
`A.size()` | Returns the size of the Set A. | Θ(1) 
`A.subset(B)` | Returns true if (A ⊆ B) aka {x: ∀x∈A x∈B}, otherwise false. | Θ(n) 
`A.superset(B)` | Returns true if (A ⊇ B) aka {x: ∀x∈B x∈A}, otherwise false | Θ(n) 
`A.symmetricDifference(B)` | Returns a new Set(A ∆ B) = {x: (x∈A ⋁ x∈B) ∧ !(x∈A ∧ x∈B)} | Θ(n) 
`A.union(B)` | Returns a new Set(A ∪ B) = {x: x∈A ∨ x∈B} | Θ(n) 

## Examples

### Create some new sets.

The array elements will be in sorted order. Sets with objects either need an attribute paramater passed, OR their valueOf() funciton to be defined. A primer function will be used during all comparisons that pertain to the Set's sorted order, however, they will not modify your objects.

```javascript
// Sets of numbers.
var s1 = new Set([1, 3, 6, 2, 4, 5]); // -> { 1, 2, 3, 4, 5, 6 }

// Sets of strings:
var s3 = new Set(["a", "d", "f", "zed"]); // -> { "a", "d", "f", "zed" }

// Sets of objects:
// If you dont set an attribute ("name" in this case)
// as the index, the set will behave oddly.
var s7 = new Set([{"name": "bb"}, {"name": "AA"},
		{"name": "aaa"}, {"name": "BBB"}], "name");
// -> {name:'AA' }, {name:'BBB'}, {name:'aaa'}, { name:'bb'} }

// With the added primer, s8 will sort more naturally than s7.
var s8 = new Set(
	[{"name": "bb"}, {"name": "AA"}, {"name": "aaa"}, {"name": "BBB"}]
    , "name"
    , function(ele){ ele.toLowerCase(); } 
); // -> {name:'AA' }, {name:'aaa'}, {name:'bb'}, { name:'BBB'} }
```

*Note: Sets of Arrays act odd.*

### Do some cool operations.

```javascript
// {...} notation is used to informally represent Set objects.
var s1 = new Set([1, 3, 6, 2, 4, 5]); // -> { 1, 2, 3, 4, 5, 6 }
var s2 = new Set([1, 6, 5]); // -> { 1, 5, 6 }
var s3 = new Set([1, 6, 5]); // -> { 1, 15, 30 }

s1.difference(s2); // -> { 2, 3, 4 }
s2.difference(s1); // -> {}
s1.intersect(s2); // -> { 1, 5, 6 }
s1.isEmpty(); // -> false
s2.subset(s1); // -> true
s1.superset(s2); // -> true
s1.symmetricDifference(s2); // -> { 2, 3, 4 }
s1.union(s3); // -> { 1, 2, 3, 4, 5, 6, 15, 30 }

var s8 = new Set(
	[{"name": "bb"}, {"name": "AA"}, {"name": "aaa"}, {"name": "BBB"}]
    , "name"
    , function(ele){ ele.toLowerCase(); } 
); // -> { {name: 'AA'}, {name: 'aaa'}, {name: 'bb'}, {name: 'BBB'} }

s8.find("bb"); // -> 2
s8.get("bb"); // -> {name: 'bb'}
s8.has("bb"); // -> true
s8.insert({name: 'xx'});
// -> { {name: 'AA'}, {name: 'aaa'}, {name: 'bb'}, {name: 'BBB'}, {name:"xx"} }

s8.remove("bb"); // -> { {name: 'AA'}, {name: 'aaa'}, {name: 'BBB'}, {name:"xx"} }
s8.size(); // -> 4

s1 = new Set([1,2,3,4]);
s2 = new Set([3,4,5,6]);
s3 = new Set([3,4,9]);

// You can chain operations.
s1.intersect(s2).intersect(s3); // -> { 3, 4 }

// You can mix up function chain order and use function composition.
s1.union(s2).intersect(s3); // -> { 3, 4 }
s1.intersect(s2).union(s3); // -> { 3, 4, 9 }
s1.union(s2.intersect(s3)); // -> { 1, 2, 3, 4 }
s1.intersect(s2.union(s3)); // -> { 3, 4 }

```


