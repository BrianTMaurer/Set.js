// Generated by CoffeeScript 1.6.3
var Set, assert, s1, s2, s3;

assert = require("assert");

Set = require("../Set.js").Set;

console.log(s1 = new Set([1, 2, 3, 4]));

console.log(s2 = new Set([3, 4, 5, 6]));

console.log(s3 = new Set([3, 4, 9]));

console.log(s1.union(s2).intersect(s3));

console.log(s1.intersect(s2).union(s3));

console.log(s1.union(s2.intersect(s3)));

console.log(s1.intersect(s2.union(s3)));
