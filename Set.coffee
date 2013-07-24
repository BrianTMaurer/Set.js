###
This small library extends the JavaScript Array object
to work as a sorted Set using the provided methods.

Set Properties:
* Sorted in Ascending Order
* No Duplicate Indexes
* Uniform Type

All types of elements will work as long as you pass the attribute paramater
to be used during comparisons (>,<,==,etc.).
###


class Set
	constructor: (elements, attribute, primer) ->
		this.elements = []
		this.attribute = attribute ? false
		# Set up the index (aka key) key_primer for sorting comparisons
		this.key_primer = primer ? (ele) -> ele
		if elements && elements[0]
			this.type = typeof(elements[0])
			for ele in elements
				this.insert(ele)
		else
			this.type = undefined

	###
	(A \ B) = {x: x∈A ∧ x∉B }
	###
	difference: (set) ->
		if this.type != set.type
			new Set([])
		b = set
		a = this
		a_ptr = 0
		a_max = a.elements.length
		a_arr = a.elements
		b_ptr = 0
		b_max = b.elements.length
		b_arr = b.elements
		c = new Set([])
		c_arr = c.elements
		c_ptr = 0
		while (a_ptr <= a_max) && (b_ptr <= b_max) && !(a_ptr == a_max && b_ptr == b_max)
			# If element keys are equal, increment both pointers
			if this.primer(a_arr[a_ptr]) == this.primer(b_arr[b_ptr])
				a_ptr++
				b_ptr++
			# if b_ptr has reached end, add elements from a, finish a
			else if b_ptr == b_max
				c_arr[c_ptr] = a_arr[a_ptr]
				a_ptr++
				c_ptr++
			# if a_ptr has reached the end, done
			else if a_ptr == a_max
				break
			# if a element key is bigger, increment b pointer
			else if this.primer(a_arr[a_ptr]) > this.primer(b_arr[b_ptr])
				b_ptr++
			# if b element key is bigger, add elements from a, increment a pointer
			else if this.primer(a_arr[a_ptr]) < this.primer(b_arr[b_ptr])
				c_arr[c_ptr] = a_arr[a_ptr]
				a_ptr++
				c_ptr++
			else
				break
		return c


	###
	Finds the index of an element in the Set.
	###
	find: (key) ->
		low = 0
		high = this.elements.length - 1
		while low <= high
			mid = Math.floor((low + high) / 2)
			target = this.primer(this.elements[mid])
			if key == target
				return mid
			else if key > target
				low = mid + 1
			else
				high = mid - 1
		-1 # using conventional javascript no index found

	###
	Returns an element from the Set.
	###
	get: (key) ->
		this.elements[this.find(key)]

	###
	Checks if an element is in the set
	###
	has: (key) ->
		if this.find(key) != -1
			true
		else
			false

	###
	Inserts an element into the Set maintaining sorted order.
	###
	insert: (ele) ->
		if this.elements.length == 0
			this.elements[0] = ele
			this.type = typeof(ele)
		else if this.type != typeof ele
			console.log "mismatched set element type"
		else
			low = 0
			high = this.elements.length - 1
			while low <= high
				mid = Math.floor((low + high) / 2)
				key = this.primer(ele)
				mid_target = this.primer(this.elements[mid])
				low_target = this.primer(this.elements[low])
				high_target = this.primer(this.elements[high])
				if high_target < key
					mid = high + 1
					break
				else if low_target > key
					mid = low
					break
				else if mid_target < key
					low = mid + 1
				else
					high = mid - 1
			if this.primer(this.elements[mid]) != this.primer(ele)
				this.elements[mid...mid] = ele
		return this


	###
	(A ∩ B) = {x: x∈A ∧ x∈B}
	###
	intersect: (set) ->
		if this.type != set.type
			new Set([])
		b = set
		a = this
		a_ptr = 0
		a_max = this.elements.length
		a_arr = this.elements
		b_ptr = 0
		b_max = b.elements.length
		b_arr = b.elements
		c = new Set([])
		c_arr = c.elements
		c_ptr = 0
		while (a_ptr <= a_max) && (b_ptr <= b_max) && !(a_ptr == a_max && b_ptr == b_max)
			# if a element key is larger, and b_ptr is at end finish, or vis a versa, due to sorted nature, there are no more matches
			if (this.primer(a_arr[a_ptr]) > this.primer(b_arr[b_ptr]) && b_ptr == b_max) || (this.primer(b_arr[b_ptr]) > this.primer(a_arr[a_ptr]) && a_ptr == a_max)
				break
			# If element keys are equal, increment both pointers, add to c
			else if this.primer(a_arr[a_ptr]) == this.primer(b_arr[b_ptr])
				c_arr[c_ptr] = a_arr[a_ptr]
				a_ptr++
				b_ptr++
				c_ptr++
			# if b_ptr has reached end, finish a
			else if b_ptr == b_max
				a_ptr++
			# if a_ptr has reached the end, finish b
			else if a_ptr == a_max
				b_ptr++
			# if a element key is bigger, increment b pointer
			else if this.primer(a_arr[a_ptr]) > this.primer(b_arr[b_ptr])
				b_ptr++
			# if b element key is bigger, increment a pointer
			else if this.primer(a_arr[a_ptr]) < this.primer(b_arr[b_ptr])
				a_ptr++
			else
				break
		return c

	# used for index priming. Useful for object sets, converting to upper/lower case before string comparisons, etc.
	primer: (ele) ->
		if ele == undefined
			ele
		else if this.attribute && ele[this.attribute]
			this.key_primer(ele[this.attribute])
		else
			this.key_primer(ele)

	###
	Removes an element from the Set.
	###
	remove: (key) ->
		index = this.find(key)
		if index != -1
			this.elements[index..] = this.elements[(index+1)..]
		return this
		

	###
	Returns the size (or length) of the set.
	###
	size: () ->
		return this.elements.length

	###
	Similar functionalty to array.slice(begin[, end]) only key based rather than index based.
	i.e. if you have a set of objects { name: "bob", ..., name: "catrina", ..., name: "zelda"}
	you could slice from "catrina" to "zelda". Also, a new set is returned rather than an array.
	###
	slice: () ->
		if arguments.length == 1
			begin = this.find(arguments[0])
			sliced_elements = this.elements.slice(begin)
		if arguments.length == 2
			begin = this.find(arguments[0])
			end = this.find(arguments[1])
			sliced_elements = this.elements.slice(begin, end)
		return new Set(sliced_elements)

	###
	Similar functionality to array.splice(index, howMany[, element1[, ...[, elementN]]]). However, elements will be inserted in sorted order, you will splice at a given key rather than an array index, and this set is returned, not an array.
	###
	splice: () ->
		if arguments.length == 1
			index = this.find(arguments[0])
			this.elements.splice(index)
		if arguments.length > 1
			index = this.find(arguments[0])
			this.elements.splice(index, arguments[1])
			# it is important to splice first, insert new elements. The other way around you could isert an
			# element and then inadvertently splice it out due to using the set insert.
			delete arguments[0]
			delete arguments[1]
			for k, ele of arguments
				this.insert(ele)
		return this

	###
	(A ⊆ B) = {x: ∀x∈A x∈B}
	###
	subset: (set) ->
		if this.type != set.type
			false
		b = set
		a = this
		a_ptr = 0
		a_max = this.elements.length
		a_arr = this.elements
		b_ptr = 0
		b_max = b.elements.length
		b_arr = b.elements
		# Walk through both sets
		while a_ptr <= a_max && b_ptr <= b_max && !(a_ptr == a_max && b_ptr == b_max)
			# if a element key == b element key, skip this element
			if this.primer(a_arr[a_ptr]) == this.primer(b_arr[b_ptr])
				a_ptr++
				b_ptr++
			# if a is exhausted then a is a subset of b
			else if a_ptr == a_max
				return true
			# if b is exhausted or b element key is larger than a element key, then a is not a subset of b
			else if b_ptr == b_max || this.primer(a_arr[a_ptr]) < this.primer(b_arr[b_ptr])
				return false
			# if a key > b key move to the next b element to see if it is a match
			else if this.primer(a_arr[a_ptr]) > this.primer(b_arr[b_ptr])
				b_ptr++
			else
				return false
		return true

	###
	(A ⊇ B) = {x: ∀x∈B x∈A}
	###
	superset: (set) ->
		b = set
		return b.subset(this)

	###
	(A ∆ B) = {x: (x∈A ⋁ x∈B) ∧ !(x∈A ∧ x∈B) }
	###
	symmetricDifference: (set) ->
		if this.type != set.type
			new Set([])
		b = set
		a = this
		a_ptr = 0
		a_max = this.elements.length
		a_arr = this.elements
		b_ptr = 0
		b_max = b.elements.length
		b_arr = b.elements
		c = new Set([])
		c_arr = c.elements
		c_ptr = 0
		# Walk through both sets
		while a_ptr <= a_max && b_ptr <= b_max && !(a_ptr == a_max && b_ptr == b_max)
			# if a element key == b element key, skip this element
			if this.primer(a_arr[a_ptr]) == this.primer(b_arr[b_ptr])
				a_ptr++
				b_ptr++
			# if a is exhausted add the rest of b
			else if a_ptr == a_max
				c_arr[c_ptr] = b_arr[b_ptr]
				b_ptr++
				c_ptr++
			# if b is exhausted add the rest of a
			else if b_ptr == b_max
				c_arr[c_ptr] = a_arr[a_ptr]
				a_ptr++
				c_ptr++
			# if a element key < b key add the a element and increment a_ptr
			else if this.primer(a_arr[a_ptr]) < this.primer(b_arr[b_ptr])
				c_arr[c_ptr] = a_arr[a_ptr]
				a_ptr++
				c_ptr++
			# if a key > b key add the b element and increment b_ptr
			else if this.primer(a_arr[a_ptr]) > this.primer(b_arr[b_ptr])
				c_arr[c_ptr] = b_arr[b_ptr]
				b_ptr++
				c_ptr++
			else
				break
		return c

	###
	(A ∪ B) = {x: x∈A ∨ x∈B }
	###
	union: (set) ->
		if this.type != set.type
			new Set([])
		b = set
		a = this
		a_ptr = 0
		a_max = this.elements.length
		a_arr = this.elements
		b_ptr = 0
		b_max = b.elements.length
		b_arr = b.elements
		c = new Set([])
		c_arr = c.elements
		c_ptr = 0
		# Walk through both sets
		while a_ptr <= a_max && b_ptr <= b_max && !(a_ptr == a_max && b_ptr == b_max)
			# if b_ptr has reached end, add element from a, finish a
			if b_ptr == b_max
				c_arr[c_ptr] = a_arr[a_ptr]
				a_ptr++
				c_ptr++
			# if a_ptr has reached the end, add element from b, finish b
			else if a_ptr == a_max
				c_arr[c_ptr] = b_arr[b_ptr]
				b_ptr++
				c_ptr++
			# If element keys == increment both pointers, add element to c
			else if this.primer(a_arr[a_ptr]) == this.primer(b_arr[b_ptr])
				c_arr[c_ptr] = a_arr[a_ptr]
				a_ptr++
				b_ptr++
				c_ptr++
			# if a element key is bigger, add element from b, increment b pointer
			else if this.primer(a_arr[a_ptr]) > this.primer(b_arr[b_ptr])
				c_arr[c_ptr] = b_arr[b_ptr]
				b_ptr++
				c_ptr++
			# if b element key is bigger, add element from a, increment a pointer
			else if this.primer(a_arr[a_ptr]) < this.primer(b_arr[b_ptr])
				c_arr[c_ptr] = a_arr[a_ptr]
				a_ptr++
				c_ptr++
			else
				break
		return c

if (typeof window == 'undefined')
	exports.Set = Set
else
	window.Set = Set

# End of file.  
# --------- --------- --------- --------- --------- --------- --------- --------- --------- ---------