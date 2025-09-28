(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.1/optimize for better performance and smaller assets.');


// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**_UNUSED/
	var node = args['node'];
	//*/
	/**/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS
//
// For some reason, tabs can appear in href protocols and it still works.
// So '\tjava\tSCRIPT:alert("!!!")' and 'javascript:alert("!!!")' are the same
// in practice. That is why _VirtualDom_RE_js and _VirtualDom_RE_js_html look
// so freaky.
//
// Pulling the regular expressions out to the top level gives a slight speed
// boost in small benchmarks (4-10%) but hoisting values to reduce allocation
// can be unpredictable in large programs where JIT may have a harder time with
// functions are not fully self-contained. The benefit is more that the js and
// js_html ones are so weird that I prefer to see them near each other.


var _VirtualDom_RE_script = /^script$/i;
var _VirtualDom_RE_on_formAction = /^(on|formAction$)/i;
var _VirtualDom_RE_js = /^\s*j\s*a\s*v\s*a\s*s\s*c\s*r\s*i\s*p\s*t\s*:/i;
var _VirtualDom_RE_js_html = /^\s*(j\s*a\s*v\s*a\s*s\s*c\s*r\s*i\s*p\s*t\s*:|d\s*a\s*t\s*a\s*:\s*t\s*e\s*x\s*t\s*\/\s*h\s*t\s*m\s*l\s*(,|;))/i;


function _VirtualDom_noScript(tag)
{
	return _VirtualDom_RE_script.test(tag) ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return _VirtualDom_RE_on_formAction.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return _VirtualDom_RE_js.test(value)
		? /**_UNUSED/''//*//**/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return _VirtualDom_RE_js_html.test(value)
		? /**_UNUSED/''//*//**/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlJson(value)
{
	return (typeof _Json_unwrap(value) === 'string' && _VirtualDom_RE_js_html.test(_Json_unwrap(value)))
		? _Json_wrap(
			/**_UNUSED/''//*//**/'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'//*/
		) : value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2($elm$json$Json$Decode$map, func, handler.a)
				:
			A3($elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				$elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		message: func(record.message),
		stopPropagation: record.stopPropagation,
		preventDefault: record.preventDefault
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: $elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!$elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = $elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.message;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.stopPropagation;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.preventDefault) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}




// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var view = impl.view;
			/**_UNUSED/
			var domNode = args['node'];
			//*/
			/**/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.setup && impl.setup(sendToApp)
			var view = impl.view;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.body);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.title) && (_VirtualDom_doc.title = title = doc.title);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.onUrlChange;
	var onUrlRequest = impl.onUrlRequest;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		setup: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = $elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.protocol === next.protocol
							&& curr.host === next.host
							&& curr.port_.a === next.port_.a
						)
							? $elm$browser$Browser$Internal(next)
							: $elm$browser$Browser$External(href)
					));
				}
			});
		},
		init: function(flags)
		{
			return A3(impl.init, flags, _Browser_getUrl(), key);
		},
		view: impl.view,
		update: impl.update,
		subscriptions: impl.subscriptions
	});
}

function _Browser_getUrl()
{
	return $elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return $elm$core$Result$isOk(result) ? $elm$core$Maybe$Just(result.a) : $elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { hidden: 'hidden', change: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { hidden: 'mozHidden', change: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { hidden: 'msHidden', change: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { hidden: 'webkitHidden', change: 'webkitvisibilitychange' }
		: { hidden: 'hidden', change: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail($elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		scene: _Browser_getScene(),
		viewport: {
			x: _Browser_window.pageXOffset,
			y: _Browser_window.pageYOffset,
			width: _Browser_doc.documentElement.clientWidth,
			height: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		width: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		height: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			scene: {
				width: node.scrollWidth,
				height: node.scrollHeight
			},
			viewport: {
				x: node.scrollLeft,
				y: node.scrollTop,
				width: node.clientWidth,
				height: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			scene: _Browser_getScene(),
			viewport: {
				x: x,
				y: y,
				width: _Browser_doc.documentElement.clientWidth,
				height: _Browser_doc.documentElement.clientHeight
			},
			element: {
				x: x + rect.left,
				y: y + rect.top,
				width: rect.width,
				height: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2($elm$core$Task$perform, $elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}




// STRINGS


var _Parser_isSubString = F5(function(smallString, offset, row, col, bigString)
{
	var smallLength = smallString.length;
	var isGood = offset + smallLength <= bigString.length;

	for (var i = 0; isGood && i < smallLength; )
	{
		var code = bigString.charCodeAt(offset);
		isGood =
			smallString[i++] === bigString[offset++]
			&& (
				code === 0x000A /* \n */
					? ( row++, col=1 )
					: ( col++, (code & 0xF800) === 0xD800 ? smallString[i++] === bigString[offset++] : 1 )
			)
	}

	return _Utils_Tuple3(isGood ? offset : -1, row, col);
});



// CHARS


var _Parser_isSubChar = F3(function(predicate, offset, string)
{
	return (
		string.length <= offset
			? -1
			:
		(string.charCodeAt(offset) & 0xF800) === 0xD800
			? (predicate(_Utils_chr(string.substr(offset, 2))) ? offset + 2 : -1)
			:
		(predicate(_Utils_chr(string[offset]))
			? ((string[offset] === '\n') ? -2 : (offset + 1))
			: -1
		)
	);
});


var _Parser_isAsciiCode = F3(function(code, offset, string)
{
	return string.charCodeAt(offset) === code;
});



// NUMBERS


var _Parser_chompBase10 = F2(function(offset, string)
{
	for (; offset < string.length; offset++)
	{
		var code = string.charCodeAt(offset);
		if (code < 0x30 || 0x39 < code)
		{
			return offset;
		}
	}
	return offset;
});


var _Parser_consumeBase = F3(function(base, offset, string)
{
	for (var total = 0; offset < string.length; offset++)
	{
		var digit = string.charCodeAt(offset) - 0x30;
		if (digit < 0 || base <= digit) break;
		total = base * total + digit;
	}
	return _Utils_Tuple2(offset, total);
});


var _Parser_consumeBase16 = F2(function(offset, string)
{
	for (var total = 0; offset < string.length; offset++)
	{
		var code = string.charCodeAt(offset);
		if (0x30 <= code && code <= 0x39)
		{
			total = 16 * total + code - 0x30;
		}
		else if (0x41 <= code && code <= 0x46)
		{
			total = 16 * total + code - 55;
		}
		else if (0x61 <= code && code <= 0x66)
		{
			total = 16 * total + code - 87;
		}
		else
		{
			break;
		}
	}
	return _Utils_Tuple2(offset, total);
});



// FIND STRING


var _Parser_findSubString = F5(function(smallString, offset, row, col, bigString)
{
	var newOffset = bigString.indexOf(smallString, offset);
	var target = newOffset < 0 ? bigString.length : newOffset + smallString.length;

	while (offset < target)
	{
		var code = bigString.charCodeAt(offset++);
		code === 0x000A /* \n */
			? ( col=1, row++ )
			: ( col++, (code & 0xF800) === 0xD800 && offset++ )
	}

	return _Utils_Tuple3(newOffset, row, col);
});



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});
var $author$project$Main$init = {};
var $elm$core$Basics$EQ = {$: 'EQ'};
var $elm$core$Basics$GT = {$: 'GT'};
var $elm$core$Basics$LT = {$: 'LT'};
var $elm$core$List$cons = _List_cons;
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0.a;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var $elm$core$Basics$False = {$: 'False'};
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var $elm$core$Maybe$Nothing = {$: 'Nothing'};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 'Nothing') {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / $elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = {$: 'True'};
var $elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 'Normal':
			return 0;
		case 'MayStopPropagation':
			return 1;
		case 'MayPreventDefault':
			return 2;
		default:
			return 3;
	}
};
var $elm$browser$Browser$External = function (a) {
	return {$: 'External', a: a};
};
var $elm$browser$Browser$Internal = function (a) {
	return {$: 'Internal', a: a};
};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $elm$browser$Browser$Dom$NotFound = function (a) {
	return {$: 'NotFound', a: a};
};
var $elm$url$Url$Http = {$: 'Http'};
var $elm$url$Url$Https = {$: 'Https'};
var $elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {fragment: fragment, host: host, path: path, port_: port_, protocol: protocol, query: query};
	});
var $elm$core$String$contains = _String_contains;
var $elm$core$String$length = _String_length;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$indexes = _String_indexes;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$toInt = _String_toInt;
var $elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if ($elm$core$String$isEmpty(str) || A2($elm$core$String$contains, '@', str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, ':', str);
			if (!_v0.b) {
				return $elm$core$Maybe$Just(
					A6($elm$url$Url$Url, protocol, str, $elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_v0.b.b) {
					var i = _v0.a;
					var _v1 = $elm$core$String$toInt(
						A2($elm$core$String$dropLeft, i + 1, str));
					if (_v1.$ === 'Nothing') {
						return $elm$core$Maybe$Nothing;
					} else {
						var port_ = _v1;
						return $elm$core$Maybe$Just(
							A6(
								$elm$url$Url$Url,
								protocol,
								A2($elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return $elm$core$Maybe$Nothing;
				}
			}
		}
	});
var $elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '/', str);
			if (!_v0.b) {
				return A5($elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _v0.a;
				return A5(
					$elm$url$Url$chompBeforePath,
					protocol,
					A2($elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '?', str);
			if (!_v0.b) {
				return A4($elm$url$Url$chompBeforeQuery, protocol, $elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _v0.a;
				return A4(
					$elm$url$Url$chompBeforeQuery,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if ($elm$core$String$isEmpty(str)) {
			return $elm$core$Maybe$Nothing;
		} else {
			var _v0 = A2($elm$core$String$indexes, '#', str);
			if (!_v0.b) {
				return A3($elm$url$Url$chompBeforeFragment, protocol, $elm$core$Maybe$Nothing, str);
			} else {
				var i = _v0.a;
				return A3(
					$elm$url$Url$chompBeforeFragment,
					protocol,
					$elm$core$Maybe$Just(
						A2($elm$core$String$dropLeft, i + 1, str)),
					A2($elm$core$String$left, i, str));
			}
		}
	});
var $elm$core$String$startsWith = _String_startsWith;
var $elm$url$Url$fromString = function (str) {
	return A2($elm$core$String$startsWith, 'http://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Http,
		A2($elm$core$String$dropLeft, 7, str)) : (A2($elm$core$String$startsWith, 'https://', str) ? A2(
		$elm$url$Url$chompAfterProtocol,
		$elm$url$Url$Https,
		A2($elm$core$String$dropLeft, 8, str)) : $elm$core$Maybe$Nothing);
};
var $elm$core$Basics$never = function (_v0) {
	never:
	while (true) {
		var nvr = _v0.a;
		var $temp$_v0 = nvr;
		_v0 = $temp$_v0;
		continue never;
	}
};
var $elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(_Utils_Tuple0);
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0.a;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return _Utils_Tuple0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(_Utils_Tuple0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0.a;
		return $elm$core$Task$Perform(
			A2($elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Task$perform = F2(
	function (toMessage, task) {
		return $elm$core$Task$command(
			$elm$core$Task$Perform(
				A2($elm$core$Task$map, toMessage, task)));
	});
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $elm$core$Platform$Sub$batch = _Platform_batch;
var $elm$core$Platform$Sub$none = $elm$core$Platform$Sub$batch(_List_Nil);
var $elm$browser$Browser$sandbox = function (impl) {
	return _Browser_element(
		{
			init: function (_v0) {
				return _Utils_Tuple2(impl.init, $elm$core$Platform$Cmd$none);
			},
			subscriptions: function (_v1) {
				return $elm$core$Platform$Sub$none;
			},
			update: F2(
				function (msg, model) {
					return _Utils_Tuple2(
						A2(impl.update, msg, model),
						$elm$core$Platform$Cmd$none);
				}),
			view: impl.view
		});
};
var $author$project$Main$update = F2(
	function (msg, model) {
		return model;
	});
var $elm$html$Html$div = _VirtualDom_node('div');
var $elm$html$Html$h2 = _VirtualDom_node('h2');
var $author$project$ScriptaV2$Language$MicroLaTeXLang = {$: 'MicroLaTeXLang'};
var $author$project$ScriptaV2$Config$idPrefix = 'L';
var $elm$core$String$lines = _String_lines;
var $author$project$MicroLaTeX$Expression$initWithTokens = F2(
	function (lineNumber, tokens) {
		return {
			committed: _List_Nil,
			lineNumber: lineNumber,
			messages: _List_Nil,
			numberOfTokens: $elm$core$List$length(tokens),
			stack: _List_Nil,
			step: 0,
			tokenIndex: 0,
			tokens: $elm$core$List$reverse(tokens)
		};
	});
var $author$project$MicroLaTeX$Helpers$loop = F2(
	function (s, f) {
		loop:
		while (true) {
			var _v0 = f(s);
			if (_v0.$ === 'Loop') {
				var s_ = _v0.a;
				var $temp$s = s_,
					$temp$f = f;
				s = $temp$s;
				f = $temp$f;
				continue loop;
			} else {
				var b = _v0.a;
				return b;
			}
		}
	});
var $author$project$MicroLaTeX$Helpers$Done = function (a) {
	return {$: 'Done', a: a};
};
var $author$project$MicroLaTeX$Helpers$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $rtfeldman$console_print$Console$bgBlue = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[44m', str, '\u001B[49m']));
};
var $author$project$MicroLaTeX$LogTools$forklog_ = F6(
	function (fg, bg, label, width, f, a) {
		return a;
	});
var $rtfeldman$console_print$Console$white = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[37m', str, '\u001B[39m']));
};
var $author$project$MicroLaTeX$LogTools$forklogBlue = F4(
	function (label, width, f, a) {
		return A6($author$project$MicroLaTeX$LogTools$forklog_, $rtfeldman$console_print$Console$white, $rtfeldman$console_print$Console$bgBlue, label, width, f, a);
	});
var $rtfeldman$console_print$Console$bgCyan = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[46m', str, '\u001B[49m']));
};
var $rtfeldman$console_print$Console$black = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[30m', str, '\u001B[39m']));
};
var $author$project$MicroLaTeX$LogTools$forklogCyan = F4(
	function (label, width, f, a) {
		return A6($author$project$MicroLaTeX$LogTools$forklog_, $rtfeldman$console_print$Console$black, $rtfeldman$console_print$Console$bgCyan, label, width, f, a);
	});
var $rtfeldman$console_print$Console$bgRed = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[41m', str, '\u001B[49m']));
};
var $author$project$MicroLaTeX$LogTools$forklogRed = F4(
	function (label, width, f, a) {
		return A6($author$project$MicroLaTeX$LogTools$forklog_, $rtfeldman$console_print$Console$white, $rtfeldman$console_print$Console$bgRed, label, width, f, a);
	});
var $elm$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (n <= 0) {
				return list;
			} else {
				if (!list.b) {
					return list;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs;
					n = $temp$n;
					list = $temp$list;
					continue drop;
				}
			}
		}
	});
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm_community$list_extra$List$Extra$getAt = F2(
	function (idx, xs) {
		return (idx < 0) ? $elm$core$Maybe$Nothing : $elm$core$List$head(
			A2($elm$core$List$drop, idx, xs));
	});
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var $author$project$Generic$Language$Fun = F3(
	function (a, b, c) {
		return {$: 'Fun', a: a, b: b, c: c};
	});
var $author$project$Generic$Language$Text = F2(
	function (a, b) {
		return {$: 'Text', a: a, b: b};
	});
var $author$project$ScriptaV2$Config$expressionIdPrefix = 'e-';
var $author$project$MicroLaTeX$Expression$makeId = F2(
	function (lineNumber, tokenIndex) {
		return $author$project$ScriptaV2$Config$expressionIdPrefix + ($elm$core$String$fromInt(lineNumber) + ('.' + $elm$core$String$fromInt(tokenIndex)));
	});
var $author$project$MicroLaTeX$Expression$boostMeta = F2(
	function (lineNumber, meta) {
		return _Utils_update(
			meta,
			{
				id: A2($author$project$MicroLaTeX$Expression$makeId, lineNumber, 0)
			});
	});
var $author$project$MicroLaTeX$Expression$exprOfToken = F2(
	function (lineNumber, token) {
		switch (token.$) {
			case 'F':
				var str = token.a;
				var meta = token.b;
				return $elm$core$Maybe$Just(
					A3(
						$author$project$Generic$Language$Fun,
						str,
						_List_Nil,
						A2($author$project$MicroLaTeX$Expression$boostMeta, lineNumber, meta)));
			case 'S':
				var str = token.a;
				var meta = token.b;
				return $elm$core$Maybe$Just(
					A2(
						$author$project$Generic$Language$Text,
						str,
						A2($author$project$MicroLaTeX$Expression$boostMeta, lineNumber, meta)));
			case 'W':
				var str = token.a;
				var meta = token.b;
				return $elm$core$Maybe$Just(
					A2(
						$author$project$Generic$Language$Text,
						str,
						A2($author$project$MicroLaTeX$Expression$boostMeta, lineNumber, meta)));
			default:
				return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$MicroLaTeX$Expression$commit = F2(
	function (token, state) {
		var _v0 = A2($author$project$MicroLaTeX$Expression$exprOfToken, state.lineNumber, token);
		if (_v0.$ === 'Nothing') {
			return state;
		} else {
			var expr = _v0.a;
			return _Utils_update(
				state,
				{
					committed: A2($elm$core$List$cons, expr, state.committed)
				});
		}
	});
var $author$project$MicroLaTeX$Expression$pushOnStack = F2(
	function (token, state) {
		return _Utils_update(
			state,
			{
				stack: A2($elm$core$List$cons, token, state.stack)
			});
	});
var $author$project$MicroLaTeX$Expression$push = F2(
	function (token, state) {
		return _Utils_update(
			state,
			{
				stack: A2($elm$core$List$cons, token, state.stack)
			});
	});
var $author$project$MicroLaTeX$Expression$pushOrCommit = F2(
	function (token, state) {
		return $elm$core$List$isEmpty(state.stack) ? A2($author$project$MicroLaTeX$Expression$commit, token, state) : A2($author$project$MicroLaTeX$Expression$push, token, state);
	});
var $author$project$MicroLaTeX$Expression$pushToken = F2(
	function (token, state) {
		switch (token.$) {
			case 'S':
				return A2($author$project$MicroLaTeX$Expression$pushOrCommit, token, state);
			case 'F':
				return A2($author$project$MicroLaTeX$Expression$commit, token, state);
			case 'W':
				return A2($author$project$MicroLaTeX$Expression$pushOrCommit, token, state);
			case 'MathToken':
				return A2($author$project$MicroLaTeX$Expression$pushOnStack, token, state);
			case 'LMathBracket':
				return A2($author$project$MicroLaTeX$Expression$pushOnStack, token, state);
			case 'RMathBracket':
				return A2($author$project$MicroLaTeX$Expression$pushOnStack, token, state);
			case 'CodeToken':
				return A2($author$project$MicroLaTeX$Expression$pushOnStack, token, state);
			case 'BS':
				return A2($author$project$MicroLaTeX$Expression$pushOnStack, token, state);
			case 'LB':
				return A2($author$project$MicroLaTeX$Expression$pushOnStack, token, state);
			case 'RB':
				return A2($author$project$MicroLaTeX$Expression$pushOnStack, token, state);
			default:
				return A2($author$project$MicroLaTeX$Expression$pushOnStack, token, state);
		}
	});
var $author$project$MicroLaTeX$Expression$dummyTokenIndex = 0;
var $author$project$MicroLaTeX$Expression$dummyLocWithId = {begin: 0, end: 0, id: 'dummy (3)', index: $author$project$MicroLaTeX$Expression$dummyTokenIndex};
var $author$project$MicroLaTeX$Expression$errorMessage = function (message) {
	return A3(
		$author$project$Generic$Language$Fun,
		'errorHighlight',
		_List_fromArray(
			[
				A2($author$project$Generic$Language$Text, message, $author$project$MicroLaTeX$Expression$dummyLocWithId)
			]),
		$author$project$MicroLaTeX$Expression$dummyLocWithId);
};
var $author$project$MicroLaTeX$Expression$errorMessage2 = function (message) {
	return A3(
		$author$project$Generic$Language$Fun,
		'blue',
		_List_fromArray(
			[
				A2($author$project$Generic$Language$Text, message, $author$project$MicroLaTeX$Expression$dummyLocWithId)
			]),
		$author$project$MicroLaTeX$Expression$dummyLocWithId);
};
var $author$project$MicroLaTeX$Expression$errorMessageBold = function (message) {
	return A3(
		$author$project$Generic$Language$Fun,
		'bold',
		_List_fromArray(
			[
				A3(
				$author$project$Generic$Language$Fun,
				'red',
				_List_fromArray(
					[
						A2($author$project$Generic$Language$Text, message, $author$project$MicroLaTeX$Expression$dummyLocWithId)
					]),
				$author$project$MicroLaTeX$Expression$dummyLocWithId)
			]),
		$author$project$MicroLaTeX$Expression$dummyLocWithId);
};
var $author$project$MicroLaTeX$Expression$errorSuffix = function (rest) {
	if (!rest.b) {
		return ']?';
	} else {
		if ((rest.a.$ === 'W') && (!rest.b.b)) {
			var _v1 = rest.a;
			return ']?';
		} else {
			return '';
		}
	}
};
var $elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2($elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var $elm$core$List$takeTailRec = F2(
	function (n, list) {
		return $elm$core$List$reverse(
			A3($elm$core$List$takeReverse, n, list, _List_Nil));
	});
var $elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _v0 = _Utils_Tuple2(n, list);
			_v0$1:
			while (true) {
				_v0$5:
				while (true) {
					if (!_v0.b.b) {
						return list;
					} else {
						if (_v0.b.b.b) {
							switch (_v0.a) {
								case 1:
									break _v0$1;
								case 2:
									var _v2 = _v0.b;
									var x = _v2.a;
									var _v3 = _v2.b;
									var y = _v3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_v0.b.b.b.b) {
										var _v4 = _v0.b;
										var x = _v4.a;
										var _v5 = _v4.b;
										var y = _v5.a;
										var _v6 = _v5.b;
										var z = _v6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _v0$5;
									}
								default:
									if (_v0.b.b.b.b && _v0.b.b.b.b.b) {
										var _v7 = _v0.b;
										var x = _v7.a;
										var _v8 = _v7.b;
										var y = _v8.a;
										var _v9 = _v8.b;
										var z = _v9.a;
										var _v10 = _v9.b;
										var w = _v10.a;
										var tl = _v10.b;
										return (ctr > 1000) ? A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A2($elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A3($elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _v0$5;
									}
							}
						} else {
							if (_v0.a === 1) {
								break _v0$1;
							} else {
								break _v0$5;
							}
						}
					}
				}
				return list;
			}
			var _v1 = _v0.b;
			var x = _v1.a;
			return _List_fromArray(
				[x]);
		}
	});
var $elm$core$List$take = F2(
	function (n, list) {
		return A3($elm$core$List$takeFast, 0, n, list);
	});
var $author$project$MicroLaTeX$Helpers$prependMessage = F3(
	function (lineNumber, message, messages) {
		return A2(
			$elm$core$List$cons,
			message + (' (line ' + ($elm$core$String$fromInt(lineNumber) + ')')),
			A2($elm$core$List$take, 2, messages));
	});
var $author$project$MicroLaTeX$Token$RB = function (a) {
	return {$: 'RB', a: a};
};
var $author$project$MicroLaTeX$Expression$addErrorMessage = F2(
	function (message, state) {
		var committed = A2(
			$elm$core$List$cons,
			$author$project$MicroLaTeX$Expression$errorMessage(message),
			state.committed);
		return _Utils_update(
			state,
			{committed: committed});
	});
var $elm$core$List$sum = function (numbers) {
	return A3($elm$core$List$foldl, $elm$core$Basics$add, 0, numbers);
};
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $author$project$MicroLaTeX$Symbol$value = function (symbol) {
	switch (symbol.$) {
		case 'B':
			return 0;
		case 'L':
			return 1;
		case 'R':
			return -1;
		case 'St':
			return 0;
		case 'M':
			return 0;
		case 'LM':
			return 1;
		case 'RM':
			return -1;
		case 'C':
			return 0;
		case 'Fn':
			return 0;
		case 'Ws':
			return 0;
		default:
			return 0;
	}
};
var $author$project$MicroLaTeX$Symbol$balance = function (symbols) {
	return $elm$core$List$sum(
		A2($elm$core$List$map, $author$project$MicroLaTeX$Symbol$value, symbols));
};
var $author$project$MicroLaTeX$Expression$boostMeta_ = F3(
	function (lineNumber, tokenIndex, _v0) {
		var begin = _v0.begin;
		var end = _v0.end;
		var index = _v0.index;
		return {
			begin: begin,
			end: end,
			id: A2($author$project$MicroLaTeX$Expression$makeId, lineNumber, tokenIndex),
			index: index
		};
	});
var $author$project$MicroLaTeX$Expression$braceErrorAsString = function (k) {
	return (k < 0) ? ('Too many right braces (' + ($elm$core$String$fromInt(-k) + ')')) : ('Too many left braces (' + ($elm$core$String$fromInt(k) + ')'));
};
var $elm$core$List$repeatHelp = F3(
	function (result, n, value) {
		repeatHelp:
		while (true) {
			if (n <= 0) {
				return result;
			} else {
				var $temp$result = A2($elm$core$List$cons, value, result),
					$temp$n = n - 1,
					$temp$value = value;
				result = $temp$result;
				n = $temp$n;
				value = $temp$value;
				continue repeatHelp;
			}
		}
	});
var $elm$core$List$repeat = F2(
	function (n, value) {
		return A3($elm$core$List$repeatHelp, _List_Nil, n, value);
	});
var $author$project$MicroLaTeX$Expression$bracketError = function (k) {
	if (k < 0) {
		var brackets = A2(
			$elm$core$String$join,
			'',
			A2($elm$core$List$repeat, -k, ']'));
		return $author$project$MicroLaTeX$Expression$errorMessage(' ' + ('\\' + (brackets + '?')));
	} else {
		var brackets = A2(
			$elm$core$String$join,
			'',
			A2($elm$core$List$repeat, k, '['));
		return $author$project$MicroLaTeX$Expression$errorMessage(' ' + ('\\' + (brackets + '?')));
	}
};
var $author$project$MicroLaTeX$Symbol$B = {$: 'B'};
var $author$project$MicroLaTeX$Symbol$C = {$: 'C'};
var $author$project$MicroLaTeX$Symbol$Fn = {$: 'Fn'};
var $author$project$MicroLaTeX$Symbol$L = {$: 'L'};
var $author$project$MicroLaTeX$Symbol$LM = {$: 'LM'};
var $author$project$MicroLaTeX$Symbol$M = {$: 'M'};
var $author$project$MicroLaTeX$Symbol$R = {$: 'R'};
var $author$project$MicroLaTeX$Symbol$RM = {$: 'RM'};
var $author$project$MicroLaTeX$Symbol$St = {$: 'St'};
var $author$project$MicroLaTeX$Symbol$TEs = {$: 'TEs'};
var $author$project$MicroLaTeX$Symbol$Ws = {$: 'Ws'};
var $author$project$MicroLaTeX$Symbol$toSymbol2 = function (token) {
	switch (token.$) {
		case 'BS':
			return $author$project$MicroLaTeX$Symbol$B;
		case 'LB':
			return $author$project$MicroLaTeX$Symbol$L;
		case 'RB':
			return $author$project$MicroLaTeX$Symbol$R;
		case 'MathToken':
			return $author$project$MicroLaTeX$Symbol$M;
		case 'LMathBracket':
			return $author$project$MicroLaTeX$Symbol$LM;
		case 'RMathBracket':
			return $author$project$MicroLaTeX$Symbol$RM;
		case 'CodeToken':
			return $author$project$MicroLaTeX$Symbol$C;
		case 'S':
			return $author$project$MicroLaTeX$Symbol$St;
		case 'F':
			return $author$project$MicroLaTeX$Symbol$Fn;
		case 'W':
			return $author$project$MicroLaTeX$Symbol$Ws;
		default:
			return $author$project$MicroLaTeX$Symbol$TEs;
	}
};
var $author$project$MicroLaTeX$Symbol$convertTokens2 = function (tokens) {
	return A2($elm$core$List$map, $author$project$MicroLaTeX$Symbol$toSymbol2, tokens);
};
var $author$project$MicroLaTeX$Expression$dummyLoc = {begin: 0, end: 0, index: $author$project$MicroLaTeX$Expression$dummyTokenIndex};
var $author$project$MicroLaTeX$Token$TLB = {$: 'TLB'};
var $elm$core$Basics$neq = _Utils_notEqual;
var $elm_community$list_extra$List$Extra$takeWhile = function (predicate) {
	var takeWhileMemo = F2(
		function (memo, list) {
			takeWhileMemo:
			while (true) {
				if (!list.b) {
					return $elm$core$List$reverse(memo);
				} else {
					var x = list.a;
					var xs = list.b;
					if (predicate(x)) {
						var $temp$memo = A2($elm$core$List$cons, x, memo),
							$temp$list = xs;
						memo = $temp$memo;
						list = $temp$list;
						continue takeWhileMemo;
					} else {
						return $elm$core$List$reverse(memo);
					}
				}
			}
		});
	return takeWhileMemo(_List_Nil);
};
var $author$project$MicroLaTeX$Match$getSegment = F2(
	function (sym, symbols) {
		var seg_ = A2(
			$elm_community$list_extra$List$Extra$takeWhile,
			function (sym_) {
				return !_Utils_eq(sym_, sym);
			},
			A2($elm$core$List$drop, 1, symbols));
		var n = $elm$core$List$length(seg_);
		var _v0 = A2($elm_community$list_extra$List$Extra$getAt, n + 1, symbols);
		if (_v0.$ === 'Nothing') {
			return A2($elm$core$List$cons, sym, seg_);
		} else {
			var last = _v0.a;
			return A2(
				$elm$core$List$cons,
				sym,
				_Utils_ap(
					seg_,
					_List_fromArray(
						[last])));
		}
	});
var $elm_community$list_extra$List$Extra$last = function (items) {
	last:
	while (true) {
		if (!items.b) {
			return $elm$core$Maybe$Nothing;
		} else {
			if (!items.b.b) {
				var x = items.a;
				return $elm$core$Maybe$Just(x);
			} else {
				var rest = items.b;
				var $temp$items = rest;
				items = $temp$items;
				continue last;
			}
		}
	}
};
var $author$project$MicroLaTeX$Util$dropLast = function (list) {
	var n = $elm$core$List$length(list);
	return A2($elm$core$List$take, n - 1, list);
};
var $author$project$MicroLaTeX$Util$middle = function (list) {
	return $author$project$MicroLaTeX$Util$dropLast(
		A2($elm$core$List$drop, 1, list));
};
var $author$project$Tools$Loop$loop = F2(
	function (s, f) {
		loop:
		while (true) {
			var _v0 = f(s);
			if (_v0.$ === 'Loop') {
				var s_ = _v0.a;
				var $temp$s = s_,
					$temp$f = f;
				s = $temp$s;
				f = $temp$f;
				continue loop;
			} else {
				var b = _v0.a;
				return b;
			}
		}
	});
var $elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var $elm$core$List$member = F2(
	function (x, xs) {
		return A2(
			$elm$core$List$any,
			function (a) {
				return _Utils_eq(a, x);
			},
			xs);
	});
var $author$project$Tools$Loop$Done = function (a) {
	return {$: 'Done', a: a};
};
var $author$project$Tools$Loop$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $author$project$MicroLaTeX$Match$nextStep = function (state) {
	var _v0 = $elm$core$List$head(state.symbols);
	if (_v0.$ === 'Nothing') {
		return $author$project$Tools$Loop$Done($elm$core$Maybe$Nothing);
	} else {
		var sym = _v0.a;
		var brackets = state.brackets + $author$project$MicroLaTeX$Symbol$value(sym);
		return (brackets < 0) ? $author$project$Tools$Loop$Done($elm$core$Maybe$Nothing) : ((!brackets) ? $author$project$Tools$Loop$Done(
			$elm$core$Maybe$Just(state.index)) : $author$project$Tools$Loop$Loop(
			{
				brackets: brackets,
				index: state.index + 1,
				symbols: A2($elm$core$List$drop, 1, state.symbols)
			}));
	}
};
var $author$project$MicroLaTeX$Match$match = function (symbols) {
	var _v0 = $elm$core$List$head(symbols);
	if (_v0.$ === 'Nothing') {
		return $elm$core$Maybe$Nothing;
	} else {
		var symbol = _v0.a;
		return A2(
			$elm$core$List$member,
			symbol,
			_List_fromArray(
				[$author$project$MicroLaTeX$Symbol$C, $author$project$MicroLaTeX$Symbol$M])) ? $elm$core$Maybe$Just(
			$elm$core$List$length(
				A2($author$project$MicroLaTeX$Match$getSegment, symbol, symbols)) - 1) : (($author$project$MicroLaTeX$Symbol$value(symbol) < 0) ? $elm$core$Maybe$Nothing : A2(
			$author$project$Tools$Loop$loop,
			{
				brackets: $author$project$MicroLaTeX$Symbol$value(symbol),
				index: 1,
				symbols: A2($elm$core$List$drop, 1, symbols)
			},
			$author$project$MicroLaTeX$Match$nextStep));
	}
};
var $author$project$MicroLaTeX$Match$splitAt = F2(
	function (k, list) {
		return _Utils_Tuple2(
			A2($elm$core$List$take, k, list),
			A2($elm$core$List$drop, k, list));
	});
var $author$project$MicroLaTeX$Match$split = function (symbols) {
	var _v0 = $author$project$MicroLaTeX$Match$match(symbols);
	if (_v0.$ === 'Nothing') {
		return $elm$core$Maybe$Nothing;
	} else {
		var k = _v0.a;
		return $elm$core$Maybe$Just(
			A2($author$project$MicroLaTeX$Match$splitAt, k + 1, symbols));
	}
};
var $author$project$MicroLaTeX$Match$hasReducibleArgs = function (symbols) {
	hasReducibleArgs:
	while (true) {
		_v15$7:
		while (true) {
			if (!symbols.b) {
				return true;
			} else {
				switch (symbols.a.$) {
					case 'LM':
						if (((symbols.b.b && (symbols.b.a.$ === 'St')) && symbols.b.b.b) && (symbols.b.b.a.$ === 'RM')) {
							var _v16 = symbols.a;
							var _v17 = symbols.b;
							var _v18 = _v17.a;
							var _v19 = _v17.b;
							var _v20 = _v19.a;
							var _v21 = $author$project$MicroLaTeX$Match$split(symbols);
							if (_v21.$ === 'Nothing') {
								return false;
							} else {
								var _v22 = _v21.a;
								var a = _v22.a;
								var b = _v22.b;
								return $author$project$MicroLaTeX$Match$hasReducibleArgs(
									$author$project$MicroLaTeX$Util$middle(a)) && $author$project$MicroLaTeX$Match$hasReducibleArgs(b);
							}
						} else {
							break _v15$7;
						}
					case 'L':
						var _v23 = symbols.a;
						var _v24 = $author$project$MicroLaTeX$Match$split(symbols);
						if (_v24.$ === 'Nothing') {
							return false;
						} else {
							var _v25 = _v24.a;
							var a = _v25.a;
							var b = _v25.b;
							return $author$project$MicroLaTeX$Match$hasReducibleArgs(
								$author$project$MicroLaTeX$Util$middle(a)) && $author$project$MicroLaTeX$Match$hasReducibleArgs(b);
						}
					case 'C':
						var _v26 = symbols.a;
						return $author$project$MicroLaTeX$Match$reducibleAux(symbols);
					case 'M':
						var _v27 = symbols.a;
						var seg = A2($author$project$MicroLaTeX$Match$getSegment, $author$project$MicroLaTeX$Symbol$M, symbols);
						if ($author$project$MicroLaTeX$Match$reducible(seg)) {
							var $temp$symbols = A2(
								$elm$core$List$drop,
								$elm$core$List$length(seg),
								symbols);
							symbols = $temp$symbols;
							continue hasReducibleArgs;
						} else {
							return false;
						}
					case 'B':
						var _v28 = symbols.a;
						var rest = symbols.b;
						var $temp$symbols = rest;
						symbols = $temp$symbols;
						continue hasReducibleArgs;
					case 'St':
						var _v29 = symbols.a;
						var rest = symbols.b;
						var $temp$symbols = rest;
						symbols = $temp$symbols;
						continue hasReducibleArgs;
					default:
						break _v15$7;
				}
			}
		}
		return false;
	}
};
var $author$project$MicroLaTeX$Match$reducible = function (symbols) {
	_v2$4:
	while (true) {
		if (symbols.b) {
			switch (symbols.a.$) {
				case 'LM':
					if ((((symbols.b.b && (symbols.b.a.$ === 'St')) && symbols.b.b.b) && (symbols.b.b.a.$ === 'RM')) && (!symbols.b.b.b.b)) {
						var _v3 = symbols.a;
						var _v4 = symbols.b;
						var _v5 = _v4.a;
						var _v6 = _v4.b;
						var _v7 = _v6.a;
						return true;
					} else {
						break _v2$4;
					}
				case 'M':
					var _v8 = symbols.a;
					var rest = symbols.b;
					return _Utils_eq(
						$elm$core$List$head(
							$elm$core$List$reverse(rest)),
						$elm$core$Maybe$Just($author$project$MicroLaTeX$Symbol$M));
				case 'C':
					var _v9 = symbols.a;
					var rest = symbols.b;
					return _Utils_eq(
						$elm$core$List$head(
							$elm$core$List$reverse(rest)),
						$elm$core$Maybe$Just($author$project$MicroLaTeX$Symbol$C));
				case 'B':
					if (symbols.b.b && (symbols.b.a.$ === 'St')) {
						var _v10 = symbols.a;
						var _v11 = symbols.b;
						var _v12 = _v11.a;
						var rest = _v11.b;
						var _v13 = $elm_community$list_extra$List$Extra$last(rest);
						if ((_v13.$ === 'Just') && (_v13.a.$ === 'R')) {
							var _v14 = _v13.a;
							return $author$project$MicroLaTeX$Match$hasReducibleArgs(rest);
						} else {
							return false;
						}
					} else {
						break _v2$4;
					}
				default:
					break _v2$4;
			}
		} else {
			break _v2$4;
		}
	}
	return false;
};
var $author$project$MicroLaTeX$Match$reducibleAux = function (symbols) {
	var _v0 = $author$project$MicroLaTeX$Match$split(symbols);
	if (_v0.$ === 'Nothing') {
		return false;
	} else {
		var _v1 = _v0.a;
		var a = _v1.a;
		var b = _v1.b;
		return $author$project$MicroLaTeX$Match$reducible(a) && $author$project$MicroLaTeX$Match$hasReducibleArgs(b);
	}
};
var $author$project$MicroLaTeX$Expression$isReducible = function (tokens) {
	var symbols = $author$project$MicroLaTeX$Symbol$convertTokens2(
		$elm$core$List$reverse(tokens));
	return _Utils_eq(symbols, _List_Nil) ? false : $author$project$MicroLaTeX$Match$reducible(symbols);
};
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $elm$core$Basics$not = _Basics_not;
var $rtfeldman$console_print$Console$bgYellow = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[43m', str, '\u001B[49m']));
};
var $author$project$MicroLaTeX$LogTools$forklogYellow = F4(
	function (label, width, f, a) {
		return A6($author$project$MicroLaTeX$LogTools$forklog_, $rtfeldman$console_print$Console$black, $rtfeldman$console_print$Console$bgYellow, label, width, f, a);
	});
var $author$project$Generic$Language$VFun = F3(
	function (a, b, c) {
		return {$: 'VFun', a: a, b: b, c: c};
	});
var $elm$core$String$dropRight = F2(
	function (n, string) {
		return (n < 1) ? string : A3($elm$core$String$slice, 0, -n, string);
	});
var $elm$core$String$replace = F3(
	function (before, after, string) {
		return A2(
			$elm$core$String$join,
			after,
			A2($elm$core$String$split, before, string));
	});
var $elm$core$String$right = F2(
	function (n, string) {
		return (n < 1) ? '' : A3(
			$elm$core$String$slice,
			-n,
			$elm$core$String$length(string),
			string);
	});
var $author$project$MicroLaTeX$Token$stringValue = function (token) {
	switch (token.$) {
		case 'BS':
			return '\\';
		case 'F':
			return 'F';
		case 'LB':
			return '{';
		case 'RB':
			return '}';
		case 'LMathBracket':
			return '\\(';
		case 'RMathBracket':
			return '\\)';
		case 'S':
			var str = token.a;
			return str;
		case 'W':
			var str = token.a;
			return str;
		case 'MathToken':
			return '$';
		case 'CodeToken':
			return '`';
		default:
			return 'tokenError';
	}
};
var $author$project$MicroLaTeX$Token$toString = function (tokens) {
	return A2(
		$elm$core$String$join,
		'',
		A2($elm$core$List$map, $author$project$MicroLaTeX$Token$stringValue, tokens));
};
var $author$project$MicroLaTeX$Expression$handleBracketedMath = function (state) {
	var content = $author$project$MicroLaTeX$Token$toString(
		$elm$core$List$reverse(state.stack));
	var trailing = A2($elm$core$String$right, 1, content);
	var committed = (trailing === ')') ? A2(
		$elm$core$List$cons,
		A3(
			$author$project$Generic$Language$VFun,
			'math',
			A2(
				$elm$core$String$dropRight,
				2,
				A2($elm$core$String$dropLeft, 2, content)),
			A3(
				$author$project$MicroLaTeX$Expression$boostMeta_,
				state.tokenIndex,
				2,
				{begin: 0, end: 0, index: 0})),
		state.committed) : A2(
		$elm$core$List$cons,
		A3(
			$author$project$Generic$Language$Fun,
			'red',
			_List_fromArray(
				[
					A2($author$project$Generic$Language$Text, '$', $author$project$MicroLaTeX$Expression$dummyLocWithId)
				]),
			$author$project$MicroLaTeX$Expression$dummyLocWithId),
		A2(
			$elm$core$List$cons,
			A3(
				$author$project$Generic$Language$VFun,
				'math',
				A3($elm$core$String$replace, '$', '', content),
				{
					begin: 0,
					end: 0,
					id: A2($author$project$MicroLaTeX$Expression$makeId, state.lineNumber, state.tokenIndex),
					index: 0
				}),
			state.committed));
	return _Utils_update(
		state,
		{committed: committed, stack: _List_Nil});
};
var $author$project$MicroLaTeX$Expression$handleCode = function (state) {
	var content = $author$project$MicroLaTeX$Token$toString(
		$elm$core$List$reverse(state.stack));
	var trailing = A2($elm$core$String$right, 1, content);
	var committed = function () {
		if ((trailing === '`') && (content === '`')) {
			var _v0 = function () {
				var _v1 = state.committed;
				if (_v1.b) {
					var first = _v1.a;
					var rest = _v1.b;
					return _Utils_Tuple2(first, rest);
				} else {
					return _Utils_Tuple2(
						A3(
							$author$project$Generic$Language$Fun,
							'red',
							_List_fromArray(
								[
									A2(
									$author$project$Generic$Language$Text,
									'????(4)',
									A3($author$project$MicroLaTeX$Expression$boostMeta_, state.lineNumber, state.tokenIndex, $author$project$MicroLaTeX$Expression$dummyLoc))
								]),
							$author$project$MicroLaTeX$Expression$dummyLocWithId),
						_List_Nil);
				}
			}();
			var first_ = _v0.a;
			var rest_ = _v0.b;
			return A2(
				$elm$core$List$cons,
				first_,
				A2(
					$elm$core$List$cons,
					A3(
						$author$project$Generic$Language$Fun,
						'red',
						_List_fromArray(
							[
								A2(
								$author$project$Generic$Language$Text,
								'`',
								A3($author$project$MicroLaTeX$Expression$boostMeta_, state.lineNumber, state.tokenIndex, $author$project$MicroLaTeX$Expression$dummyLoc))
							]),
						$author$project$MicroLaTeX$Expression$dummyLocWithId),
					rest_));
		} else {
			if (trailing === '`') {
				return A2(
					$elm$core$List$cons,
					A3(
						$author$project$Generic$Language$VFun,
						'code',
						A3($elm$core$String$replace, '`', '', content),
						A3(
							$author$project$MicroLaTeX$Expression$boostMeta_,
							state.lineNumber,
							state.tokenIndex,
							{begin: 0, end: 0, index: 0})),
					state.committed);
			} else {
				return A2(
					$elm$core$List$cons,
					A3(
						$author$project$Generic$Language$Fun,
						'red',
						_List_fromArray(
							[
								A2($author$project$Generic$Language$Text, '`', $author$project$MicroLaTeX$Expression$dummyLocWithId)
							]),
						$author$project$MicroLaTeX$Expression$dummyLocWithId),
					A2(
						$elm$core$List$cons,
						A3(
							$author$project$Generic$Language$VFun,
							'code',
							A3($elm$core$String$replace, '`', '', content),
							A3(
								$author$project$MicroLaTeX$Expression$boostMeta_,
								state.lineNumber,
								state.tokenIndex,
								{begin: 0, end: 0, index: 0})),
						state.committed));
			}
		}
	}();
	return _Utils_update(
		state,
		{committed: committed, stack: _List_Nil});
};
var $author$project$MicroLaTeX$Expression$handleMath = function (state) {
	var _v0 = state.stack;
	if ((((((_v0.b && (_v0.a.$ === 'MathToken')) && _v0.b.b) && (_v0.b.a.$ === 'S')) && _v0.b.b.b) && (_v0.b.b.a.$ === 'MathToken')) && (!_v0.b.b.b.b)) {
		var _v1 = _v0.b;
		var _v2 = _v1.a;
		var str = _v2.a;
		var m2 = _v2.b;
		var _v3 = _v1.b;
		return _Utils_update(
			state,
			{
				committed: A2(
					$elm$core$List$cons,
					A3(
						$author$project$Generic$Language$VFun,
						'math',
						str,
						A2($author$project$MicroLaTeX$Expression$boostMeta, state.lineNumber, m2)),
					state.committed),
				stack: _List_Nil
			});
	} else {
		return state;
	}
};
var $author$project$MicroLaTeX$Token$BS = function (a) {
	return {$: 'BS', a: a};
};
var $author$project$MicroLaTeX$Token$RMathBracket = function (a) {
	return {$: 'RMathBracket', a: a};
};
var $author$project$MicroLaTeX$Expression$errorMessage1Part = function (a) {
	return A3(
		$author$project$Generic$Language$Fun,
		'errorHighlight',
		_List_fromArray(
			[
				A2($author$project$Generic$Language$Text, a, $author$project$MicroLaTeX$Expression$dummyLocWithId)
			]),
		$author$project$MicroLaTeX$Expression$dummyLocWithId);
};
var $author$project$MicroLaTeX$Expression$errorMessage3Part = F3(
	function (a, b, c) {
		return _List_fromArray(
			[
				A3(
				$author$project$Generic$Language$Fun,
				'blue',
				_List_fromArray(
					[
						A2($author$project$Generic$Language$Text, a, $author$project$MicroLaTeX$Expression$dummyLocWithId)
					]),
				$author$project$MicroLaTeX$Expression$dummyLocWithId),
				A3(
				$author$project$Generic$Language$Fun,
				'errorHighlight',
				_List_fromArray(
					[
						A2($author$project$Generic$Language$Text, b, $author$project$MicroLaTeX$Expression$dummyLocWithId)
					]),
				$author$project$MicroLaTeX$Expression$dummyLocWithId),
				A3(
				$author$project$Generic$Language$Fun,
				'errorHighlight',
				_List_fromArray(
					[
						A2($author$project$Generic$Language$Text, c, $author$project$MicroLaTeX$Expression$dummyLocWithId)
					]),
				$author$project$MicroLaTeX$Expression$dummyLocWithId)
			]);
	});
var $author$project$MicroLaTeX$Expression$isLBToken = function (maybeTok) {
	if ((maybeTok.$ === 'Just') && (maybeTok.a.$ === 'LB')) {
		return true;
	} else {
		return false;
	}
};
var $author$project$MicroLaTeX$Expression$split = function (tokens) {
	var _v0 = $author$project$MicroLaTeX$Match$match(
		$author$project$MicroLaTeX$Symbol$convertTokens2(tokens));
	if (_v0.$ === 'Nothing') {
		return _Utils_Tuple2(tokens, _List_Nil);
	} else {
		var k = _v0.a;
		return A2($author$project$MicroLaTeX$Match$splitAt, k + 1, tokens);
	}
};
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$MicroLaTeX$Expression$reduceRestOfTokens = F3(
	function (macroName, lineNumber, tokens) {
		_v10$5:
		while (true) {
			if (tokens.b) {
				switch (tokens.a.$) {
					case 'BS':
						return A2($author$project$MicroLaTeX$Expression$reduceTokens, lineNumber, tokens);
					case 'S':
						var _v11 = tokens.a;
						var str = _v11.a;
						var m1 = _v11.b;
						var rest = tokens.b;
						return A2(
							$elm$core$List$cons,
							A2(
								$author$project$Generic$Language$Text,
								str,
								A2($author$project$MicroLaTeX$Expression$boostMeta, lineNumber, m1)),
							A3($author$project$MicroLaTeX$Expression$reduceRestOfTokens, $elm$core$Maybe$Nothing, lineNumber, rest));
					case 'LB':
						var _v12 = $author$project$MicroLaTeX$Match$match(
							$author$project$MicroLaTeX$Symbol$convertTokens2(tokens));
						if (_v12.$ === 'Nothing') {
							return A3(
								$author$project$MicroLaTeX$Expression$errorMessage3Part,
								'\\' + A2($elm$core$Maybe$withDefault, 'x', macroName),
								$author$project$MicroLaTeX$Token$toString(tokens),
								' ?}');
						} else {
							var k = _v12.a;
							var _v13 = A2($author$project$MicroLaTeX$Match$splitAt, k + 1, tokens);
							var a = _v13.a;
							var b = _v13.b;
							var aa = A2(
								$elm$core$List$drop,
								1,
								A2(
									$elm$core$List$take,
									$elm$core$List$length(a) - 1,
									a));
							return _Utils_ap(
								A2($author$project$MicroLaTeX$Expression$reduceTokens, lineNumber, aa),
								A3($author$project$MicroLaTeX$Expression$reduceRestOfTokens, $elm$core$Maybe$Nothing, lineNumber, b));
						}
					case 'MathToken':
						if (((tokens.b.b && (tokens.b.a.$ === 'S')) && tokens.b.b.b) && (tokens.b.b.a.$ === 'MathToken')) {
							var _v14 = tokens.b;
							var _v15 = _v14.a;
							var str = _v15.a;
							var m2 = _v15.b;
							var _v16 = _v14.b;
							var more = _v16.b;
							return A2(
								$elm$core$List$cons,
								A3(
									$author$project$Generic$Language$VFun,
									'math',
									str,
									A2($author$project$MicroLaTeX$Expression$boostMeta, lineNumber, m2)),
								A3($author$project$MicroLaTeX$Expression$reduceRestOfTokens, $elm$core$Maybe$Nothing, lineNumber, more));
						} else {
							break _v10$5;
						}
					case 'LMathBracket':
						if (((tokens.b.b && (tokens.b.a.$ === 'S')) && tokens.b.b.b) && (tokens.b.b.a.$ === 'RMathBracket')) {
							var _v17 = tokens.b;
							var _v18 = _v17.a;
							var str = _v18.a;
							var m2 = _v18.b;
							var _v19 = _v17.b;
							var more = _v19.b;
							return A2(
								$elm$core$List$cons,
								A3(
									$author$project$Generic$Language$VFun,
									'math',
									str,
									A2($author$project$MicroLaTeX$Expression$boostMeta, lineNumber, m2)),
								A3($author$project$MicroLaTeX$Expression$reduceRestOfTokens, $elm$core$Maybe$Nothing, lineNumber, more));
						} else {
							break _v10$5;
						}
					default:
						break _v10$5;
				}
			} else {
				return _List_Nil;
			}
		}
		var token = tokens.a;
		var more = tokens.b;
		var _v20 = A2($author$project$MicroLaTeX$Expression$exprOfToken, lineNumber, token);
		if (_v20.$ === 'Just') {
			var expr = _v20.a;
			return A2(
				$elm$core$List$cons,
				expr,
				A3($author$project$MicroLaTeX$Expression$reduceRestOfTokens, $elm$core$Maybe$Nothing, lineNumber, more));
		} else {
			return _List_fromArray(
				[
					$author$project$MicroLaTeX$Expression$errorMessage('•••?(7)')
				]);
		}
	});
var $author$project$MicroLaTeX$Expression$reduceTokens = F2(
	function (lineNumber, tokens) {
		_v0$4:
		while (true) {
			if (tokens.b) {
				switch (tokens.a.$) {
					case 'S':
						if (tokens.b.b && (tokens.b.a.$ === 'BS')) {
							var _v1 = tokens.a;
							var t = _v1.a;
							var m1 = _v1.b;
							var _v2 = tokens.b;
							var m2 = _v2.a.a;
							var rest = _v2.b;
							return A2(
								$elm$core$List$cons,
								A2(
									$author$project$Generic$Language$Text,
									t,
									A2($author$project$MicroLaTeX$Expression$boostMeta, lineNumber, m1)),
								A2(
									$author$project$MicroLaTeX$Expression$reduceTokens,
									lineNumber,
									A2(
										$elm$core$List$cons,
										$author$project$MicroLaTeX$Token$BS(m2),
										rest)));
						} else {
							var _v3 = tokens.a;
							var t = _v3.a;
							var m2 = _v3.b;
							var rest = tokens.b;
							return A2(
								$elm$core$List$cons,
								A2(
									$author$project$Generic$Language$Text,
									t,
									A2($author$project$MicroLaTeX$Expression$boostMeta, lineNumber, m2)),
								A3($author$project$MicroLaTeX$Expression$reduceRestOfTokens, $elm$core$Maybe$Nothing, lineNumber, rest));
						}
					case 'LMathBracket':
						if (((tokens.b.b && (tokens.b.a.$ === 'S')) && tokens.b.b.b) && (tokens.b.b.a.$ === 'RMathBracket')) {
							var m1 = tokens.a.a;
							var _v4 = tokens.b;
							var _v5 = _v4.a;
							var str = _v5.a;
							var m2 = _v5.b;
							var _v6 = _v4.b;
							var m3 = _v6.a.a;
							var rest = _v6.b;
							return A2(
								$elm$core$List$cons,
								A3(
									$author$project$Generic$Language$VFun,
									'math',
									str,
									A2($author$project$MicroLaTeX$Expression$boostMeta, lineNumber, m2)),
								A2(
									$author$project$MicroLaTeX$Expression$reduceTokens,
									lineNumber,
									A2(
										$elm$core$List$cons,
										$author$project$MicroLaTeX$Token$RMathBracket(m3),
										rest)));
						} else {
							break _v0$4;
						}
					case 'BS':
						if (tokens.b.b && (tokens.b.a.$ === 'S')) {
							var m1 = tokens.a.a;
							var _v7 = tokens.b;
							var _v8 = _v7.a;
							var name = _v8.a;
							var rest = _v7.b;
							var _v9 = $author$project$MicroLaTeX$Expression$split(rest);
							var a = _v9.a;
							var b = _v9.b;
							return _Utils_eq(b, _List_Nil) ? _List_fromArray(
								[
									A3(
									$author$project$Generic$Language$Fun,
									name,
									A3(
										$author$project$MicroLaTeX$Expression$reduceRestOfTokens,
										$elm$core$Maybe$Just(name),
										lineNumber,
										rest),
									m1)
								]) : ($author$project$MicroLaTeX$Expression$isLBToken(
								$elm$core$List$head(b)) ? _List_fromArray(
								[
									A3(
									$author$project$Generic$Language$Fun,
									name,
									_Utils_ap(
										A3(
											$author$project$MicroLaTeX$Expression$reduceRestOfTokens,
											$elm$core$Maybe$Just(name),
											lineNumber,
											a),
										A3(
											$author$project$MicroLaTeX$Expression$reduceRestOfTokens,
											$elm$core$Maybe$Just(name),
											lineNumber,
											b)),
									m1)
								]) : _Utils_ap(
								_List_fromArray(
									[
										A3(
										$author$project$Generic$Language$Fun,
										name,
										A3(
											$author$project$MicroLaTeX$Expression$reduceRestOfTokens,
											$elm$core$Maybe$Just(name),
											lineNumber,
											a),
										m1)
									]),
								A3(
									$author$project$MicroLaTeX$Expression$reduceRestOfTokens,
									$elm$core$Maybe$Just(name),
									lineNumber,
									b)));
						} else {
							break _v0$4;
						}
					default:
						break _v0$4;
				}
			} else {
				break _v0$4;
			}
		}
		return _List_fromArray(
			[
				$author$project$MicroLaTeX$Expression$errorMessage1Part('{??}')
			]);
	});
var $author$project$MicroLaTeX$Expression$reduceState_ = function (state) {
	var symbols = A4(
		$author$project$MicroLaTeX$LogTools$forklogYellow,
		'Symbols (reduceState_)',
		12,
		$elm$core$Basics$identity,
		$elm$core$List$reverse(
			$author$project$MicroLaTeX$Symbol$convertTokens2(state.stack)));
	var _v0 = $elm$core$List$head(symbols);
	_v0$4:
	while (true) {
		if (_v0.$ === 'Just') {
			switch (_v0.a.$) {
				case 'B':
					var _v1 = _v0.a;
					var _v2 = A2(
						$author$project$MicroLaTeX$Expression$reduceTokens,
						state.lineNumber,
						$elm$core$List$reverse(state.stack));
					if (((((_v2.b && (_v2.a.$ === 'Fun')) && (_v2.a.a === 'ERROR')) && _v2.a.b.b) && (_v2.a.b.a.$ === 'Text')) && (!_v2.a.b.b.b)) {
						var _v3 = _v2.a;
						var _v4 = _v3.b;
						var _v5 = _v4.a;
						var message = _v5.a;
						var rest = _v2.b;
						return _Utils_update(
							state,
							{
								committed: _Utils_ap(rest, state.committed),
								messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, message, state.messages),
								stack: _List_Nil
							});
					} else {
						var exprs = _v2;
						return _Utils_update(
							state,
							{
								committed: _Utils_ap(exprs, state.committed),
								stack: _List_Nil
							});
					}
				case 'M':
					var _v6 = _v0.a;
					return $author$project$MicroLaTeX$Expression$handleMath(state);
				case 'LM':
					var _v7 = _v0.a;
					return $author$project$MicroLaTeX$Expression$handleBracketedMath(state);
				case 'C':
					var _v8 = _v0.a;
					return $author$project$MicroLaTeX$Expression$handleCode(state);
				default:
					break _v0$4;
			}
		} else {
			break _v0$4;
		}
	}
	return state;
};
var $author$project$MicroLaTeX$Token$TBS = {$: 'TBS'};
var $author$project$MicroLaTeX$Token$TCode = {$: 'TCode'};
var $author$project$MicroLaTeX$Token$TF = {$: 'TF'};
var $author$project$MicroLaTeX$Token$TLMathBrace = {$: 'TLMathBrace'};
var $author$project$MicroLaTeX$Token$TMath = {$: 'TMath'};
var $author$project$MicroLaTeX$Token$TRB = {$: 'TRB'};
var $author$project$MicroLaTeX$Token$TRMathBrace = {$: 'TRMathBrace'};
var $author$project$MicroLaTeX$Token$TS = {$: 'TS'};
var $author$project$MicroLaTeX$Token$TTokenError = {$: 'TTokenError'};
var $author$project$MicroLaTeX$Token$TW = {$: 'TW'};
var $author$project$MicroLaTeX$Token$type_ = function (token) {
	switch (token.$) {
		case 'BS':
			return $author$project$MicroLaTeX$Token$TBS;
		case 'F':
			return $author$project$MicroLaTeX$Token$TF;
		case 'LB':
			return $author$project$MicroLaTeX$Token$TLB;
		case 'RB':
			return $author$project$MicroLaTeX$Token$TRB;
		case 'LMathBracket':
			return $author$project$MicroLaTeX$Token$TLMathBrace;
		case 'RMathBracket':
			return $author$project$MicroLaTeX$Token$TRMathBrace;
		case 'S':
			return $author$project$MicroLaTeX$Token$TS;
		case 'W':
			return $author$project$MicroLaTeX$Token$TW;
		case 'MathToken':
			return $author$project$MicroLaTeX$Token$TMath;
		case 'CodeToken':
			return $author$project$MicroLaTeX$Token$TCode;
		default:
			return $author$project$MicroLaTeX$Token$TTokenError;
	}
};
var $author$project$MicroLaTeX$Expression$reduceState = function (state) {
	var peek = A2($elm_community$list_extra$List$Extra$getAt, state.tokenIndex, state.tokens);
	return ($author$project$MicroLaTeX$Expression$isReducible(state.stack) && (!_Utils_eq(
		A2($elm$core$Maybe$map, $author$project$MicroLaTeX$Token$type_, peek),
		$elm$core$Maybe$Just($author$project$MicroLaTeX$Token$TLB)))) ? $author$project$MicroLaTeX$Expression$reduceState_(state) : A4(
		$author$project$MicroLaTeX$LogTools$forklogRed,
		'Not reducible',
		12,
		function (state_) {
			return $elm$core$List$reverse(
				$author$project$MicroLaTeX$Symbol$convertTokens2(state_.stack));
		},
		state);
};
var $author$project$MicroLaTeX$Expression$recoverFromError2 = function (state) {
	var k = $author$project$MicroLaTeX$Symbol$balance(
		$author$project$MicroLaTeX$Symbol$convertTokens2(
			$elm$core$List$reverse(state.stack)));
	var newStack = _Utils_ap(
		A2(
			$elm$core$List$repeat,
			k,
			$author$project$MicroLaTeX$Token$RB(
				A3($author$project$MicroLaTeX$Expression$boostMeta_, state.lineNumber, state.tokenIndex, $author$project$MicroLaTeX$Expression$dummyLoc))),
		state.stack);
	var newSymbols = $author$project$MicroLaTeX$Symbol$convertTokens2(
		$elm$core$List$reverse(newStack));
	var reducible = $author$project$MicroLaTeX$Match$reducible(newSymbols);
	return reducible ? $author$project$MicroLaTeX$Helpers$Done(
		A2(
			$author$project$MicroLaTeX$Expression$addErrorMessage,
			' ]? ',
			$author$project$MicroLaTeX$Expression$reduceState(
				_Utils_update(
					state,
					{
						committed: A2(
							$elm$core$List$cons,
							$author$project$MicroLaTeX$Expression$errorMessage('{'),
							state.committed),
						numberOfTokens: $elm$core$List$length(newStack),
						stack: newStack,
						tokenIndex: 0
					})))) : $author$project$MicroLaTeX$Helpers$Done(
		_Utils_update(
			state,
			{
				committed: A2(
					$elm$core$List$cons,
					$author$project$MicroLaTeX$Expression$bracketError(k),
					state.committed),
				messages: A3(
					$author$project$MicroLaTeX$Helpers$prependMessage,
					state.lineNumber,
					$author$project$MicroLaTeX$Expression$braceErrorAsString(k),
					state.messages)
			}));
};
var $author$project$MicroLaTeX$Expression$recoverFromError = function (state) {
	var _v0 = $elm$core$List$reverse(state.stack);
	_v0$12:
	while (true) {
		if (_v0.b) {
			switch (_v0.a.$) {
				case 'BS':
					if (_v0.b.b && (_v0.b.a.$ === 'S')) {
						if (!_v0.b.b.b) {
							var _v1 = _v0.b;
							var _v2 = _v1.a;
							var fname = _v2.a;
							var m = _v2.b;
							return $author$project$MicroLaTeX$Helpers$Done(
								_Utils_update(
									state,
									{
										committed: A2(
											$elm$core$List$cons,
											A3($author$project$Generic$Language$Fun, fname, _List_Nil, m),
											state.committed),
										stack: _List_Nil
									}));
						} else {
							if (_v0.b.b.a.$ === 'LB') {
								var _v3 = _v0.b;
								var _v4 = _v3.a;
								var fname = _v4.a;
								var _v5 = _v3.b;
								var m3 = _v5.a.a;
								return $author$project$MicroLaTeX$Helpers$Loop(
									_Utils_update(
										state,
										{
											committed: A2(
												$elm$core$List$cons,
												$author$project$MicroLaTeX$Expression$errorMessage('\\' + (fname + '{')),
												state.committed),
											messages: A3(
												$author$project$MicroLaTeX$Helpers$prependMessage,
												state.lineNumber,
												'Missing right brace, column ' + $elm$core$String$fromInt(m3.begin),
												state.messages),
											stack: _List_Nil,
											tokenIndex: m3.index + 1
										}));
							} else {
								break _v0$12;
							}
						}
					} else {
						break _v0$12;
					}
				case 'LB':
					if (_v0.b.b) {
						switch (_v0.b.a.$) {
							case 'RB':
								var _v6 = _v0.b;
								var meta = _v6.a.a;
								return $author$project$MicroLaTeX$Helpers$Loop(
									_Utils_update(
										state,
										{
											committed: A2(
												$elm$core$List$cons,
												$author$project$MicroLaTeX$Expression$errorMessage('{?}'),
												state.committed),
											messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, 'Brackets need to enclose something', state.messages),
											stack: _List_Nil,
											tokenIndex: meta.index + 1
										}));
							case 'LB':
								var _v7 = _v0.b;
								var meta = _v7.a.a;
								return $author$project$MicroLaTeX$Helpers$Loop(
									_Utils_update(
										state,
										{
											committed: A2(
												$elm$core$List$cons,
												$author$project$MicroLaTeX$Expression$errorMessage('{'),
												state.committed),
											messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, 'You have consecutive left brackets', state.messages),
											stack: _List_Nil,
											tokenIndex: meta.index
										}));
							case 'S':
								var _v8 = _v0.b;
								var _v9 = _v8.a;
								var fName = _v9.a;
								var meta = _v9.b;
								var rest = _v8.b;
								return $author$project$MicroLaTeX$Helpers$Loop(
									_Utils_update(
										state,
										{
											committed: A2(
												$elm$core$List$cons,
												$author$project$MicroLaTeX$Expression$errorMessage(
													$author$project$MicroLaTeX$Expression$errorSuffix(rest)),
												A2(
													$elm$core$List$cons,
													$author$project$MicroLaTeX$Expression$errorMessage2('{' + fName),
													state.committed)),
											messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, 'Missing right bracket', state.messages),
											stack: _List_Nil,
											tokenIndex: meta.index + 1
										}));
							case 'W':
								if (_v0.b.a.a === ' ') {
									var _v10 = _v0.b;
									var _v11 = _v10.a;
									var meta = _v11.b;
									return $author$project$MicroLaTeX$Helpers$Loop(
										_Utils_update(
											state,
											{
												committed: A2(
													$elm$core$List$cons,
													$author$project$MicroLaTeX$Expression$errorMessage('{ - can\'t have space after the brace '),
													state.committed),
												messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, 'Can\'t have space after left bracket - try [something ...', state.messages),
												stack: _List_Nil,
												tokenIndex: meta.index + 1
											}));
								} else {
									break _v0$12;
								}
							default:
								break _v0$12;
						}
					} else {
						return $author$project$MicroLaTeX$Helpers$Done(
							_Utils_update(
								state,
								{
									committed: A2(
										$elm$core$List$cons,
										$author$project$MicroLaTeX$Expression$errorMessage('..extra{?'),
										state.committed),
									messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, 'That left bracket needs something after it', state.messages),
									numberOfTokens: 0,
									stack: _List_Nil,
									tokenIndex: 0
								}));
					}
				case 'RB':
					var meta = _v0.a.a;
					return $author$project$MicroLaTeX$Helpers$Loop(
						_Utils_update(
							state,
							{
								committed: A2(
									$elm$core$List$cons,
									$author$project$MicroLaTeX$Expression$errorMessage(' extra }?'),
									state.committed),
								messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, 'Extra right braces(s)', state.messages),
								stack: _List_Nil,
								tokenIndex: meta.index + 1
							}));
				case 'MathToken':
					var meta = _v0.a.a;
					var rest = _v0.b;
					var content = $author$project$MicroLaTeX$Token$toString(rest);
					var message = (content === '') ? '$?$' : '$ ';
					return $author$project$MicroLaTeX$Helpers$Loop(
						_Utils_update(
							state,
							{
								committed: A2(
									$elm$core$List$cons,
									$author$project$MicroLaTeX$Expression$errorMessage(message),
									state.committed),
								messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, 'opening dollar sign needs to be matched with a closing one', state.messages),
								numberOfTokens: 0,
								stack: _List_Nil,
								tokenIndex: meta.index + 1
							}));
				case 'LMathBracket':
					var meta = _v0.a.a;
					var rest = _v0.b;
					var reversedStack = $elm$core$List$reverse(state.stack);
					var toCommitted = function () {
						if (((reversedStack.b && (reversedStack.a.$ === 'LMathBracket')) && reversedStack.b.b) && (reversedStack.b.a.$ === 'S')) {
							var _v13 = reversedStack.b;
							var _v14 = _v13.a;
							var c = _v14.a;
							var m = _v14.b;
							var rest_ = _v13.b;
							return A2(
								$elm$core$List$cons,
								A2($author$project$Generic$Language$Text, c, m),
								A2(
									$elm$core$List$cons,
									A3(
										$author$project$Generic$Language$Fun,
										'red',
										_List_fromArray(
											[
												A2($author$project$Generic$Language$Text, 'insert \\(', m)
											]),
										m),
									state.committed));
						} else {
							return state.committed;
						}
					}();
					var newTokenIndex = meta.index + 2;
					return $author$project$MicroLaTeX$Helpers$Loop(
						_Utils_update(
							state,
							{
								committed: toCommitted,
								messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, 'left bracket needs to be matched with a right bracket', state.messages),
								numberOfTokens: 0,
								stack: _List_Nil,
								tokenIndex: newTokenIndex
							}));
				case 'RMathBracket':
					var meta = _v0.a.a;
					var rest = _v0.b;
					var reversedStack = $elm$core$List$reverse(state.stack);
					var toCommitted = function () {
						if (reversedStack.b && (reversedStack.a.$ === 'RMathBracket')) {
							var m = reversedStack.a.a;
							var rest_ = reversedStack.b;
							return A2(
								$elm$core$List$cons,
								A3(
									$author$project$Generic$Language$Fun,
									'red',
									_List_fromArray(
										[
											A2($author$project$Generic$Language$Text, 'extra \\)', m)
										]),
									m),
								state.committed);
						} else {
							return state.committed;
						}
					}();
					var newTokenIndex = meta.index + 1;
					return $author$project$MicroLaTeX$Helpers$Loop(
						_Utils_update(
							state,
							{
								committed: toCommitted,
								messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, 'left bracket needs to be matched with a right bracket', state.messages),
								numberOfTokens: 0,
								stack: _List_Nil,
								tokenIndex: newTokenIndex
							}));
				case 'CodeToken':
					var meta = _v0.a.a;
					var rest = _v0.b;
					var content = $author$project$MicroLaTeX$Token$toString(rest);
					var message = (content === '') ? '`?`' : '` ';
					return $author$project$MicroLaTeX$Helpers$Loop(
						_Utils_update(
							state,
							{
								committed: A2(
									$elm$core$List$cons,
									$author$project$MicroLaTeX$Expression$errorMessageBold(message),
									state.committed),
								messages: A3($author$project$MicroLaTeX$Helpers$prependMessage, state.lineNumber, 'opening backtick needs to be matched with a closing one', state.messages),
								numberOfTokens: 0,
								stack: _List_Nil,
								tokenIndex: meta.index + 1
							}));
				default:
					break _v0$12;
			}
		} else {
			break _v0$12;
		}
	}
	return $author$project$MicroLaTeX$Expression$recoverFromError2(state);
};
var $author$project$Generic$Language$simplifyExpr = function (expr) {
	switch (expr.$) {
		case 'Fun':
			var name = expr.a;
			var args = expr.b;
			return A3(
				$author$project$Generic$Language$Fun,
				name,
				A2($elm$core$List$map, $author$project$Generic$Language$simplifyExpr, args),
				_Utils_Tuple0);
		case 'VFun':
			var name = expr.a;
			var arg = expr.b;
			return A3($author$project$Generic$Language$VFun, name, arg, _Utils_Tuple0);
		case 'Text':
			var text = expr.a;
			return A2($author$project$Generic$Language$Text, text, _Utils_Tuple0);
		default:
			var eList = expr.a;
			return A2($author$project$Generic$Language$Text, 'text', _Utils_Tuple0);
	}
};
var $author$project$MicroLaTeX$Token$stringValue2 = function (token) {
	switch (token.$) {
		case 'BS':
			var m = token.a;
			return 'BS:' + $elm$core$String$fromInt(m.index);
		case 'F':
			var m = token.b;
			return 'F:' + $elm$core$String$fromInt(m.index);
		case 'LB':
			var m = token.a;
			return 'LB:' + $elm$core$String$fromInt(m.index);
		case 'RB':
			var m = token.a;
			return 'RB:' + $elm$core$String$fromInt(m.index);
		case 'LMathBracket':
			var m = token.a;
			return 'LTB:' + $elm$core$String$fromInt(m.index);
		case 'RMathBracket':
			var m = token.a;
			return 'RTB:' + $elm$core$String$fromInt(m.index);
		case 'S':
			var str = token.a;
			var m = token.b;
			return 'S ' + (str + (': ' + $elm$core$String$fromInt(m.index)));
		case 'W':
			var m = token.b;
			return 'W:' + $elm$core$String$fromInt(m.index);
		case 'MathToken':
			var m = token.a;
			return '$:' + $elm$core$String$fromInt(m.index);
		case 'CodeToken':
			var m = token.a;
			return 'C:' + $elm$core$String$fromInt(m.index);
		default:
			var m = token.b;
			return 'tokenError:' + $elm$core$String$fromInt(m.index);
	}
};
var $author$project$MicroLaTeX$Token$toString2 = function (tokens) {
	return A2(
		$elm$core$String$join,
		'; ',
		A2($elm$core$List$map, $author$project$MicroLaTeX$Token$stringValue2, tokens));
};
var $author$project$MicroLaTeX$Expression$show = function (state) {
	return _Utils_Tuple2(
		$author$project$MicroLaTeX$Token$toString2(
			$elm$core$List$reverse(state.stack)),
		A2($elm$core$List$map, $author$project$Generic$Language$simplifyExpr, state.committed));
};
var $author$project$MicroLaTeX$Expression$nextStep = function (state) {
	var _v0 = A2($elm_community$list_extra$List$Extra$getAt, state.tokenIndex, state.tokens);
	if (_v0.$ === 'Nothing') {
		return $elm$core$List$isEmpty(state.stack) ? $author$project$MicroLaTeX$Helpers$Done(
			A4($author$project$MicroLaTeX$LogTools$forklogBlue, 'Done', 12, $author$project$MicroLaTeX$Expression$show, state)) : $author$project$MicroLaTeX$Expression$recoverFromError(
			A4($author$project$MicroLaTeX$LogTools$forklogRed, 'Recover', 12, $author$project$MicroLaTeX$Expression$show, state));
	} else {
		var token = _v0.a;
		return $author$project$MicroLaTeX$Helpers$Loop(
			A4(
				$author$project$MicroLaTeX$LogTools$forklogCyan,
				'Push-Reduce',
				12,
				$author$project$MicroLaTeX$Expression$show,
				function (st) {
					return _Utils_update(
						st,
						{step: st.step + 1});
				}(
					$author$project$MicroLaTeX$Expression$reduceState(
						A2(
							$author$project$MicroLaTeX$Expression$pushToken,
							token,
							_Utils_update(
								state,
								{tokenIndex: state.tokenIndex + 1}))))));
	}
};
var $author$project$MicroLaTeX$Expression$run = function (state) {
	return function (state_) {
		return _Utils_update(
			state_,
			{
				committed: $elm$core$List$reverse(state_.committed)
			});
	}(
		A2($author$project$MicroLaTeX$Helpers$loop, state, $author$project$MicroLaTeX$Expression$nextStep));
};
var $author$project$MicroLaTeX$Token$Normal = {$: 'Normal'};
var $author$project$MicroLaTeX$Token$init = function (str) {
	return {
		currentToken: $elm$core$Maybe$Nothing,
		mode: $author$project$MicroLaTeX$Token$Normal,
		scanpointer: 0,
		source: str,
		sourceLength: $elm$core$String$length(str),
		tokenIndex: 0,
		tokens: _List_Nil
	};
};
var $author$project$MicroLaTeX$Token$finish = function (state) {
	var _v0 = state.currentToken;
	if (_v0.$ === 'Just') {
		var token = _v0.a;
		return $author$project$MicroLaTeX$Helpers$Done(
			A2($elm$core$List$cons, token, state.tokens));
	} else {
		return $author$project$MicroLaTeX$Helpers$Done(state.tokens);
	}
};
var $elm$core$Basics$ge = _Utils_ge;
var $author$project$MicroLaTeX$Token$TokenError = F2(
	function (a, b) {
		return {$: 'TokenError', a: a, b: b};
	});
var $author$project$MicroLaTeX$Token$makeId = F2(
	function (a, b) {
		return $elm$core$String$fromInt(a) + ('.' + $elm$core$String$fromInt(b));
	});
var $elm$parser$Parser$Advanced$bagToList = F2(
	function (bag, list) {
		bagToList:
		while (true) {
			switch (bag.$) {
				case 'Empty':
					return list;
				case 'AddRight':
					var bag1 = bag.a;
					var x = bag.b;
					var $temp$bag = bag1,
						$temp$list = A2($elm$core$List$cons, x, list);
					bag = $temp$bag;
					list = $temp$list;
					continue bagToList;
				default:
					var bag1 = bag.a;
					var bag2 = bag.b;
					var $temp$bag = bag1,
						$temp$list = A2($elm$parser$Parser$Advanced$bagToList, bag2, list);
					bag = $temp$bag;
					list = $temp$list;
					continue bagToList;
			}
		}
	});
var $elm$parser$Parser$Advanced$run = F2(
	function (_v0, src) {
		var parse = _v0.a;
		var _v1 = parse(
			{col: 1, context: _List_Nil, indent: 1, offset: 0, row: 1, src: src});
		if (_v1.$ === 'Good') {
			var value = _v1.b;
			return $elm$core$Result$Ok(value);
		} else {
			var bag = _v1.b;
			return $elm$core$Result$Err(
				A2($elm$parser$Parser$Advanced$bagToList, bag, _List_Nil));
		}
	});
var $author$project$MicroLaTeX$Token$CodeToken = function (a) {
	return {$: 'CodeToken', a: a};
};
var $elm$parser$Parser$Advanced$Bad = F2(
	function (a, b) {
		return {$: 'Bad', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$Good = F3(
	function (a, b, c) {
		return {$: 'Good', a: a, b: b, c: c};
	});
var $elm$parser$Parser$Advanced$Parser = function (a) {
	return {$: 'Parser', a: a};
};
var $elm$parser$Parser$Advanced$map = F2(
	function (func, _v0) {
		var parse = _v0.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v1 = parse(s0);
				if (_v1.$ === 'Good') {
					var p = _v1.a;
					var a = _v1.b;
					var s1 = _v1.c;
					return A3(
						$elm$parser$Parser$Advanced$Good,
						p,
						func(a),
						s1);
				} else {
					var p = _v1.a;
					var x = _v1.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				}
			});
	});
var $author$project$MicroLaTeX$Tools$ExpectingPrefix = {$: 'ExpectingPrefix'};
var $elm$parser$Parser$Advanced$AddRight = F2(
	function (a, b) {
		return {$: 'AddRight', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$DeadEnd = F4(
	function (row, col, problem, contextStack) {
		return {col: col, contextStack: contextStack, problem: problem, row: row};
	});
var $elm$parser$Parser$Advanced$Empty = {$: 'Empty'};
var $elm$parser$Parser$Advanced$fromState = F2(
	function (s, x) {
		return A2(
			$elm$parser$Parser$Advanced$AddRight,
			$elm$parser$Parser$Advanced$Empty,
			A4($elm$parser$Parser$Advanced$DeadEnd, s.row, s.col, x, s.context));
	});
var $elm$parser$Parser$Advanced$isSubChar = _Parser_isSubChar;
var $elm$parser$Parser$Advanced$chompIf = F2(
	function (isGood, expecting) {
		return $elm$parser$Parser$Advanced$Parser(
			function (s) {
				var newOffset = A3($elm$parser$Parser$Advanced$isSubChar, isGood, s.offset, s.src);
				return _Utils_eq(newOffset, -1) ? A2(
					$elm$parser$Parser$Advanced$Bad,
					false,
					A2($elm$parser$Parser$Advanced$fromState, s, expecting)) : (_Utils_eq(newOffset, -2) ? A3(
					$elm$parser$Parser$Advanced$Good,
					true,
					_Utils_Tuple0,
					{col: 1, context: s.context, indent: s.indent, offset: s.offset + 1, row: s.row + 1, src: s.src}) : A3(
					$elm$parser$Parser$Advanced$Good,
					true,
					_Utils_Tuple0,
					{col: s.col + 1, context: s.context, indent: s.indent, offset: newOffset, row: s.row, src: s.src}));
			});
	});
var $elm$parser$Parser$Advanced$chompWhileHelp = F5(
	function (isGood, offset, row, col, s0) {
		chompWhileHelp:
		while (true) {
			var newOffset = A3($elm$parser$Parser$Advanced$isSubChar, isGood, offset, s0.src);
			if (_Utils_eq(newOffset, -1)) {
				return A3(
					$elm$parser$Parser$Advanced$Good,
					_Utils_cmp(s0.offset, offset) < 0,
					_Utils_Tuple0,
					{col: col, context: s0.context, indent: s0.indent, offset: offset, row: row, src: s0.src});
			} else {
				if (_Utils_eq(newOffset, -2)) {
					var $temp$isGood = isGood,
						$temp$offset = offset + 1,
						$temp$row = row + 1,
						$temp$col = 1,
						$temp$s0 = s0;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					s0 = $temp$s0;
					continue chompWhileHelp;
				} else {
					var $temp$isGood = isGood,
						$temp$offset = newOffset,
						$temp$row = row,
						$temp$col = col + 1,
						$temp$s0 = s0;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					s0 = $temp$s0;
					continue chompWhileHelp;
				}
			}
		}
	});
var $elm$parser$Parser$Advanced$chompWhile = function (isGood) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return A5($elm$parser$Parser$Advanced$chompWhileHelp, isGood, s.offset, s.row, s.col, s);
		});
};
var $elm$parser$Parser$Advanced$getOffset = $elm$parser$Parser$Advanced$Parser(
	function (s) {
		return A3($elm$parser$Parser$Advanced$Good, false, s.offset, s);
	});
var $elm$parser$Parser$Advanced$getSource = $elm$parser$Parser$Advanced$Parser(
	function (s) {
		return A3($elm$parser$Parser$Advanced$Good, false, s.src, s);
	});
var $elm$core$Basics$always = F2(
	function (a, _v0) {
		return a;
	});
var $elm$parser$Parser$Advanced$map2 = F3(
	function (func, _v0, _v1) {
		var parseA = _v0.a;
		var parseB = _v1.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v2 = parseA(s0);
				if (_v2.$ === 'Bad') {
					var p = _v2.a;
					var x = _v2.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				} else {
					var p1 = _v2.a;
					var a = _v2.b;
					var s1 = _v2.c;
					var _v3 = parseB(s1);
					if (_v3.$ === 'Bad') {
						var p2 = _v3.a;
						var x = _v3.b;
						return A2($elm$parser$Parser$Advanced$Bad, p1 || p2, x);
					} else {
						var p2 = _v3.a;
						var b = _v3.b;
						var s2 = _v3.c;
						return A3(
							$elm$parser$Parser$Advanced$Good,
							p1 || p2,
							A2(func, a, b),
							s2);
					}
				}
			});
	});
var $elm$parser$Parser$Advanced$ignorer = F2(
	function (keepParser, ignoreParser) {
		return A3($elm$parser$Parser$Advanced$map2, $elm$core$Basics$always, keepParser, ignoreParser);
	});
var $elm$parser$Parser$Advanced$keeper = F2(
	function (parseFunc, parseArg) {
		return A3($elm$parser$Parser$Advanced$map2, $elm$core$Basics$apL, parseFunc, parseArg);
	});
var $elm$parser$Parser$Advanced$succeed = function (a) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return A3($elm$parser$Parser$Advanced$Good, false, a, s);
		});
};
var $author$project$MicroLaTeX$Tools$text = F2(
	function (prefix, _continue) {
		return A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$keeper,
				A2(
					$elm$parser$Parser$Advanced$keeper,
					$elm$parser$Parser$Advanced$succeed(
						F3(
							function (start, finish, content) {
								return {
									begin: start,
									content: A3($elm$core$String$slice, start, finish, content),
									end: finish
								};
							})),
					A2(
						$elm$parser$Parser$Advanced$ignorer,
						A2(
							$elm$parser$Parser$Advanced$ignorer,
							$elm$parser$Parser$Advanced$getOffset,
							A2(
								$elm$parser$Parser$Advanced$chompIf,
								function (c) {
									return prefix(c);
								},
								$author$project$MicroLaTeX$Tools$ExpectingPrefix)),
						$elm$parser$Parser$Advanced$chompWhile(
							function (c) {
								return _continue(c);
							}))),
				$elm$parser$Parser$Advanced$getOffset),
			$elm$parser$Parser$Advanced$getSource);
	});
var $author$project$MicroLaTeX$Token$codeParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$MicroLaTeX$Token$CodeToken(
					{
						begin: start,
						end: start,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			A2(
				$author$project$MicroLaTeX$Tools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('`'));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$MicroLaTeX$Token$S = F2(
	function (a, b) {
		return {$: 'S', a: a, b: b};
	});
var $author$project$MicroLaTeX$Token$codeChars = _List_fromArray(
	[
		_Utils_chr('`')
	]);
var $author$project$MicroLaTeX$Token$languageChars = _List_fromArray(
	[
		_Utils_chr('\\'),
		_Utils_chr('{'),
		_Utils_chr('}'),
		_Utils_chr('`'),
		_Utils_chr('$')
	]);
var $author$project$MicroLaTeX$Token$codeTextParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (data) {
				return A2(
					$author$project$MicroLaTeX$Token$S,
					data.content,
					{
						begin: start,
						end: ((start + data.end) - data.begin) - 1,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			A2(
				$author$project$MicroLaTeX$Tools$text,
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$MicroLaTeX$Token$codeChars));
				},
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$MicroLaTeX$Token$languageChars));
				}));
	});
var $elm$parser$Parser$Advanced$Append = F2(
	function (a, b) {
		return {$: 'Append', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$oneOfHelp = F3(
	function (s0, bag, parsers) {
		oneOfHelp:
		while (true) {
			if (!parsers.b) {
				return A2($elm$parser$Parser$Advanced$Bad, false, bag);
			} else {
				var parse = parsers.a.a;
				var remainingParsers = parsers.b;
				var _v1 = parse(s0);
				if (_v1.$ === 'Good') {
					var step = _v1;
					return step;
				} else {
					var step = _v1;
					var p = step.a;
					var x = step.b;
					if (p) {
						return step;
					} else {
						var $temp$s0 = s0,
							$temp$bag = A2($elm$parser$Parser$Advanced$Append, bag, x),
							$temp$parsers = remainingParsers;
						s0 = $temp$s0;
						bag = $temp$bag;
						parsers = $temp$parsers;
						continue oneOfHelp;
					}
				}
			}
		}
	});
var $elm$parser$Parser$Advanced$oneOf = function (parsers) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			return A3($elm$parser$Parser$Advanced$oneOfHelp, s, $elm$parser$Parser$Advanced$Empty, parsers);
		});
};
var $author$project$MicroLaTeX$Token$W = F2(
	function (a, b) {
		return {$: 'W', a: a, b: b};
	});
var $author$project$MicroLaTeX$Token$whiteSpaceParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (data) {
				return A2(
					$author$project$MicroLaTeX$Token$W,
					data.content,
					{
						begin: start,
						end: start,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			A2(
				$author$project$MicroLaTeX$Tools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr(' '));
				},
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr(' '));
				}));
	});
var $author$project$MicroLaTeX$Token$codeParser_ = F2(
	function (start, index) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					A2($author$project$MicroLaTeX$Token$codeTextParser, start, index),
					A2($author$project$MicroLaTeX$Token$codeParser, start, index),
					A2($author$project$MicroLaTeX$Token$whiteSpaceParser, start, index)
				]));
	});
var $author$project$MicroLaTeX$Token$LMathBracket = function (a) {
	return {$: 'LMathBracket', a: a};
};
var $author$project$MicroLaTeX$Tools$ExpectingSymbol = function (a) {
	return {$: 'ExpectingSymbol', a: a};
};
var $elm$parser$Parser$Advanced$Token = F2(
	function (a, b) {
		return {$: 'Token', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$isSubString = _Parser_isSubString;
var $elm$parser$Parser$Advanced$token = function (_v0) {
	var str = _v0.a;
	var expecting = _v0.b;
	var progress = !$elm$core$String$isEmpty(str);
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			var _v1 = A5($elm$parser$Parser$Advanced$isSubString, str, s.offset, s.row, s.col, s.src);
			var newOffset = _v1.a;
			var newRow = _v1.b;
			var newCol = _v1.c;
			return _Utils_eq(newOffset, -1) ? A2(
				$elm$parser$Parser$Advanced$Bad,
				false,
				A2($elm$parser$Parser$Advanced$fromState, s, expecting)) : A3(
				$elm$parser$Parser$Advanced$Good,
				progress,
				_Utils_Tuple0,
				{col: newCol, context: s.context, indent: s.indent, offset: newOffset, row: newRow, src: s.src});
		});
};
var $elm$parser$Parser$Advanced$symbol = $elm$parser$Parser$Advanced$token;
var $author$project$MicroLaTeX$Tools$symbol = function (symb) {
	return A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			$elm$parser$Parser$Advanced$succeed(
				F2(
					function (start, finish) {
						return {begin: start, content: symb, end: finish};
					})),
			A2(
				$elm$parser$Parser$Advanced$ignorer,
				$elm$parser$Parser$Advanced$getOffset,
				$elm$parser$Parser$Advanced$symbol(
					A2(
						$elm$parser$Parser$Advanced$Token,
						symb,
						$author$project$MicroLaTeX$Tools$ExpectingSymbol(symb))))),
		$elm$parser$Parser$Advanced$getOffset);
};
var $author$project$MicroLaTeX$Token$leftMathBracketParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v0) {
				return $author$project$MicroLaTeX$Token$LMathBracket(
					{
						begin: start,
						end: start + 1,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			$author$project$MicroLaTeX$Tools$symbol('\\('));
	});
var $author$project$MicroLaTeX$Token$mathChars = _List_fromArray(
	[
		_Utils_chr('$')
	]);
var $author$project$MicroLaTeX$Token$mathTextParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (data) {
				return A2(
					$author$project$MicroLaTeX$Token$S,
					data.content,
					{
						begin: start,
						end: ((start + data.end) - data.begin) - 1,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			A2(
				$author$project$MicroLaTeX$Tools$text,
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$MicroLaTeX$Token$mathChars));
				},
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$MicroLaTeX$Token$languageChars));
				}));
	});
var $author$project$MicroLaTeX$Token$rightMathBracketParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v0) {
				return $author$project$MicroLaTeX$Token$RMathBracket(
					{
						begin: start,
						end: start + 1,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			$author$project$MicroLaTeX$Tools$symbol('\\)'));
	});
var $author$project$MicroLaTeX$Token$mathParser2_ = F2(
	function (start, index) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					A2($author$project$MicroLaTeX$Token$leftMathBracketParser, start, index),
					A2($author$project$MicroLaTeX$Token$rightMathBracketParser, start, index),
					A2($author$project$MicroLaTeX$Token$mathTextParser, start, index),
					A2($author$project$MicroLaTeX$Token$whiteSpaceParser, start, index)
				]));
	});
var $author$project$MicroLaTeX$Token$MathToken = function (a) {
	return {$: 'MathToken', a: a};
};
var $author$project$MicroLaTeX$Token$mathParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$MicroLaTeX$Token$MathToken(
					{
						begin: start,
						end: start,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			A2(
				$author$project$MicroLaTeX$Tools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('$'));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$MicroLaTeX$Token$mathParser_ = F2(
	function (start, index) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					A2($author$project$MicroLaTeX$Token$mathTextParser, start, index),
					A2($author$project$MicroLaTeX$Token$mathParser, start, index),
					A2($author$project$MicroLaTeX$Token$leftMathBracketParser, start, index),
					A2($author$project$MicroLaTeX$Token$rightMathBracketParser, start, index),
					A2($author$project$MicroLaTeX$Token$whiteSpaceParser, start, index)
				]));
	});
var $author$project$MicroLaTeX$Token$backslashParser1 = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$MicroLaTeX$Token$BS(
					{
						begin: start,
						end: start,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			A2(
				$author$project$MicroLaTeX$Tools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('\\'));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$MicroLaTeX$Token$F = F2(
	function (a, b) {
		return {$: 'F', a: a, b: b};
	});
var $elm$parser$Parser$Advanced$andThen = F2(
	function (callback, _v0) {
		var parseA = _v0.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v1 = parseA(s0);
				if (_v1.$ === 'Bad') {
					var p = _v1.a;
					var x = _v1.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				} else {
					var p1 = _v1.a;
					var a = _v1.b;
					var s1 = _v1.c;
					var _v2 = callback(a);
					var parseB = _v2.a;
					var _v3 = parseB(s1);
					if (_v3.$ === 'Bad') {
						var p2 = _v3.a;
						var x = _v3.b;
						return A2($elm$parser$Parser$Advanced$Bad, p1 || p2, x);
					} else {
						var p2 = _v3.a;
						var b = _v3.b;
						var s2 = _v3.c;
						return A3($elm$parser$Parser$Advanced$Good, p1 || p2, b, s2);
					}
				}
			});
	});
var $author$project$MicroLaTeX$Token$first = F2(
	function (p, q) {
		return A2(
			$elm$parser$Parser$Advanced$andThen,
			function (x) {
				return A2(
					$elm$parser$Parser$Advanced$map,
					function (_v0) {
						return x;
					},
					q);
			},
			p);
	});
var $author$project$MicroLaTeX$Token$backslashParser2 = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (data) {
				return A2(
					$author$project$MicroLaTeX$Token$F,
					A2($elm$core$String$dropLeft, 1, data.content),
					{
						begin: start,
						end: ((start + data.end) - data.begin) - 1,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			A2(
				$author$project$MicroLaTeX$Token$first,
				A2(
					$author$project$MicroLaTeX$Tools$text,
					function (c) {
						return _Utils_eq(
							c,
							_Utils_chr('\\'));
					},
					function (c) {
						return (!_Utils_eq(
							c,
							_Utils_chr(' '))) && (!_Utils_eq(
							c,
							_Utils_chr('{')));
					}),
				$author$project$MicroLaTeX$Tools$symbol(' ')));
	});
var $elm$parser$Parser$Advanced$backtrackable = function (_v0) {
	var parse = _v0.a;
	return $elm$parser$Parser$Advanced$Parser(
		function (s0) {
			var _v1 = parse(s0);
			if (_v1.$ === 'Bad') {
				var x = _v1.b;
				return A2($elm$parser$Parser$Advanced$Bad, false, x);
			} else {
				var a = _v1.b;
				var s1 = _v1.c;
				return A3($elm$parser$Parser$Advanced$Good, false, a, s1);
			}
		});
};
var $author$project$MicroLaTeX$Token$backslashParser = F2(
	function (start, index) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					$elm$parser$Parser$Advanced$backtrackable(
					A2($author$project$MicroLaTeX$Token$backslashParser2, start, index)),
					A2($author$project$MicroLaTeX$Token$backslashParser1, start, index)
				]));
	});
var $author$project$MicroLaTeX$Token$LB = function (a) {
	return {$: 'LB', a: a};
};
var $author$project$MicroLaTeX$Token$leftBraceParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$MicroLaTeX$Token$LB(
					{
						begin: start,
						end: start,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			A2(
				$author$project$MicroLaTeX$Tools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('{'));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$MicroLaTeX$Token$rightBraceParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$MicroLaTeX$Token$RB(
					{
						begin: start,
						end: start,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			A2(
				$author$project$MicroLaTeX$Tools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('}'));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$MicroLaTeX$Token$textParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (data) {
				return A2(
					$author$project$MicroLaTeX$Token$S,
					data.content,
					{
						begin: start,
						end: ((start + data.end) - data.begin) - 1,
						id: A2($author$project$MicroLaTeX$Token$makeId, start, index),
						index: index
					});
			},
			A2(
				$author$project$MicroLaTeX$Tools$text,
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$MicroLaTeX$Token$languageChars));
				},
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$MicroLaTeX$Token$languageChars));
				}));
	});
var $author$project$MicroLaTeX$Token$tokenParser_ = F2(
	function (start, index) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					A2($author$project$MicroLaTeX$Token$textParser, start, index),
					A2($author$project$MicroLaTeX$Token$leftMathBracketParser, start, index),
					A2($author$project$MicroLaTeX$Token$rightMathBracketParser, start, index),
					A2($author$project$MicroLaTeX$Token$backslashParser, start, index),
					A2($author$project$MicroLaTeX$Token$leftBraceParser, start, index),
					A2($author$project$MicroLaTeX$Token$rightBraceParser, start, index),
					A2($author$project$MicroLaTeX$Token$mathParser, start, index),
					A2($author$project$MicroLaTeX$Token$codeParser, start, index),
					A2($author$project$MicroLaTeX$Token$whiteSpaceParser, start, index)
				]));
	});
var $author$project$MicroLaTeX$Token$tokenParser = F3(
	function (mode, start, index) {
		switch (mode.$) {
			case 'Normal':
				return A2($author$project$MicroLaTeX$Token$tokenParser_, start, index);
			case 'InMath':
				if (mode.a.$ === 'ILDollar') {
					var _v1 = mode.a;
					return A2($author$project$MicroLaTeX$Token$mathParser_, start, index);
				} else {
					var _v2 = mode.a;
					return A2($author$project$MicroLaTeX$Token$mathParser2_, start, index);
				}
			default:
				return A2($author$project$MicroLaTeX$Token$codeParser_, start, index);
		}
	});
var $author$project$MicroLaTeX$Token$get = F3(
	function (state, start, input) {
		var _v0 = A2(
			$elm$parser$Parser$Advanced$run,
			A3($author$project$MicroLaTeX$Token$tokenParser, state.mode, start, state.tokenIndex),
			input);
		if (_v0.$ === 'Ok') {
			var token = _v0.a;
			return token;
		} else {
			var errorList = _v0.a;
			return A2(
				$author$project$MicroLaTeX$Token$TokenError,
				errorList,
				{
					begin: start,
					end: start + 1,
					id: A2($author$project$MicroLaTeX$Token$makeId, start, state.tokenIndex),
					index: state.tokenIndex
				});
		}
	});
var $author$project$MicroLaTeX$Token$setIndex = F2(
	function (k, token) {
		switch (token.$) {
			case 'BS':
				var meta = token.a;
				return $author$project$MicroLaTeX$Token$BS(
					_Utils_update(
						meta,
						{index: k}));
			case 'F':
				var str = token.a;
				var meta = token.b;
				return A2(
					$author$project$MicroLaTeX$Token$F,
					str,
					_Utils_update(
						meta,
						{index: k}));
			case 'LB':
				var meta = token.a;
				return $author$project$MicroLaTeX$Token$LB(
					_Utils_update(
						meta,
						{index: k}));
			case 'RB':
				var meta = token.a;
				return $author$project$MicroLaTeX$Token$RB(
					_Utils_update(
						meta,
						{index: k}));
			case 'LMathBracket':
				var meta = token.a;
				return $author$project$MicroLaTeX$Token$LMathBracket(
					_Utils_update(
						meta,
						{index: k}));
			case 'RMathBracket':
				var meta = token.a;
				return $author$project$MicroLaTeX$Token$RMathBracket(
					_Utils_update(
						meta,
						{index: k}));
			case 'S':
				var str = token.a;
				var meta = token.b;
				return A2(
					$author$project$MicroLaTeX$Token$S,
					str,
					_Utils_update(
						meta,
						{index: k}));
			case 'W':
				var str = token.a;
				var meta = token.b;
				return A2(
					$author$project$MicroLaTeX$Token$W,
					str,
					_Utils_update(
						meta,
						{index: k}));
			case 'MathToken':
				var meta = token.a;
				return $author$project$MicroLaTeX$Token$MathToken(
					_Utils_update(
						meta,
						{index: k}));
			case 'CodeToken':
				var meta = token.a;
				return $author$project$MicroLaTeX$Token$CodeToken(
					_Utils_update(
						meta,
						{index: k}));
			default:
				var list = token.a;
				var meta = token.b;
				return A2(
					$author$project$MicroLaTeX$Token$TokenError,
					list,
					_Utils_update(
						meta,
						{index: k}));
		}
	});
var $author$project$MicroLaTeX$Token$handleBS = F2(
	function (state, token) {
		var _v0 = state.currentToken;
		if (_v0.$ === 'Nothing') {
			return _Utils_Tuple3(
				A2(
					$elm$core$List$cons,
					A2($author$project$MicroLaTeX$Token$setIndex, state.tokenIndex, token),
					state.tokens),
				state.tokenIndex + 1,
				$elm$core$Maybe$Nothing);
		} else {
			var textToken = _v0.a;
			return _Utils_Tuple3(
				A2(
					$elm$core$List$cons,
					A2($author$project$MicroLaTeX$Token$setIndex, state.tokenIndex + 1, token),
					A2(
						$elm$core$List$cons,
						A2($author$project$MicroLaTeX$Token$setIndex, state.tokenIndex, textToken),
						state.tokens)),
				state.tokenIndex + 2,
				$elm$core$Maybe$Nothing);
		}
	});
var $author$project$MicroLaTeX$Token$handleDefault = F2(
	function (state, token) {
		var _v0 = state.currentToken;
		if (_v0.$ === 'Nothing') {
			return _Utils_Tuple3(
				A2(
					$elm$core$List$cons,
					A2($author$project$MicroLaTeX$Token$setIndex, state.tokenIndex, token),
					state.tokens),
				state.tokenIndex + 1,
				$elm$core$Maybe$Nothing);
		} else {
			var textToken = _v0.a;
			return _Utils_Tuple3(
				A2(
					$elm$core$List$cons,
					A2($author$project$MicroLaTeX$Token$setIndex, state.tokenIndex + 1, token),
					A2($elm$core$List$cons, textToken, state.tokens)),
				state.tokenIndex + 2,
				$elm$core$Maybe$Nothing);
		}
	});
var $author$project$MicroLaTeX$Token$handleLB = F2(
	function (state, token) {
		var _v0 = state.currentToken;
		if (_v0.$ === 'Nothing') {
			return _Utils_Tuple3(
				A2(
					$elm$core$List$cons,
					A2($author$project$MicroLaTeX$Token$setIndex, state.tokenIndex, token),
					state.tokens),
				state.tokenIndex + 1,
				$elm$core$Maybe$Nothing);
		} else {
			var textToken = _v0.a;
			return _Utils_Tuple3(
				A2(
					$elm$core$List$cons,
					A2($author$project$MicroLaTeX$Token$setIndex, state.tokenIndex + 1, token),
					A2(
						$elm$core$List$cons,
						A2($author$project$MicroLaTeX$Token$setIndex, state.tokenIndex, textToken),
						state.tokens)),
				state.tokenIndex + 2,
				$elm$core$Maybe$Nothing);
		}
	});
var $author$project$MicroLaTeX$Token$boostExprMeta = F3(
	function (lineNumber, tokenIndex, _v0) {
		var begin = _v0.begin;
		var end = _v0.end;
		var index = _v0.index;
		return {
			begin: begin,
			end: end,
			id: A2($author$project$MicroLaTeX$Token$makeId, lineNumber, tokenIndex),
			index: index
		};
	});
var $author$project$MicroLaTeX$Token$getExprMeta = function (token) {
	switch (token.$) {
		case 'BS':
			var m = token.a;
			return m;
		case 'F':
			var m = token.b;
			return m;
		case 'LB':
			var m = token.a;
			return m;
		case 'RB':
			var m = token.a;
			return m;
		case 'LMathBracket':
			var m = token.a;
			return m;
		case 'RMathBracket':
			var m = token.a;
			return m;
		case 'S':
			var m = token.b;
			return m;
		case 'W':
			var m = token.b;
			return m;
		case 'MathToken':
			var m = token.a;
			return m;
		case 'CodeToken':
			var m = token.a;
			return m;
		default:
			var m = token.b;
			return m;
	}
};
var $author$project$MicroLaTeX$Token$mergeToken = F2(
	function (lastToken, currentToken) {
		var lastTokenExprMeta = $author$project$MicroLaTeX$Token$getExprMeta(lastToken);
		var currentTokenExprMeta = $author$project$MicroLaTeX$Token$getExprMeta(currentToken);
		var meta = {begin: lastTokenExprMeta.begin, end: currentTokenExprMeta.end, index: -1};
		return A2(
			$author$project$MicroLaTeX$Token$S,
			_Utils_ap(
				$author$project$MicroLaTeX$Token$stringValue(lastToken),
				$author$project$MicroLaTeX$Token$stringValue(currentToken)),
			A3($author$project$MicroLaTeX$Token$boostExprMeta, meta.begin, meta.end, meta));
	});
var $author$project$MicroLaTeX$Token$updateCurrentToken = F3(
	function (index, token, currentToken) {
		if (currentToken.$ === 'Nothing') {
			return $elm$core$Maybe$Just(
				A2($author$project$MicroLaTeX$Token$setIndex, index, token));
		} else {
			var token_ = currentToken.a;
			return $elm$core$Maybe$Just(
				A2(
					$author$project$MicroLaTeX$Token$setIndex,
					index,
					A2($author$project$MicroLaTeX$Token$mergeToken, token_, token)));
		}
	});
var $author$project$MicroLaTeX$Token$handleMerge = F2(
	function (state, token) {
		return _Utils_Tuple3(
			state.tokens,
			state.tokenIndex,
			A3($author$project$MicroLaTeX$Token$updateCurrentToken, state.tokenIndex, token, state.currentToken));
	});
var $author$project$MicroLaTeX$Token$isTextToken = function (token) {
	return A2(
		$elm$core$List$member,
		$author$project$MicroLaTeX$Token$type_(token),
		_List_fromArray(
			[$author$project$MicroLaTeX$Token$TW, $author$project$MicroLaTeX$Token$TS]));
};
var $author$project$MicroLaTeX$Token$length = function (token) {
	switch (token.$) {
		case 'BS':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'F':
			var meta = token.b;
			return meta.end - meta.begin;
		case 'LB':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'RB':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'LMathBracket':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'RMathBracket':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'S':
			var meta = token.b;
			return meta.end - meta.begin;
		case 'MathToken':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'CodeToken':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'W':
			var meta = token.b;
			return meta.end - meta.begin;
		default:
			var meta = token.b;
			return meta.end - meta.begin;
	}
};
var $author$project$MicroLaTeX$Token$ILBracket = {$: 'ILBracket'};
var $author$project$MicroLaTeX$Token$ILDollar = {$: 'ILDollar'};
var $author$project$MicroLaTeX$Token$InCode = {$: 'InCode'};
var $author$project$MicroLaTeX$Token$InMath = function (a) {
	return {$: 'InMath', a: a};
};
var $author$project$MicroLaTeX$Token$newMode = F2(
	function (token, currentMode) {
		switch (currentMode.$) {
			case 'Normal':
				switch (token.$) {
					case 'MathToken':
						return $author$project$MicroLaTeX$Token$InMath($author$project$MicroLaTeX$Token$ILDollar);
					case 'LMathBracket':
						return $author$project$MicroLaTeX$Token$InMath($author$project$MicroLaTeX$Token$ILBracket);
					case 'CodeToken':
						return $author$project$MicroLaTeX$Token$InCode;
					default:
						return $author$project$MicroLaTeX$Token$Normal;
				}
			case 'InMath':
				if (currentMode.a.$ === 'ILDollar') {
					var _v2 = currentMode.a;
					switch (token.$) {
						case 'MathToken':
							return $author$project$MicroLaTeX$Token$Normal;
						case 'RMathBracket':
							return $author$project$MicroLaTeX$Token$InMath($author$project$MicroLaTeX$Token$ILDollar);
						default:
							return $author$project$MicroLaTeX$Token$InMath($author$project$MicroLaTeX$Token$ILDollar);
					}
				} else {
					var _v4 = currentMode.a;
					switch (token.$) {
						case 'MathToken':
							return $author$project$MicroLaTeX$Token$InMath($author$project$MicroLaTeX$Token$ILBracket);
						case 'RMathBracket':
							return $author$project$MicroLaTeX$Token$Normal;
						default:
							return $author$project$MicroLaTeX$Token$InMath($author$project$MicroLaTeX$Token$ILBracket);
					}
				}
			default:
				if (token.$ === 'CodeToken') {
					return $author$project$MicroLaTeX$Token$Normal;
				} else {
					return $author$project$MicroLaTeX$Token$InCode;
				}
		}
	});
var $author$project$MicroLaTeX$Token$nextStep = function (state) {
	if (_Utils_cmp(state.scanpointer, state.sourceLength) > -1) {
		return $author$project$MicroLaTeX$Token$finish(state);
	} else {
		var token = A3(
			$author$project$MicroLaTeX$Token$get,
			state,
			state.scanpointer,
			A2($elm$core$String$dropLeft, state.scanpointer, state.source));
		var newScanPointer = (state.scanpointer + $author$project$MicroLaTeX$Token$length(token)) + 1;
		var _v0 = $author$project$MicroLaTeX$Token$isTextToken(token) ? A2($author$project$MicroLaTeX$Token$handleMerge, state, token) : (_Utils_eq(
			$author$project$MicroLaTeX$Token$type_(token),
			$author$project$MicroLaTeX$Token$TBS) ? A2($author$project$MicroLaTeX$Token$handleBS, state, token) : (_Utils_eq(
			$author$project$MicroLaTeX$Token$type_(token),
			$author$project$MicroLaTeX$Token$TLB) ? A2($author$project$MicroLaTeX$Token$handleLB, state, token) : A2($author$project$MicroLaTeX$Token$handleDefault, state, token)));
		var tokens = _v0.a;
		var tokenIndex = _v0.b;
		var currentToken_ = _v0.c;
		var currentToken = $author$project$MicroLaTeX$Token$isTextToken(token) ? currentToken_ : $elm$core$Maybe$Nothing;
		return $author$project$MicroLaTeX$Helpers$Loop(
			_Utils_update(
				state,
				{
					currentToken: currentToken,
					mode: A2($author$project$MicroLaTeX$Token$newMode, token, state.mode),
					scanpointer: newScanPointer,
					tokenIndex: tokenIndex,
					tokens: tokens
				}));
	}
};
var $author$project$MicroLaTeX$Token$run = function (source) {
	return A2(
		$author$project$MicroLaTeX$Helpers$loop,
		$author$project$MicroLaTeX$Token$init(source),
		$author$project$MicroLaTeX$Token$nextStep);
};
var $author$project$MicroLaTeX$Expression$parse = F2(
	function (lineNumber, str) {
		return $author$project$MicroLaTeX$Expression$run(
			A2(
				$author$project$MicroLaTeX$Expression$initWithTokens,
				lineNumber,
				$author$project$MicroLaTeX$Token$run(str))).committed;
	});
var $elm$core$Dict$Black = {$: 'Black'};
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var $elm$core$Dict$Red = {$: 'Red'};
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var $elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.e.d.$ === 'RBNode_elm_builtin') && (dict.e.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var lLeft = _v1.d;
			var lRight = _v1.e;
			var _v2 = dict.e;
			var rClr = _v2.a;
			var rK = _v2.b;
			var rV = _v2.c;
			var rLeft = _v2.d;
			var _v3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _v2.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				rlK,
				rlV,
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					rlL),
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v4 = dict.d;
			var lClr = _v4.a;
			var lK = _v4.b;
			var lV = _v4.c;
			var lLeft = _v4.d;
			var lRight = _v4.e;
			var _v5 = dict.e;
			var rClr = _v5.a;
			var rK = _v5.b;
			var rV = _v5.c;
			var rLeft = _v5.d;
			var rRight = _v5.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.d.d.$ === 'RBNode_elm_builtin') && (dict.d.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var _v2 = _v1.d;
			var _v3 = _v2.a;
			var llK = _v2.b;
			var llV = _v2.c;
			var llLeft = _v2.d;
			var llRight = _v2.e;
			var lRight = _v1.e;
			var _v4 = dict.e;
			var rClr = _v4.a;
			var rK = _v4.b;
			var rV = _v4.c;
			var rLeft = _v4.d;
			var rRight = _v4.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				lK,
				lV,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					lRight,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v5 = dict.d;
			var lClr = _v5.a;
			var lK = _v5.b;
			var lV = _v5.c;
			var lLeft = _v5.d;
			var lRight = _v5.e;
			var _v6 = dict.e;
			var rClr = _v6.a;
			var rK = _v6.b;
			var rV = _v6.c;
			var rLeft = _v6.d;
			var rRight = _v6.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
			var _v1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, lRight, right));
		} else {
			_v2$2:
			while (true) {
				if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Black')) {
					if (right.d.$ === 'RBNode_elm_builtin') {
						if (right.d.a.$ === 'Black') {
							var _v3 = right.a;
							var _v4 = right.d;
							var _v5 = _v4.a;
							return $elm$core$Dict$moveRedRight(dict);
						} else {
							break _v2$2;
						}
					} else {
						var _v6 = right.a;
						var _v7 = right.d;
						return $elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _v2$2;
				}
			}
			return dict;
		}
	});
var $elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor.$ === 'Black') {
			if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
				var _v3 = lLeft.a;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					$elm$core$Dict$removeMin(left),
					right);
			} else {
				var _v4 = $elm$core$Dict$moveRedLeft(dict);
				if (_v4.$ === 'RBNode_elm_builtin') {
					var nColor = _v4.a;
					var nKey = _v4.b;
					var nValue = _v4.c;
					var nLeft = _v4.d;
					var nRight = _v4.e;
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						$elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				$elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return $elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var $elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Black')) {
					var _v4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
						var _v6 = lLeft.a;
						return A5(
							$elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2($elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _v7 = $elm$core$Dict$moveRedLeft(dict);
						if (_v7.$ === 'RBNode_elm_builtin') {
							var nColor = _v7.a;
							var nKey = _v7.b;
							var nValue = _v7.c;
							var nLeft = _v7.d;
							var nRight = _v7.e;
							return A5(
								$elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2($elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return $elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						$elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2($elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					$elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7($elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var $elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBNode_elm_builtin') {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _v1 = $elm$core$Dict$getMin(right);
				if (_v1.$ === 'RBNode_elm_builtin') {
					var minKey = _v1.b;
					var minValue = _v1.c;
					return A5(
						$elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						$elm$core$Dict$removeMin(right));
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					$elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2($elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var $elm$core$Dict$remove = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$removeHelp, key, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$finalize = function (state) {
	return {
		blocks: A2(
			$elm$core$List$map,
			function (b) {
				return _Utils_update(
					b,
					{
						properties: A2($elm$core$Dict$remove, 'status', b.properties)
					});
			},
			$elm$core$List$reverse(state.committedBlocks)),
		holdingStack: state.holdingStack,
		stack: state.stack
	};
};
var $author$project$MicroLaTeX$PrimitiveBlock$init = F3(
	function (idPrefix, outerCount, lines) {
		return {blockClassification: $elm$core$Maybe$Nothing, committedBlocks: _List_Nil, count: -1, firstBlockLine: 0, holdingStack: _List_Nil, idPrefix: idPrefix, inVerbatimBlock: false, indent: 0, label: '0, START', labelStack: _List_Nil, level: -1, lineNumber: -1, lines: lines, outerCount: 0, position: 0, sourceText: '', stack: _List_Nil};
	});
var $author$project$MicroLaTeX$PrimitiveBlock$loop = F2(
	function (s, f) {
		loop:
		while (true) {
			var _v0 = f(s);
			if (_v0.$ === 'Loop') {
				var s_ = _v0.a;
				var $temp$s = s_,
					$temp$f = f;
				s = $temp$s;
				f = $temp$f;
				continue loop;
			} else {
				var b = _v0.a;
				return b;
			}
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$Done = function (a) {
	return {$: 'Done', a: a};
};
var $author$project$MicroLaTeX$PrimitiveBlock$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $author$project$MicroLaTeX$ClassifyBlock$CEmpty = {$: 'CEmpty'};
var $author$project$MicroLaTeX$ClassifyBlock$CPlainText = {$: 'CPlainText'};
var $author$project$MicroLaTeX$ClassifyBlock$LXOrdinaryBlock = function (a) {
	return {$: 'LXOrdinaryBlock', a: a};
};
var $author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock = function (a) {
	return {$: 'CSpecialBlock', a: a};
};
var $elm$parser$Parser$Advanced$findSubString = _Parser_findSubString;
var $elm$parser$Parser$Advanced$fromInfo = F4(
	function (row, col, x, context) {
		return A2(
			$elm$parser$Parser$Advanced$AddRight,
			$elm$parser$Parser$Advanced$Empty,
			A4($elm$parser$Parser$Advanced$DeadEnd, row, col, x, context));
	});
var $elm$parser$Parser$Advanced$chompUntil = function (_v0) {
	var str = _v0.a;
	var expecting = _v0.b;
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			var _v1 = A5($elm$parser$Parser$Advanced$findSubString, str, s.offset, s.row, s.col, s.src);
			var newOffset = _v1.a;
			var newRow = _v1.b;
			var newCol = _v1.c;
			return _Utils_eq(newOffset, -1) ? A2(
				$elm$parser$Parser$Advanced$Bad,
				false,
				A4($elm$parser$Parser$Advanced$fromInfo, newRow, newCol, expecting, s.context)) : A3(
				$elm$parser$Parser$Advanced$Good,
				_Utils_cmp(s.offset, newOffset) < 0,
				_Utils_Tuple0,
				{col: newCol, context: s.context, indent: s.indent, offset: newOffset, row: newRow, src: s.src});
		});
};
var $elm$parser$Parser$Expecting = function (a) {
	return {$: 'Expecting', a: a};
};
var $elm$parser$Parser$toToken = function (str) {
	return A2(
		$elm$parser$Parser$Advanced$Token,
		str,
		$elm$parser$Parser$Expecting(str));
};
var $elm$parser$Parser$chompUntil = function (str) {
	return $elm$parser$Parser$Advanced$chompUntil(
		$elm$parser$Parser$toToken(str));
};
var $elm$parser$Parser$getOffset = $elm$parser$Parser$Advanced$getOffset;
var $elm$parser$Parser$getSource = $elm$parser$Parser$Advanced$getSource;
var $elm$parser$Parser$ignorer = $elm$parser$Parser$Advanced$ignorer;
var $elm$parser$Parser$keeper = $elm$parser$Parser$Advanced$keeper;
var $elm$parser$Parser$map = $elm$parser$Parser$Advanced$map;
var $elm$parser$Parser$succeed = $elm$parser$Parser$Advanced$succeed;
var $elm$parser$Parser$ExpectingSymbol = function (a) {
	return {$: 'ExpectingSymbol', a: a};
};
var $elm$parser$Parser$symbol = function (str) {
	return $elm$parser$Parser$Advanced$symbol(
		A2(
			$elm$parser$Parser$Advanced$Token,
			str,
			$elm$parser$Parser$ExpectingSymbol(str)));
};
var $author$project$MicroLaTeX$ClassifyBlock$pseudoBlockParser = F2(
	function (name, lxSpecial) {
		return A2(
			$elm$parser$Parser$map,
			function (_v0) {
				return $author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(lxSpecial);
			},
			A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$keeper,
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$succeed($elm$core$String$slice),
							$elm$parser$Parser$symbol('\\' + name)),
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$getOffset,
							$elm$parser$Parser$chompUntil('\n'))),
					$elm$parser$Parser$getOffset),
				$elm$parser$Parser$getSource));
	});
var $author$project$MicroLaTeX$ClassifyBlock$bannerParser = A2(
	$author$project$MicroLaTeX$ClassifyBlock$pseudoBlockParser,
	'banner',
	$author$project$MicroLaTeX$ClassifyBlock$LXOrdinaryBlock('banner'));
var $author$project$MicroLaTeX$ClassifyBlock$CBeginBlock = function (a) {
	return {$: 'CBeginBlock', a: a};
};
var $author$project$MicroLaTeX$ClassifyBlock$beginBlockParser = A2(
	$elm$parser$Parser$map,
	$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock,
	A2(
		$elm$parser$Parser$keeper,
		A2(
			$elm$parser$Parser$keeper,
			A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$succeed($elm$core$String$slice),
					$elm$parser$Parser$symbol('\\begin{')),
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$getOffset,
					$elm$parser$Parser$chompUntil('}'))),
			$elm$parser$Parser$getOffset),
		$elm$parser$Parser$getSource));
var $author$project$MicroLaTeX$ClassifyBlock$contentsParser = A2(
	$author$project$MicroLaTeX$ClassifyBlock$pseudoBlockParser,
	'contents',
	$author$project$MicroLaTeX$ClassifyBlock$LXOrdinaryBlock('contents'));
var $author$project$MicroLaTeX$ClassifyBlock$LXDescription = function (a) {
	return {$: 'LXDescription', a: a};
};
var $author$project$MicroLaTeX$ClassifyBlock$descriptionItemParser = A2(
	$elm$parser$Parser$ignorer,
	$elm$parser$Parser$succeed(
		$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
			$author$project$MicroLaTeX$ClassifyBlock$LXDescription('\\desc'))),
	$elm$parser$Parser$symbol('\\desc'));
var $author$project$MicroLaTeX$ClassifyBlock$CEndBlock = function (a) {
	return {$: 'CEndBlock', a: a};
};
var $author$project$MicroLaTeX$ClassifyBlock$endBlockParser = A2(
	$elm$parser$Parser$map,
	$author$project$MicroLaTeX$ClassifyBlock$CEndBlock,
	A2(
		$elm$parser$Parser$keeper,
		A2(
			$elm$parser$Parser$keeper,
			A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$succeed($elm$core$String$slice),
					$elm$parser$Parser$symbol('\\end{')),
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$getOffset,
					$elm$parser$Parser$chompUntil('}'))),
			$elm$parser$Parser$getOffset),
		$elm$parser$Parser$getSource));
var $author$project$MicroLaTeX$ClassifyBlock$LXItem = function (a) {
	return {$: 'LXItem', a: a};
};
var $author$project$MicroLaTeX$ClassifyBlock$itemParser = A2(
	$elm$parser$Parser$ignorer,
	$elm$parser$Parser$succeed(
		$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
			$author$project$MicroLaTeX$ClassifyBlock$LXItem('\\item'))),
	$elm$parser$Parser$symbol('\\item'));
var $author$project$MicroLaTeX$ClassifyBlock$markdownItemParser = A2(
	$elm$parser$Parser$ignorer,
	$elm$parser$Parser$succeed(
		$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
			$author$project$MicroLaTeX$ClassifyBlock$LXItem('-'))),
	$elm$parser$Parser$symbol('-'));
var $author$project$MicroLaTeX$ClassifyBlock$LXNumbered = function (a) {
	return {$: 'LXNumbered', a: a};
};
var $author$project$MicroLaTeX$ClassifyBlock$markdownNumberParser = A2(
	$elm$parser$Parser$ignorer,
	$elm$parser$Parser$succeed(
		$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
			$author$project$MicroLaTeX$ClassifyBlock$LXNumbered('.'))),
	$elm$parser$Parser$symbol('.'));
var $author$project$MicroLaTeX$ClassifyBlock$CMathBlockBegin = {$: 'CMathBlockBegin'};
var $author$project$MicroLaTeX$ClassifyBlock$mathBlockBeginParser = A2(
	$elm$parser$Parser$ignorer,
	$elm$parser$Parser$succeed($author$project$MicroLaTeX$ClassifyBlock$CMathBlockBegin),
	$elm$parser$Parser$symbol('\\['));
var $author$project$MicroLaTeX$ClassifyBlock$CMathBlockDelim = {$: 'CMathBlockDelim'};
var $author$project$MicroLaTeX$ClassifyBlock$mathBlockDelimParser = A2(
	$elm$parser$Parser$map,
	function (_v0) {
		return $author$project$MicroLaTeX$ClassifyBlock$CMathBlockDelim;
	},
	A2(
		$elm$parser$Parser$ignorer,
		$elm$parser$Parser$succeed(_Utils_Tuple0),
		$elm$parser$Parser$symbol('$$')));
var $author$project$MicroLaTeX$ClassifyBlock$CMathBlockEnd = {$: 'CMathBlockEnd'};
var $author$project$MicroLaTeX$ClassifyBlock$mathBlockEndParser = A2(
	$elm$parser$Parser$ignorer,
	$elm$parser$Parser$succeed($author$project$MicroLaTeX$ClassifyBlock$CMathBlockEnd),
	$elm$parser$Parser$symbol('\\]'));
var $author$project$MicroLaTeX$ClassifyBlock$numberedParser = A2(
	$elm$parser$Parser$ignorer,
	$elm$parser$Parser$succeed(
		$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
			$author$project$MicroLaTeX$ClassifyBlock$LXNumbered('\\numbered'))),
	$elm$parser$Parser$symbol('\\numbered'));
var $elm$parser$Parser$oneOf = $elm$parser$Parser$Advanced$oneOf;
var $elm$parser$Parser$Advanced$chompUntilEndOr = function (str) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			var _v0 = A5(_Parser_findSubString, str, s.offset, s.row, s.col, s.src);
			var newOffset = _v0.a;
			var newRow = _v0.b;
			var newCol = _v0.c;
			var adjustedOffset = (newOffset < 0) ? $elm$core$String$length(s.src) : newOffset;
			return A3(
				$elm$parser$Parser$Advanced$Good,
				_Utils_cmp(s.offset, adjustedOffset) < 0,
				_Utils_Tuple0,
				{col: newCol, context: s.context, indent: s.indent, offset: adjustedOffset, row: newRow, src: s.src});
		});
};
var $elm$parser$Parser$chompUntilEndOr = $elm$parser$Parser$Advanced$chompUntilEndOr;
var $author$project$MicroLaTeX$ClassifyBlock$ordinaryBlockParser = A2(
	$elm$parser$Parser$map,
	function (s) {
		return $author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
			$author$project$MicroLaTeX$ClassifyBlock$LXOrdinaryBlock(s));
	},
	A2(
		$elm$parser$Parser$keeper,
		A2(
			$elm$parser$Parser$keeper,
			A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$succeed($elm$core$String$slice),
					$elm$parser$Parser$symbol('| ')),
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$getOffset,
					$elm$parser$Parser$chompUntilEndOr(' '))),
			$elm$parser$Parser$getOffset),
		$elm$parser$Parser$getSource));
var $author$project$MicroLaTeX$ClassifyBlock$specialBlockParser = F2(
	function (name, lxSpecial) {
		return A2(
			$elm$parser$Parser$map,
			function (_v0) {
				return $author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(lxSpecial);
			},
			A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$keeper,
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$succeed($elm$core$String$slice),
							$elm$parser$Parser$symbol('\\' + (name + '{'))),
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$getOffset,
							$elm$parser$Parser$chompUntil('}'))),
					$elm$parser$Parser$getOffset),
				$elm$parser$Parser$getSource));
	});
var $author$project$MicroLaTeX$ClassifyBlock$specialOrdinaryBlockParser = function (name) {
	return A2(
		$author$project$MicroLaTeX$ClassifyBlock$specialBlockParser,
		name,
		$author$project$MicroLaTeX$ClassifyBlock$LXOrdinaryBlock(name));
};
var $author$project$MicroLaTeX$ClassifyBlock$CVerbatimBlockDelim = {$: 'CVerbatimBlockDelim'};
var $author$project$MicroLaTeX$ClassifyBlock$verbatimBlockDelimParser = A2(
	$elm$parser$Parser$map,
	function (_v0) {
		return $author$project$MicroLaTeX$ClassifyBlock$CVerbatimBlockDelim;
	},
	A2(
		$elm$parser$Parser$ignorer,
		$elm$parser$Parser$succeed(_Utils_Tuple0),
		$elm$parser$Parser$symbol('```')));
var $author$project$MicroLaTeX$ClassifyBlock$LXVerbatimBlock = function (a) {
	return {$: 'LXVerbatimBlock', a: a};
};
var $author$project$MicroLaTeX$ClassifyBlock$verbatimBlockParser = A2(
	$elm$parser$Parser$map,
	function (s) {
		return $author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
			$author$project$MicroLaTeX$ClassifyBlock$LXVerbatimBlock(s));
	},
	A2(
		$elm$parser$Parser$keeper,
		A2(
			$elm$parser$Parser$keeper,
			A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$succeed($elm$core$String$slice),
					$elm$parser$Parser$symbol('|| ')),
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$getOffset,
					$elm$parser$Parser$chompUntilEndOr(' '))),
			$elm$parser$Parser$getOffset),
		$elm$parser$Parser$getSource));
var $author$project$MicroLaTeX$ClassifyBlock$classifierParser = $elm$parser$Parser$oneOf(
	_List_fromArray(
		[
			$author$project$MicroLaTeX$ClassifyBlock$beginBlockParser,
			$author$project$MicroLaTeX$ClassifyBlock$endBlockParser,
			$author$project$MicroLaTeX$ClassifyBlock$mathBlockDelimParser,
			$author$project$MicroLaTeX$ClassifyBlock$mathBlockBeginParser,
			$author$project$MicroLaTeX$ClassifyBlock$mathBlockEndParser,
			$author$project$MicroLaTeX$ClassifyBlock$verbatimBlockDelimParser,
			$author$project$MicroLaTeX$ClassifyBlock$ordinaryBlockParser,
			$author$project$MicroLaTeX$ClassifyBlock$verbatimBlockParser,
			$author$project$MicroLaTeX$ClassifyBlock$itemParser,
			$author$project$MicroLaTeX$ClassifyBlock$descriptionItemParser,
			$author$project$MicroLaTeX$ClassifyBlock$markdownItemParser,
			$author$project$MicroLaTeX$ClassifyBlock$specialOrdinaryBlockParser('section'),
			$author$project$MicroLaTeX$ClassifyBlock$specialOrdinaryBlockParser('title'),
			$author$project$MicroLaTeX$ClassifyBlock$specialOrdinaryBlockParser('subsection'),
			$author$project$MicroLaTeX$ClassifyBlock$specialOrdinaryBlockParser('subsubsection'),
			$author$project$MicroLaTeX$ClassifyBlock$specialOrdinaryBlockParser('subheading'),
			$author$project$MicroLaTeX$ClassifyBlock$specialOrdinaryBlockParser('setcounter'),
			$author$project$MicroLaTeX$ClassifyBlock$specialOrdinaryBlockParser('shiftandsetcounter'),
			$author$project$MicroLaTeX$ClassifyBlock$bannerParser,
			$author$project$MicroLaTeX$ClassifyBlock$contentsParser,
			$author$project$MicroLaTeX$ClassifyBlock$numberedParser,
			$author$project$MicroLaTeX$ClassifyBlock$markdownNumberParser
		]));
var $elm$parser$Parser$DeadEnd = F3(
	function (row, col, problem) {
		return {col: col, problem: problem, row: row};
	});
var $elm$parser$Parser$problemToDeadEnd = function (p) {
	return A3($elm$parser$Parser$DeadEnd, p.row, p.col, p.problem);
};
var $elm$parser$Parser$run = F2(
	function (parser, source) {
		var _v0 = A2($elm$parser$Parser$Advanced$run, parser, source);
		if (_v0.$ === 'Ok') {
			var a = _v0.a;
			return $elm$core$Result$Ok(a);
		} else {
			var problems = _v0.a;
			return $elm$core$Result$Err(
				A2($elm$core$List$map, $elm$parser$Parser$problemToDeadEnd, problems));
		}
	});
var $elm$core$String$trimLeft = _String_trimLeft;
var $author$project$MicroLaTeX$ClassifyBlock$classify = function (str) {
	var str_ = $elm$core$String$trimLeft(str);
	if (str_ === '') {
		return $author$project$MicroLaTeX$ClassifyBlock$CEmpty;
	} else {
		var _v0 = A2($elm$parser$Parser$run, $author$project$MicroLaTeX$ClassifyBlock$classifierParser, str_);
		if (_v0.$ === 'Ok') {
			var classificationOfLine = _v0.a;
			return classificationOfLine;
		} else {
			return (str === '') ? $author$project$MicroLaTeX$ClassifyBlock$CEmpty : $author$project$MicroLaTeX$ClassifyBlock$CPlainText;
		}
	}
};
var $elm$parser$Parser$chompWhile = $elm$parser$Parser$Advanced$chompWhile;
var $author$project$MicroLaTeX$Line$prefixParser = F2(
	function (position, lineNumber) {
		return A2(
			$elm$parser$Parser$keeper,
			A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$keeper,
						$elm$parser$Parser$succeed(
							F4(
								function (prefixStart, prefixEnd, lineEnd, content) {
									return {
										content: A3($elm$core$String$slice, prefixEnd, lineEnd, content),
										indent: prefixEnd - prefixStart,
										lineNumber: lineNumber,
										position: position,
										prefix: A3($elm$core$String$slice, 0, prefixEnd, content)
									};
								})),
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$getOffset,
							$elm$parser$Parser$chompWhile(
								function (c) {
									return _Utils_eq(
										c,
										_Utils_chr(' '));
								}))),
					A2(
						$elm$parser$Parser$ignorer,
						$elm$parser$Parser$getOffset,
						$elm$parser$Parser$chompWhile(
							function (c) {
								return !_Utils_eq(
									c,
									_Utils_chr('\n'));
							}))),
				$elm$parser$Parser$getOffset),
			$elm$parser$Parser$getSource);
	});
var $author$project$MicroLaTeX$Line$classify = F3(
	function (position, lineNumber, str) {
		var _v0 = A2(
			$elm$parser$Parser$run,
			A2($author$project$MicroLaTeX$Line$prefixParser, position, lineNumber),
			str);
		if (_v0.$ === 'Err') {
			return {content: '!!ERROR', indent: 0, lineNumber: lineNumber, position: position, prefix: ''};
		} else {
			var result = _v0.a;
			return result;
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$getPosition = F2(
	function (rawLine, state) {
		return (rawLine === '') ? (state.position + 1) : ((state.position + $elm$core$String$length(rawLine)) + 1);
	});
var $author$project$Generic$BlockUtilities$updateMeta = F2(
	function (transformMeta, block) {
		var oldMeta = block.meta;
		var newMeta = transformMeta(oldMeta);
		return _Utils_update(
			block,
			{meta: newMeta});
	});
var $author$project$MicroLaTeX$PrimitiveBlock$addSource = F2(
	function (lastLine, block) {
		return A2(
			$author$project$Generic$BlockUtilities$updateMeta,
			function (m) {
				return _Utils_update(
					m,
					{
						numberOfLines: $elm$core$List$length(block.body) + 2,
						sourceText: block.firstLine + ('\n' + (A2($elm$core$String$join, '\n', block.body) + ('\n' + lastLine)))
					});
			},
			block);
	});
var $author$project$MicroLaTeX$PrimitiveBlock$slice = F3(
	function (a, b, list) {
		return A2(
			$elm$core$List$drop,
			a,
			A2($elm$core$List$take, b + 1, list));
	});
var $elm$core$Dict$singleton = F2(
	function (key, value) {
		return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
	});
var $author$project$MicroLaTeX$PrimitiveBlock$statusFinished = A2($elm$core$Dict$singleton, 'status', 'finished');
var $elm_community$list_extra$List$Extra$uncons = function (list) {
	if (!list.b) {
		return $elm$core$Maybe$Nothing;
	} else {
		var first = list.a;
		var rest = list.b;
		return $elm$core$Maybe$Just(
			_Utils_Tuple2(first, rest));
	}
};
var $author$project$MicroLaTeX$PrimitiveBlock$handleVerbatimBlock = F2(
	function (line, state) {
		var _v0 = $elm_community$list_extra$List$Extra$uncons(state.stack);
		if (_v0.$ === 'Nothing') {
			return state;
		} else {
			var _v1 = _v0.a;
			var block = _v1.a;
			var rest = _v1.b;
			var _v2 = $elm_community$list_extra$List$Extra$uncons(state.labelStack);
			if (_v2.$ === 'Nothing') {
				return state;
			} else {
				var _v3 = _v2.a;
				var topLabel = _v3.a;
				var otherLabels = _v3.b;
				var newBlock = A2(
					$author$project$MicroLaTeX$PrimitiveBlock$addSource,
					line.content,
					_Utils_update(
						block,
						{
							body: A3($author$project$MicroLaTeX$PrimitiveBlock$slice, topLabel.lineNumber + 1, state.lineNumber - 1, state.lines),
							properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished
						}));
				return _Utils_update(
					state,
					{
						committedBlocks: A2($elm$core$List$cons, newBlock, state.committedBlocks),
						inVerbatimBlock: false,
						labelStack: otherLabels,
						level: state.level - 1,
						stack: rest
					});
			}
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$Filled = {$: 'Filled'};
var $author$project$MicroLaTeX$PrimitiveBlock$Started = {$: 'Started'};
var $author$project$Generic$Language$Ordinary = function (a) {
	return {$: 'Ordinary', a: a};
};
var $author$project$Generic$Language$Paragraph = {$: 'Paragraph'};
var $author$project$Generic$Language$Verbatim = function (a) {
	return {$: 'Verbatim', a: a};
};
var $author$project$MicroLaTeX$PrimitiveBlock$verbatimBlockNames = _List_fromArray(
	['equation', 'table', 'array', 'textarray', 'align', 'aligned', 'math', 'code', 'verbatim', 'figure', 'verse', 'mathmacros', 'textmacros', 'hide', 'docinfo', 'csvtable', 'chart', 'svg', 'quiver', 'image', 'tikz', 'load-files', 'include', 'iframe']);
var $author$project$MicroLaTeX$PrimitiveBlock$getHeading = function (str) {
	var _v0 = $author$project$MicroLaTeX$ClassifyBlock$classify(str);
	switch (_v0.$) {
		case 'CBeginBlock':
			var label = _v0.a;
			return A2($elm$core$List$member, label, $author$project$MicroLaTeX$PrimitiveBlock$verbatimBlockNames) ? $author$project$Generic$Language$Verbatim(label) : $author$project$Generic$Language$Ordinary(label);
		case 'CMathBlockDelim':
			return $author$project$Generic$Language$Verbatim('math');
		case 'CVerbatimBlockDelim':
			return $author$project$Generic$Language$Verbatim('code');
		case 'CMathBlockBegin':
			return $author$project$Generic$Language$Verbatim('math');
		case 'CMathBlockEnd':
			return $author$project$Generic$Language$Verbatim('math');
		default:
			return $author$project$Generic$Language$Paragraph;
	}
};
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1.$) {
				case 'LT':
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$statusStarted = A2($elm$core$Dict$singleton, 'status', 'started');
var $author$project$MicroLaTeX$PrimitiveBlock$blockFromLine = F5(
	function (statePosition, idPrefix, count, level, line) {
		var indent = line.indent;
		var lineNumber = line.lineNumber;
		var position = line.position;
		var prefix = line.prefix;
		var content = line.content;
		return {
			args: _List_Nil,
			body: _List_Nil,
			firstLine: line.content,
			heading: $author$project$MicroLaTeX$PrimitiveBlock$getHeading(line.content),
			indent: indent,
			meta: {
				error: $elm$core$Maybe$Nothing,
				id: $author$project$ScriptaV2$Config$idPrefix + ('-' + $elm$core$String$fromInt(lineNumber)),
				lineNumber: lineNumber,
				messages: _List_Nil,
				numberOfLines: 0,
				position: (!statePosition) ? 0 : (statePosition + 2),
				sourceText: ''
			},
			properties: A3(
				$elm$core$Dict$insert,
				'level',
				$elm$core$String$fromInt(level),
				$author$project$MicroLaTeX$PrimitiveBlock$statusStarted),
			style: $elm$core$Maybe$Nothing
		};
	});
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $elm$core$String$trim = _String_trim;
var $author$project$MicroLaTeX$PrimitiveBlock$getArgs = function (mstr) {
	if (mstr.$ === 'Nothing') {
		return _List_Nil;
	} else {
		var str = mstr.a;
		var strs = A2(
			$elm$core$List$map,
			$elm$core$String$trim,
			A2($elm$core$String$split, ', ', str));
		return A2(
			$elm$core$List$filter,
			function (t) {
				return !A2($elm$core$String$contains, ':', t);
			},
			strs);
	}
};
var $elm$parser$Parser$Advanced$spaces = $elm$parser$Parser$Advanced$chompWhile(
	function (c) {
		return _Utils_eq(
			c,
			_Utils_chr(' ')) || (_Utils_eq(
			c,
			_Utils_chr('\n')) || _Utils_eq(
			c,
			_Utils_chr('\r')));
	});
var $elm$parser$Parser$spaces = $elm$parser$Parser$Advanced$spaces;
var $author$project$MicroLaTeX$Util$itemParser = F2(
	function (leftDelimiter, rightDelimiter) {
		return A2(
			$elm$parser$Parser$map,
			$elm$core$String$trim,
			A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$keeper,
						A2(
							$elm$parser$Parser$ignorer,
							A2(
								$elm$parser$Parser$ignorer,
								A2(
									$elm$parser$Parser$ignorer,
									$elm$parser$Parser$succeed($elm$core$String$slice),
									$elm$parser$Parser$chompUntil(leftDelimiter)),
								$elm$parser$Parser$symbol(leftDelimiter)),
							$elm$parser$Parser$spaces),
						A2(
							$elm$parser$Parser$ignorer,
							$elm$parser$Parser$getOffset,
							$elm$parser$Parser$chompUntil(rightDelimiter))),
					$elm$parser$Parser$getOffset),
				$elm$parser$Parser$getSource));
	});
var $author$project$MicroLaTeX$Util$bracedItemParser = A2($author$project$MicroLaTeX$Util$itemParser, '{', '}');
var $elm$parser$Parser$Advanced$loopHelp = F4(
	function (p, state, callback, s0) {
		loopHelp:
		while (true) {
			var _v0 = callback(state);
			var parse = _v0.a;
			var _v1 = parse(s0);
			if (_v1.$ === 'Good') {
				var p1 = _v1.a;
				var step = _v1.b;
				var s1 = _v1.c;
				if (step.$ === 'Loop') {
					var newState = step.a;
					var $temp$p = p || p1,
						$temp$state = newState,
						$temp$callback = callback,
						$temp$s0 = s1;
					p = $temp$p;
					state = $temp$state;
					callback = $temp$callback;
					s0 = $temp$s0;
					continue loopHelp;
				} else {
					var result = step.a;
					return A3($elm$parser$Parser$Advanced$Good, p || p1, result, s1);
				}
			} else {
				var p1 = _v1.a;
				var x = _v1.b;
				return A2($elm$parser$Parser$Advanced$Bad, p || p1, x);
			}
		}
	});
var $elm$parser$Parser$Advanced$loop = F2(
	function (state, callback) {
		return $elm$parser$Parser$Advanced$Parser(
			function (s) {
				return A4($elm$parser$Parser$Advanced$loopHelp, false, state, callback, s);
			});
	});
var $elm$parser$Parser$Advanced$Done = function (a) {
	return {$: 'Done', a: a};
};
var $elm$parser$Parser$Advanced$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $elm$parser$Parser$toAdvancedStep = function (step) {
	if (step.$ === 'Loop') {
		var s = step.a;
		return $elm$parser$Parser$Advanced$Loop(s);
	} else {
		var a = step.a;
		return $elm$parser$Parser$Advanced$Done(a);
	}
};
var $elm$parser$Parser$loop = F2(
	function (state, callback) {
		return A2(
			$elm$parser$Parser$Advanced$loop,
			state,
			function (s) {
				return A2(
					$elm$parser$Parser$map,
					$elm$parser$Parser$toAdvancedStep,
					callback(s));
			});
	});
var $elm$parser$Parser$Done = function (a) {
	return {$: 'Done', a: a};
};
var $elm$parser$Parser$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $author$project$MicroLaTeX$Util$manyHelp = F2(
	function (p, vs) {
		return $elm$parser$Parser$oneOf(
			_List_fromArray(
				[
					A2(
					$elm$parser$Parser$keeper,
					$elm$parser$Parser$succeed(
						function (v) {
							return $elm$parser$Parser$Loop(
								A2($elm$core$List$cons, v, vs));
						}),
					A2($elm$parser$Parser$ignorer, p, $elm$parser$Parser$spaces)),
					A2(
					$elm$parser$Parser$map,
					function (_v0) {
						return $elm$parser$Parser$Done(
							$elm$core$List$reverse(vs));
					},
					$elm$parser$Parser$succeed(_Utils_Tuple0))
				]));
	});
var $author$project$MicroLaTeX$Util$many = function (p) {
	return A2(
		$elm$parser$Parser$loop,
		_List_Nil,
		$author$project$MicroLaTeX$Util$manyHelp(p));
};
var $author$project$MicroLaTeX$Util$getBracedItems = function (str) {
	var _v0 = A2(
		$elm$parser$Parser$run,
		$author$project$MicroLaTeX$Util$many($author$project$MicroLaTeX$Util$bracedItemParser),
		str);
	if (_v0.$ === 'Ok') {
		var val = _v0.a;
		return val;
	} else {
		return _List_Nil;
	}
};
var $author$project$MicroLaTeX$PrimitiveBlock$getKVData = function (mstr) {
	if (mstr.$ === 'Nothing') {
		return _List_Nil;
	} else {
		var str = mstr.a;
		var strs = A2(
			$elm$core$List$map,
			$elm$core$String$trim,
			A2($elm$core$String$split, ', ', str));
		return A2(
			$elm$core$List$filter,
			function (t) {
				return A2($elm$core$String$contains, ':', t);
			},
			strs);
	}
};
var $author$project$MicroLaTeX$Util$bracketedItemParser = A2($author$project$MicroLaTeX$Util$itemParser, '[', ']');
var $author$project$MicroLaTeX$Util$getBracketedItem = function (str) {
	var _v0 = A2($elm$parser$Parser$run, $author$project$MicroLaTeX$Util$bracketedItemParser, str);
	if (_v0.$ === 'Ok') {
		var val = _v0.a;
		return $elm$core$Maybe$Just(val);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$MicroLaTeX$Util$macroValParser = function (macroName) {
	return A2(
		$elm$parser$Parser$map,
		$elm$core$String$trim,
		A2(
			$elm$parser$Parser$keeper,
			A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$keeper,
					A2(
						$elm$parser$Parser$ignorer,
						A2(
							$elm$parser$Parser$ignorer,
							A2(
								$elm$parser$Parser$ignorer,
								$elm$parser$Parser$succeed($elm$core$String$slice),
								$elm$parser$Parser$chompUntil('\\' + (macroName + '{'))),
							$elm$parser$Parser$symbol('\\' + (macroName + '{'))),
						$elm$parser$Parser$spaces),
					A2(
						$elm$parser$Parser$ignorer,
						$elm$parser$Parser$getOffset,
						$elm$parser$Parser$chompUntilEndOr('}'))),
				$elm$parser$Parser$getOffset),
			$elm$parser$Parser$getSource));
};
var $author$project$MicroLaTeX$Util$getMicroLaTeXItem = F2(
	function (key, str) {
		var _v0 = A2(
			$elm$parser$Parser$run,
			$author$project$MicroLaTeX$Util$macroValParser(key),
			str);
		if (_v0.$ === 'Ok') {
			var val = _v0.a;
			return $elm$core$Maybe$Just(val);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$MicroLaTeX$Line$getNameAndArgString = function (line) {
	var normalizedLine = $elm$core$String$trim(line.content);
	var name = function () {
		var _v0 = A2($author$project$MicroLaTeX$Util$getMicroLaTeXItem, 'begin', normalizedLine);
		if (_v0.$ === 'Just') {
			var str = _v0.a;
			return $elm$core$Maybe$Just(str);
		} else {
			return (normalizedLine === '$$') ? $elm$core$Maybe$Just('math') : $elm$core$Maybe$Nothing;
		}
	}();
	return _Utils_Tuple2(
		name,
		$author$project$MicroLaTeX$Util$getBracketedItem(normalizedLine));
};
var $author$project$MicroLaTeX$PrimitiveBlock$KVInKey = {$: 'KVInKey'};
var $author$project$MicroLaTeX$PrimitiveBlock$KVInValue = {$: 'KVInValue'};
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$core$Dict$fromList = function (assocs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, dict) {
				var key = _v0.a;
				var value = _v0.b;
				return A3($elm$core$Dict$insert, key, value, dict);
			}),
		$elm$core$Dict$empty,
		assocs);
};
var $author$project$MicroLaTeX$PrimitiveBlock$nextKVStep = function (state) {
	var _v0 = $elm_community$list_extra$List$Extra$uncons(state.input);
	if (_v0.$ === 'Nothing') {
		var kvList_ = function () {
			var _v2 = state.currentKey;
			if (_v2.$ === 'Nothing') {
				return state.kvList;
			} else {
				var key = _v2.a;
				return A2(
					$elm$core$List$map,
					function (_v3) {
						var k = _v3.a;
						var v = _v3.b;
						return _Utils_Tuple2(
							k,
							$elm$core$List$reverse(v));
					},
					A2(
						$elm$core$List$cons,
						_Utils_Tuple2(key, state.currentValue),
						state.kvList));
			}
		}();
		return $author$project$MicroLaTeX$PrimitiveBlock$Done(
			$elm$core$Dict$fromList(
				A2(
					$elm$core$List$map,
					function (_v1) {
						var k = _v1.a;
						var v = _v1.b;
						return _Utils_Tuple2(
							k,
							A2($elm$core$String$join, ' ', v));
					},
					kvList_)));
	} else {
		var _v4 = _v0.a;
		var item = _v4.a;
		var rest = _v4.b;
		var _v5 = state.kvStatus;
		if (_v5.$ === 'KVInKey') {
			if (A2($elm$core$String$contains, ':', item)) {
				var _v6 = state.currentKey;
				if (_v6.$ === 'Nothing') {
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						_Utils_update(
							state,
							{
								currentKey: $elm$core$Maybe$Just(
									A2($elm$core$String$dropRight, 1, item)),
								input: rest,
								kvStatus: $author$project$MicroLaTeX$PrimitiveBlock$KVInValue
							}));
				} else {
					var key = _v6.a;
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						{
							currentKey: $elm$core$Maybe$Just(
								A2($elm$core$String$dropRight, 1, item)),
							currentValue: _List_Nil,
							input: rest,
							kvList: A2(
								$elm$core$List$cons,
								_Utils_Tuple2(key, state.currentValue),
								state.kvList),
							kvStatus: $author$project$MicroLaTeX$PrimitiveBlock$KVInValue
						});
				}
			} else {
				return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					_Utils_update(
						state,
						{input: rest}));
			}
		} else {
			if (A2($elm$core$String$contains, ':', item)) {
				var _v7 = state.currentKey;
				if (_v7.$ === 'Nothing') {
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						_Utils_update(
							state,
							{
								currentKey: $elm$core$Maybe$Just(
									A2($elm$core$String$dropRight, 1, item)),
								currentValue: _List_Nil,
								input: rest,
								kvStatus: $author$project$MicroLaTeX$PrimitiveBlock$KVInValue
							}));
				} else {
					var key = _v7.a;
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						_Utils_update(
							state,
							{
								currentKey: $elm$core$Maybe$Just(
									A2($elm$core$String$dropRight, 1, item)),
								currentValue: _List_Nil,
								input: rest,
								kvList: A2(
									$elm$core$List$cons,
									_Utils_Tuple2(key, state.currentValue),
									state.kvList),
								kvStatus: $author$project$MicroLaTeX$PrimitiveBlock$KVInValue
							}));
				}
			} else {
				return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					_Utils_update(
						state,
						{
							currentValue: A2($elm$core$List$cons, item, state.currentValue),
							input: rest
						}));
			}
		}
	}
};
var $author$project$MicroLaTeX$PrimitiveBlock$prepareKVData = function (data_) {
	var initialState = {currentKey: $elm$core$Maybe$Nothing, currentValue: _List_Nil, input: data_, kvList: _List_Nil, kvStatus: $author$project$MicroLaTeX$PrimitiveBlock$KVInKey};
	return A2($author$project$MicroLaTeX$PrimitiveBlock$loop, initialState, $author$project$MicroLaTeX$PrimitiveBlock$nextKVStep);
};
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $author$project$MicroLaTeX$PrimitiveBlock$explode = function (txt) {
	return A2(
		$elm$core$List$map,
		$elm$core$String$split(':'),
		txt);
};
var $author$project$MicroLaTeX$PrimitiveBlock$fix = function (strs) {
	if (strs.b) {
		if (strs.b.b) {
			var a = strs.a;
			var _v1 = strs.b;
			var b = _v1.a;
			return A2(
				$elm$core$List$cons,
				a + ':',
				A2($elm$core$List$cons, b, _List_Nil));
		} else {
			var a = strs.a;
			return A2($elm$core$List$cons, a, _List_Nil);
		}
	} else {
		return _List_Nil;
	}
};
var $author$project$MicroLaTeX$PrimitiveBlock$prepareList = function (strs) {
	return $elm$core$List$concat(
		A2(
			$elm$core$List$map,
			$author$project$MicroLaTeX$PrimitiveBlock$fix,
			$author$project$MicroLaTeX$PrimitiveBlock$explode(strs)));
};
var $author$project$MicroLaTeX$PrimitiveBlock$updateHeadingWithName = F2(
	function (name_, heading) {
		if (name_.$ === 'Nothing') {
			return heading;
		} else {
			var name = name_.a;
			switch (heading.$) {
				case 'Paragraph':
					return $author$project$Generic$Language$Paragraph;
				case 'Ordinary':
					if (heading.a === 'tabular') {
						return $author$project$Generic$Language$Ordinary('table');
					} else {
						return $author$project$Generic$Language$Ordinary(name);
					}
				default:
					return $author$project$Generic$Language$Verbatim(name);
			}
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$elaborate = F2(
	function (line, pb) {
		if (_Utils_eq(
			pb.body,
			_List_fromArray(
				['']))) {
			return pb;
		} else {
			var body = function () {
				var _v2 = pb.heading;
				if (_v2.$ === 'Verbatim') {
					return A2($elm$core$List$map, $elm$core$String$trimLeft, pb.body);
				} else {
					return pb.body;
				}
			}();
			var _v0 = $author$project$MicroLaTeX$Line$getNameAndArgString(line);
			var name = _v0.a;
			var args_ = _v0.b;
			var namedArgs = $author$project$MicroLaTeX$PrimitiveBlock$getKVData(args_);
			var properties = $author$project$MicroLaTeX$PrimitiveBlock$prepareKVData(
				$author$project$MicroLaTeX$PrimitiveBlock$prepareList(namedArgs));
			var simpleArgs = function () {
				if (name.$ === 'Nothing') {
					return $author$project$MicroLaTeX$PrimitiveBlock$getArgs(args_);
				} else {
					var name_ = name.a;
					var prefix = '\\begin{' + (name_ + '}');
					var adjustedLine = A3($elm$core$String$replace, prefix, '', line.content);
					return ((name_ === 'table') || (name_ === 'tabular')) ? _List_fromArray(
						[adjustedLine]) : $author$project$MicroLaTeX$Util$getBracedItems(adjustedLine);
				}
			}();
			return _Utils_update(
				pb,
				{
					args: simpleArgs,
					body: body,
					heading: A2($author$project$MicroLaTeX$PrimitiveBlock$updateHeadingWithName, name, pb.heading),
					properties: properties
				});
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$beginBlock = F5(
	function (idPrefix, count, classifier, line, state) {
		var newBlockClassifier = function () {
			if (classifier.$ === 'CBeginBlock') {
				var name = classifier.a;
				return A2($elm$core$List$member, name, $author$project$MicroLaTeX$PrimitiveBlock$verbatimBlockNames) ? $elm$core$Maybe$Just(classifier) : $elm$core$Maybe$Nothing;
			} else {
				return $elm$core$Maybe$Nothing;
			}
		}();
		var level = state.level + 1;
		var newBlock = A2(
			$author$project$MicroLaTeX$PrimitiveBlock$elaborate,
			line,
			A5($author$project$MicroLaTeX$PrimitiveBlock$blockFromLine, state.position, idPrefix, count, level, line));
		var labelStack = function () {
			var _v0 = $elm_community$list_extra$List$Extra$uncons(state.labelStack);
			if (_v0.$ === 'Nothing') {
				return state.labelStack;
			} else {
				var _v1 = _v0.a;
				var label = _v1.a;
				var rest_ = _v1.b;
				return A2(
					$elm$core$List$cons,
					_Utils_update(
						label,
						{status: $author$project$MicroLaTeX$PrimitiveBlock$Filled}),
					rest_);
			}
		}();
		return _Utils_update(
			state,
			{
				blockClassification: newBlockClassifier,
				firstBlockLine: line.lineNumber,
				labelStack: A2(
					$elm$core$List$cons,
					{classification: classifier, level: level, lineNumber: line.lineNumber, status: $author$project$MicroLaTeX$PrimitiveBlock$Started},
					labelStack),
				level: level,
				lineNumber: line.lineNumber,
				stack: A2($elm$core$List$cons, newBlock, state.stack)
			});
	});
var $author$project$MicroLaTeX$PrimitiveBlock$statusFilled = A2($elm$core$Dict$singleton, 'status', 'filled');
var $author$project$MicroLaTeX$PrimitiveBlock$changeStatusOfStackTop = F3(
	function (block, rest, state) {
		if (_Utils_eq(
			A2(
				$elm$core$Maybe$map,
				function ($) {
					return $.status;
				},
				$elm$core$List$head(state.labelStack)),
			$elm$core$Maybe$Just($author$project$MicroLaTeX$PrimitiveBlock$Filled))) {
			return state.stack;
		} else {
			if (_Utils_eq(
				A2(
					$elm$core$Maybe$map,
					function ($) {
						return $.status;
					},
					$elm$core$List$head(state.labelStack)),
				$elm$core$Maybe$Just($author$project$MicroLaTeX$PrimitiveBlock$Started))) {
				var firstBlockLine = A2(
					$elm$core$Maybe$withDefault,
					0,
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.lineNumber;
						},
						$elm$core$List$head(state.labelStack)));
				var newBlock = function () {
					var body = A3($author$project$MicroLaTeX$PrimitiveBlock$slice, firstBlockLine + 1, state.lineNumber - 1, state.lines);
					var numberOfLines = $elm$core$List$length(body);
					return A2(
						$author$project$Generic$BlockUtilities$updateMeta,
						function (m) {
							return _Utils_update(
								m,
								{numberOfLines: numberOfLines});
						},
						_Utils_update(
							block,
							{
								body: A3($author$project$MicroLaTeX$PrimitiveBlock$slice, firstBlockLine + 1, state.lineNumber - 1, state.lines),
								properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFilled
							}));
				}();
				return A2($elm$core$List$cons, newBlock, rest);
			} else {
				return state.stack;
			}
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$dispatchBeginBlock = F5(
	function (idPrefix, count, classifier, line, state) {
		var _v0 = $elm_community$list_extra$List$Extra$uncons(state.stack);
		if (_v0.$ === 'Nothing') {
			return A5($author$project$MicroLaTeX$PrimitiveBlock$beginBlock, idPrefix, count, classifier, line, state);
		} else {
			var _v1 = _v0.a;
			var block = _v1.a;
			var rest = _v1.b;
			return A5(
				$author$project$MicroLaTeX$PrimitiveBlock$beginBlock,
				idPrefix,
				count,
				classifier,
				line,
				_Utils_update(
					state,
					{
						stack: A3($author$project$MicroLaTeX$PrimitiveBlock$changeStatusOfStackTop, block, rest, state)
					}));
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$getContent = F3(
	function (classifier, line, state) {
		_v0$4:
		while (true) {
			switch (classifier.$) {
				case 'CPlainText':
					return $elm$core$List$reverse(
						A3($author$project$MicroLaTeX$PrimitiveBlock$slice, state.firstBlockLine, line.lineNumber - 1, state.lines));
				case 'CSpecialBlock':
					switch (classifier.a.$) {
						case 'LXItem':
							var str = classifier.a.a;
							return A2(
								$elm$core$List$map,
								function (line_) {
									return $elm$core$String$trim(
										A3($elm$core$String$replace, str, '', line_));
								},
								$elm$core$List$reverse(
									A3($author$project$MicroLaTeX$PrimitiveBlock$slice, state.firstBlockLine, line.lineNumber, state.lines)));
						case 'LXNumbered':
							var str = classifier.a.a;
							return A2(
								$elm$core$List$map,
								function (line_) {
									return $elm$core$String$trim(
										A3($elm$core$String$replace, str, '', line_));
								},
								$elm$core$List$reverse(
									A3($author$project$MicroLaTeX$PrimitiveBlock$slice, state.firstBlockLine, line.lineNumber, state.lines)));
						default:
							break _v0$4;
					}
				case 'CEndBlock':
					return $elm$core$List$reverse(
						A3($author$project$MicroLaTeX$PrimitiveBlock$slice, state.firstBlockLine + 1, line.lineNumber - 1, state.lines));
				default:
					break _v0$4;
			}
		}
		return $elm$core$List$reverse(
			A3($author$project$MicroLaTeX$PrimitiveBlock$slice, state.firstBlockLine + 1, line.lineNumber - 1, state.lines));
	});
var $author$project$MicroLaTeX$PrimitiveBlock$getSource = F2(
	function (line, state) {
		return A2(
			$elm$core$String$join,
			'\n',
			A3($author$project$MicroLaTeX$PrimitiveBlock$slice, state.firstBlockLine, line.lineNumber, state.lines));
	});
var $author$project$MicroLaTeX$PrimitiveBlock$setError = function (error) {
	return $author$project$Generic$BlockUtilities$updateMeta(
		function (m) {
			return _Utils_update(
				m,
				{error: error});
		});
};
var $author$project$MicroLaTeX$PrimitiveBlock$newBlockWithError = F3(
	function (classifier, content, block) {
		_v0$4:
		while (true) {
			switch (classifier.$) {
				case 'CMathBlockDelim':
					return A2(
						$author$project$MicroLaTeX$PrimitiveBlock$setError,
						$elm$core$Maybe$Just('Missing $$ at end'),
						_Utils_update(
							block,
							{
								body: $elm$core$List$reverse(content),
								properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished
							}));
				case 'CVerbatimBlockDelim':
					return A2(
						$author$project$MicroLaTeX$PrimitiveBlock$setError,
						$elm$core$Maybe$Just('Missing ``` at end'),
						_Utils_update(
							block,
							{
								body: A2(
									$elm$core$List$map,
									A2($elm$core$String$replace, '```', ''),
									$elm$core$List$reverse(content)),
								properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished
							}));
				case 'CSpecialBlock':
					switch (classifier.a.$) {
						case 'LXItem':
							var str = classifier.a.a;
							return _Utils_update(
								block,
								{
									body: A2(
										$elm$core$List$filter,
										function (line_) {
											return line_ !== '';
										},
										$elm$core$List$reverse(content)),
									properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished
								});
						case 'LXNumbered':
							var str = classifier.a.a;
							return _Utils_update(
								block,
								{
									body: A2(
										$elm$core$List$filter,
										function (line_) {
											return line_ !== '';
										},
										$elm$core$List$reverse(content)),
									properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished
								});
						default:
							break _v0$4;
					}
				default:
					break _v0$4;
			}
		}
		return _Utils_update(
			block,
			{
				body: $elm$core$List$reverse(content),
				properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished
			});
	});
var $author$project$MicroLaTeX$PrimitiveBlock$newBlockWithOutError = F2(
	function (content, block) {
		return _Utils_update(
			block,
			{
				body: $elm$core$List$reverse(content),
				properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished
			});
	});
var $author$project$MicroLaTeX$PrimitiveBlock$resolveIfStackEmpty = function (state) {
	return _Utils_eq(state.stack, _List_Nil) ? _Utils_update(
		state,
		{
			committedBlocks: _Utils_ap(state.holdingStack, state.committedBlocks),
			holdingStack: _List_Nil
		}) : state;
};
var $author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch = F4(
	function (labelHead, classifier, line, state) {
		var _v0 = $elm_community$list_extra$List$Extra$uncons(state.stack);
		if (_v0.$ === 'Nothing') {
			return state;
		} else {
			var _v1 = _v0.a;
			var block = _v1.a;
			var rest = _v1.b;
			if (_Utils_eq(
				A2(
					$elm$core$Maybe$map,
					function ($) {
						return $.status;
					},
					labelHead),
				$elm$core$Maybe$Just($author$project$MicroLaTeX$PrimitiveBlock$Filled))) {
				return $author$project$MicroLaTeX$PrimitiveBlock$resolveIfStackEmpty(
					_Utils_update(
						state,
						{
							committedBlocks: A2(
								$elm$core$List$cons,
								A2(
									$author$project$MicroLaTeX$PrimitiveBlock$addSource,
									line.content,
									_Utils_update(
										block,
										{properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished})),
								state.committedBlocks),
							level: state.level - 1,
							stack: rest
						}));
			} else {
				var newBlock = function () {
					_v2$2:
					while (true) {
						if (classifier.$ === 'CSpecialBlock') {
							switch (classifier.a.$) {
								case 'LXVerbatimBlock':
									if (classifier.a.a === 'texComment') {
										return A2(
											$author$project$MicroLaTeX$PrimitiveBlock$addSource,
											line.content,
											A3(
												$author$project$MicroLaTeX$PrimitiveBlock$newBlockWithError,
												classifier,
												_Utils_ap(
													A3($author$project$MicroLaTeX$PrimitiveBlock$getContent, classifier, line, state),
													_List_fromArray(
														[block.firstLine])),
												block));
									} else {
										break _v2$2;
									}
								case 'LXOrdinaryBlock':
									var name = classifier.a.a;
									if (name === 'banner') {
										var listSlice = F3(
											function (start, end, list) {
												return A2(
													$elm$core$List$drop,
													start,
													A2($elm$core$List$take, end, list));
											});
										var finish = state.lineNumber;
										var start = function (x) {
											return x + 1;
										}(
											A2(
												$elm$core$Maybe$withDefault,
												finish,
												A2(
													$elm$core$Maybe$map,
													function ($) {
														return $.lineNumber;
													},
													labelHead)));
										return _Utils_update(
											block,
											{
												body: A3(listSlice, start, finish, state.lines)
											});
									} else {
										return block;
									}
								default:
									break _v2$2;
							}
						} else {
							break _v2$2;
						}
					}
					if (A2(
						$elm$core$List$member,
						classifier,
						A2($elm$core$List$map, $author$project$MicroLaTeX$ClassifyBlock$CEndBlock, $author$project$MicroLaTeX$PrimitiveBlock$verbatimBlockNames))) {
						var sourceText = A2($author$project$MicroLaTeX$PrimitiveBlock$getSource, line, state);
						return A3(
							$author$project$MicroLaTeX$PrimitiveBlock$newBlockWithError,
							classifier,
							A3($author$project$MicroLaTeX$PrimitiveBlock$getContent, classifier, line, state),
							A2(
								$author$project$Generic$BlockUtilities$updateMeta,
								function (m) {
									return _Utils_update(
										m,
										{
											numberOfLines: $elm$core$List$length(block.body),
											sourceText: sourceText
										});
								},
								block));
					} else {
						return A2(
							$author$project$MicroLaTeX$PrimitiveBlock$addSource,
							line.content,
							A2(
								$author$project$MicroLaTeX$PrimitiveBlock$newBlockWithOutError,
								A3($author$project$MicroLaTeX$PrimitiveBlock$getContent, classifier, line, state),
								block));
					}
				}();
				return $author$project$MicroLaTeX$PrimitiveBlock$resolveIfStackEmpty(
					_Utils_update(
						state,
						{
							holdingStack: A2($elm$core$List$cons, newBlock, state.holdingStack),
							labelStack: A2($elm$core$List$drop, 1, state.labelStack),
							level: state.level - 1,
							stack: A2(
								$elm$core$List$drop,
								1,
								A3($author$project$MicroLaTeX$PrimitiveBlock$changeStatusOfStackTop, block, rest, state))
						}));
			}
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$finishBlock = F2(
	function (lastLine, state) {
		var _v0 = $elm_community$list_extra$List$Extra$uncons(state.stack);
		if (_v0.$ === 'Nothing') {
			return state;
		} else {
			var _v1 = _v0.a;
			var block = _v1.a;
			var updatedBlock = A2(
				$author$project$MicroLaTeX$PrimitiveBlock$addSource,
				lastLine,
				A2(
					$author$project$Generic$BlockUtilities$updateMeta,
					function (m) {
						return _Utils_update(
							m,
							{numberOfLines: state.lineNumber - state.firstBlockLine});
					},
					_Utils_update(
						block,
						{properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished})));
			return _Utils_update(
				state,
				{
					committedBlocks: A2($elm$core$List$cons, updatedBlock, state.committedBlocks),
					labelStack: A2($elm$core$List$drop, 1, state.labelStack),
					stack: A2($elm$core$List$drop, 1, state.stack)
				});
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$verbatimBlocks = _List_fromArray(
	['table', 'textarray', 'array', 'code', 'equation', 'align', 'aligned', 'verbatim', 'figure']);
var $author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMismatch = F4(
	function (label_, classifier, line, state) {
		var _v0 = $elm_community$list_extra$List$Extra$uncons(state.stack);
		if (_v0.$ === 'Nothing') {
			return state;
		} else {
			var _v1 = _v0.a;
			var block = _v1.a;
			var rest = _v1.b;
			var _v2 = $elm_community$list_extra$List$Extra$uncons(state.labelStack);
			if (_v2.$ === 'Nothing') {
				return state;
			} else {
				var _v3 = _v2.a;
				var label = _v3.a;
				var _v4 = function () {
					var _v5 = block.heading;
					switch (_v5.$) {
						case 'Paragraph':
							return _Utils_Tuple2($author$project$Generic$Language$Paragraph, '-');
						case 'Ordinary':
							var name_ = _v5.a;
							return _Utils_Tuple2(
								$author$project$Generic$Language$Ordinary(name_),
								name_);
						default:
							var name_ = _v5.a;
							return A2($elm$core$List$member, name_, $author$project$MicroLaTeX$PrimitiveBlock$verbatimBlocks) ? _Utils_Tuple2(
								$author$project$Generic$Language$Verbatim('code'),
								'code') : _Utils_Tuple2(
								$author$project$Generic$Language$Verbatim(name_),
								name_);
					}
				}();
				var heading = _v4.a;
				var name__ = _v4.b;
				var body = A2($elm$core$List$member, name__, $author$project$MicroLaTeX$PrimitiveBlock$verbatimBlockNames) ? $elm$core$List$reverse(
					A3($author$project$MicroLaTeX$PrimitiveBlock$getContent, label_.classification, line, state)) : $elm$core$List$reverse(
					A3($author$project$MicroLaTeX$PrimitiveBlock$getContent, label_.classification, line, state));
				var newBlock = function () {
					var error = function () {
						var _v6 = _Utils_Tuple2(label.classification, classifier);
						if (_v6.a.$ === 'CBeginBlock') {
							if (_v6.b.$ === 'CEndBlock') {
								var a = _v6.a.a;
								var b = _v6.b.a;
								return $elm$core$Maybe$Just('Mismatch: \\begin{' + (a + ('} ≠ \\end{' + (b + '}'))));
							} else {
								var a = _v6.a.a;
								return $elm$core$Maybe$Just('Missing \\end{' + (a + '}'));
							}
						} else {
							return $elm$core$Maybe$Nothing;
						}
					}();
					return A2(
						$author$project$MicroLaTeX$PrimitiveBlock$addSource,
						line.content,
						A2(
							$author$project$Generic$BlockUtilities$updateMeta,
							function (m) {
								return _Utils_update(
									m,
									{
										error: error,
										numberOfLines: $elm$core$List$length(body)
									});
							},
							_Utils_update(
								block,
								{args: block.args, body: body, heading: heading, properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished})));
				}();
				return $author$project$MicroLaTeX$PrimitiveBlock$resolveIfStackEmpty(
					A2(
						$author$project$MicroLaTeX$PrimitiveBlock$finishBlock,
						line.content,
						_Utils_update(
							state,
							{
								holdingStack: A2($elm$core$List$cons, newBlock, state.holdingStack),
								labelStack: A2($elm$core$List$drop, 1, state.labelStack),
								level: state.level - 1,
								stack: rest
							})));
			}
		}
	});
var $author$project$MicroLaTeX$ClassifyBlock$match = F2(
	function (c1, c2) {
		var _v0 = _Utils_Tuple2(c1, c2);
		_v0$5:
		while (true) {
			switch (_v0.a.$) {
				case 'CBeginBlock':
					if (_v0.b.$ === 'CEndBlock') {
						var label1 = _v0.a.a;
						var label2 = _v0.b.a;
						return _Utils_eq(label1, label2);
					} else {
						break _v0$5;
					}
				case 'CMathBlockDelim':
					if (_v0.b.$ === 'CMathBlockDelim') {
						var _v1 = _v0.a;
						var _v2 = _v0.b;
						return true;
					} else {
						break _v0$5;
					}
				case 'CVerbatimBlockDelim':
					if (_v0.b.$ === 'CVerbatimBlockDelim') {
						var _v3 = _v0.a;
						var _v4 = _v0.b;
						return false;
					} else {
						break _v0$5;
					}
				case 'CSpecialBlock':
					return true;
				case 'CMathBlockBegin':
					if (_v0.b.$ === 'CMathBlockEnd') {
						var _v5 = _v0.a;
						var _v6 = _v0.b;
						return true;
					} else {
						break _v0$5;
					}
				default:
					break _v0$5;
			}
		}
		return false;
	});
var $author$project$MicroLaTeX$PrimitiveBlock$endBlock = F3(
	function (classification, currentLine, state) {
		var _v0 = $elm$core$List$head(state.labelStack);
		if (_v0.$ === 'Nothing') {
			return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
				_Utils_update(
					state,
					{level: state.level - 1}));
		} else {
			var label = _v0.a;
			return (A2($author$project$MicroLaTeX$ClassifyBlock$match, label.classification, classification) && _Utils_eq(state.level, label.level)) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
				A4(
					$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch,
					$elm$core$Maybe$Just(label),
					classification,
					currentLine,
					_Utils_update(
						state,
						{blockClassification: $elm$core$Maybe$Nothing}))) : $author$project$MicroLaTeX$PrimitiveBlock$Loop(
				A4(
					$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMismatch,
					label,
					classification,
					currentLine,
					_Utils_update(
						state,
						{blockClassification: $elm$core$Maybe$Nothing})));
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$resetLevelIfStackIsEmpty = function (state) {
	return $elm$core$List$isEmpty(state.stack) ? _Utils_update(
		state,
		{level: -1}) : state;
};
var $author$project$MicroLaTeX$PrimitiveBlock$emptyLine = F2(
	function (currentLine, state) {
		var _v0 = $elm$core$List$head(state.labelStack);
		if (_v0.$ === 'Nothing') {
			return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
				$author$project$MicroLaTeX$PrimitiveBlock$resetLevelIfStackIsEmpty(state));
		} else {
			var label = _v0.a;
			var _v1 = label.classification;
			switch (_v1.$) {
				case 'CPlainText':
					return A3($author$project$MicroLaTeX$PrimitiveBlock$endBlock, $author$project$MicroLaTeX$ClassifyBlock$CPlainText, currentLine, state);
				case 'CMathBlockDelim':
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						A4($author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMismatch, label, $author$project$MicroLaTeX$ClassifyBlock$CMathBlockDelim, currentLine, state));
				case 'CMathBlockBegin':
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(state);
				case 'CMathBlockEnd':
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						$author$project$MicroLaTeX$PrimitiveBlock$resetLevelIfStackIsEmpty(state));
				case 'CBeginBlock':
					var name = _v1.a;
					return A2($elm$core$List$member, name, $author$project$MicroLaTeX$PrimitiveBlock$verbatimBlocks) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						A4(
							$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMismatch,
							label,
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock(name),
							currentLine,
							state)) : $author$project$MicroLaTeX$PrimitiveBlock$Loop(state);
				case 'CSpecialBlock':
					switch (_v1.a.$) {
						case 'LXPseudoBlock':
							var _v2 = _v1.a;
							return A3(
								$author$project$MicroLaTeX$PrimitiveBlock$endBlock,
								$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
									$author$project$MicroLaTeX$ClassifyBlock$LXItem('')),
								currentLine,
								state);
						case 'LXItem':
							var str = _v1.a.a;
							return A3(
								$author$project$MicroLaTeX$PrimitiveBlock$endBlock,
								$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
									$author$project$MicroLaTeX$ClassifyBlock$LXItem(str)),
								currentLine,
								state);
						case 'LXDescription':
							var str = _v1.a.a;
							return A3(
								$author$project$MicroLaTeX$PrimitiveBlock$endBlock,
								$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
									$author$project$MicroLaTeX$ClassifyBlock$LXDescription(str)),
								currentLine,
								state);
						case 'LXNumbered':
							var str = _v1.a.a;
							return A3(
								$author$project$MicroLaTeX$PrimitiveBlock$endBlock,
								$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
									$author$project$MicroLaTeX$ClassifyBlock$LXNumbered(str)),
								currentLine,
								state);
						case 'LXOrdinaryBlock':
							var name = _v1.a.a;
							return A3(
								$author$project$MicroLaTeX$PrimitiveBlock$endBlock,
								$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
									$author$project$MicroLaTeX$ClassifyBlock$LXOrdinaryBlock(name)),
								currentLine,
								state);
						default:
							var name = _v1.a.a;
							return A3(
								$author$project$MicroLaTeX$PrimitiveBlock$endBlock,
								$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
									$author$project$MicroLaTeX$ClassifyBlock$LXVerbatimBlock(name)),
								currentLine,
								state);
					}
				case 'CEndBlock':
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						$author$project$MicroLaTeX$PrimitiveBlock$resetLevelIfStackIsEmpty(state));
				case 'CVerbatimBlockDelim':
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						$author$project$MicroLaTeX$PrimitiveBlock$resetLevelIfStackIsEmpty(state));
				default:
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						$author$project$MicroLaTeX$PrimitiveBlock$resetLevelIfStackIsEmpty(state));
			}
		}
	});
var $author$project$MicroLaTeX$ClassifyBlock$argParser = function (name) {
	return A2(
		$elm$parser$Parser$keeper,
		A2(
			$elm$parser$Parser$keeper,
			A2(
				$elm$parser$Parser$keeper,
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$succeed($elm$core$String$slice),
					$elm$parser$Parser$symbol('\\' + (name + '{'))),
				A2(
					$elm$parser$Parser$ignorer,
					$elm$parser$Parser$getOffset,
					$elm$parser$Parser$chompUntil('}'))),
			$elm$parser$Parser$getOffset),
		$elm$parser$Parser$getSource);
};
var $author$project$MicroLaTeX$ClassifyBlock$getArg = F2(
	function (name, str) {
		return A2(
			$elm$parser$Parser$run,
			$author$project$MicroLaTeX$ClassifyBlock$argParser(name),
			str);
	});
var $elm$core$Result$withDefault = F2(
	function (def, result) {
		if (result.$ === 'Ok') {
			var a = result.a;
			return a;
		} else {
			return def;
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$handleSpecial_ = F3(
	function (classifier, line, state) {
		var level = state.level + 1;
		var newBlock_ = A2(
			$author$project$MicroLaTeX$PrimitiveBlock$elaborate,
			line,
			function (b) {
				return _Utils_update(
					b,
					{
						body: A2($elm$core$List$cons, b.firstLine, b.body)
					});
			}(
				A5($author$project$MicroLaTeX$PrimitiveBlock$blockFromLine, state.position, state.idPrefix, state.outerCount, level, line)));
		var newBlock = function () {
			_v2$6:
			while (true) {
				switch (classifier.$) {
					case 'CVerbatimBlockDelim':
						return _Utils_update(
							newBlock_,
							{
								heading: $author$project$Generic$Language$Ordinary('numbered'),
								properties: $elm$core$Dict$fromList(
									_List_fromArray(
										[
											_Utils_Tuple2(
											'firstLine',
											A3($elm$core$String$replace, '```', '', line.content))
										]))
							});
					case 'CSpecialBlock':
						switch (classifier.a.$) {
							case 'LXItem':
								var str = classifier.a.a;
								return _Utils_update(
									newBlock_,
									{
										heading: $author$project$Generic$Language$Ordinary('item'),
										properties: $elm$core$Dict$fromList(
											_List_fromArray(
												[
													_Utils_Tuple2(
													'firstLine',
													A3($elm$core$String$replace, '\\item', '', line.content))
												]))
									});
							case 'LXNumbered':
								var str = classifier.a.a;
								return _Utils_update(
									newBlock_,
									{
										heading: $author$project$Generic$Language$Ordinary('numbered'),
										properties: $elm$core$Dict$fromList(
											_List_fromArray(
												[
													_Utils_Tuple2(
													'firstLine',
													A3($elm$core$String$replace, str, '', line.content))
												]))
									});
							case 'LXDescription':
								var str = classifier.a.a;
								return _Utils_update(
									newBlock_,
									{
										args: _List_fromArray(
											[
												A3($elm$core$String$replace, '\\desc ', '', line.content)
											]),
										heading: $author$project$Generic$Language$Ordinary('desc'),
										properties: $elm$core$Dict$fromList(
											_List_fromArray(
												[
													_Utils_Tuple2(
													'firstLine',
													A3($elm$core$String$replace, str, '', line.content))
												]))
									});
							case 'LXOrdinaryBlock':
								var name_ = classifier.a.a;
								var _v3 = function () {
									switch (name_) {
										case 'banner':
											return _Utils_Tuple2('banner', _List_Nil);
										case 'section':
											return _Utils_Tuple2(
												'section',
												_List_fromArray(
													['2']));
										case 'subsection':
											return _Utils_Tuple2(
												'section',
												_List_fromArray(
													['3']));
										case 'subsubsection':
											return _Utils_Tuple2(
												'section',
												_List_fromArray(
													['4']));
										case 'subheading':
											return _Utils_Tuple2(
												'section',
												_List_fromArray(
													['5']));
										case 'setcounter':
											return _Utils_Tuple2(
												'setcounter',
												_List_fromArray(
													[
														A2(
														$elm$core$Result$withDefault,
														'1',
														A2($author$project$MicroLaTeX$ClassifyBlock$getArg, name_, newBlock_.firstLine))
													]));
										case 'shiftandsetcounter':
											return _Utils_Tuple2(
												'shiftandsetcounter',
												_List_fromArray(
													[
														A2(
														$elm$core$Result$withDefault,
														'1',
														A2($author$project$MicroLaTeX$ClassifyBlock$getArg, name_, newBlock_.firstLine))
													]));
										default:
											return _Utils_Tuple2(name_, _List_Nil);
									}
								}();
								var name = _v3.a;
								var args = _v3.b;
								return _Utils_update(
									newBlock_,
									{
										args: args,
										body: function () {
											var _v5 = A2($author$project$MicroLaTeX$ClassifyBlock$getArg, name_, newBlock_.firstLine);
											if (_v5.$ === 'Err') {
												return _List_Nil;
											} else {
												var arg = _v5.a;
												return _List_fromArray(
													[arg]);
											}
										}(),
										heading: $author$project$Generic$Language$Ordinary(name),
										properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished
									});
							case 'LXVerbatimBlock':
								var name = classifier.a.a;
								return _Utils_update(
									newBlock_,
									{
										heading: $author$project$Generic$Language$Verbatim(name)
									});
							default:
								break _v2$6;
						}
					default:
						break _v2$6;
				}
			}
			return newBlock_;
		}();
		var labelStack = function () {
			var _v0 = $elm_community$list_extra$List$Extra$uncons(state.labelStack);
			if (_v0.$ === 'Nothing') {
				return state.labelStack;
			} else {
				var _v1 = _v0.a;
				var label = _v1.a;
				var rest_ = _v1.b;
				return A2(
					$elm$core$List$cons,
					_Utils_update(
						label,
						{status: $author$project$MicroLaTeX$PrimitiveBlock$Filled}),
					rest_);
			}
		}();
		return _Utils_update(
			state,
			{
				firstBlockLine: line.lineNumber,
				indent: line.indent,
				labelStack: A2(
					$elm$core$List$cons,
					{classification: classifier, level: level, lineNumber: line.lineNumber, status: $author$project$MicroLaTeX$PrimitiveBlock$Started},
					labelStack),
				level: level,
				lineNumber: line.lineNumber,
				stack: A2($elm$core$List$cons, newBlock, state.stack)
			});
	});
var $author$project$MicroLaTeX$PrimitiveBlock$handleSpecialBlock = F3(
	function (classifier, line, state) {
		var _v0 = $elm_community$list_extra$List$Extra$uncons(state.stack);
		if (_v0.$ === 'Nothing') {
			return A3($author$project$MicroLaTeX$PrimitiveBlock$handleSpecial_, classifier, line, state);
		} else {
			var _v1 = _v0.a;
			var block = _v1.a;
			var rest = _v1.b;
			return A3(
				$author$project$MicroLaTeX$PrimitiveBlock$handleSpecial_,
				classifier,
				line,
				_Utils_update(
					state,
					{
						stack: A3($author$project$MicroLaTeX$PrimitiveBlock$changeStatusOfStackTop, block, rest, state)
					}));
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$handleComment = F2(
	function (line, state) {
		var newBlock = A2(
			$author$project$Generic$BlockUtilities$updateMeta,
			function (m) {
				return _Utils_update(
					m,
					{numberOfLines: 1});
			},
			function (b) {
				return _Utils_update(
					b,
					{
						heading: $author$project$Generic$Language$Verbatim('texComment')
					});
			}(
				A5($author$project$MicroLaTeX$PrimitiveBlock$blockFromLine, state.position, state.idPrefix, state.outerCount, 0, line)));
		var labelStack = function () {
			var _v0 = $elm_community$list_extra$List$Extra$uncons(state.labelStack);
			if (_v0.$ === 'Nothing') {
				return state.labelStack;
			} else {
				var _v1 = _v0.a;
				var label = _v1.a;
				var rest_ = _v1.b;
				return A2(
					$elm$core$List$cons,
					_Utils_update(
						label,
						{status: $author$project$MicroLaTeX$PrimitiveBlock$Filled}),
					rest_);
			}
		}();
		return _Utils_update(
			state,
			{
				firstBlockLine: line.lineNumber,
				indent: line.indent,
				labelStack: A2(
					$elm$core$List$cons,
					{
						classification: $author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(
							$author$project$MicroLaTeX$ClassifyBlock$LXVerbatimBlock('texComment')),
						level: 0,
						lineNumber: line.lineNumber,
						status: $author$project$MicroLaTeX$PrimitiveBlock$Started
					},
					labelStack),
				level: 0,
				lineNumber: line.lineNumber,
				stack: A2($elm$core$List$cons, newBlock, state.stack)
			});
	});
var $author$project$MicroLaTeX$PrimitiveBlock$plainText = F2(
	function (state_, currentLine) {
		var state = (_Utils_cmp(currentLine.indent, state_.indent) > 0) ? _Utils_update(
			state_,
			{indent: currentLine.indent, level: state_.level + 1}) : ((_Utils_cmp(currentLine.indent, state_.indent) < 0) ? _Utils_update(
			state_,
			{indent: currentLine.indent, level: state_.level - 1}) : state_);
		if (_Utils_eq(
			A2(
				$elm$core$Maybe$map,
				function ($) {
					return $.status;
				},
				$elm$core$List$head(state.labelStack)),
			$elm$core$Maybe$Just($author$project$MicroLaTeX$PrimitiveBlock$Filled)) || _Utils_eq(state.labelStack, _List_Nil)) {
			return (A2($elm$core$String$left, 1, currentLine.content) === '%') ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
				A2($author$project$MicroLaTeX$PrimitiveBlock$handleComment, currentLine, state)) : $author$project$MicroLaTeX$PrimitiveBlock$Loop(
				A5($author$project$MicroLaTeX$PrimitiveBlock$dispatchBeginBlock, state.idPrefix, state.outerCount, $author$project$MicroLaTeX$ClassifyBlock$CPlainText, currentLine, state));
		} else {
			var _v0 = $elm$core$List$head(state.labelStack);
			if (_v0.$ === 'Nothing') {
				return $author$project$MicroLaTeX$PrimitiveBlock$Loop(state);
			} else {
				var topLabel = _v0.a;
				return ((_Utils_cmp(state.level, topLabel.level) > 0) && (!A2(
					$elm$core$List$member,
					topLabel.classification,
					_List_fromArray(
						[
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('equation'),
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('array'),
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('textarray'),
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('align'),
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('aligned')
						])))) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A5($author$project$MicroLaTeX$PrimitiveBlock$dispatchBeginBlock, state.idPrefix, state.outerCount, $author$project$MicroLaTeX$ClassifyBlock$CPlainText, currentLine, state)) : $author$project$MicroLaTeX$PrimitiveBlock$Loop(state);
			}
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$nexStepAux = F3(
	function (currentLine, mTopLabel, state) {
		var _v0 = $author$project$MicroLaTeX$ClassifyBlock$classify(currentLine.content + '\n');
		switch (_v0.$) {
			case 'CBeginBlock':
				var label = _v0.a;
				var _v1 = _Utils_Tuple2(label, currentLine.lineNumber);
				return A2($elm$core$List$member, label, $author$project$MicroLaTeX$PrimitiveBlock$verbatimBlocks) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A5(
						$author$project$MicroLaTeX$PrimitiveBlock$dispatchBeginBlock,
						state.idPrefix,
						state.outerCount,
						$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock(label),
						currentLine,
						_Utils_update(
							state,
							{inVerbatimBlock: true, label: 'CBeginBlock 3'}))) : $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A5(
						$author$project$MicroLaTeX$PrimitiveBlock$dispatchBeginBlock,
						state.idPrefix,
						state.outerCount,
						$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock(label),
						currentLine,
						_Utils_update(
							state,
							{label: 'CBeginBlock 3'})));
			case 'CEndBlock':
				var label = _v0.a;
				var _v2 = _Utils_Tuple2(label, currentLine.lineNumber);
				return A2(
					$elm$core$List$member,
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.classification;
						},
						$elm$core$List$head(
							$elm$core$List$reverse(state.labelStack))),
					_List_fromArray(
						[
							$elm$core$Maybe$Just(
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('code'))
						])) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A4(
						$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch,
						$elm$core$Maybe$Nothing,
						$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('code'),
						currentLine,
						_Utils_update(
							state,
							{label: 'CEndBlock 2'}))) : (A2(
					$elm$core$List$member,
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.classification;
						},
						$elm$core$List$head(
							$elm$core$List$reverse(state.labelStack))),
					_List_fromArray(
						[
							$elm$core$Maybe$Just(
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('equation'))
						])) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A4(
						$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch,
						$elm$core$Maybe$Nothing,
						$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('equation'),
						currentLine,
						_Utils_update(
							state,
							{label: 'CEndBlock 3'}))) : (A2(
					$elm$core$List$member,
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.classification;
						},
						$elm$core$List$head(
							$elm$core$List$reverse(state.labelStack))),
					_List_fromArray(
						[
							$elm$core$Maybe$Just(
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('align')),
							$elm$core$Maybe$Just(
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('aligned'))
						])) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A4(
						$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch,
						$elm$core$Maybe$Nothing,
						$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('align'),
						currentLine,
						_Utils_update(
							state,
							{label: 'CEndBlock 4'}))) : (A2(
					$elm$core$List$member,
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.classification;
						},
						$elm$core$List$head(
							$elm$core$List$reverse(state.labelStack))),
					_List_fromArray(
						[
							$elm$core$Maybe$Just(
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('aligned'))
						])) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A4(
						$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch,
						$elm$core$Maybe$Nothing,
						$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('aligned'),
						currentLine,
						_Utils_update(
							state,
							{label: 'CEndBlock 4a'}))) : (A2(
					$elm$core$List$member,
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.classification;
						},
						$elm$core$List$head(
							$elm$core$List$reverse(state.labelStack))),
					_List_fromArray(
						[
							$elm$core$Maybe$Just(
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('array'))
						])) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A4(
						$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch,
						$elm$core$Maybe$Nothing,
						$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('array'),
						currentLine,
						_Utils_update(
							state,
							{label: 'CEndBlock 4'}))) : (A2(
					$elm$core$List$member,
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.classification;
						},
						$elm$core$List$head(
							$elm$core$List$reverse(state.labelStack))),
					_List_fromArray(
						[
							$elm$core$Maybe$Just(
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('textarray'))
						])) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A4(
						$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch,
						$elm$core$Maybe$Nothing,
						$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('textarray'),
						currentLine,
						_Utils_update(
							state,
							{label: 'CEndBlock 4'}))) : (A2(
					$elm$core$List$member,
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.classification;
						},
						$elm$core$List$head(
							$elm$core$List$reverse(state.labelStack))),
					_List_fromArray(
						[
							$elm$core$Maybe$Just(
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('verbatim'))
						])) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A4(
						$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch,
						$elm$core$Maybe$Nothing,
						$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('verbatim'),
						currentLine,
						_Utils_update(
							state,
							{label: 'CEndBlock 4'}))) : A3(
					$author$project$MicroLaTeX$PrimitiveBlock$endBlock,
					$author$project$MicroLaTeX$ClassifyBlock$CEndBlock(label),
					currentLine,
					_Utils_update(
						state,
						{label: 'CEndBlock 5'}))))))));
			case 'CSpecialBlock':
				var label = _v0.a;
				var _v3 = _Utils_Tuple2(label, currentLine.lineNumber);
				return A2(
					$elm$core$List$member,
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.classification;
						},
						$elm$core$List$head(state.labelStack)),
					_List_fromArray(
						[
							$elm$core$Maybe$Just(
							$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('code')),
							$elm$core$Maybe$Just($author$project$MicroLaTeX$ClassifyBlock$CMathBlockDelim)
						])) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(state) : $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A3(
						$author$project$MicroLaTeX$PrimitiveBlock$handleSpecialBlock,
						$author$project$MicroLaTeX$ClassifyBlock$CSpecialBlock(label),
						currentLine,
						state));
			case 'CMathBlockDelim':
				var _v4 = currentLine.lineNumber;
				var _v5 = $elm$core$List$head(state.labelStack);
				if (_v5.$ === 'Nothing') {
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						A5($author$project$MicroLaTeX$PrimitiveBlock$dispatchBeginBlock, state.idPrefix, state.outerCount, $author$project$MicroLaTeX$ClassifyBlock$CMathBlockDelim, currentLine, state));
				} else {
					var label = _v5.a;
					return A2(
						$elm$core$List$member,
						label.classification,
						_List_fromArray(
							[
								$author$project$MicroLaTeX$ClassifyBlock$CBeginBlock('code')
							])) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(state) : (_Utils_eq(label.classification, $author$project$MicroLaTeX$ClassifyBlock$CMathBlockDelim) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						A4(
							$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch,
							$elm$core$Maybe$Just(label),
							$author$project$MicroLaTeX$ClassifyBlock$CMathBlockDelim,
							currentLine,
							state)) : $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						A5($author$project$MicroLaTeX$PrimitiveBlock$dispatchBeginBlock, state.idPrefix, state.outerCount, $author$project$MicroLaTeX$ClassifyBlock$CMathBlockDelim, currentLine, state)));
				}
			case 'CMathBlockBegin':
				var _v6 = currentLine.lineNumber;
				return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A5(
						$author$project$MicroLaTeX$PrimitiveBlock$dispatchBeginBlock,
						state.idPrefix,
						state.outerCount,
						$author$project$MicroLaTeX$ClassifyBlock$CMathBlockBegin,
						currentLine,
						_Utils_update(
							state,
							{inVerbatimBlock: true})));
			case 'CMathBlockEnd':
				var _v7 = currentLine.lineNumber;
				var _v8 = $elm$core$List$head(state.labelStack);
				if (_v8.$ === 'Just') {
					var label = _v8.a;
					return _Utils_eq(label.classification, $author$project$MicroLaTeX$ClassifyBlock$CMathBlockBegin) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						A4(
							$author$project$MicroLaTeX$PrimitiveBlock$endBlockOnMatch,
							$elm$core$Maybe$Just(label),
							$author$project$MicroLaTeX$ClassifyBlock$CMathBlockEnd,
							currentLine,
							_Utils_update(
								state,
								{inVerbatimBlock: false}))) : $author$project$MicroLaTeX$PrimitiveBlock$Loop(state);
				} else {
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(state);
				}
			case 'CVerbatimBlockDelim':
				var _v9 = currentLine.lineNumber;
				return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
					A2($author$project$MicroLaTeX$PrimitiveBlock$handleVerbatimBlock, currentLine, state));
			case 'CPlainText':
				var _v10 = _Utils_Tuple2(currentLine.lineNumber, state.labelStack);
				var _v11 = $elm$core$List$head(state.labelStack);
				if (_v11.$ === 'Just') {
					var label = _v11.a;
					var _v12 = label.classification;
					if (_v12.$ === 'CMathBlockDelim') {
						return $author$project$MicroLaTeX$PrimitiveBlock$Loop(state);
					} else {
						return A2($author$project$MicroLaTeX$PrimitiveBlock$plainText, state, currentLine);
					}
				} else {
					return A2($author$project$MicroLaTeX$PrimitiveBlock$plainText, state, currentLine);
				}
			default:
				var _v13 = currentLine.lineNumber;
				return A2($author$project$MicroLaTeX$PrimitiveBlock$emptyLine, currentLine, state);
		}
	});
var $author$project$MicroLaTeX$PrimitiveBlock$missingTagError = function (block) {
	var _v0 = block.heading;
	_v0$3:
	while (true) {
		switch (_v0.$) {
			case 'Ordinary':
				if (_v0.a === 'item') {
					return $elm$core$Maybe$Nothing;
				} else {
					break _v0$3;
				}
			case 'Verbatim':
				switch (_v0.a) {
					case 'math':
						return $elm$core$Maybe$Just('Missing \\end{math}');
					case 'code':
						return $elm$core$Maybe$Just('Missing \\end{code}');
					default:
						break _v0$3;
				}
			default:
				break _v0$3;
		}
	}
	return $elm$core$Maybe$Nothing;
};
var $elm_community$list_extra$List$Extra$unconsLast = function (list) {
	var _v0 = $elm$core$List$reverse(list);
	if (!_v0.b) {
		return $elm$core$Maybe$Nothing;
	} else {
		var last_ = _v0.a;
		var rest = _v0.b;
		return $elm$core$Maybe$Just(
			_Utils_Tuple2(
				last_,
				$elm$core$List$reverse(rest)));
	}
};
var $author$project$MicroLaTeX$PrimitiveBlock$recoverFromError = function (state) {
	var _v0 = $elm_community$list_extra$List$Extra$unconsLast(state.stack);
	if (_v0.$ === 'Nothing') {
		return state;
	} else {
		var _v1 = _v0.a;
		var block = _v1.a;
		var _v2 = $elm_community$list_extra$List$Extra$unconsLast(state.labelStack);
		if (_v2.$ === 'Nothing') {
			return state;
		} else {
			var _v3 = _v2.a;
			var topLabel = _v3.a;
			var lastLineNumber = state.lineNumber;
			var firstLineNumber = topLabel.lineNumber;
			var provisionalContent = function () {
				var _v5 = topLabel.status;
				if (_v5.$ === 'Filled') {
					return block.body;
				} else {
					return A3($author$project$MicroLaTeX$PrimitiveBlock$slice, firstLineNumber + 1, lastLineNumber, state.lines);
				}
			}();
			var body = A2(
				$elm_community$list_extra$List$Extra$takeWhile,
				function (item) {
					return item !== '';
				},
				provisionalContent);
			var lineNumber = (firstLineNumber + $elm$core$List$length(body)) + 1;
			var revisedContent = function () {
				var _v4 = $elm_community$list_extra$List$Extra$last(body);
				if (_v4.$ === 'Nothing') {
					return body;
				} else {
					var str = _v4.a;
					return (A2($elm$core$String$left, 4, str) === '\\end') ? $author$project$MicroLaTeX$Util$dropLast(body) : body;
				}
			}();
			var newBlock = A2(
				$author$project$MicroLaTeX$PrimitiveBlock$addSource,
				'',
				A2(
					$author$project$MicroLaTeX$PrimitiveBlock$setError,
					$author$project$MicroLaTeX$PrimitiveBlock$missingTagError(block),
					_Utils_update(
						block,
						{body: revisedContent, properties: $author$project$MicroLaTeX$PrimitiveBlock$statusFinished})));
			return _Utils_update(
				state,
				{
					blockClassification: $elm$core$Maybe$Nothing,
					committedBlocks: A2($elm$core$List$cons, newBlock, state.committedBlocks),
					holdingStack: _List_Nil,
					labelStack: _List_Nil,
					lineNumber: lineNumber,
					stack: _List_Nil
				});
		}
	}
};
var $author$project$MicroLaTeX$PrimitiveBlock$nextStep = function (state_) {
	var currentLine__ = A2($elm_community$list_extra$List$Extra$getAt, state_.lineNumber, state_.lines);
	var newPosition = function () {
		if (currentLine__.$ === 'Nothing') {
			return state_.position;
		} else {
			var currentLine_ = currentLine__.a;
			return state_.position + $elm$core$String$length(currentLine_);
		}
	}();
	var state = _Utils_update(
		state_,
		{count: state_.count + 1, lineNumber: state_.lineNumber + 1, position: newPosition});
	var mTopLabel = A2(
		$elm$core$Maybe$map,
		function ($) {
			return $.classification;
		},
		$elm$core$List$head(state.labelStack));
	var _v0 = A2($elm_community$list_extra$List$Extra$getAt, state.lineNumber, state.lines);
	if (_v0.$ === 'Nothing') {
		return $elm$core$List$isEmpty(state.stack) ? $author$project$MicroLaTeX$PrimitiveBlock$Done(state) : $author$project$MicroLaTeX$PrimitiveBlock$Loop(
			$author$project$MicroLaTeX$PrimitiveBlock$recoverFromError(state));
	} else {
		var rawLine = _v0.a;
		var currentLine = A3(
			$author$project$MicroLaTeX$Line$classify,
			A2($author$project$MicroLaTeX$PrimitiveBlock$getPosition, rawLine, state),
			state.lineNumber,
			rawLine);
		if (state.inVerbatimBlock) {
			var _v1 = $author$project$MicroLaTeX$ClassifyBlock$classify(currentLine.content + '\n');
			switch (_v1.$) {
				case 'CEndBlock':
					var label = _v1.a;
					return A2($elm$core$List$member, label, $author$project$MicroLaTeX$PrimitiveBlock$verbatimBlocks) ? $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						A2($author$project$MicroLaTeX$PrimitiveBlock$handleVerbatimBlock, currentLine, state)) : $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						_Utils_update(
							state,
							{label: 'XXX'}));
				case 'CMathBlockEnd':
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						A2($author$project$MicroLaTeX$PrimitiveBlock$handleVerbatimBlock, currentLine, state));
				default:
					return $author$project$MicroLaTeX$PrimitiveBlock$Loop(
						_Utils_update(
							state,
							{label: 'XXX'}));
			}
		} else {
			return A3($author$project$MicroLaTeX$PrimitiveBlock$nexStepAux, currentLine, mTopLabel, state);
		}
	}
};
var $author$project$MicroLaTeX$PrimitiveBlock$parseLoop = F3(
	function (idPrefix, outerCount, lines) {
		return $author$project$MicroLaTeX$PrimitiveBlock$finalize(
			A2(
				$author$project$MicroLaTeX$PrimitiveBlock$loop,
				A3($author$project$MicroLaTeX$PrimitiveBlock$init, idPrefix, outerCount, lines),
				$author$project$MicroLaTeX$PrimitiveBlock$nextStep));
	});
var $author$project$MicroLaTeX$PrimitiveBlock$parse = F3(
	function (idPrefix, outerCount, lines) {
		return A3($author$project$MicroLaTeX$PrimitiveBlock$parseLoop, idPrefix, outerCount, lines).blocks;
	});
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (_v0.$ === 'Just') {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $author$project$Library$Tree$initTree = function (input) {
	return {input: input, n: 0, output: $elm$core$Maybe$Nothing, pathToActiveNode: $elm$core$Maybe$Nothing};
};
var $author$project$Library$Tree$loop = F2(
	function (s, f) {
		loop:
		while (true) {
			var _v0 = f(s);
			if (_v0.$ === 'Loop') {
				var s_ = _v0.a;
				var $temp$s = s_,
					$temp$f = f;
				s = $temp$s;
				f = $temp$f;
				continue loop;
			} else {
				var b = _v0.a;
				return b;
			}
		}
	});
var $author$project$Library$Tree$Done = function (a) {
	return {$: 'Done', a: a};
};
var $author$project$Library$Tree$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $maca$elm_rose_tree$RoseTree$Tree$Tree = F2(
	function (a, b) {
		return {$: 'Tree', a: a, b: b};
	});
var $elm$core$Array$fromListHelp = F3(
	function (list, nodeList, nodeListSize) {
		fromListHelp:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, list);
			var jsArray = _v0.a;
			var remainingItems = _v0.b;
			if (_Utils_cmp(
				$elm$core$Elm$JsArray$length(jsArray),
				$elm$core$Array$branchFactor) < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					true,
					{nodeList: nodeList, nodeListSize: nodeListSize, tail: jsArray});
			} else {
				var $temp$list = remainingItems,
					$temp$nodeList = A2(
					$elm$core$List$cons,
					$elm$core$Array$Leaf(jsArray),
					nodeList),
					$temp$nodeListSize = nodeListSize + 1;
				list = $temp$list;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue fromListHelp;
			}
		}
	});
var $elm$core$Array$fromList = function (list) {
	if (!list.b) {
		return $elm$core$Array$empty;
	} else {
		return A3($elm$core$Array$fromListHelp, list, _List_Nil, 0);
	}
};
var $maca$elm_rose_tree$RoseTree$Tree$branch = F2(
	function (a, ns) {
		return A2(
			$maca$elm_rose_tree$RoseTree$Tree$Tree,
			a,
			$elm$core$Array$fromList(ns));
	});
var $maca$elm_rose_tree$RoseTree$Tree$children = function (_v0) {
	var ns = _v0.b;
	return $elm$core$Array$toList(ns);
};
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $maca$elm_rose_tree$RoseTree$Tree$leaf = function (a) {
	return A2($maca$elm_rose_tree$RoseTree$Tree$Tree, a, $elm$core$Array$empty);
};
var $elm$core$Maybe$map2 = F3(
	function (func, ma, mb) {
		if (ma.$ === 'Nothing') {
			return $elm$core$Maybe$Nothing;
		} else {
			var a = ma.a;
			if (mb.$ === 'Nothing') {
				return $elm$core$Maybe$Nothing;
			} else {
				var b = mb.a;
				return $elm$core$Maybe$Just(
					A2(func, a, b));
			}
		}
	});
var $elm$core$Elm$JsArray$push = _JsArray_push;
var $elm$core$Bitwise$and = _Bitwise_and;
var $elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var $elm$core$Array$bitMask = 4294967295 >>> (32 - $elm$core$Array$shiftStep);
var $elm$core$Elm$JsArray$singleton = _JsArray_singleton;
var $elm$core$Elm$JsArray$unsafeGet = _JsArray_unsafeGet;
var $elm$core$Elm$JsArray$unsafeSet = _JsArray_unsafeSet;
var $elm$core$Array$insertTailInTree = F4(
	function (shift, index, tail, tree) {
		var pos = $elm$core$Array$bitMask & (index >>> shift);
		if (_Utils_cmp(
			pos,
			$elm$core$Elm$JsArray$length(tree)) > -1) {
			if (shift === 5) {
				return A2(
					$elm$core$Elm$JsArray$push,
					$elm$core$Array$Leaf(tail),
					tree);
			} else {
				var newSub = $elm$core$Array$SubTree(
					A4($elm$core$Array$insertTailInTree, shift - $elm$core$Array$shiftStep, index, tail, $elm$core$Elm$JsArray$empty));
				return A2($elm$core$Elm$JsArray$push, newSub, tree);
			}
		} else {
			var value = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
			if (value.$ === 'SubTree') {
				var subTree = value.a;
				var newSub = $elm$core$Array$SubTree(
					A4($elm$core$Array$insertTailInTree, shift - $elm$core$Array$shiftStep, index, tail, subTree));
				return A3($elm$core$Elm$JsArray$unsafeSet, pos, newSub, tree);
			} else {
				var newSub = $elm$core$Array$SubTree(
					A4(
						$elm$core$Array$insertTailInTree,
						shift - $elm$core$Array$shiftStep,
						index,
						tail,
						$elm$core$Elm$JsArray$singleton(value)));
				return A3($elm$core$Elm$JsArray$unsafeSet, pos, newSub, tree);
			}
		}
	});
var $elm$core$Bitwise$shiftLeftBy = _Bitwise_shiftLeftBy;
var $elm$core$Array$unsafeReplaceTail = F2(
	function (newTail, _v0) {
		var len = _v0.a;
		var startShift = _v0.b;
		var tree = _v0.c;
		var tail = _v0.d;
		var originalTailLen = $elm$core$Elm$JsArray$length(tail);
		var newTailLen = $elm$core$Elm$JsArray$length(newTail);
		var newArrayLen = len + (newTailLen - originalTailLen);
		if (_Utils_eq(newTailLen, $elm$core$Array$branchFactor)) {
			var overflow = _Utils_cmp(newArrayLen >>> $elm$core$Array$shiftStep, 1 << startShift) > 0;
			if (overflow) {
				var newShift = startShift + $elm$core$Array$shiftStep;
				var newTree = A4(
					$elm$core$Array$insertTailInTree,
					newShift,
					len,
					newTail,
					$elm$core$Elm$JsArray$singleton(
						$elm$core$Array$SubTree(tree)));
				return A4($elm$core$Array$Array_elm_builtin, newArrayLen, newShift, newTree, $elm$core$Elm$JsArray$empty);
			} else {
				return A4(
					$elm$core$Array$Array_elm_builtin,
					newArrayLen,
					startShift,
					A4($elm$core$Array$insertTailInTree, startShift, len, newTail, tree),
					$elm$core$Elm$JsArray$empty);
			}
		} else {
			return A4($elm$core$Array$Array_elm_builtin, newArrayLen, startShift, tree, newTail);
		}
	});
var $elm$core$Array$push = F2(
	function (a, array) {
		var tail = array.d;
		return A2(
			$elm$core$Array$unsafeReplaceTail,
			A2($elm$core$Elm$JsArray$push, a, tail),
			array);
	});
var $maca$elm_rose_tree$RoseTree$Tree$push = F2(
	function (n, _v0) {
		var a = _v0.a;
		var ns = _v0.b;
		return A2(
			$maca$elm_rose_tree$RoseTree$Tree$Tree,
			a,
			A2($elm$core$Array$push, n, ns));
	});
var $elm$core$Array$getHelp = F3(
	function (shift, index, tree) {
		getHelp:
		while (true) {
			var pos = $elm$core$Array$bitMask & (index >>> shift);
			var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
			if (_v0.$ === 'SubTree') {
				var subTree = _v0.a;
				var $temp$shift = shift - $elm$core$Array$shiftStep,
					$temp$index = index,
					$temp$tree = subTree;
				shift = $temp$shift;
				index = $temp$index;
				tree = $temp$tree;
				continue getHelp;
			} else {
				var values = _v0.a;
				return A2($elm$core$Elm$JsArray$unsafeGet, $elm$core$Array$bitMask & index, values);
			}
		}
	});
var $elm$core$Array$tailIndex = function (len) {
	return (len >>> 5) << 5;
};
var $elm$core$Array$get = F2(
	function (index, _v0) {
		var len = _v0.a;
		var startShift = _v0.b;
		var tree = _v0.c;
		var tail = _v0.d;
		return ((index < 0) || (_Utils_cmp(index, len) > -1)) ? $elm$core$Maybe$Nothing : ((_Utils_cmp(
			index,
			$elm$core$Array$tailIndex(len)) > -1) ? $elm$core$Maybe$Just(
			A2($elm$core$Elm$JsArray$unsafeGet, $elm$core$Array$bitMask & index, tail)) : $elm$core$Maybe$Just(
			A3($elm$core$Array$getHelp, startShift, index, tree)));
	});
var $elm$core$Array$setHelp = F4(
	function (shift, index, value, tree) {
		var pos = $elm$core$Array$bitMask & (index >>> shift);
		var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
		if (_v0.$ === 'SubTree') {
			var subTree = _v0.a;
			var newSub = A4($elm$core$Array$setHelp, shift - $elm$core$Array$shiftStep, index, value, subTree);
			return A3(
				$elm$core$Elm$JsArray$unsafeSet,
				pos,
				$elm$core$Array$SubTree(newSub),
				tree);
		} else {
			var values = _v0.a;
			var newLeaf = A3($elm$core$Elm$JsArray$unsafeSet, $elm$core$Array$bitMask & index, value, values);
			return A3(
				$elm$core$Elm$JsArray$unsafeSet,
				pos,
				$elm$core$Array$Leaf(newLeaf),
				tree);
		}
	});
var $elm$core$Array$set = F3(
	function (index, value, array) {
		var len = array.a;
		var startShift = array.b;
		var tree = array.c;
		var tail = array.d;
		return ((index < 0) || (_Utils_cmp(index, len) > -1)) ? array : ((_Utils_cmp(
			index,
			$elm$core$Array$tailIndex(len)) > -1) ? A4(
			$elm$core$Array$Array_elm_builtin,
			len,
			startShift,
			tree,
			A3($elm$core$Elm$JsArray$unsafeSet, $elm$core$Array$bitMask & index, value, tail)) : A4(
			$elm$core$Array$Array_elm_builtin,
			len,
			startShift,
			A4($elm$core$Array$setHelp, startShift, index, value, tree),
			tail));
	});
var $elm_community$array_extra$Array$Extra$update = F2(
	function (index, alter) {
		return function (array) {
			var _v0 = A2($elm$core$Array$get, index, array);
			if (_v0.$ === 'Nothing') {
				return array;
			} else {
				var element = _v0.a;
				return A3(
					$elm$core$Array$set,
					index,
					alter(element),
					array);
			}
		};
	});
var $maca$elm_rose_tree$RoseTree$Tree$updateAtHelp = F3(
	function (path, f, _v0) {
		var a = _v0.a;
		var ns = _v0.b;
		if (path.b) {
			if (!path.b.b) {
				var idx = path.a;
				return A2(
					$maca$elm_rose_tree$RoseTree$Tree$Tree,
					a,
					A2(f, idx, ns));
			} else {
				var idx = path.a;
				var rest = path.b;
				return A2(
					$maca$elm_rose_tree$RoseTree$Tree$Tree,
					a,
					A3(
						$elm_community$array_extra$Array$Extra$update,
						idx,
						A2($maca$elm_rose_tree$RoseTree$Tree$updateAtHelp, rest, f),
						ns));
			}
		} else {
			return A2($maca$elm_rose_tree$RoseTree$Tree$Tree, a, ns);
		}
	});
var $maca$elm_rose_tree$RoseTree$Tree$updateAt = F3(
	function (path, f, tree) {
		if (!path.b) {
			return f(tree);
		} else {
			return A3(
				$maca$elm_rose_tree$RoseTree$Tree$updateAtHelp,
				path,
				function (idx) {
					return A2($elm_community$array_extra$Array$Extra$update, idx, f);
				},
				tree);
		}
	});
var $maca$elm_rose_tree$RoseTree$Tree$pushChildFor = F2(
	function (path, child) {
		return A2(
			$maca$elm_rose_tree$RoseTree$Tree$updateAt,
			path,
			$maca$elm_rose_tree$RoseTree$Tree$push(child));
	});
var $author$project$Library$Tree$nextStepTree = F2(
	function (getLevel, state) {
		var _v0 = state.input;
		if (!_v0.b) {
			return $author$project$Library$Tree$Done(state.output);
		} else {
			if (!_v0.b.b) {
				var lastItem = _v0.a;
				var _v1 = state.pathToActiveNode;
				if (_v1.$ === 'Nothing') {
					return $author$project$Library$Tree$Done(
						$elm$core$Maybe$Just(
							A2($maca$elm_rose_tree$RoseTree$Tree$branch, lastItem, _List_Nil)));
				} else {
					var path = _v1.a;
					return $author$project$Library$Tree$Done(
						A2(
							$elm$core$Maybe$map,
							A2(
								$maca$elm_rose_tree$RoseTree$Tree$pushChildFor,
								path,
								$maca$elm_rose_tree$RoseTree$Tree$leaf(lastItem)),
							state.output));
				}
			} else {
				var currentItem = _v0.a;
				var _v2 = _v0.b;
				var nextItem = _v2.a;
				var rest = _v2.b;
				var newOutput = function () {
					var _v5 = state.pathToActiveNode;
					if (_v5.$ === 'Nothing') {
						return $elm$core$Maybe$Just(
							A2($maca$elm_rose_tree$RoseTree$Tree$branch, currentItem, _List_Nil));
					} else {
						var path = _v5.a;
						return A2(
							$elm$core$Maybe$map,
							A2(
								$maca$elm_rose_tree$RoseTree$Tree$pushChildFor,
								path,
								$maca$elm_rose_tree$RoseTree$Tree$leaf(currentItem)),
							state.output);
					}
				}();
				var indexToActiveNode = A2(
					$elm$core$Maybe$map,
					A2(
						$elm$core$Basics$composeR,
						$maca$elm_rose_tree$RoseTree$Tree$children,
						A2(
							$elm$core$Basics$composeR,
							$elm$core$List$length,
							function (i) {
								return i - 1;
							})),
					newOutput);
				var dropLast = function (list) {
					return A2(
						$elm$core$List$take,
						$elm$core$List$length(list) - 1,
						list);
				};
				var append = F2(
					function (k, list) {
						return _Utils_ap(
							list,
							_List_fromArray(
								[k]));
					});
				var getNewPath = F2(
					function (currentItem_, nextItem_) {
						var _v3 = A2(
							$elm$core$Basics$compare,
							getLevel(nextItem_),
							getLevel(currentItem_));
						switch (_v3.$) {
							case 'GT':
								var _v4 = state.pathToActiveNode;
								if (_v4.$ === 'Nothing') {
									return $elm$core$Maybe$Just(_List_Nil);
								} else {
									return A3($elm$core$Maybe$map2, append, indexToActiveNode, state.pathToActiveNode);
								}
							case 'EQ':
								return state.pathToActiveNode;
							default:
								return A2($elm$core$Maybe$map, dropLast, state.pathToActiveNode);
						}
					});
				var newPath = A2(getNewPath, currentItem, nextItem);
				return $author$project$Library$Tree$Loop(
					{
						input: A2($elm$core$List$cons, nextItem, rest),
						n: state.n + 1,
						output: newOutput,
						pathToActiveNode: newPath
					});
			}
		}
	});
var $author$project$Library$Tree$makeTree = F2(
	function (getLevel, input) {
		var initialState = $author$project$Library$Tree$initTree(input);
		return A2(
			$author$project$Library$Tree$loop,
			initialState,
			$author$project$Library$Tree$nextStepTree(getLevel));
	});
var $author$project$Library$Forest$init = F2(
	function (getLevel, input) {
		var _v0 = $elm$core$List$head(input);
		if (_v0.$ === 'Nothing') {
			return {currentLevel: 0, currentList: _List_Nil, input: _List_Nil, output: _List_Nil, rootLevel: 0};
		} else {
			var item = _v0.a;
			return {
				currentLevel: getLevel(item),
				currentList: _List_Nil,
				input: input,
				output: _List_Nil,
				rootLevel: getLevel(item)
			};
		}
	});
var $author$project$Library$Forest$loop = F2(
	function (s, f) {
		loop:
		while (true) {
			var _v0 = f(s);
			if (_v0.$ === 'Loop') {
				var s_ = _v0.a;
				var $temp$s = s_,
					$temp$f = f;
				s = $temp$s;
				f = $temp$f;
				continue loop;
			} else {
				var b = _v0.a;
				return b;
			}
		}
	});
var $author$project$Library$Forest$Done = function (a) {
	return {$: 'Done', a: a};
};
var $author$project$Library$Forest$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $author$project$Library$Forest$nextStep = F2(
	function (getLevel, state) {
		var _v0 = state.input;
		if (!_v0.b) {
			return $author$project$Library$Forest$Done(
				$elm$core$List$reverse(
					A2(
						$elm$core$List$cons,
						$elm$core$List$reverse(state.currentList),
						state.output)));
		} else {
			var x = _v0.a;
			var xs = _v0.b;
			var level = getLevel(x);
			return _Utils_eq(level, state.rootLevel) ? $author$project$Library$Forest$Loop(
				_Utils_update(
					state,
					{
						currentLevel: level,
						currentList: _List_fromArray(
							[x]),
						input: xs,
						output: _Utils_eq(state.currentList, _List_Nil) ? state.output : A2(
							$elm$core$List$cons,
							$elm$core$List$reverse(state.currentList),
							state.output)
					})) : $author$project$Library$Forest$Loop(
				_Utils_update(
					state,
					{
						currentLevel: level,
						currentList: A2($elm$core$List$cons, x, state.currentList),
						input: xs
					}));
		}
	});
var $author$project$Library$Forest$toListList = F2(
	function (getLevel, input) {
		var initialState = A2($author$project$Library$Forest$init, getLevel, input);
		return A2(
			$author$project$Library$Forest$loop,
			initialState,
			$author$project$Library$Forest$nextStep(getLevel));
	});
var $author$project$Library$Forest$makeForest = F2(
	function (getLevel, input) {
		return A2(
			$elm$core$List$filterMap,
			$elm$core$Basics$identity,
			A2(
				$elm$core$List$map,
				$author$project$Library$Tree$makeTree(getLevel),
				A2($author$project$Library$Forest$toListList, getLevel, input)));
	});
var $author$project$Generic$ForestTransform$forestFromBlocks = F2(
	function (indentation, blocks) {
		return A2($author$project$Library$Forest$makeForest, indentation, blocks);
	});
var $elm$core$Elm$JsArray$map = _JsArray_map;
var $elm$core$Array$map = F2(
	function (func, _v0) {
		var len = _v0.a;
		var startShift = _v0.b;
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = function (node) {
			if (node.$ === 'SubTree') {
				var subTree = node.a;
				return $elm$core$Array$SubTree(
					A2($elm$core$Elm$JsArray$map, helper, subTree));
			} else {
				var values = node.a;
				return $elm$core$Array$Leaf(
					A2($elm$core$Elm$JsArray$map, func, values));
			}
		};
		return A4(
			$elm$core$Array$Array_elm_builtin,
			len,
			startShift,
			A2($elm$core$Elm$JsArray$map, helper, tree),
			A2($elm$core$Elm$JsArray$map, func, tail));
	});
var $maca$elm_rose_tree$RoseTree$Tree$mapValues = F2(
	function (f, _v0) {
		var a = _v0.a;
		var ns = _v0.b;
		return A2(
			$maca$elm_rose_tree$RoseTree$Tree$Tree,
			f(a),
			A2(
				$elm$core$Array$map,
				$maca$elm_rose_tree$RoseTree$Tree$mapValues(f),
				ns));
	});
var $author$project$Generic$Forest$map = F2(
	function (f, forest) {
		return A2(
			$elm$core$List$map,
			$maca$elm_rose_tree$RoseTree$Tree$mapValues(f),
			forest);
	});
var $author$project$Generic$Language$boost = F2(
	function (position, meta) {
		return _Utils_update(
			meta,
			{begin: meta.begin + position, end: meta.end + position});
	});
var $toastal$either$Either$Left = function (a) {
	return {$: 'Left', a: a};
};
var $toastal$either$Either$Right = function (a) {
	return {$: 'Right', a: a};
};
var $author$project$Generic$Language$getMeta = function (expr) {
	switch (expr.$) {
		case 'Fun':
			var meta = expr.c;
			return meta;
		case 'VFun':
			var meta = expr.c;
			return meta;
		case 'Text':
			var meta = expr.b;
			return meta;
		default:
			var meta = expr.b;
			return meta;
	}
};
var $author$project$Generic$Language$ExprList = F2(
	function (a, b) {
		return {$: 'ExprList', a: a, b: b};
	});
var $author$project$Generic$Language$setMeta = F2(
	function (meta, expr) {
		switch (expr.$) {
			case 'Fun':
				var name = expr.a;
				var args = expr.b;
				return A3($author$project$Generic$Language$Fun, name, args, meta);
			case 'VFun':
				var name = expr.a;
				var arg = expr.b;
				return A3($author$project$Generic$Language$VFun, name, arg, meta);
			case 'Text':
				var text = expr.a;
				return A2($author$project$Generic$Language$Text, text, meta);
			default:
				var eList = expr.a;
				return A2($author$project$Generic$Language$ExprList, eList, meta);
		}
	});
var $author$project$Generic$Language$updateMeta = F2(
	function (update, expr) {
		return A2(
			$author$project$Generic$Language$setMeta,
			update(
				$author$project$Generic$Language$getMeta(expr)),
			expr);
	});
var $author$project$Generic$Language$updateMetaInBlock = F2(
	function (updater, block) {
		var newBody = function () {
			var _v0 = block.body;
			if (_v0.$ === 'Left') {
				var str = _v0.a;
				return $toastal$either$Either$Left(str);
			} else {
				var exprs = _v0.a;
				return $toastal$either$Either$Right(
					A2(
						$elm$core$List$map,
						$author$project$Generic$Language$updateMeta(updater),
						exprs));
			}
		}();
		return _Utils_update(
			block,
			{body: newBody});
	});
var $author$project$Generic$Language$boostBlock = function (block) {
	return A2(
		$author$project$Generic$Language$updateMetaInBlock,
		$author$project$Generic$Language$boost(block.meta.position),
		block);
};
var $author$project$Generic$Language$emptyExprMeta = {begin: 0, end: 0, id: 'id', index: 0};
var $author$project$Generic$Pipeline$fixItemsAux = F2(
	function (acc, input) {
		var folder = F2(
			function (str, list) {
				if (A2(
					$elm$core$String$left,
					1,
					$elm$core$String$trimLeft(str)) === '-') {
					return A2(
						$elm$core$List$cons,
						A2(
							$elm$core$String$dropLeft,
							2,
							$elm$core$String$trimLeft(str)),
						list);
				} else {
					if (!list.b) {
						return _List_Nil;
					} else {
						var first = list.a;
						var rest = list.b;
						return A2($elm$core$List$cons, first + (' ' + str), rest);
					}
				}
			});
		return A3($elm$core$List$foldl, folder, acc, input);
	});
var $author$project$Generic$Pipeline$fixItems = function (list) {
	return $elm$core$List$reverse(
		A2($author$project$Generic$Pipeline$fixItemsAux, _List_Nil, list));
};
var $author$project$Generic$Pipeline$fixNumberedItemsAux = F2(
	function (acc, input) {
		var folder = F2(
			function (str, list) {
				if (A2(
					$elm$core$String$left,
					1,
					$elm$core$String$trimLeft(str)) === '.') {
					return A2(
						$elm$core$List$cons,
						A2(
							$elm$core$String$dropLeft,
							2,
							$elm$core$String$trimLeft(str)),
						list);
				} else {
					if (!list.b) {
						return _List_Nil;
					} else {
						var first = list.a;
						var rest = list.b;
						return A2($elm$core$List$cons, first + (' ' + str), rest);
					}
				}
			});
		return A3($elm$core$List$foldl, folder, acc, input);
	});
var $author$project$Generic$Pipeline$fixNumberedItems = function (list) {
	return $elm$core$List$reverse(
		A2($author$project$Generic$Pipeline$fixNumberedItemsAux, _List_Nil, list));
};
var $author$project$M$Expression$fixup = function (input) {
	if (input.b && (input.a.$ === 'Fun')) {
		var _v1 = input.a;
		var name = _v1.a;
		var exprList = _v1.b;
		var meta = _v1.c;
		var rest = input.b;
		var newExprlist = function () {
			if (exprList.b) {
				var head = exprList.a;
				var tail = exprList.b;
				if (head.$ === 'Text') {
					var str = head.a;
					var meta_ = head.b;
					return _Utils_ap(
						_List_fromArray(
							[
								A2(
								$author$project$Generic$Language$Text,
								$elm$core$String$trim(str),
								meta_)
							]),
						tail);
				} else {
					return exprList;
				}
			} else {
				return _List_Nil;
			}
		}();
		return A2(
			$elm$core$List$cons,
			A3($author$project$Generic$Language$Fun, name, newExprlist, meta),
			$author$project$M$Expression$fixup(rest));
	} else {
		return input;
	}
};
var $author$project$M$Expression$initWithTokens = F2(
	function (lineNumber, tokens) {
		return {
			committed: _List_Nil,
			lineNumber: lineNumber,
			messages: _List_Nil,
			numberOfTokens: $elm$core$List$length(tokens),
			stack: _List_Nil,
			step: 0,
			tokenIndex: 0,
			tokens: $elm$core$List$reverse(tokens)
		};
	});
var $author$project$M$Expression$advanceTokenIndex = function (state) {
	return _Utils_update(
		state,
		{tokenIndex: state.tokenIndex + 1});
};
var $author$project$M$Expression$getToken = function (state) {
	return A2($elm_community$list_extra$List$Extra$getAt, state.tokenIndex, state.tokens);
};
var $author$project$M$Expression$pushOnStack_ = F2(
	function (token, state) {
		return _Utils_update(
			state,
			{
				stack: A2($elm$core$List$cons, token, state.stack)
			});
	});
var $author$project$M$Expression$makeId = F2(
	function (lineNumber, tokenIndex) {
		return $author$project$ScriptaV2$Config$expressionIdPrefix + ($elm$core$String$fromInt(lineNumber) + ('.' + $elm$core$String$fromInt(tokenIndex)));
	});
var $author$project$M$Expression$boostMeta = F3(
	function (lineNumber, tokenIndex, _v0) {
		var begin = _v0.begin;
		var end = _v0.end;
		var index = _v0.index;
		return {
			begin: begin,
			end: end,
			id: A2($author$project$M$Expression$makeId, lineNumber, tokenIndex),
			index: index
		};
	});
var $author$project$M$Tokenizer$indexOf = function (token) {
	switch (token.$) {
		case 'LB':
			var meta = token.a;
			return meta.index;
		case 'RB':
			var meta = token.a;
			return meta.index;
		case 'LMB':
			var meta = token.a;
			return meta.index;
		case 'RMB':
			var meta = token.a;
			return meta.index;
		case 'S':
			var meta = token.b;
			return meta.index;
		case 'W':
			var meta = token.b;
			return meta.index;
		case 'MathToken':
			var meta = token.a;
			return meta.index;
		case 'BracketedMath':
			var meta = token.b;
			return meta.index;
		case 'CodeToken':
			var meta = token.a;
			return meta.index;
		default:
			var meta = token.b;
			return meta.index;
	}
};
var $author$project$M$Expression$stringTokenToExpr = F2(
	function (lineNumber, token) {
		switch (token.$) {
			case 'S':
				var str = token.a;
				var loc = token.b;
				return $elm$core$Maybe$Just(
					A2(
						$author$project$Generic$Language$Text,
						str,
						A3(
							$author$project$M$Expression$boostMeta,
							lineNumber,
							$author$project$M$Tokenizer$indexOf(token),
							loc)));
			case 'W':
				var str = token.a;
				var loc = token.b;
				return $elm$core$Maybe$Just(
					A2(
						$author$project$Generic$Language$Text,
						str,
						A3(
							$author$project$M$Expression$boostMeta,
							lineNumber,
							$author$project$M$Tokenizer$indexOf(token),
							loc)));
			case 'BracketedMath':
				var str = token.a;
				var loc = token.b;
				return $elm$core$Maybe$Just(
					A3(
						$author$project$Generic$Language$VFun,
						'math',
						str,
						A3(
							$author$project$M$Expression$boostMeta,
							lineNumber,
							$author$project$M$Tokenizer$indexOf(token),
							loc)));
			default:
				return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$M$Expression$commit = F2(
	function (token, state) {
		var _v0 = A2($author$project$M$Expression$stringTokenToExpr, state.lineNumber, token);
		if (_v0.$ === 'Nothing') {
			return state;
		} else {
			var expr = _v0.a;
			return _Utils_update(
				state,
				{
					committed: A2($elm$core$List$cons, expr, state.committed)
				});
		}
	});
var $author$project$M$Expression$push = F2(
	function (token, state) {
		return _Utils_update(
			state,
			{
				stack: A2($elm$core$List$cons, token, state.stack)
			});
	});
var $author$project$M$Expression$pushOrCommit_ = F2(
	function (token, state) {
		return $elm$core$List$isEmpty(state.stack) ? A2($author$project$M$Expression$commit, token, state) : A2($author$project$M$Expression$push, token, state);
	});
var $author$project$M$Expression$pushOrCommit = F2(
	function (token, state) {
		switch (token.$) {
			case 'S':
				return A2($author$project$M$Expression$pushOrCommit_, token, state);
			case 'W':
				return A2($author$project$M$Expression$pushOrCommit_, token, state);
			case 'MathToken':
				return A2($author$project$M$Expression$pushOnStack_, token, state);
			case 'BracketedMath':
				return A2($author$project$M$Expression$pushOrCommit_, token, state);
			case 'CodeToken':
				return A2($author$project$M$Expression$pushOnStack_, token, state);
			case 'LB':
				return A2($author$project$M$Expression$pushOnStack_, token, state);
			case 'RB':
				return A2($author$project$M$Expression$pushOnStack_, token, state);
			case 'LMB':
				return A2($author$project$M$Expression$pushOnStack_, token, state);
			case 'RMB':
				return A2($author$project$M$Expression$pushOnStack_, token, state);
			default:
				return A2($author$project$M$Expression$pushOnStack_, token, state);
		}
	});
var $author$project$M$Tokenizer$LB = function (a) {
	return {$: 'LB', a: a};
};
var $author$project$M$Tokenizer$RB = function (a) {
	return {$: 'RB', a: a};
};
var $author$project$M$Tokenizer$S = F2(
	function (a, b) {
		return {$: 'S', a: a, b: b};
	});
var $author$project$M$Tokenizer$BracketedMath = F2(
	function (a, b) {
		return {$: 'BracketedMath', a: a, b: b};
	});
var $author$project$M$Tokenizer$CodeToken = function (a) {
	return {$: 'CodeToken', a: a};
};
var $author$project$M$Tokenizer$LMB = function (a) {
	return {$: 'LMB', a: a};
};
var $author$project$M$Tokenizer$MathToken = function (a) {
	return {$: 'MathToken', a: a};
};
var $author$project$M$Tokenizer$RMB = function (a) {
	return {$: 'RMB', a: a};
};
var $author$project$M$Tokenizer$TokenError = F2(
	function (a, b) {
		return {$: 'TokenError', a: a, b: b};
	});
var $author$project$M$Tokenizer$W = F2(
	function (a, b) {
		return {$: 'W', a: a, b: b};
	});
var $author$project$M$Tokenizer$setIndex = F2(
	function (k, token) {
		switch (token.$) {
			case 'LB':
				var meta = token.a;
				return $author$project$M$Tokenizer$LB(
					_Utils_update(
						meta,
						{index: k}));
			case 'RB':
				var meta = token.a;
				return $author$project$M$Tokenizer$RB(
					_Utils_update(
						meta,
						{index: k}));
			case 'LMB':
				var meta = token.a;
				return $author$project$M$Tokenizer$LMB(
					_Utils_update(
						meta,
						{index: k}));
			case 'RMB':
				var meta = token.a;
				return $author$project$M$Tokenizer$RMB(
					_Utils_update(
						meta,
						{index: k}));
			case 'S':
				var str = token.a;
				var meta = token.b;
				return A2(
					$author$project$M$Tokenizer$S,
					str,
					_Utils_update(
						meta,
						{index: k}));
			case 'W':
				var str = token.a;
				var meta = token.b;
				return A2(
					$author$project$M$Tokenizer$W,
					str,
					_Utils_update(
						meta,
						{index: k}));
			case 'MathToken':
				var meta = token.a;
				return $author$project$M$Tokenizer$MathToken(
					_Utils_update(
						meta,
						{index: k}));
			case 'BracketedMath':
				var str = token.a;
				var meta = token.b;
				return A2(
					$author$project$M$Tokenizer$BracketedMath,
					str,
					_Utils_update(
						meta,
						{index: k}));
			case 'CodeToken':
				var meta = token.a;
				return $author$project$M$Tokenizer$CodeToken(
					_Utils_update(
						meta,
						{index: k}));
			default:
				var list = token.a;
				var meta = token.b;
				return A2(
					$author$project$M$Tokenizer$TokenError,
					list,
					_Utils_update(
						meta,
						{index: k}));
		}
	});
var $author$project$M$Tokenizer$changeTokenIndicesFrom = F3(
	function (from, delta, tokens) {
		var f = function (token) {
			var k = $author$project$M$Tokenizer$indexOf(token);
			return (_Utils_cmp(k, from) > -1) ? A2($author$project$M$Tokenizer$setIndex, k + delta, token) : token;
		};
		return A2(
			$elm$core$List$map,
			function (token) {
				return f(token);
			},
			tokens);
	});
var $author$project$M$Expression$dummyTokenIndex = 0;
var $author$project$M$Expression$dummyLoc = {begin: 0, end: 0, index: $author$project$M$Expression$dummyTokenIndex};
var $author$project$M$Expression$dummyLocWithId = {begin: 0, end: 0, id: 'dummy (2)', index: $author$project$M$Expression$dummyTokenIndex};
var $author$project$M$Expression$errorMessage = function (message) {
	return A3(
		$author$project$Generic$Language$Fun,
		'errorHighlight',
		_List_fromArray(
			[
				A2($author$project$Generic$Language$Text, message, $author$project$M$Expression$dummyLocWithId)
			]),
		$author$project$M$Expression$dummyLocWithId);
};
var $author$project$M$Expression$errorSuffix = function (rest) {
	if (!rest.b) {
		return ']?';
	} else {
		if ((rest.a.$ === 'W') && (!rest.b.b)) {
			var _v1 = rest.a;
			return ']?';
		} else {
			return '';
		}
	}
};
var $author$project$Tools$ParserHelpers$prependMessage = F3(
	function (lineNumber, message, messages) {
		return A2(
			$elm$core$List$cons,
			message + (' (line ' + ($elm$core$String$fromInt(lineNumber) + ')')),
			A2($elm$core$List$take, 2, messages));
	});
var $author$project$M$Expression$addErrorMessage = F2(
	function (message, state) {
		var committed = A2(
			$elm$core$List$cons,
			$author$project$M$Expression$errorMessage(message),
			state.committed);
		return _Utils_update(
			state,
			{committed: committed});
	});
var $author$project$M$Symbol$value = function (symbol) {
	switch (symbol.$) {
		case 'L':
			return 1;
		case 'R':
			return -1;
		case 'LM':
			return 1;
		case 'RM':
			return -1;
		case 'ST':
			return 0;
		case 'WS':
			return 0;
		case 'M':
			return 0;
		case 'BM':
			return 0;
		case 'C':
			return 0;
		default:
			return 0;
	}
};
var $author$project$M$Symbol$balance = function (symbols) {
	return $elm$core$List$sum(
		A2($elm$core$List$map, $author$project$M$Symbol$value, symbols));
};
var $author$project$M$Expression$bracketError = function (k) {
	if (k < 0) {
		var brackets = A2(
			$elm$core$String$join,
			'',
			A2($elm$core$List$repeat, -k, ']'));
		return $author$project$M$Expression$errorMessage(
			' ' + (brackets + (' << Too many right brackets (' + ($elm$core$String$fromInt(-k) + ')'))));
	} else {
		var brackets = A2(
			$elm$core$String$join,
			'',
			A2($elm$core$List$repeat, k, '['));
		return $author$project$M$Expression$errorMessage(
			' ' + (brackets + (' << Too many left brackets (' + ($elm$core$String$fromInt(k) + ')'))));
	}
};
var $author$project$M$Expression$bracketErrorAsString = function (k) {
	return (k < 0) ? ('Too many right brackets (' + ($elm$core$String$fromInt(-k) + ')')) : ('Too many left brackets (' + ($elm$core$String$fromInt(k) + ')'));
};
var $author$project$M$Symbol$C = {$: 'C'};
var $author$project$M$Symbol$M = {$: 'M'};
var $author$project$M$Symbol$WS = {$: 'WS'};
var $author$project$M$Match$dropLast = function (list) {
	var n = $elm$core$List$length(list);
	return A2($elm$core$List$take, n - 1, list);
};
var $author$project$M$Match$getSegment = F2(
	function (sym, symbols) {
		var seg_ = A2(
			$elm_community$list_extra$List$Extra$takeWhile,
			function (sym_) {
				return !_Utils_eq(sym_, sym);
			},
			A2($elm$core$List$drop, 1, symbols));
		var n = $elm$core$List$length(seg_);
		var _v0 = A2($elm_community$list_extra$List$Extra$getAt, n + 1, symbols);
		if (_v0.$ === 'Nothing') {
			return A2($elm$core$List$cons, sym, seg_);
		} else {
			var last = _v0.a;
			return A2(
				$elm$core$List$cons,
				sym,
				_Utils_ap(
					seg_,
					_List_fromArray(
						[last])));
		}
	});
var $author$project$Tools$ParserHelpers$loop = F2(
	function (s, f) {
		loop:
		while (true) {
			var _v0 = f(s);
			if (_v0.$ === 'Loop') {
				var s_ = _v0.a;
				var $temp$s = s_,
					$temp$f = f;
				s = $temp$s;
				f = $temp$f;
				continue loop;
			} else {
				var b = _v0.a;
				return b;
			}
		}
	});
var $author$project$Tools$ParserHelpers$Done = function (a) {
	return {$: 'Done', a: a};
};
var $author$project$Tools$ParserHelpers$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $author$project$M$Match$nextStep = function (state) {
	var _v0 = $elm$core$List$head(state.symbols);
	if (_v0.$ === 'Nothing') {
		return $author$project$Tools$ParserHelpers$Done($elm$core$Maybe$Nothing);
	} else {
		var sym = _v0.a;
		var brackets = state.brackets + $author$project$M$Symbol$value(sym);
		return (brackets < 0) ? $author$project$Tools$ParserHelpers$Done($elm$core$Maybe$Nothing) : ((!brackets) ? $author$project$Tools$ParserHelpers$Done(
			$elm$core$Maybe$Just(state.index)) : $author$project$Tools$ParserHelpers$Loop(
			{
				brackets: brackets,
				index: state.index + 1,
				symbols: A2($elm$core$List$drop, 1, state.symbols)
			}));
	}
};
var $author$project$M$Match$match = function (symbols) {
	var _v0 = $elm$core$List$head(symbols);
	if (_v0.$ === 'Nothing') {
		return $elm$core$Maybe$Nothing;
	} else {
		var symbol = _v0.a;
		return A2(
			$elm$core$List$member,
			symbol,
			_List_fromArray(
				[$author$project$M$Symbol$C, $author$project$M$Symbol$M])) ? $elm$core$Maybe$Just(
			$elm$core$List$length(
				A2($author$project$M$Match$getSegment, symbol, symbols)) - 1) : (($author$project$M$Symbol$value(symbol) < 0) ? $elm$core$Maybe$Nothing : A2(
			$author$project$Tools$ParserHelpers$loop,
			{
				brackets: $author$project$M$Symbol$value(symbol),
				index: 1,
				symbols: A2($elm$core$List$drop, 1, symbols)
			},
			$author$project$M$Match$nextStep));
	}
};
var $author$project$M$Match$splitAt = F2(
	function (k, list) {
		return _Utils_Tuple2(
			A2($elm$core$List$take, k, list),
			A2($elm$core$List$drop, k, list));
	});
var $author$project$M$Match$split = function (symbols) {
	var _v0 = $author$project$M$Match$match(symbols);
	if (_v0.$ === 'Nothing') {
		return $elm$core$Maybe$Nothing;
	} else {
		var k = _v0.a;
		return $elm$core$Maybe$Just(
			A2($author$project$M$Match$splitAt, k + 1, symbols));
	}
};
var $author$project$M$Match$hasReducibleArgs = function (symbols) {
	hasReducibleArgs:
	while (true) {
		if (!symbols.b) {
			return true;
		} else {
			switch (symbols.a.$) {
				case 'L':
					var _v14 = symbols.a;
					return $author$project$M$Match$reducibleAux(symbols);
				case 'LM':
					var _v15 = symbols.a;
					return $author$project$M$Match$reducibleAux(symbols);
				case 'C':
					var _v16 = symbols.a;
					return $author$project$M$Match$reducibleAux(symbols);
				case 'M':
					var _v17 = symbols.a;
					var seg = A2($author$project$M$Match$getSegment, $author$project$M$Symbol$M, symbols);
					if ($author$project$M$Match$isReducible(seg)) {
						var $temp$symbols = A2(
							$elm$core$List$drop,
							$elm$core$List$length(seg),
							symbols);
						symbols = $temp$symbols;
						continue hasReducibleArgs;
					} else {
						return false;
					}
				case 'BM':
					var _v18 = symbols.a;
					var rest = symbols.b;
					var $temp$symbols = rest;
					symbols = $temp$symbols;
					continue hasReducibleArgs;
				case 'ST':
					var _v19 = symbols.a;
					var rest = symbols.b;
					var $temp$symbols = rest;
					symbols = $temp$symbols;
					continue hasReducibleArgs;
				default:
					return false;
			}
		}
	}
};
var $author$project$M$Match$isReducible = function (symbols_) {
	var symbols = A2(
		$elm$core$List$filter,
		function (sym) {
			return !_Utils_eq(sym, $author$project$M$Symbol$WS);
		},
		symbols_);
	_v2$4:
	while (true) {
		if (symbols.b) {
			switch (symbols.a.$) {
				case 'M':
					var _v3 = symbols.a;
					var rest = symbols.b;
					return _Utils_eq(
						$elm$core$List$head(
							$elm$core$List$reverse(rest)),
						$elm$core$Maybe$Just($author$project$M$Symbol$M));
				case 'C':
					var _v4 = symbols.a;
					var rest = symbols.b;
					return _Utils_eq(
						$elm$core$List$head(
							$elm$core$List$reverse(rest)),
						$elm$core$Maybe$Just($author$project$M$Symbol$C));
				case 'L':
					if (symbols.b.b && (symbols.b.a.$ === 'ST')) {
						var _v5 = symbols.a;
						var _v6 = symbols.b;
						var _v7 = _v6.a;
						var rest = _v6.b;
						var _v8 = $elm$core$List$head(
							$elm$core$List$reverse(rest));
						if ((_v8.$ === 'Just') && (_v8.a.$ === 'R')) {
							var _v9 = _v8.a;
							return $author$project$M$Match$hasReducibleArgs(
								$author$project$M$Match$dropLast(rest));
						} else {
							return false;
						}
					} else {
						break _v2$4;
					}
				case 'LM':
					var _v10 = symbols.a;
					var rest = symbols.b;
					var _v11 = $elm$core$List$head(
						$elm$core$List$reverse(rest));
					if ((_v11.$ === 'Just') && (_v11.a.$ === 'RM')) {
						var _v12 = _v11.a;
						return true;
					} else {
						return false;
					}
				default:
					break _v2$4;
			}
		} else {
			break _v2$4;
		}
	}
	return false;
};
var $author$project$M$Match$reducibleAux = function (symbols) {
	var _v0 = $author$project$M$Match$split(symbols);
	if (_v0.$ === 'Nothing') {
		return false;
	} else {
		var _v1 = _v0.a;
		var a = _v1.a;
		var b = _v1.b;
		return $author$project$M$Match$isReducible(a) && $author$project$M$Match$hasReducibleArgs(b);
	}
};
var $author$project$M$Expression$errorMessageInvisible = function (_v0) {
	return A3(
		$author$project$Generic$Language$Fun,
		'invisible',
		_List_fromArray(
			[
				A2($author$project$Generic$Language$Text, 'foo', $author$project$M$Expression$dummyLocWithId)
			]),
		$author$project$M$Expression$dummyLocWithId);
};
var $author$project$M$Tokenizer$TLB = {$: 'TLB'};
var $author$project$M$Tokenizer$TRB = {$: 'TRB'};
var $author$project$M$Tokenizer$TBracketedMath = {$: 'TBracketedMath'};
var $author$project$M$Tokenizer$TCode = {$: 'TCode'};
var $author$project$M$Tokenizer$TLMB = {$: 'TLMB'};
var $author$project$M$Tokenizer$TMath = {$: 'TMath'};
var $author$project$M$Tokenizer$TRMB = {$: 'TRMB'};
var $author$project$M$Tokenizer$TS = {$: 'TS'};
var $author$project$M$Tokenizer$TTokenError = {$: 'TTokenError'};
var $author$project$M$Tokenizer$TW = {$: 'TW'};
var $author$project$M$Tokenizer$type_ = function (token) {
	switch (token.$) {
		case 'LB':
			return $author$project$M$Tokenizer$TLB;
		case 'RB':
			return $author$project$M$Tokenizer$TRB;
		case 'LMB':
			return $author$project$M$Tokenizer$TLMB;
		case 'RMB':
			return $author$project$M$Tokenizer$TRMB;
		case 'S':
			return $author$project$M$Tokenizer$TS;
		case 'W':
			return $author$project$M$Tokenizer$TW;
		case 'MathToken':
			return $author$project$M$Tokenizer$TMath;
		case 'BracketedMath':
			return $author$project$M$Tokenizer$TBracketedMath;
		case 'CodeToken':
			return $author$project$M$Tokenizer$TCode;
		default:
			return $author$project$M$Tokenizer$TTokenError;
	}
};
var $author$project$M$Expression$isExpr = function (tokens) {
	return _Utils_eq(
		A2(
			$elm$core$List$map,
			$author$project$M$Tokenizer$type_,
			A2($elm$core$List$take, 1, tokens)),
		_List_fromArray(
			[$author$project$M$Tokenizer$TLB])) && _Utils_eq(
		A2(
			$elm$core$List$map,
			$author$project$M$Tokenizer$type_,
			A2(
				$elm$core$List$take,
				1,
				$elm$core$List$reverse(tokens))),
		_List_fromArray(
			[$author$project$M$Tokenizer$TRB]));
};
var $author$project$M$Symbol$BM = {$: 'BM'};
var $author$project$M$Symbol$E = {$: 'E'};
var $author$project$M$Symbol$L = {$: 'L'};
var $author$project$M$Symbol$LM = {$: 'LM'};
var $author$project$M$Symbol$R = {$: 'R'};
var $author$project$M$Symbol$RM = {$: 'RM'};
var $author$project$M$Symbol$ST = {$: 'ST'};
var $author$project$M$Symbol$toSymbol = function (token) {
	switch (token.$) {
		case 'LB':
			return $author$project$M$Symbol$L;
		case 'RB':
			return $author$project$M$Symbol$R;
		case 'LMB':
			return $author$project$M$Symbol$LM;
		case 'RMB':
			return $author$project$M$Symbol$RM;
		case 'S':
			return $author$project$M$Symbol$ST;
		case 'W':
			return $author$project$M$Symbol$WS;
		case 'MathToken':
			return $author$project$M$Symbol$M;
		case 'BracketedMath':
			return $author$project$M$Symbol$BM;
		case 'CodeToken':
			return $author$project$M$Symbol$C;
		default:
			return $author$project$M$Symbol$E;
	}
};
var $author$project$M$Symbol$toSymbols = function (tokens) {
	return A2($elm$core$List$map, $author$project$M$Symbol$toSymbol, tokens);
};
var $author$project$M$Expression$splitTokens = function (tokens) {
	var _v0 = $author$project$M$Match$match(
		$author$project$M$Symbol$toSymbols(tokens));
	if (_v0.$ === 'Nothing') {
		return $elm$core$Maybe$Nothing;
	} else {
		var k = _v0.a;
		return $elm$core$Maybe$Just(
			A2($author$project$M$Match$splitAt, k + 1, tokens));
	}
};
var $author$project$M$Expression$segLength = function (tokens) {
	return $elm$core$List$length(
		A2(
			$author$project$M$Match$getSegment,
			$author$project$M$Symbol$M,
			$author$project$M$Symbol$toSymbols(tokens)));
};
var $author$project$M$Expression$splitTokensWithSegment = function (tokens) {
	return A2(
		$author$project$M$Match$splitAt,
		$author$project$M$Expression$segLength(tokens) + 1,
		tokens);
};
var $author$project$M$Expression$unbracket = function (list) {
	return A2(
		$elm$core$List$drop,
		1,
		A2(
			$elm$core$List$take,
			$elm$core$List$length(list) - 1,
			list));
};
var $author$project$M$Expression$reduceRestOfTokens = F2(
	function (lineNumber, tokens) {
		if (tokens.b) {
			switch (tokens.a.$) {
				case 'LB':
					var _v15 = $author$project$M$Expression$splitTokens(tokens);
					if (_v15.$ === 'Nothing') {
						return _List_fromArray(
							[
								$author$project$M$Expression$errorMessageInvisible('Error on match'),
								A2($author$project$Generic$Language$Text, 'error on match', $author$project$M$Expression$dummyLocWithId)
							]);
					} else {
						var _v16 = _v15.a;
						var a = _v16.a;
						var b = _v16.b;
						return _Utils_ap(
							A2($author$project$M$Expression$reduceTokens, lineNumber, a),
							A2($author$project$M$Expression$reduceRestOfTokens, lineNumber, b));
					}
				case 'LMB':
					var _v17 = $author$project$M$Expression$splitTokens(tokens);
					if (_v17.$ === 'Nothing') {
						return _List_fromArray(
							[
								$author$project$M$Expression$errorMessageInvisible('Error on match'),
								A2($author$project$Generic$Language$Text, 'error on match', $author$project$M$Expression$dummyLocWithId)
							]);
					} else {
						var _v18 = _v17.a;
						var a = _v18.a;
						var b = _v18.b;
						return _Utils_ap(
							A2($author$project$M$Expression$reduceTokens, lineNumber, a),
							A2($author$project$M$Expression$reduceRestOfTokens, lineNumber, b));
					}
				case 'MathToken':
					var _v19 = $author$project$M$Expression$splitTokensWithSegment(tokens);
					var a = _v19.a;
					var b = _v19.b;
					return _Utils_ap(
						A2($author$project$M$Expression$reduceTokens, lineNumber, a),
						A2($author$project$M$Expression$reduceRestOfTokens, lineNumber, b));
				case 'CodeToken':
					var _v20 = $author$project$M$Expression$splitTokensWithSegment(tokens);
					var a = _v20.a;
					var b = _v20.b;
					return _Utils_ap(
						A2($author$project$M$Expression$reduceTokens, lineNumber, a),
						A2($author$project$M$Expression$reduceRestOfTokens, lineNumber, b));
				case 'S':
					var _v21 = tokens.a;
					var str = _v21.a;
					var meta = _v21.b;
					return A2(
						$elm$core$List$cons,
						A2(
							$author$project$Generic$Language$Text,
							str,
							A3(
								$author$project$M$Expression$boostMeta,
								0,
								$author$project$M$Tokenizer$indexOf(
									A2($author$project$M$Tokenizer$S, str, meta)),
								meta)),
						A2(
							$author$project$M$Expression$reduceRestOfTokens,
							lineNumber,
							A2($elm$core$List$drop, 1, tokens)));
				default:
					var token = tokens.a;
					var _v22 = A2($author$project$M$Expression$stringTokenToExpr, lineNumber, token);
					if (_v22.$ === 'Just') {
						var expr = _v22.a;
						return A2(
							$elm$core$List$cons,
							expr,
							A2(
								$author$project$M$Expression$reduceRestOfTokens,
								lineNumber,
								A2($elm$core$List$drop, 1, tokens)));
					} else {
						return _List_fromArray(
							[
								$author$project$M$Expression$errorMessage(
								'Line ' + ($elm$core$String$fromInt(lineNumber) + ', error converting token')),
								A2($author$project$Generic$Language$Text, 'error converting Token', $author$project$M$Expression$dummyLocWithId)
							]);
					}
			}
		} else {
			return _List_Nil;
		}
	});
var $author$project$M$Expression$reduceTokens = F2(
	function (lineNumber, tokens) {
		if ($author$project$M$Expression$isExpr(tokens)) {
			var args = $author$project$M$Expression$unbracket(tokens);
			if (args.b && (args.a.$ === 'S')) {
				var _v1 = args.a;
				var name = _v1.a;
				var meta = _v1.b;
				return _List_fromArray(
					[
						A3(
						$author$project$Generic$Language$Fun,
						name,
						A2(
							$author$project$M$Expression$reduceRestOfTokens,
							lineNumber,
							A2($elm$core$List$drop, 1, args)),
						A3($author$project$M$Expression$boostMeta, lineNumber, meta.index, meta))
					]);
			} else {
				return _List_fromArray(
					[
						$author$project$M$Expression$errorMessage('[????]')
					]);
			}
		} else {
			_v2$4:
			while (true) {
				if (tokens.b) {
					switch (tokens.a.$) {
						case 'MathToken':
							if (((tokens.b.b && (tokens.b.a.$ === 'S')) && tokens.b.b.b) && (tokens.b.b.a.$ === 'MathToken')) {
								var meta = tokens.a.a;
								var _v3 = tokens.b;
								var _v4 = _v3.a;
								var str = _v4.a;
								var _v5 = _v3.b;
								var rest = _v5.b;
								return A2(
									$elm$core$List$cons,
									A3(
										$author$project$Generic$Language$VFun,
										'math',
										str,
										A3($author$project$M$Expression$boostMeta, lineNumber, meta.index, meta)),
									A2($author$project$M$Expression$reduceRestOfTokens, lineNumber, rest));
							} else {
								break _v2$4;
							}
						case 'CodeToken':
							if (((tokens.b.b && (tokens.b.a.$ === 'S')) && tokens.b.b.b) && (tokens.b.b.a.$ === 'CodeToken')) {
								var meta = tokens.a.a;
								var _v6 = tokens.b;
								var _v7 = _v6.a;
								var str = _v7.a;
								var _v8 = _v6.b;
								var rest = _v8.b;
								return A2(
									$elm$core$List$cons,
									A3(
										$author$project$Generic$Language$VFun,
										'code',
										str,
										A3($author$project$M$Expression$boostMeta, lineNumber, meta.index, meta)),
									A2($author$project$M$Expression$reduceRestOfTokens, lineNumber, rest));
							} else {
								break _v2$4;
							}
						case 'LMB':
							if (((tokens.b.b && (tokens.b.a.$ === 'S')) && tokens.b.b.b) && (tokens.b.b.a.$ === 'RMB')) {
								var meta = tokens.a.a;
								var _v9 = tokens.b;
								var _v10 = _v9.a;
								var str = _v10.a;
								var _v11 = _v9.b;
								var rest = _v11.b;
								return A2(
									$elm$core$List$cons,
									A3(
										$author$project$Generic$Language$VFun,
										'math',
										str,
										A3($author$project$M$Expression$boostMeta, lineNumber, meta.index, meta)),
									A2($author$project$M$Expression$reduceRestOfTokens, lineNumber, rest));
							} else {
								var meta = tokens.a.a;
								var rest = tokens.b;
								var reversedRest = $elm$core$List$reverse(rest);
								var _v12 = $elm$core$List$head(reversedRest);
								if ((_v12.$ === 'Just') && (_v12.a.$ === 'RMB')) {
									var content = A2(
										$elm$core$String$join,
										' ',
										A2(
											$elm$core$List$map,
											function (t) {
												switch (t.$) {
													case 'S':
														var str = t.a;
														return str;
													case 'LB':
														return '[';
													case 'RB':
														return ']';
													default:
														return '';
												}
											},
											rest));
									return _List_fromArray(
										[
											A3(
											$author$project$Generic$Language$VFun,
											'math',
											content,
											A3($author$project$M$Expression$boostMeta, lineNumber, meta.index, meta))
										]);
								} else {
									return _List_fromArray(
										[
											$author$project$M$Expression$errorMessage('[????]')
										]);
								}
							}
						default:
							break _v2$4;
					}
				} else {
					break _v2$4;
				}
			}
			return _List_fromArray(
				[
					$author$project$M$Expression$errorMessage('[????]')
				]);
		}
	});
var $author$project$M$Expression$reduceStack = function (state) {
	return A2(
		$author$project$M$Expression$reduceTokens,
		state.lineNumber,
		$elm$core$List$reverse(state.stack));
};
var $author$project$M$Expression$tokensAreReducible = function (state) {
	return $author$project$M$Match$isReducible(
		$elm$core$List$reverse(
			$author$project$M$Symbol$toSymbols(state.stack)));
};
var $author$project$M$Expression$reduceState = function (state) {
	return $author$project$M$Expression$tokensAreReducible(state) ? _Utils_update(
		state,
		{
			committed: _Utils_ap(
				$author$project$M$Expression$reduceStack(state),
				state.committed),
			stack: _List_Nil
		}) : state;
};
var $author$project$M$Expression$recoverFromUnknownError = function (state) {
	var k = $author$project$M$Symbol$balance(
		$author$project$M$Symbol$toSymbols(
			$elm$core$List$reverse(state.stack)));
	var newStack = _Utils_ap(
		A2(
			$elm$core$List$repeat,
			k,
			$author$project$M$Tokenizer$RB($author$project$M$Expression$dummyLoc)),
		state.stack);
	var newSymbols = $author$project$M$Symbol$toSymbols(
		$elm$core$List$reverse(newStack));
	var reducible = $author$project$M$Match$isReducible(newSymbols);
	return reducible ? $author$project$Tools$Loop$Done(
		A2(
			$author$project$M$Expression$addErrorMessage,
			' ?!?(1) ',
			$author$project$M$Expression$reduceState(
				_Utils_update(
					state,
					{
						committed: A2(
							$elm$core$List$cons,
							$author$project$M$Expression$errorMessage(' ?!?(2) '),
							state.committed),
						messages: A3(
							$author$project$Tools$ParserHelpers$prependMessage,
							state.lineNumber,
							' ?!?(3) ' + ($elm$core$String$fromInt(k) + ' right brackets'),
							state.messages),
						numberOfTokens: $elm$core$List$length(newStack),
						stack: newStack,
						tokenIndex: 0
					})))) : $author$project$Tools$Loop$Done(
		_Utils_update(
			state,
			{
				committed: A2(
					$elm$core$List$cons,
					$author$project$M$Expression$bracketError(k),
					state.committed),
				messages: A3(
					$author$project$Tools$ParserHelpers$prependMessage,
					state.lineNumber,
					$author$project$M$Expression$bracketErrorAsString(k),
					state.messages)
			}));
};
var $author$project$M$Tokenizer$stringValue = function (token) {
	switch (token.$) {
		case 'LB':
			return '[';
		case 'RB':
			return ']';
		case 'LMB':
			return '\\(';
		case 'RMB':
			return '\\)';
		case 'S':
			var str = token.a;
			return str;
		case 'W':
			var str = token.a;
			return str;
		case 'MathToken':
			return '$';
		case 'BracketedMath':
			var s = token.a;
			return '\\(' + (s + '\\)');
		case 'CodeToken':
			return '`';
		default:
			return 'tokenError';
	}
};
var $author$project$M$Tokenizer$toString = function (tokens) {
	return A2(
		$elm$core$String$join,
		'',
		A2($elm$core$List$map, $author$project$M$Tokenizer$stringValue, tokens));
};
var $author$project$M$Expression$recoverFromError = function (state) {
	var _v0 = $elm$core$List$reverse(state.stack);
	_v0$11:
	while (true) {
		if (_v0.b) {
			switch (_v0.a.$) {
				case 'LMB':
					var meta1 = _v0.a.a;
					var rest = _v0.b;
					var k = meta1.index;
					var shiftedTokens = A3($author$project$M$Tokenizer$changeTokenIndicesFrom, k + 1, 4, state.tokens);
					var errorTokens = _List_fromArray(
						[
							$author$project$M$Tokenizer$LB(
							{begin: 0, end: 0, index: k + 1}),
							A2(
							$author$project$M$Tokenizer$S,
							'red',
							{begin: 1, end: 3, index: k + 2}),
							A2(
							$author$project$M$Tokenizer$S,
							' unmatched \\(',
							{begin: 4, end: 9, index: k + 3}),
							$author$project$M$Tokenizer$RB(
							{begin: 10, end: 10, index: k + 4})
						]);
					return $author$project$Tools$Loop$Loop(
						_Utils_update(
							state,
							{
								messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'No terminating right math bracket', state.messages),
								stack: _List_Nil,
								tokenIndex: meta1.index + 1,
								tokens: _Utils_ap(
									A2($elm$core$List$take, k + 1, state.tokens),
									_Utils_ap(
										errorTokens,
										A2($elm$core$List$drop, k + 1, shiftedTokens)))
							}));
				case 'RMB':
					var meta1 = _v0.a.a;
					var k = meta1.index;
					var shiftedTokens = A3($author$project$M$Tokenizer$changeTokenIndicesFrom, k + 1, 4, state.tokens);
					var errorTokens = _List_fromArray(
						[
							$author$project$M$Tokenizer$LB(
							{begin: 0, end: 0, index: k + 1}),
							A2(
							$author$project$M$Tokenizer$S,
							'red',
							{begin: 1, end: 3, index: k + 2}),
							A2(
							$author$project$M$Tokenizer$S,
							'unmatched \\)',
							{begin: 4, end: 9, index: k + 3}),
							$author$project$M$Tokenizer$RB(
							{begin: 10, end: 10, index: k + 4})
						]);
					return $author$project$Tools$Loop$Loop(
						_Utils_update(
							state,
							{
								messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'No terminating right math bracket', state.messages),
								stack: _List_Nil,
								tokenIndex: meta1.index + 1,
								tokens: _Utils_ap(
									A2($elm$core$List$take, k + 1, state.tokens),
									_Utils_ap(
										errorTokens,
										A2($elm$core$List$drop, k + 1, shiftedTokens)))
							}));
				case 'LB':
					if (_v0.b.b) {
						switch (_v0.b.a.$) {
							case 'RB':
								var _v1 = _v0.b;
								var meta = _v1.a.a;
								return $author$project$Tools$Loop$Loop(
									_Utils_update(
										state,
										{
											committed: A2(
												$elm$core$List$cons,
												$author$project$M$Expression$errorMessage('[?]'),
												state.committed),
											messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'Brackets must enclose something', state.messages),
											stack: _List_Nil,
											tokenIndex: meta.index + 1
										}));
							case 'LB':
								var meta1 = _v0.a.a;
								var _v2 = _v0.b;
								var k = meta1.index;
								var shiftedTokens = A3($author$project$M$Tokenizer$changeTokenIndicesFrom, k + 1, 1, state.tokens);
								return $author$project$Tools$Loop$Loop(
									_Utils_update(
										state,
										{
											messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'Consecutive left brackets', state.messages),
											stack: _List_Nil,
											tokenIndex: meta1.index,
											tokens: _Utils_ap(
												A2($elm$core$List$take, k + 1, state.tokens),
												A2(
													$elm$core$List$cons,
													A2(
														$author$project$M$Tokenizer$S,
														'1[??',
														_Utils_update(
															$author$project$M$Expression$dummyLoc,
															{index: k + 1})),
													A2($elm$core$List$drop, k + 1, shiftedTokens)))
										}));
							case 'S':
								var _v3 = _v0.b;
								var _v4 = _v3.a;
								var fName = _v4.a;
								var meta = _v4.b;
								var rest = _v3.b;
								return $author$project$Tools$Loop$Loop(
									_Utils_update(
										state,
										{
											committed: A2(
												$elm$core$List$cons,
												$author$project$M$Expression$errorMessage(
													$author$project$M$Expression$errorSuffix(rest)),
												A2(
													$elm$core$List$cons,
													$author$project$M$Expression$errorMessage('[' + fName),
													state.committed)),
											messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'Missing right bracket', state.messages),
											stack: _List_Nil,
											tokenIndex: meta.index + 1
										}));
							case 'W':
								if (_v0.b.a.a === ' ') {
									var _v5 = _v0.b;
									var _v6 = _v5.a;
									var meta = _v6.b;
									return $author$project$Tools$Loop$Loop(
										_Utils_update(
											state,
											{
												committed: A2(
													$elm$core$List$cons,
													$author$project$M$Expression$errorMessage('[ - can\'t have space after the bracket '),
													state.committed),
												messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'Can\'t have space after left bracket - try [something ...', state.messages),
												stack: _List_Nil,
												tokenIndex: meta.index + 1
											}));
								} else {
									break _v0$11;
								}
							default:
								break _v0$11;
						}
					} else {
						return $author$project$Tools$Loop$Done(
							_Utils_update(
								state,
								{
									committed: A2(
										$elm$core$List$cons,
										$author$project$M$Expression$errorMessage('[...?'),
										state.committed),
									messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'That left bracket needs something after it', state.messages),
									numberOfTokens: 0,
									stack: _List_Nil,
									tokenIndex: 0
								}));
					}
				case 'RB':
					var meta = _v0.a.a;
					return $author$project$Tools$Loop$Loop(
						_Utils_update(
							state,
							{
								committed: A2(
									$elm$core$List$cons,
									$author$project$M$Expression$errorMessage(' extra ]?'),
									state.committed),
								messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'Extra right bracket(s)', state.messages),
								stack: _List_Nil,
								tokenIndex: meta.index + 1
							}));
				case 'MathToken':
					var meta = _v0.a.a;
					var rest = _v0.b;
					var content = $author$project$M$Tokenizer$toString(rest);
					var message = (content === '') ? '$?$' : '$ ';
					return $author$project$Tools$Loop$Loop(
						_Utils_update(
							state,
							{
								committed: A2(
									$elm$core$List$cons,
									$author$project$M$Expression$errorMessage(message),
									state.committed),
								messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'opening dollar sign needs to be matched with a closing one', state.messages),
								numberOfTokens: 0,
								stack: _List_Nil,
								tokenIndex: meta.index + 1
							}));
				case 'CodeToken':
					var meta = _v0.a.a;
					var rest = _v0.b;
					var content = $author$project$M$Tokenizer$toString(rest);
					var message = (content === '') ? '`?`' : '` ';
					return $author$project$Tools$Loop$Loop(
						_Utils_update(
							state,
							{
								committed: A2(
									$elm$core$List$cons,
									$author$project$M$Expression$errorMessage(message),
									state.committed),
								messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'opening backtick needs to be matched with a closing one', state.messages),
								numberOfTokens: 0,
								stack: _List_Nil,
								tokenIndex: meta.index + 1
							}));
				case 'TokenError':
					var _v7 = _v0.a;
					var meta = _v7.b;
					return $author$project$Tools$Loop$Loop(
						_Utils_update(
							state,
							{
								committed: A2(
									$elm$core$List$cons,
									$author$project$M$Expression$errorMessage('\\[..??'),
									state.committed),
								messages: A3($author$project$Tools$ParserHelpers$prependMessage, state.lineNumber, 'No mathching \\]??', state.messages),
								stack: _List_Nil,
								tokenIndex: meta.index + 1
							}));
				default:
					break _v0$11;
			}
		} else {
			break _v0$11;
		}
	}
	return $author$project$M$Expression$recoverFromUnknownError(state);
};
var $author$project$M$Expression$stackIsEmpty = function (state) {
	return $elm$core$List$isEmpty(state.stack);
};
var $author$project$M$Expression$nextStep = function (state) {
	var _v0 = $author$project$M$Expression$getToken(state);
	if (_v0.$ === 'Nothing') {
		return $author$project$M$Expression$stackIsEmpty(state) ? $author$project$Tools$Loop$Done(state) : $author$project$M$Expression$recoverFromError(state);
	} else {
		var token = _v0.a;
		return $author$project$Tools$Loop$Loop(
			function (st) {
				return _Utils_update(
					st,
					{step: st.step + 1});
			}(
				$author$project$M$Expression$reduceState(
					A2(
						$author$project$M$Expression$pushOrCommit,
						token,
						$author$project$M$Expression$advanceTokenIndex(state)))));
	}
};
var $author$project$M$Expression$run = function (state) {
	return function (state_) {
		return _Utils_update(
			state_,
			{
				committed: $elm$core$List$reverse(state_.committed)
			});
	}(
		A2($author$project$Tools$Loop$loop, state, $author$project$M$Expression$nextStep));
};
var $author$project$M$Expression$parseTokenListToState = F2(
	function (lineNumber, tokens) {
		var state = $author$project$M$Expression$run(
			A2($author$project$M$Expression$initWithTokens, lineNumber, tokens));
		return state;
	});
var $author$project$M$Tokenizer$Normal = {$: 'Normal'};
var $author$project$M$Tokenizer$init = function (str) {
	return {
		currentToken: $elm$core$Maybe$Nothing,
		mode: $author$project$M$Tokenizer$Normal,
		scanpointer: 0,
		source: str,
		sourceLength: $elm$core$String$length(str),
		tokenIndex: 0,
		tokens: _List_Nil
	};
};
var $author$project$Tools$ParserTools$ExpectingPrefix = {$: 'ExpectingPrefix'};
var $author$project$Tools$ParserTools$text = F2(
	function (prefix, _continue) {
		return A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$keeper,
				A2(
					$elm$parser$Parser$Advanced$keeper,
					$elm$parser$Parser$Advanced$succeed(
						F3(
							function (start, finish, content) {
								return {
									begin: start,
									content: A3($elm$core$String$slice, start, finish, content),
									end: finish
								};
							})),
					A2(
						$elm$parser$Parser$Advanced$ignorer,
						A2(
							$elm$parser$Parser$Advanced$ignorer,
							$elm$parser$Parser$Advanced$getOffset,
							A2(
								$elm$parser$Parser$Advanced$chompIf,
								function (c) {
									return prefix(c);
								},
								$author$project$Tools$ParserTools$ExpectingPrefix)),
						$elm$parser$Parser$Advanced$chompWhile(
							function (c) {
								return _continue(c);
							}))),
				$elm$parser$Parser$Advanced$getOffset),
			$elm$parser$Parser$Advanced$getSource);
	});
var $author$project$M$Tokenizer$codeParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$M$Tokenizer$CodeToken(
					{begin: start, end: start, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('`'));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$M$Tokenizer$codeChars = _List_fromArray(
	[
		_Utils_chr('`')
	]);
var $author$project$M$Tokenizer$languageChars = _List_fromArray(
	[
		_Utils_chr('['),
		_Utils_chr(']'),
		_Utils_chr('`'),
		_Utils_chr('$'),
		_Utils_chr('\\')
	]);
var $author$project$M$Tokenizer$codeTextParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (data) {
				return A2(
					$author$project$M$Tokenizer$S,
					data.content,
					{begin: start, end: ((start + data.end) - data.begin) - 1, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$M$Tokenizer$codeChars));
				},
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$M$Tokenizer$languageChars));
				}));
	});
var $author$project$M$Tokenizer$whiteSpaceParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (data) {
				return A2(
					$author$project$M$Tokenizer$W,
					data.content,
					{begin: start, end: start, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr(' '));
				},
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr(' '));
				}));
	});
var $author$project$M$Tokenizer$codeParser_ = F2(
	function (start, index) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					A2($author$project$M$Tokenizer$codeTextParser, start, index),
					A2($author$project$M$Tokenizer$codeParser, start, index),
					A2($author$project$M$Tokenizer$whiteSpaceParser, start, index)
				]));
	});
var $author$project$M$Tokenizer$mathParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$M$Tokenizer$MathToken(
					{begin: start, end: start, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('$'));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$M$Tokenizer$mathChars = _List_fromArray(
	[
		_Utils_chr('$')
	]);
var $author$project$M$Tokenizer$mathTextParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (data) {
				return A2(
					$author$project$M$Tokenizer$S,
					data.content,
					{begin: start, end: ((start + data.end) - data.begin) - 1, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$M$Tokenizer$mathChars));
				},
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$M$Tokenizer$languageChars));
				}));
	});
var $author$project$M$Tokenizer$mathParser_ = F2(
	function (start, index) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					A2($author$project$M$Tokenizer$mathTextParser, start, index),
					A2($author$project$M$Tokenizer$mathParser, start, index),
					A2($author$project$M$Tokenizer$whiteSpaceParser, start, index)
				]));
	});
var $author$project$M$Tokenizer$backSlashedPrefixParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (data) {
				return A2(
					$author$project$M$Tokenizer$S,
					data.content,
					{begin: start, end: ((start + data.end) - data.begin) - 1, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('\\'));
				},
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$M$Tokenizer$languageChars));
				}));
	});
var $author$project$M$Tokenizer$leftBracketParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$M$Tokenizer$LB(
					{begin: start, end: start, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('['));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$M$Tokenizer$leftMathBracketParser_ = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$M$Tokenizer$LMB(
					{begin: start, end: start + 1, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('('));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$M$Tokenizer$leftMathBracketParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$andThen,
			function (_v1) {
				return A2($author$project$M$Tokenizer$leftMathBracketParser_, start, index);
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr('\\'));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$M$Tokenizer$rightBracketParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$M$Tokenizer$RB(
					{begin: start, end: start, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr(']'));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$M$Tokenizer$rightMathBracketParser_ = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (_v1) {
				return $author$project$M$Tokenizer$RMB(
					{begin: start, end: start + 1, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return _Utils_eq(
						c,
						_Utils_chr(')'));
				},
				function (_v0) {
					return false;
				}));
	});
var $author$project$M$Tokenizer$rightMathBracketParser = F2(
	function (start, index) {
		return $elm$parser$Parser$Advanced$backtrackable(
			A2(
				$elm$parser$Parser$Advanced$andThen,
				function (_v1) {
					return A2($author$project$M$Tokenizer$rightMathBracketParser_, start, index);
				},
				A2(
					$author$project$Tools$ParserTools$text,
					function (c) {
						return _Utils_eq(
							c,
							_Utils_chr('\\'));
					},
					function (_v0) {
						return false;
					})));
	});
var $author$project$M$Tokenizer$textParser = F2(
	function (start, index) {
		return A2(
			$elm$parser$Parser$Advanced$map,
			function (data) {
				return A2(
					$author$project$M$Tokenizer$S,
					data.content,
					{begin: start, end: ((start + data.end) - data.begin) - 1, index: index});
			},
			A2(
				$author$project$Tools$ParserTools$text,
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$M$Tokenizer$languageChars));
				},
				function (c) {
					return !A2(
						$elm$core$List$member,
						c,
						A2(
							$elm$core$List$cons,
							_Utils_chr(' '),
							$author$project$M$Tokenizer$languageChars));
				}));
	});
var $author$project$M$Tokenizer$tokenParser_ = F2(
	function (start, index) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					$elm$parser$Parser$Advanced$oneOf(
					_List_fromArray(
						[
							$elm$parser$Parser$Advanced$backtrackable(
							A2($author$project$M$Tokenizer$leftMathBracketParser, start, index)),
							$elm$parser$Parser$Advanced$backtrackable(
							A2($author$project$M$Tokenizer$rightMathBracketParser, start, index)),
							A2($author$project$M$Tokenizer$backSlashedPrefixParser, start, index)
						])),
					A2($author$project$M$Tokenizer$whiteSpaceParser, start, index),
					A2($author$project$M$Tokenizer$textParser, start, index),
					A2($author$project$M$Tokenizer$leftBracketParser, start, index),
					A2($author$project$M$Tokenizer$rightBracketParser, start, index),
					A2($author$project$M$Tokenizer$mathParser, start, index),
					A2($author$project$M$Tokenizer$codeParser, start, index)
				]));
	});
var $author$project$M$Tokenizer$tokenParser = F3(
	function (mode, start, index) {
		switch (mode.$) {
			case 'Normal':
				return A2($author$project$M$Tokenizer$tokenParser_, start, index);
			case 'InMath':
				return A2($author$project$M$Tokenizer$mathParser_, start, index);
			default:
				return A2($author$project$M$Tokenizer$codeParser_, start, index);
		}
	});
var $author$project$M$Tokenizer$get = F3(
	function (state, start, input) {
		var _v0 = A2(
			$elm$parser$Parser$Advanced$run,
			A3($author$project$M$Tokenizer$tokenParser, state.mode, start, state.tokenIndex),
			input);
		if (_v0.$ === 'Ok') {
			var token = _v0.a;
			return token;
		} else {
			var errorList = _v0.a;
			return A2(
				$author$project$M$Tokenizer$TokenError,
				errorList,
				{begin: start, end: start + 1, index: state.tokenIndex});
		}
	});
var $author$project$M$Tokenizer$isTextToken = function (token) {
	return A2(
		$elm$core$List$member,
		$author$project$M$Tokenizer$type_(token),
		_List_fromArray(
			[$author$project$M$Tokenizer$TW, $author$project$M$Tokenizer$TS]));
};
var $author$project$M$Tokenizer$length = function (token) {
	switch (token.$) {
		case 'LB':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'RB':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'LMB':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'RMB':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'S':
			var meta = token.b;
			return meta.end - meta.begin;
		case 'MathToken':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'CodeToken':
			var meta = token.a;
			return meta.end - meta.begin;
		case 'BracketedMath':
			var meta = token.b;
			return meta.end - meta.begin;
		case 'W':
			var meta = token.b;
			return meta.end - meta.begin;
		default:
			var meta = token.b;
			return meta.end - meta.begin;
	}
};
var $author$project$M$Tokenizer$InCode = {$: 'InCode'};
var $author$project$M$Tokenizer$InMath = {$: 'InMath'};
var $author$project$M$Tokenizer$newMode = F2(
	function (token, currentMode) {
		switch (currentMode.$) {
			case 'Normal':
				switch (token.$) {
					case 'MathToken':
						return $author$project$M$Tokenizer$InMath;
					case 'CodeToken':
						return $author$project$M$Tokenizer$InCode;
					default:
						return $author$project$M$Tokenizer$Normal;
				}
			case 'InMath':
				if (token.$ === 'MathToken') {
					return $author$project$M$Tokenizer$Normal;
				} else {
					return $author$project$M$Tokenizer$InMath;
				}
			default:
				if (token.$ === 'CodeToken') {
					return $author$project$M$Tokenizer$Normal;
				} else {
					return $author$project$M$Tokenizer$InCode;
				}
		}
	});
var $author$project$M$Tokenizer$getMeta = function (token) {
	switch (token.$) {
		case 'LB':
			var m = token.a;
			return m;
		case 'RB':
			var m = token.a;
			return m;
		case 'LMB':
			var m = token.a;
			return m;
		case 'RMB':
			var m = token.a;
			return m;
		case 'S':
			var m = token.b;
			return m;
		case 'W':
			var m = token.b;
			return m;
		case 'MathToken':
			var m = token.a;
			return m;
		case 'BracketedMath':
			var m = token.b;
			return m;
		case 'CodeToken':
			var m = token.a;
			return m;
		default:
			var m = token.b;
			return m;
	}
};
var $author$project$M$Tokenizer$mergeToken = F2(
	function (lastToken, currentToken) {
		var lastTokenMeta = $author$project$M$Tokenizer$getMeta(lastToken);
		var currentTokenMeta = $author$project$M$Tokenizer$getMeta(currentToken);
		var meta = {begin: lastTokenMeta.begin, end: currentTokenMeta.end, index: -1};
		return A2(
			$author$project$M$Tokenizer$S,
			_Utils_ap(
				$author$project$M$Tokenizer$stringValue(lastToken),
				$author$project$M$Tokenizer$stringValue(currentToken)),
			meta);
	});
var $author$project$M$Tokenizer$updateCurrentToken = F3(
	function (index, token, currentToken) {
		if (currentToken.$ === 'Nothing') {
			return $elm$core$Maybe$Just(
				A2($author$project$M$Tokenizer$setIndex, index, token));
		} else {
			var token_ = currentToken.a;
			return $elm$core$Maybe$Just(
				A2(
					$author$project$M$Tokenizer$setIndex,
					index,
					A2($author$project$M$Tokenizer$mergeToken, token_, token)));
		}
	});
var $author$project$M$Tokenizer$nextStep = function (state) {
	if (_Utils_cmp(state.scanpointer, state.sourceLength) > -1) {
		var _v0 = state.currentToken;
		if (_v0.$ === 'Just') {
			var token = _v0.a;
			return $author$project$Tools$ParserHelpers$Done(
				A2($elm$core$List$cons, token, state.tokens));
		} else {
			return $author$project$Tools$ParserHelpers$Done(state.tokens);
		}
	} else {
		var token = A3(
			$author$project$M$Tokenizer$get,
			state,
			state.scanpointer,
			A2($elm$core$String$dropLeft, state.scanpointer, state.source));
		var newScanPointer = (state.scanpointer + $author$project$M$Tokenizer$length(token)) + 1;
		var _v1 = function () {
			if ($author$project$M$Tokenizer$isTextToken(token)) {
				return _Utils_eq(
					A2(
						$elm$core$Maybe$map,
						$author$project$M$Tokenizer$type_,
						$elm$core$List$head(state.tokens)),
					$elm$core$Maybe$Just($author$project$M$Tokenizer$TLB)) ? _Utils_Tuple3(
					A2(
						$elm$core$List$cons,
						A2($author$project$M$Tokenizer$setIndex, state.tokenIndex, token),
						state.tokens),
					state.tokenIndex + 1,
					$elm$core$Maybe$Nothing) : _Utils_Tuple3(
					state.tokens,
					state.tokenIndex,
					A3($author$project$M$Tokenizer$updateCurrentToken, state.tokenIndex, token, state.currentToken));
			} else {
				if (_Utils_eq(
					$author$project$M$Tokenizer$type_(token),
					$author$project$M$Tokenizer$TLB)) {
					var _v2 = state.currentToken;
					if (_v2.$ === 'Nothing') {
						return _Utils_Tuple3(
							A2(
								$elm$core$List$cons,
								A2($author$project$M$Tokenizer$setIndex, state.tokenIndex, token),
								state.tokens),
							state.tokenIndex + 1,
							$elm$core$Maybe$Nothing);
					} else {
						var textToken = _v2.a;
						return _Utils_Tuple3(
							A2(
								$elm$core$List$cons,
								A2($author$project$M$Tokenizer$setIndex, state.tokenIndex + 1, token),
								A2(
									$elm$core$List$cons,
									A2($author$project$M$Tokenizer$setIndex, state.tokenIndex, textToken),
									state.tokens)),
							state.tokenIndex + 2,
							$elm$core$Maybe$Nothing);
					}
				} else {
					var _v3 = state.currentToken;
					if (_v3.$ === 'Nothing') {
						return _Utils_Tuple3(
							A2(
								$elm$core$List$cons,
								A2($author$project$M$Tokenizer$setIndex, state.tokenIndex, token),
								state.tokens),
							state.tokenIndex + 1,
							$elm$core$Maybe$Nothing);
					} else {
						var textToken = _v3.a;
						return _Utils_Tuple3(
							A2(
								$elm$core$List$cons,
								A2($author$project$M$Tokenizer$setIndex, state.tokenIndex + 1, token),
								A2($elm$core$List$cons, textToken, state.tokens)),
							state.tokenIndex + 2,
							$elm$core$Maybe$Nothing);
					}
				}
			}
		}();
		var tokens = _v1.a;
		var tokenIndex = _v1.b;
		var currentToken_ = _v1.c;
		var currentToken = $author$project$M$Tokenizer$isTextToken(token) ? currentToken_ : $elm$core$Maybe$Nothing;
		return $author$project$Tools$ParserHelpers$Loop(
			_Utils_update(
				state,
				{
					currentToken: currentToken,
					mode: A2($author$project$M$Tokenizer$newMode, token, state.mode),
					scanpointer: newScanPointer,
					tokenIndex: tokenIndex,
					tokens: tokens
				}));
	}
};
var $author$project$M$Tokenizer$run = function (source) {
	return A2(
		$author$project$Tools$ParserHelpers$loop,
		$author$project$M$Tokenizer$init(source),
		$author$project$M$Tokenizer$nextStep);
};
var $author$project$M$Expression$parseToState = F2(
	function (lineNumber, str) {
		return A2(
			$author$project$M$Expression$parseTokenListToState,
			lineNumber,
			$author$project$M$Tokenizer$run(str));
	});
var $author$project$M$Expression$parse = F2(
	function (lineNumber, str) {
		var state = A2($author$project$M$Expression$parseToState, lineNumber, str);
		return $author$project$M$Expression$fixup(state.committed);
	});
var $author$project$Generic$Pipeline$toExpressionBlock_ = F2(
	function (parse, primitiveBlock) {
		return {
			args: primitiveBlock.args,
			body: function () {
				var _v0 = primitiveBlock.heading;
				switch (_v0.$) {
					case 'Paragraph':
						return $toastal$either$Either$Right(
							parse(
								A2($elm$core$String$join, '\n', primitiveBlock.body)));
					case 'Ordinary':
						switch (_v0.a) {
							case 'itemList':
								var items = $author$project$Generic$Pipeline$fixItems(
									A2($elm$core$List$cons, primitiveBlock.firstLine, primitiveBlock.body));
								var content_ = A2($elm$core$List$map, parse, items);
								return $toastal$either$Either$Right(
									A2(
										$elm$core$List$map,
										function (list) {
											return A2($author$project$Generic$Language$ExprList, list, $author$project$Generic$Language$emptyExprMeta);
										},
										content_));
							case 'numberedList':
								var items = $author$project$Generic$Pipeline$fixNumberedItems(
									A2($elm$core$List$cons, primitiveBlock.firstLine, primitiveBlock.body));
								var content_ = A2(
									$elm$core$List$map,
									$author$project$M$Expression$parse(0),
									items);
								return $toastal$either$Either$Right(
									A2(
										$elm$core$List$map,
										function (list) {
											return A2($author$project$Generic$Language$ExprList, list, $author$project$Generic$Language$emptyExprMeta);
										},
										content_));
							default:
								return $toastal$either$Either$Right(
									parse(
										A2($elm$core$String$join, '\n', primitiveBlock.body)));
						}
					default:
						return $toastal$either$Either$Left(
							A2($elm$core$String$join, '\n', primitiveBlock.body));
				}
			}(),
			firstLine: primitiveBlock.firstLine,
			heading: primitiveBlock.heading,
			indent: primitiveBlock.indent,
			meta: primitiveBlock.meta,
			properties: A3($elm$core$Dict$insert, 'id', primitiveBlock.meta.id, primitiveBlock.properties),
			style: primitiveBlock.style
		};
	});
var $author$project$Generic$Pipeline$toExpressionBlock = F2(
	function (parser, block) {
		return $author$project$Generic$Language$boostBlock(
			A2(
				$author$project$Generic$Pipeline$toExpressionBlock_,
				parser(block.meta.lineNumber),
				block));
	});
var $author$project$Generic$Compiler$parse_ = F6(
	function (lang, primitiveBlockParser, exprParser, idPrefix, outerCount, lines) {
		return A2(
			$author$project$Generic$Forest$map,
			$author$project$Generic$Pipeline$toExpressionBlock(exprParser),
			A2(
				$author$project$Generic$ForestTransform$forestFromBlocks,
				function ($) {
					return $.indent;
				},
				A3(primitiveBlockParser, idPrefix, outerCount, lines)));
	});
var $author$project$Render$Export$LaTeXToScripta2$parseL = function (latexSource) {
	var outerCount = 0;
	var lines = $elm$core$String$lines(latexSource);
	var idPrefix = $author$project$ScriptaV2$Config$idPrefix;
	return A6($author$project$Generic$Compiler$parse_, $author$project$ScriptaV2$Language$MicroLaTeXLang, $author$project$MicroLaTeX$PrimitiveBlock$parse, $author$project$MicroLaTeX$Expression$parse, idPrefix, outerCount, lines);
};
var $elm$html$Html$pre = _VirtualDom_node('pre');
var $author$project$Render$Export$LaTeXToScripta2$isAlphaNum = function (str) {
	var _v0 = $elm$core$String$uncons(str);
	if (_v0.$ === 'Just') {
		var _v1 = _v0.a;
		var _char = _v1.a;
		return $elm$core$Char$isAlphaNum(_char);
	} else {
		return false;
	}
};
var $author$project$Render$Export$LaTeXToScripta2$intelligentJoin = function (tokens) {
	if (!tokens.b) {
		return '';
	} else {
		if (!tokens.b.b) {
			var single = tokens.a;
			return single;
		} else {
			var first = tokens.a;
			var _v1 = tokens.b;
			var second = _v1.a;
			var rest = _v1.b;
			var needsSpace = $author$project$Render$Export$LaTeXToScripta2$isAlphaNum(
				A2($elm$core$String$right, 1, first)) && $author$project$Render$Export$LaTeXToScripta2$isAlphaNum(
				A2($elm$core$String$left, 1, second));
			var separator = needsSpace ? ' ' : '';
			return _Utils_ap(
				first,
				_Utils_ap(
					separator,
					$author$project$Render$Export$LaTeXToScripta2$intelligentJoin(
						A2($elm$core$List$cons, second, rest))));
		}
	}
};
var $author$project$ETeX$KaTeX$accents = _List_fromArray(
	['hat', 'widehat', 'check', 'widecheck', 'tilde', 'widetilde', 'acute', 'grave', 'dot', 'ddot', 'breve', 'bar', 'vec', 'mathring', 'overline', 'underline', 'overleftarrow', 'overrightarrow', 'overleftrightarrow', 'underleftarrow', 'underrightarrow', 'underleftrightarrow', 'overgroup', 'undergroup', 'overbrace', 'underbrace', 'overparen', 'underparen', 'overrightleftharpoons', 'boxed', 'underlinesegment', 'overlinesegment']);
var $author$project$ETeX$KaTeX$arrows = _List_fromArray(
	['leftarrow', 'gets', 'rightarrow', 'to', 'leftrightarrow', 'Leftarrow', 'Rightarrow', 'Leftrightarrow', 'iff', 'uparrow', 'downarrow', 'updownarrow', 'Uparrow', 'Downarrow', 'Updownarrow', 'mapsto', 'hookleftarrow', 'hookrightarrow', 'leftharpoonup', 'rightharpoonup', 'leftharpoondown', 'rightharpoondown', 'rightleftharpoons', 'longleftarrow', 'longrightarrow', 'longleftrightarrow', 'Longleftarrow', 'impliedby', 'Longrightarrow', 'implies', 'Longleftrightarrow', 'longmapsto', 'nearrow', 'searrow', 'swarrow', 'nwarrow', 'dashleftarrow', 'dashrightarrow', 'leftleftarrows', 'rightrightarrows', 'leftrightarrows', 'rightleftarrows', 'Lleftarrow', 'Rrightarrow', 'twoheadleftarrow', 'twoheadrightarrow', 'leftarrowtail', 'rightarrowtail', 'looparrowleft', 'looparrowright', 'curvearrowleft', 'curvearrowright', 'circlearrowleft', 'circlearrowright', 'multimap', 'leftrightsquigarrow', 'rightsquigarrow', 'leadsto', 'restriction']);
var $author$project$ETeX$KaTeX$bigOperators = _List_fromArray(
	['sum', 'prod', 'coprod', 'bigcup', 'bigcap', 'bigvee', 'bigwedge', 'bigoplus', 'bigotimes', 'bigodot', 'biguplus', 'bigsqcup', 'int', 'oint', 'iint', 'iiint', 'iiiint', 'intop', 'smallint']);
var $author$project$ETeX$KaTeX$binaryOperators = _List_fromArray(
	['pm', 'mp', 'times', 'div', 'cdot', 'ast', 'star', 'circ', 'bullet', 'oplus', 'ominus', 'otimes', 'oslash', 'odot', 'dagger', 'ddagger', 'vee', 'lor', 'wedge', 'land', 'cap', 'cup', 'setminus', 'smallsetminus', 'triangleleft', 'triangleright', 'bigtriangleup', 'bigtriangledown', 'lhd', 'rhd', 'unlhd', 'unrhd', 'amalg', 'uplus', 'sqcap', 'sqcup', 'boxplus', 'boxminus', 'boxtimes', 'boxdot', 'leftthreetimes', 'rightthreetimes', 'curlyvee', 'curlywedge', 'dotplus', 'divideontimes', 'doublebarwedge']);
var $author$project$ETeX$KaTeX$binomials = _List_fromArray(
	['binom', 'dbinom', 'tbinom', 'brace', 'brack']);
var $author$project$ETeX$KaTeX$delimiters = _List_fromArray(
	['lbrace', 'rbrace', 'lbrack', 'rbrack', 'langle', 'rangle', 'vert', 'Vert', 'lvert', 'rvert', 'lVert', 'rVert', 'lfloor', 'rfloor', 'lceil', 'rceil', 'lgroup', 'rgroup', 'lmoustache', 'rmoustache', 'ulcorner', 'urcorner', 'llcorner', 'lrcorner']);
var $author$project$ETeX$KaTeX$fonts = _List_fromArray(
	['mathrm', 'mathit', 'mathbf', 'boldsymbol', 'pmb', 'mathbb', 'Bbb', 'mathcal', 'cal', 'mathscr', 'scr', 'mathfrak', 'frak', 'mathsf', 'sf', 'mathtt', 'tt', 'mathnormal', 'text', 'textbf', 'textit', 'textrm', 'textsf', 'texttt', 'textnormal', 'textup', 'operatorname', 'operatorname*']);
var $author$project$ETeX$KaTeX$fractions = _List_fromArray(
	['frac', 'dfrac', 'tfrac', 'cfrac', 'genfrac', 'over', 'atop', 'choose']);
var $elm$core$Set$Set_elm_builtin = function (a) {
	return {$: 'Set_elm_builtin', a: a};
};
var $elm$core$Set$empty = $elm$core$Set$Set_elm_builtin($elm$core$Dict$empty);
var $elm$core$Set$insert = F2(
	function (key, _v0) {
		var dict = _v0.a;
		return $elm$core$Set$Set_elm_builtin(
			A3($elm$core$Dict$insert, key, _Utils_Tuple0, dict));
	});
var $elm$core$Set$fromList = function (list) {
	return A3($elm$core$List$foldl, $elm$core$Set$insert, $elm$core$Set$empty, list);
};
var $author$project$ETeX$KaTeX$greekLetters = _List_fromArray(
	['alpha', 'beta', 'gamma', 'delta', 'epsilon', 'varepsilon', 'zeta', 'eta', 'theta', 'vartheta', 'iota', 'kappa', 'varkappa', 'lambda', 'mu', 'nu', 'xi', 'pi', 'varpi', 'rho', 'varrho', 'sigma', 'varsigma', 'tau', 'upsilon', 'phi', 'varphi', 'chi', 'psi', 'omega', 'Gamma', 'Delta', 'Theta', 'Lambda', 'Xi', 'Pi', 'Sigma', 'Upsilon', 'Phi', 'Psi', 'Omega', 'digamma', 'varGamma', 'varDelta', 'varTheta', 'varLambda', 'varXi', 'varPi', 'varSigma', 'varUpsilon', 'varPhi', 'varPsi', 'varOmega']);
var $author$project$ETeX$KaTeX$logicAndSetTheory = _List_fromArray(
	['forall', 'exists', 'nexists', 'complement', 'subset', 'supset', 'mid', 'nmid', 'notsubset', 'nsubset', 'nsupset', 'nsupseteq', 'nsubseteq', 'subsetneq', 'supsetneq', 'subsetneqq', 'supsetneqq', 'varsubsetneq', 'varsupsetneq', 'varsubsetneqq', 'varsupsetneqq', 'isin', 'notin', 'notni', 'niton', 'in', 'ni', 'emptyset', 'varnothing', 'setminus', 'smallsetminus', 'complement', 'neg', 'lnot']);
var $author$project$ETeX$KaTeX$mathFunctions = _List_fromArray(
	['sin', 'cos', 'tan', 'cot', 'sec', 'csc', 'sinh', 'cosh', 'tanh', 'coth', 'sech', 'csch', 'arcsin', 'arccos', 'arctan', 'arctg', 'arcctg', 'ln', 'log', 'lg', 'exp', 'deg', 'det', 'dim', 'hom', 'ker', 'lim', 'liminf', 'limsup', 'max', 'min', 'sup', 'inf', 'Pr', 'gcd', 'lcm', 'arg', 'mod', 'bmod', 'pmod', 'pod']);
var $author$project$ETeX$KaTeX$miscSymbols = _List_fromArray(
	['infty', 'aleph', 'beth', 'gimel', 'daleth', 'eth', 'hbar', 'hslash', 'Finv', 'Game', 'ell', 'wp', 'Re', 'Im', 'partial', 'nabla', 'Box', 'square', 'blacksquare', 'blacklozenge', 'lozenge', 'Diamond', 'triangle', 'triangledown', 'angle', 'measuredangle', 'sphericalangle', 'prime', 'backprime', 'degree', 'flat', 'natural', 'sharp', 'surd', 'top', 'bot', 'emptyset', 'varnothing', 'clubsuit', 'diamondsuit', 'heartsuit', 'spadesuit', 'blacktriangleright', 'blacktriangleleft', 'blacktriangledown', 'blacktriangle', 'bigstar', 'maltese', 'checkmark', 'diagup', 'diagdown', 'ddag', 'dag', 'copyright', 'circledR', 'pounds', 'yen', 'euro', 'cent', 'maltese']);
var $author$project$ETeX$KaTeX$relationSymbols = _List_fromArray(
	['leq', 'le', 'geq', 'ge', 'neq', 'ne', 'sim', 'simeq', 'approx', 'cong', 'equiv', 'prec', 'succ', 'preceq', 'succeq', 'll', 'gg', 'subset', 'supset', 'subseteq', 'supseteq', 'nsubseteq', 'nsupseteq', 'sqsubset', 'sqsupset', 'sqsubseteq', 'sqsupseteq', 'in', 'ni', 'notin', 'notni', 'propto', 'varpropto', 'perp', 'parallel', 'nparallel', 'smile', 'frown', 'doteq', 'fallingdotseq', 'risingdotseq', 'coloneq', 'eqcirc', 'circeq', 'triangleq', 'bumpeq', 'Bumpeq', 'doteqdot', 'thicksim', 'thickapprox', 'approxeq', 'backsim', 'backsimeq', 'preccurlyeq', 'succcurlyeq', 'curlyeqprec', 'curlyeqsucc', 'precsim', 'succsim', 'precapprox', 'succapprox', 'vartriangleleft', 'vartriangleright', 'trianglelefteq', 'trianglerighteq', 'between', 'pitchfork', 'shortmid', 'shortparallel', 'therefore', 'because', 'eqcolon', 'simcolon', 'approxcolon', 'colonapprox', 'colonsim', 'Colon', 'ratio']);
var $author$project$ETeX$KaTeX$roots = _List_fromArray(
	['sqrt', 'sqrtsign']);
var $author$project$ETeX$KaTeX$spacing = _List_fromArray(
	['quad', 'qquad', 'space', 'thinspace', 'medspace', 'thickspace', 'enspace', 'negspace', 'negmedspace', 'negthickspace', 'negthinspace', 'mkern', 'mskip', 'hskip', 'hspace', 'hspace*', 'kern', 'phantom', 'hphantom', 'vphantom', 'mathstrut', 'strut', '!', ':', ';', ',']);
var $author$project$ETeX$KaTeX$textOperators = _List_fromArray(
	['not', 'cancel', 'bcancel', 'xcancel', 'cancelto', 'sout', 'overline', 'underline', 'overset', 'underset', 'stackrel', 'atop', 'substack', 'sideset']);
var $author$project$ETeX$KaTeX$katexCommands = $elm$core$Set$fromList(
	$elm$core$List$concat(
		_List_fromArray(
			[$author$project$ETeX$KaTeX$greekLetters, $author$project$ETeX$KaTeX$binaryOperators, $author$project$ETeX$KaTeX$relationSymbols, $author$project$ETeX$KaTeX$arrows, $author$project$ETeX$KaTeX$delimiters, $author$project$ETeX$KaTeX$bigOperators, $author$project$ETeX$KaTeX$mathFunctions, $author$project$ETeX$KaTeX$accents, $author$project$ETeX$KaTeX$fonts, $author$project$ETeX$KaTeX$spacing, $author$project$ETeX$KaTeX$logicAndSetTheory, $author$project$ETeX$KaTeX$miscSymbols, $author$project$ETeX$KaTeX$fractions, $author$project$ETeX$KaTeX$binomials, $author$project$ETeX$KaTeX$roots, $author$project$ETeX$KaTeX$textOperators])));
var $elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return $elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _v1 = A2($elm$core$Basics$compare, targetKey, key);
				switch (_v1.$) {
					case 'LT':
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 'EQ':
						return $elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var $elm$core$Dict$member = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$get, key, dict);
		if (_v0.$ === 'Just') {
			return true;
		} else {
			return false;
		}
	});
var $elm$core$Set$member = F2(
	function (key, _v0) {
		var dict = _v0.a;
		return A2($elm$core$Dict$member, key, dict);
	});
var $author$project$ETeX$KaTeX$isKaTeX = function (command) {
	return A2($elm$core$Set$member, command, $author$project$ETeX$KaTeX$katexCommands);
};
var $author$project$Render$Export$LaTeXToScripta2$decoToString = F2(
	function (newMacroNames, deco) {
		if (deco.$ === 'DecoM') {
			var expr = deco.a;
			var content = A2($author$project$Render$Export$LaTeXToScripta2$mathExprToScripta, newMacroNames, expr);
			return A2($elm$core$String$startsWith, '\"', content) ? content : ((($elm$core$String$length(content) > 1) || A2($elm$core$String$contains, ' ', content)) ? ('{' + (content + '}')) : content);
		} else {
			var n = deco.a;
			var nStr = $elm$core$String$fromInt(n);
			return ($elm$core$String$length(nStr) > 1) ? ('{' + (nStr + '}')) : nStr;
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$mathExprToScripta = F2(
	function (newMacroNames, expr) {
		switch (expr.$) {
			case 'AlphaNum':
				var str = expr.a;
				return str;
			case 'MacroName':
				var str = expr.a;
				return $author$project$ETeX$KaTeX$isKaTeX(str) ? str : ('\\' + str);
			case 'FunctionName':
				var str = expr.a;
				return str;
			case 'Arg':
				var exprs = expr.a;
				return $author$project$Render$Export$LaTeXToScripta2$intelligentJoin(
					A2(
						$elm$core$List$map,
						$author$project$Render$Export$LaTeXToScripta2$mathExprToScripta(newMacroNames),
						exprs));
			case 'Param':
				var n = expr.a;
				return '#' + $elm$core$String$fromInt(n);
			case 'WS':
				return ' ';
			case 'MathSpace':
				return ' ';
			case 'MathSmallSpace':
				return ' ';
			case 'MathMediumSpace':
				return ' ';
			case 'LeftMathBrace':
				return '\\{';
			case 'RightMathBrace':
				return '\\}';
			case 'MathSymbols':
				var str = expr.a;
				return str;
			case 'Macro':
				var name = expr.a;
				var args = expr.b;
				if ($elm$core$List$isEmpty(args)) {
					return $author$project$ETeX$KaTeX$isKaTeX(name) ? name : ('\\' + name);
				} else {
					if (name === 'text') {
						if ((args.b && (args.a.$ === 'Arg')) && (!args.b.b)) {
							var content = args.a.a;
							return '\"' + (A2(
								$elm$core$String$join,
								'',
								A2(
									$elm$core$List$map,
									$author$project$Render$Export$LaTeXToScripta2$mathExprToScripta(newMacroNames),
									content)) + '\"');
						} else {
							return '\\' + (name + A2(
								$elm$core$String$join,
								'',
								A2(
									$elm$core$List$map,
									$author$project$Render$Export$LaTeXToScripta2$mathExprToScriptaArg(newMacroNames),
									args)));
						}
					} else {
						return ($author$project$ETeX$KaTeX$isKaTeX(name) || A2($elm$core$List$member, name, newMacroNames)) ? (name + ('(' + (A2(
							$elm$core$String$join,
							', ',
							A2(
								$elm$core$List$map,
								$author$project$Render$Export$LaTeXToScripta2$mathExprToScripta(newMacroNames),
								args)) + ')'))) : ('\\' + (name + A2(
							$elm$core$String$join,
							'',
							A2(
								$elm$core$List$map,
								A2(
									$elm$core$Basics$composeR,
									$author$project$Render$Export$LaTeXToScripta2$mathExprToScripta(newMacroNames),
									function (x) {
										return '{' + (x + '}');
									}),
								args))));
					}
				}
			case 'Expr':
				var exprs = expr.a;
				return A2(
					$elm$core$String$join,
					'',
					A2(
						$elm$core$List$map,
						$author$project$Render$Export$LaTeXToScripta2$mathExprToScripta(newMacroNames),
						exprs));
			case 'Comma':
				return ',';
			case 'LeftParen':
				return '(';
			case 'RightParen':
				return ')';
			case 'Sub':
				var deco = expr.a;
				return '_' + A2($author$project$Render$Export$LaTeXToScripta2$decoToString, newMacroNames, deco);
			default:
				var deco = expr.a;
				return '^' + A2($author$project$Render$Export$LaTeXToScripta2$decoToString, newMacroNames, deco);
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$mathExprToScriptaArg = F2(
	function (newMacroNames, expr) {
		if (expr.$ === 'Arg') {
			var exprs = expr.a;
			return '{' + (A2(
				$elm$core$String$join,
				'',
				A2(
					$elm$core$List$map,
					$author$project$Render$Export$LaTeXToScripta2$mathExprToScripta(newMacroNames),
					exprs)) + '}');
		} else {
			return A2($author$project$Render$Export$LaTeXToScripta2$mathExprToScripta, newMacroNames, expr);
		}
	});
var $author$project$ETeX$MathMacros$manyHelp = F2(
	function (p, vs) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					A2(
					$elm$parser$Parser$Advanced$keeper,
					$elm$parser$Parser$Advanced$succeed(
						function (v) {
							return $elm$parser$Parser$Advanced$Loop(
								A2($elm$core$List$cons, v, vs));
						}),
					p),
					A2(
					$elm$parser$Parser$Advanced$map,
					function (_v0) {
						return $elm$parser$Parser$Advanced$Done(
							$elm$core$List$reverse(vs));
					},
					$elm$parser$Parser$Advanced$succeed(_Utils_Tuple0))
				]));
	});
var $author$project$ETeX$MathMacros$many = function (p) {
	return A2(
		$elm$parser$Parser$Advanced$loop,
		_List_Nil,
		$author$project$ETeX$MathMacros$manyHelp(p));
};
var $author$project$ETeX$MathMacros$Arg = function (a) {
	return {$: 'Arg', a: a};
};
var $author$project$ETeX$MathMacros$DecoM = function (a) {
	return {$: 'DecoM', a: a};
};
var $author$project$ETeX$MathMacros$ExpectingBackslash = {$: 'ExpectingBackslash'};
var $author$project$ETeX$MathMacros$ExpectingCaret = {$: 'ExpectingCaret'};
var $author$project$ETeX$MathMacros$ExpectingLeftBrace = {$: 'ExpectingLeftBrace'};
var $author$project$ETeX$MathMacros$ExpectingLeftParen = {$: 'ExpectingLeftParen'};
var $author$project$ETeX$MathMacros$ExpectingRightBrace = {$: 'ExpectingRightBrace'};
var $author$project$ETeX$MathMacros$ExpectingRightParen = {$: 'ExpectingRightParen'};
var $author$project$ETeX$MathMacros$ExpectingUnderscore = {$: 'ExpectingUnderscore'};
var $author$project$ETeX$MathMacros$Macro = F2(
	function (a, b) {
		return {$: 'Macro', a: a, b: b};
	});
var $author$project$ETeX$MathMacros$Sub = function (a) {
	return {$: 'Sub', a: a};
};
var $author$project$ETeX$MathMacros$Super = function (a) {
	return {$: 'Super', a: a};
};
var $author$project$ETeX$MathMacros$AlphaNum = function (a) {
	return {$: 'AlphaNum', a: a};
};
var $author$project$ETeX$MathMacros$ExpectingAlpha = {$: 'ExpectingAlpha'};
var $author$project$ETeX$MathMacros$alphaNumParser_ = A2(
	$elm$parser$Parser$Advanced$keeper,
	A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			$elm$parser$Parser$Advanced$succeed($elm$core$String$slice),
			A2(
				$elm$parser$Parser$Advanced$ignorer,
				A2(
					$elm$parser$Parser$Advanced$ignorer,
					$elm$parser$Parser$Advanced$getOffset,
					A2($elm$parser$Parser$Advanced$chompIf, $elm$core$Char$isAlpha, $author$project$ETeX$MathMacros$ExpectingAlpha)),
				$elm$parser$Parser$Advanced$chompWhile($elm$core$Char$isAlphaNum))),
		$elm$parser$Parser$Advanced$getOffset),
	$elm$parser$Parser$Advanced$getSource);
var $author$project$ETeX$MathMacros$alphaNumParser = A2($elm$parser$Parser$Advanced$map, $author$project$ETeX$MathMacros$AlphaNum, $author$project$ETeX$MathMacros$alphaNumParser_);
var $author$project$ETeX$MathMacros$Comma = {$: 'Comma'};
var $author$project$ETeX$MathMacros$ExpectingComma = {$: 'ExpectingComma'};
var $author$project$ETeX$MathMacros$commaParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$MathMacros$Comma),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, ',', $author$project$ETeX$MathMacros$ExpectingComma)));
var $author$project$ETeX$MathMacros$MacroName = function (a) {
	return {$: 'MacroName', a: a};
};
var $author$project$ETeX$MathMacros$second = F2(
	function (p, q) {
		return A2(
			$elm$parser$Parser$Advanced$andThen,
			function (_v0) {
				return q;
			},
			p);
	});
var $author$project$ETeX$MathMacros$f0Parser = A2(
	$elm$parser$Parser$Advanced$map,
	$author$project$ETeX$MathMacros$MacroName,
	A2(
		$author$project$ETeX$MathMacros$second,
		$elm$parser$Parser$Advanced$symbol(
			A2($elm$parser$Parser$Advanced$Token, '\\', $author$project$ETeX$MathMacros$ExpectingBackslash)),
		$author$project$ETeX$MathMacros$alphaNumParser_));
var $elm$parser$Parser$Advanced$lazy = function (thunk) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			var _v0 = thunk(_Utils_Tuple0);
			var parse = _v0.a;
			return parse(s);
		});
};
var $author$project$ETeX$MathMacros$ExpectingLeftMathBrace = {$: 'ExpectingLeftMathBrace'};
var $author$project$ETeX$MathMacros$LeftMathBrace = {$: 'LeftMathBrace'};
var $author$project$ETeX$MathMacros$leftBraceParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$MathMacros$LeftMathBrace),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '\\{', $author$project$ETeX$MathMacros$ExpectingLeftMathBrace)));
var $author$project$ETeX$MathMacros$LeftParen = {$: 'LeftParen'};
var $author$project$ETeX$MathMacros$leftParenParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$MathMacros$LeftParen),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '(', $author$project$ETeX$MathMacros$ExpectingLeftParen)));
var $author$project$ETeX$MathMacros$ExpectingMathMediumSpace = {$: 'ExpectingMathMediumSpace'};
var $author$project$ETeX$MathMacros$MathMediumSpace = {$: 'MathMediumSpace'};
var $author$project$ETeX$MathMacros$mathMediumSpaceParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$MathMacros$MathMediumSpace),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '\\;', $author$project$ETeX$MathMacros$ExpectingMathMediumSpace)));
var $author$project$ETeX$MathMacros$ExpectingMathSmallSpace = {$: 'ExpectingMathSmallSpace'};
var $author$project$ETeX$MathMacros$MathSmallSpace = {$: 'MathSmallSpace'};
var $author$project$ETeX$MathMacros$mathSmallSpaceParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$MathMacros$MathSmallSpace),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '\\,', $author$project$ETeX$MathMacros$ExpectingMathSmallSpace)));
var $author$project$ETeX$MathMacros$ExpectingMathSpace = {$: 'ExpectingMathSpace'};
var $author$project$ETeX$MathMacros$MathSpace = {$: 'MathSpace'};
var $author$project$ETeX$MathMacros$mathSpaceParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$MathMacros$MathSpace),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '\\ ', $author$project$ETeX$MathMacros$ExpectingMathSpace)));
var $author$project$ETeX$MathMacros$ExpectingNotAlpha = {$: 'ExpectingNotAlpha'};
var $author$project$ETeX$MathMacros$MathSymbols = function (a) {
	return {$: 'MathSymbols', a: a};
};
var $author$project$ETeX$MathMacros$mathSymbolsParser = A2(
	$elm$parser$Parser$Advanced$map,
	$author$project$ETeX$MathMacros$MathSymbols,
	A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$keeper,
				$elm$parser$Parser$Advanced$succeed($elm$core$String$slice),
				A2(
					$elm$parser$Parser$Advanced$ignorer,
					A2(
						$elm$parser$Parser$Advanced$ignorer,
						$elm$parser$Parser$Advanced$getOffset,
						A2(
							$elm$parser$Parser$Advanced$chompIf,
							function (c) {
								return (!$elm$core$Char$isAlpha(c)) && (!A2(
									$elm$core$List$member,
									c,
									_List_fromArray(
										[
											_Utils_chr('_'),
											_Utils_chr('^'),
											_Utils_chr('#'),
											_Utils_chr('\\'),
											_Utils_chr('{'),
											_Utils_chr('}'),
											_Utils_chr('('),
											_Utils_chr(')'),
											_Utils_chr(',')
										])));
							},
							$author$project$ETeX$MathMacros$ExpectingNotAlpha)),
					$elm$parser$Parser$Advanced$chompWhile(
						function (c) {
							return (!$elm$core$Char$isAlpha(c)) && (!A2(
								$elm$core$List$member,
								c,
								_List_fromArray(
									[
										_Utils_chr('_'),
										_Utils_chr('^'),
										_Utils_chr('#'),
										_Utils_chr('\\'),
										_Utils_chr('{'),
										_Utils_chr('}'),
										_Utils_chr('('),
										_Utils_chr(')'),
										_Utils_chr(',')
									])));
						}))),
			$elm$parser$Parser$Advanced$getOffset),
		$elm$parser$Parser$Advanced$getSource));
var $author$project$ETeX$MathMacros$DecoI = function (a) {
	return {$: 'DecoI', a: a};
};
var $author$project$ETeX$MathMacros$ExpectingInt = {$: 'ExpectingInt'};
var $author$project$ETeX$MathMacros$InvalidNumber = {$: 'InvalidNumber'};
var $elm$parser$Parser$Advanced$consumeBase = _Parser_consumeBase;
var $elm$parser$Parser$Advanced$consumeBase16 = _Parser_consumeBase16;
var $elm$parser$Parser$Advanced$bumpOffset = F2(
	function (newOffset, s) {
		return {col: s.col + (newOffset - s.offset), context: s.context, indent: s.indent, offset: newOffset, row: s.row, src: s.src};
	});
var $elm$parser$Parser$Advanced$chompBase10 = _Parser_chompBase10;
var $elm$parser$Parser$Advanced$isAsciiCode = _Parser_isAsciiCode;
var $elm$parser$Parser$Advanced$consumeExp = F2(
	function (offset, src) {
		if (A3($elm$parser$Parser$Advanced$isAsciiCode, 101, offset, src) || A3($elm$parser$Parser$Advanced$isAsciiCode, 69, offset, src)) {
			var eOffset = offset + 1;
			var expOffset = (A3($elm$parser$Parser$Advanced$isAsciiCode, 43, eOffset, src) || A3($elm$parser$Parser$Advanced$isAsciiCode, 45, eOffset, src)) ? (eOffset + 1) : eOffset;
			var newOffset = A2($elm$parser$Parser$Advanced$chompBase10, expOffset, src);
			return _Utils_eq(expOffset, newOffset) ? (-newOffset) : newOffset;
		} else {
			return offset;
		}
	});
var $elm$parser$Parser$Advanced$consumeDotAndExp = F2(
	function (offset, src) {
		return A3($elm$parser$Parser$Advanced$isAsciiCode, 46, offset, src) ? A2(
			$elm$parser$Parser$Advanced$consumeExp,
			A2($elm$parser$Parser$Advanced$chompBase10, offset + 1, src),
			src) : A2($elm$parser$Parser$Advanced$consumeExp, offset, src);
	});
var $elm$parser$Parser$Advanced$finalizeInt = F5(
	function (invalid, handler, startOffset, _v0, s) {
		var endOffset = _v0.a;
		var n = _v0.b;
		if (handler.$ === 'Err') {
			var x = handler.a;
			return A2(
				$elm$parser$Parser$Advanced$Bad,
				true,
				A2($elm$parser$Parser$Advanced$fromState, s, x));
		} else {
			var toValue = handler.a;
			return _Utils_eq(startOffset, endOffset) ? A2(
				$elm$parser$Parser$Advanced$Bad,
				_Utils_cmp(s.offset, startOffset) < 0,
				A2($elm$parser$Parser$Advanced$fromState, s, invalid)) : A3(
				$elm$parser$Parser$Advanced$Good,
				true,
				toValue(n),
				A2($elm$parser$Parser$Advanced$bumpOffset, endOffset, s));
		}
	});
var $elm$core$String$toFloat = _String_toFloat;
var $elm$parser$Parser$Advanced$finalizeFloat = F6(
	function (invalid, expecting, intSettings, floatSettings, intPair, s) {
		var intOffset = intPair.a;
		var floatOffset = A2($elm$parser$Parser$Advanced$consumeDotAndExp, intOffset, s.src);
		if (floatOffset < 0) {
			return A2(
				$elm$parser$Parser$Advanced$Bad,
				true,
				A4($elm$parser$Parser$Advanced$fromInfo, s.row, s.col - (floatOffset + s.offset), invalid, s.context));
		} else {
			if (_Utils_eq(s.offset, floatOffset)) {
				return A2(
					$elm$parser$Parser$Advanced$Bad,
					false,
					A2($elm$parser$Parser$Advanced$fromState, s, expecting));
			} else {
				if (_Utils_eq(intOffset, floatOffset)) {
					return A5($elm$parser$Parser$Advanced$finalizeInt, invalid, intSettings, s.offset, intPair, s);
				} else {
					if (floatSettings.$ === 'Err') {
						var x = floatSettings.a;
						return A2(
							$elm$parser$Parser$Advanced$Bad,
							true,
							A2($elm$parser$Parser$Advanced$fromState, s, invalid));
					} else {
						var toValue = floatSettings.a;
						var _v1 = $elm$core$String$toFloat(
							A3($elm$core$String$slice, s.offset, floatOffset, s.src));
						if (_v1.$ === 'Nothing') {
							return A2(
								$elm$parser$Parser$Advanced$Bad,
								true,
								A2($elm$parser$Parser$Advanced$fromState, s, invalid));
						} else {
							var n = _v1.a;
							return A3(
								$elm$parser$Parser$Advanced$Good,
								true,
								toValue(n),
								A2($elm$parser$Parser$Advanced$bumpOffset, floatOffset, s));
						}
					}
				}
			}
		}
	});
var $elm$parser$Parser$Advanced$number = function (c) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			if (A3($elm$parser$Parser$Advanced$isAsciiCode, 48, s.offset, s.src)) {
				var zeroOffset = s.offset + 1;
				var baseOffset = zeroOffset + 1;
				return A3($elm$parser$Parser$Advanced$isAsciiCode, 120, zeroOffset, s.src) ? A5(
					$elm$parser$Parser$Advanced$finalizeInt,
					c.invalid,
					c.hex,
					baseOffset,
					A2($elm$parser$Parser$Advanced$consumeBase16, baseOffset, s.src),
					s) : (A3($elm$parser$Parser$Advanced$isAsciiCode, 111, zeroOffset, s.src) ? A5(
					$elm$parser$Parser$Advanced$finalizeInt,
					c.invalid,
					c.octal,
					baseOffset,
					A3($elm$parser$Parser$Advanced$consumeBase, 8, baseOffset, s.src),
					s) : (A3($elm$parser$Parser$Advanced$isAsciiCode, 98, zeroOffset, s.src) ? A5(
					$elm$parser$Parser$Advanced$finalizeInt,
					c.invalid,
					c.binary,
					baseOffset,
					A3($elm$parser$Parser$Advanced$consumeBase, 2, baseOffset, s.src),
					s) : A6(
					$elm$parser$Parser$Advanced$finalizeFloat,
					c.invalid,
					c.expecting,
					c._int,
					c._float,
					_Utils_Tuple2(zeroOffset, 0),
					s)));
			} else {
				return A6(
					$elm$parser$Parser$Advanced$finalizeFloat,
					c.invalid,
					c.expecting,
					c._int,
					c._float,
					A3($elm$parser$Parser$Advanced$consumeBase, 10, s.offset, s.src),
					s);
			}
		});
};
var $elm$parser$Parser$Advanced$int = F2(
	function (expecting, invalid) {
		return $elm$parser$Parser$Advanced$number(
			{
				binary: $elm$core$Result$Err(invalid),
				expecting: expecting,
				_float: $elm$core$Result$Err(invalid),
				hex: $elm$core$Result$Err(invalid),
				_int: $elm$core$Result$Ok($elm$core$Basics$identity),
				invalid: invalid,
				octal: $elm$core$Result$Err(invalid)
			});
	});
var $author$project$ETeX$MathMacros$numericDecoParser = A2(
	$elm$parser$Parser$Advanced$map,
	$author$project$ETeX$MathMacros$DecoI,
	A2($elm$parser$Parser$Advanced$int, $author$project$ETeX$MathMacros$ExpectingInt, $author$project$ETeX$MathMacros$InvalidNumber));
var $author$project$ETeX$MathMacros$ExpectingHash = {$: 'ExpectingHash'};
var $author$project$ETeX$MathMacros$Param = function (a) {
	return {$: 'Param', a: a};
};
var $author$project$ETeX$MathMacros$paramParser = A2(
	$elm$parser$Parser$Advanced$map,
	$author$project$ETeX$MathMacros$Param,
	A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$ignorer,
			$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
			$elm$parser$Parser$Advanced$symbol(
				A2($elm$parser$Parser$Advanced$Token, '#', $author$project$ETeX$MathMacros$ExpectingHash))),
		A2($elm$parser$Parser$Advanced$int, $author$project$ETeX$MathMacros$ExpectingInt, $author$project$ETeX$MathMacros$InvalidNumber)));
var $author$project$ETeX$MathMacros$ExpectingRightMathBrace = {$: 'ExpectingRightMathBrace'};
var $author$project$ETeX$MathMacros$RightMathBrace = {$: 'RightMathBrace'};
var $author$project$ETeX$MathMacros$rightBraceParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$MathMacros$RightMathBrace),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '\\}', $author$project$ETeX$MathMacros$ExpectingRightMathBrace)));
var $author$project$ETeX$MathMacros$RightParen = {$: 'RightParen'};
var $author$project$ETeX$MathMacros$rightParenParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$MathMacros$RightParen),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, ')', $author$project$ETeX$MathMacros$ExpectingRightParen)));
var $author$project$ETeX$MathMacros$ExpectingSpace = {$: 'ExpectingSpace'};
var $author$project$ETeX$MathMacros$WS = {$: 'WS'};
var $author$project$ETeX$MathMacros$whitespaceParser = A2(
	$elm$parser$Parser$Advanced$map,
	function (_v0) {
		return $author$project$ETeX$MathMacros$WS;
	},
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, ' ', $author$project$ETeX$MathMacros$ExpectingSpace)));
function $author$project$ETeX$MathMacros$cyclic$mathExprParser() {
	return $elm$parser$Parser$Advanced$oneOf(
		_List_fromArray(
			[
				$author$project$ETeX$MathMacros$mathMediumSpaceParser,
				$author$project$ETeX$MathMacros$mathSmallSpaceParser,
				$author$project$ETeX$MathMacros$mathSpaceParser,
				$author$project$ETeX$MathMacros$leftBraceParser,
				$author$project$ETeX$MathMacros$rightBraceParser,
				$author$project$ETeX$MathMacros$leftParenParser,
				$author$project$ETeX$MathMacros$rightParenParser,
				$author$project$ETeX$MathMacros$commaParser,
				$author$project$ETeX$MathMacros$cyclic$macroParser(),
				$author$project$ETeX$MathMacros$mathSymbolsParser,
				$elm$parser$Parser$Advanced$lazy(
				function (_v3) {
					return $author$project$ETeX$MathMacros$cyclic$argParser();
				}),
				$elm$parser$Parser$Advanced$lazy(
				function (_v4) {
					return $author$project$ETeX$MathMacros$cyclic$parenthesizedGroupParser();
				}),
				$author$project$ETeX$MathMacros$paramParser,
				$author$project$ETeX$MathMacros$whitespaceParser,
				$author$project$ETeX$MathMacros$alphaNumParser,
				$author$project$ETeX$MathMacros$f0Parser,
				$author$project$ETeX$MathMacros$cyclic$subscriptParser(),
				$author$project$ETeX$MathMacros$cyclic$superscriptParser()
			]));
}
function $author$project$ETeX$MathMacros$cyclic$macroParser() {
	return A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$ignorer,
				$elm$parser$Parser$Advanced$succeed($author$project$ETeX$MathMacros$Macro),
				$elm$parser$Parser$Advanced$symbol(
					A2($elm$parser$Parser$Advanced$Token, '\\', $author$project$ETeX$MathMacros$ExpectingBackslash))),
			$author$project$ETeX$MathMacros$alphaNumParser_),
		$author$project$ETeX$MathMacros$many(
			$author$project$ETeX$MathMacros$cyclic$argParser()));
}
function $author$project$ETeX$MathMacros$cyclic$argParser() {
	return A2(
		$elm$parser$Parser$Advanced$map,
		$author$project$ETeX$MathMacros$Arg,
		A2(
			$elm$parser$Parser$Advanced$ignorer,
			A2(
				$elm$parser$Parser$Advanced$keeper,
				A2(
					$elm$parser$Parser$Advanced$ignorer,
					$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
					$elm$parser$Parser$Advanced$symbol(
						A2($elm$parser$Parser$Advanced$Token, '{', $author$project$ETeX$MathMacros$ExpectingLeftBrace))),
				$elm$parser$Parser$Advanced$lazy(
					function (_v2) {
						return $author$project$ETeX$MathMacros$many(
							$author$project$ETeX$MathMacros$cyclic$mathExprParser());
					})),
			$elm$parser$Parser$Advanced$symbol(
				A2($elm$parser$Parser$Advanced$Token, '}', $author$project$ETeX$MathMacros$ExpectingRightBrace))));
}
function $author$project$ETeX$MathMacros$cyclic$superscriptParser() {
	return A2(
		$elm$parser$Parser$Advanced$map,
		$author$project$ETeX$MathMacros$Super,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$ignorer,
				$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
				$elm$parser$Parser$Advanced$symbol(
					A2($elm$parser$Parser$Advanced$Token, '^', $author$project$ETeX$MathMacros$ExpectingCaret))),
			$author$project$ETeX$MathMacros$cyclic$decoParser()));
}
function $author$project$ETeX$MathMacros$cyclic$subscriptParser() {
	return A2(
		$elm$parser$Parser$Advanced$map,
		$author$project$ETeX$MathMacros$Sub,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$ignorer,
				$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
				$elm$parser$Parser$Advanced$symbol(
					A2($elm$parser$Parser$Advanced$Token, '_', $author$project$ETeX$MathMacros$ExpectingUnderscore))),
			$author$project$ETeX$MathMacros$cyclic$decoParser()));
}
function $author$project$ETeX$MathMacros$cyclic$decoParser() {
	return $elm$parser$Parser$Advanced$oneOf(
		_List_fromArray(
			[
				$author$project$ETeX$MathMacros$numericDecoParser,
				A2(
				$elm$parser$Parser$Advanced$map,
				$author$project$ETeX$MathMacros$DecoM,
				$elm$parser$Parser$Advanced$lazy(
					function (_v1) {
						return $author$project$ETeX$MathMacros$cyclic$mathExprParser();
					}))
			]));
}
function $author$project$ETeX$MathMacros$cyclic$parenthesizedGroupParser() {
	return A2(
		$elm$parser$Parser$Advanced$map,
		$author$project$ETeX$MathMacros$Arg,
		A2(
			$elm$parser$Parser$Advanced$ignorer,
			A2(
				$elm$parser$Parser$Advanced$keeper,
				A2(
					$elm$parser$Parser$Advanced$ignorer,
					$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
					$elm$parser$Parser$Advanced$symbol(
						A2($elm$parser$Parser$Advanced$Token, '(', $author$project$ETeX$MathMacros$ExpectingLeftParen))),
				$elm$parser$Parser$Advanced$lazy(
					function (_v0) {
						return $author$project$ETeX$MathMacros$many(
							$author$project$ETeX$MathMacros$cyclic$mathExprParser());
					})),
			$elm$parser$Parser$Advanced$symbol(
				A2($elm$parser$Parser$Advanced$Token, ')', $author$project$ETeX$MathMacros$ExpectingRightParen))));
}
try {
	var $author$project$ETeX$MathMacros$mathExprParser = $author$project$ETeX$MathMacros$cyclic$mathExprParser();
	$author$project$ETeX$MathMacros$cyclic$mathExprParser = function () {
		return $author$project$ETeX$MathMacros$mathExprParser;
	};
	var $author$project$ETeX$MathMacros$macroParser = $author$project$ETeX$MathMacros$cyclic$macroParser();
	$author$project$ETeX$MathMacros$cyclic$macroParser = function () {
		return $author$project$ETeX$MathMacros$macroParser;
	};
	var $author$project$ETeX$MathMacros$argParser = $author$project$ETeX$MathMacros$cyclic$argParser();
	$author$project$ETeX$MathMacros$cyclic$argParser = function () {
		return $author$project$ETeX$MathMacros$argParser;
	};
	var $author$project$ETeX$MathMacros$superscriptParser = $author$project$ETeX$MathMacros$cyclic$superscriptParser();
	$author$project$ETeX$MathMacros$cyclic$superscriptParser = function () {
		return $author$project$ETeX$MathMacros$superscriptParser;
	};
	var $author$project$ETeX$MathMacros$subscriptParser = $author$project$ETeX$MathMacros$cyclic$subscriptParser();
	$author$project$ETeX$MathMacros$cyclic$subscriptParser = function () {
		return $author$project$ETeX$MathMacros$subscriptParser;
	};
	var $author$project$ETeX$MathMacros$decoParser = $author$project$ETeX$MathMacros$cyclic$decoParser();
	$author$project$ETeX$MathMacros$cyclic$decoParser = function () {
		return $author$project$ETeX$MathMacros$decoParser;
	};
	var $author$project$ETeX$MathMacros$parenthesizedGroupParser = $author$project$ETeX$MathMacros$cyclic$parenthesizedGroupParser();
	$author$project$ETeX$MathMacros$cyclic$parenthesizedGroupParser = function () {
		return $author$project$ETeX$MathMacros$parenthesizedGroupParser;
	};
} catch ($) {
	throw 'Some top-level definitions from `ETeX.MathMacros` are causing infinite recursion:\n\n  ┌─────┐\n  │    mathExprParser\n  │     ↓\n  │    macroParser\n  │     ↓\n  │    argParser\n  │     ↓\n  │    superscriptParser\n  │     ↓\n  │    subscriptParser\n  │     ↓\n  │    decoParser\n  │     ↓\n  │    parenthesizedGroupParser\n  └─────┘\n\nThese errors are very tricky, so read https://elm-lang.org/0.19.1/bad-recursion to learn how to fix it!';}
var $author$project$ETeX$MathMacros$parse = function (str) {
	return A2(
		$elm$parser$Parser$Advanced$run,
		$author$project$ETeX$MathMacros$many($author$project$ETeX$MathMacros$mathExprParser),
		str);
};
var $author$project$Render$Export$LaTeXToScripta2$convertLatexMathToScripta = F2(
	function (newMacroNames, latexMath) {
		var _v0 = $author$project$ETeX$MathMacros$parse(latexMath);
		if (_v0.$ === 'Ok') {
			var exprs = _v0.a;
			return $author$project$Render$Export$LaTeXToScripta2$intelligentJoin(
				A2(
					$elm$core$List$map,
					$author$project$Render$Export$LaTeXToScripta2$mathExprToScripta(newMacroNames),
					exprs));
		} else {
			return latexMath;
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$renderVerbatimFunction = F3(
	function (newMacroNames, name, content) {
		switch (name) {
			case 'math':
				return '$' + (A2($author$project$Render$Export$LaTeXToScripta2$convertLatexMathToScripta, newMacroNames, content) + '$');
			case 'code':
				return '`' + (content + '`');
			default:
				return '[' + (name + (' ' + (content + ']')));
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$renderArgs = F2(
	function (newMacroNames, args) {
		return A2(
			$elm$core$String$join,
			' ',
			A2(
				$elm$core$List$map,
				$author$project$Render$Export$LaTeXToScripta2$renderExpression(newMacroNames),
				args));
	});
var $author$project$Render$Export$LaTeXToScripta2$renderExpression = F2(
	function (newMacroNames, expr) {
		switch (expr.$) {
			case 'Text':
				var str = expr.a;
				return str;
			case 'Fun':
				var name = expr.a;
				var args = expr.b;
				return A3($author$project$Render$Export$LaTeXToScripta2$renderFunction, newMacroNames, name, args);
			case 'VFun':
				var name = expr.a;
				var arg = expr.b;
				return A3($author$project$Render$Export$LaTeXToScripta2$renderVerbatimFunction, newMacroNames, name, arg);
			default:
				var exprs = expr.a;
				return A2(
					$elm$core$String$join,
					' ',
					A2(
						$elm$core$List$map,
						$author$project$Render$Export$LaTeXToScripta2$renderExpression(newMacroNames),
						exprs));
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$renderFunction = F3(
	function (newMacroNames, name, args) {
		switch (name) {
			case 'text':
				return '\"' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + '\"');
			case 'bold':
				return '[b ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + ']');
			case 'textbf':
				return '[b ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + ']');
			case 'italic':
				return '[i ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + ']');
			case 'emph':
				return '[i ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + ']');
			case 'underline':
				return '[u ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + ']');
			case 'footnote':
				return '[footnote ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + ']');
			case 'cite':
				return '[cite ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + ']');
			case 'compactItem':
				return '- ' + A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args);
			case 'ref':
				return '[ref ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + ']');
			case 'label':
				return '[label ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + ']');
			case 'href':
				if (args.b) {
					if (args.b.b) {
						var first = args.a;
						var _v2 = args.b;
						var second = _v2.a;
						return '[link ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderExpression, newMacroNames, second) + (' ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderExpression, newMacroNames, first) + ']')));
					} else {
						var single = args.a;
						return '[link ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderExpression, newMacroNames, single) + ']');
					}
				} else {
					return '[link]';
				}
			case 'includegraphics':
				if (args.b) {
					var path = args.a;
					return '[image ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderExpression, newMacroNames, path) + ']');
				} else {
					return '[image]';
				}
			case 'imagecentercaptioned':
				if (args.b) {
					if (args.b.b) {
						if (args.b.b.b) {
							var caption = args.a;
							var _v5 = args.b;
							var width = _v5.a;
							var _v6 = _v5.b;
							var url = _v6.a;
							var _v7 = width;
							return '| image caption:' + (A2($author$project$Render$Export$LaTeXToScripta2$renderExpression, newMacroNames, caption) + ('\n' + A2($author$project$Render$Export$LaTeXToScripta2$renderExpression, newMacroNames, url)));
						} else {
							var caption = args.a;
							var _v8 = args.b;
							var url = _v8.a;
							return '| image caption:' + (A2($author$project$Render$Export$LaTeXToScripta2$renderExpression, newMacroNames, caption) + ('\n' + A2($author$project$Render$Export$LaTeXToScripta2$renderExpression, newMacroNames, url)));
						}
					} else {
						var url = args.a;
						return '| image\n' + A2($author$project$Render$Export$LaTeXToScripta2$renderExpression, newMacroNames, url);
					}
				} else {
					return '| image';
				}
			default:
				return '[' + (name + (' ' + (A2($author$project$Render$Export$LaTeXToScripta2$renderArgs, newMacroNames, args) + ']')));
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$renderEnvironment = F3(
	function (newMacroNames, envName, block) {
		var content = function () {
			var _v0 = block.body;
			if (_v0.$ === 'Left') {
				var str = _v0.a;
				return $elm$core$String$trim(str);
			} else {
				var exprs = _v0.a;
				return A2(
					$elm$core$String$join,
					' ',
					A2(
						$elm$core$List$map,
						$author$project$Render$Export$LaTeXToScripta2$renderExpression(newMacroNames),
						exprs));
			}
		}();
		return '| ' + (envName + ('\n' + content));
	});
var $author$project$Render$Export$LaTeXToScripta2$renderFigure = function (block) {
	var caption = function () {
		var _v0 = block.args;
		if (!_v0.b) {
			return '';
		} else {
			var arg = _v0.a;
			return '\nCaption: ' + arg;
		}
	}();
	return '| figure' + caption;
};
var $author$project$Render$Export$LaTeXToScripta2$renderItem = F2(
	function (newMacroNames, block) {
		var isEnumerate = A2($elm$core$String$contains, '\\begin{enumerate}', block.meta.sourceText) || A2($elm$core$String$contains, 'enumerate', block.firstLine);
		var prefix = isEnumerate ? '. ' : '- ';
		var extractFromFirstLine = function () {
			var line = block.firstLine;
			return (A2($elm$core$String$contains, '\\item', line) && A2($elm$core$String$contains, '{', line)) ? $elm$core$String$trim(
				A2(
					$elm$core$Maybe$withDefault,
					'',
					$elm$core$List$head(
						A2(
							$elm$core$String$split,
							'}',
							function (s) {
								return A2($elm$core$String$startsWith, '{', s) ? A2($elm$core$String$dropLeft, 1, s) : s;
							}(
								$elm$core$String$trim(
									A3($elm$core$String$replace, '\\item', '', line))))))) : '';
		}();
		var content = function () {
			if (!$elm$core$String$isEmpty(extractFromFirstLine)) {
				return extractFromFirstLine;
			} else {
				if (!$elm$core$List$isEmpty(block.args)) {
					var _v0 = block.args;
					if (_v0.b) {
						var arg = _v0.a;
						return arg;
					} else {
						return '';
					}
				} else {
					var _v1 = block.body;
					if (_v1.$ === 'Left') {
						var str = _v1.a;
						return $elm$core$String$trim(str);
					} else {
						var exprs = _v1.a;
						return $elm$core$String$trim(
							A2(
								$elm$core$String$join,
								' ',
								A2(
									$elm$core$List$map,
									$author$project$Render$Export$LaTeXToScripta2$renderExpression(newMacroNames),
									A2(
										$elm$core$List$filter,
										function (expr) {
											_v2$2:
											while (true) {
												if (expr.$ === 'Fun') {
													switch (expr.a) {
														case 'errorHighlight':
															return false;
														case 'blue':
															return false;
														default:
															break _v2$2;
													}
												} else {
													break _v2$2;
												}
											}
											return true;
										},
										exprs))));
					}
				}
			}
		}();
		return _Utils_ap(prefix, content);
	});
var $author$project$Render$Export$LaTeXToScripta2$renderNoteLike = F3(
	function (newMacroNames, envName, block) {
		var content = function () {
			var _v0 = block.body;
			if (_v0.$ === 'Left') {
				var str = _v0.a;
				return $elm$core$String$trim(str);
			} else {
				var exprs = _v0.a;
				return A2(
					$elm$core$String$join,
					' ',
					A2(
						$elm$core$List$map,
						$author$project$Render$Export$LaTeXToScripta2$renderExpression(newMacroNames),
						exprs));
			}
		}();
		return '| ' + (envName + ('\n' + content));
	});
var $elm$core$Bitwise$shiftRightBy = _Bitwise_shiftRightBy;
var $elm$core$String$repeatHelp = F3(
	function (n, chunk, result) {
		return (n <= 0) ? result : A3(
			$elm$core$String$repeatHelp,
			n >> 1,
			_Utils_ap(chunk, chunk),
			(!(n & 1)) ? result : _Utils_ap(result, chunk));
	});
var $elm$core$String$repeat = F2(
	function (n, chunk) {
		return A3($elm$core$String$repeatHelp, n, chunk, '');
	});
var $author$project$Render$Export$LaTeXToScripta2$renderSection = F2(
	function (level, block) {
		var title = function () {
			var _v0 = block.body;
			if (_v0.$ === 'Right') {
				var exprs = _v0.a;
				if (exprs.b && (exprs.a.$ === 'Text')) {
					var _v2 = exprs.a;
					var titleText = _v2.a;
					return titleText;
				} else {
					var _v3 = block.args;
					if (_v3.b) {
						var arg = _v3.a;
						return arg;
					} else {
						return 'Section';
					}
				}
			} else {
				var str = _v0.a;
				return str;
			}
		}();
		var marker = A2($elm$core$String$repeat, level, '#');
		return marker + (' ' + title);
	});
var $author$project$Render$Export$LaTeXToScripta2$renderSectionWithLevel = function (block) {
	var level = A2($elm$core$String$contains, '\\subsection', block.firstLine) ? 2 : (A2($elm$core$String$contains, '\\subsubsection', block.firstLine) ? 3 : 1);
	return A2($author$project$Render$Export$LaTeXToScripta2$renderSection, level, block);
};
var $author$project$Render$Export$LaTeXToScripta2$renderTable = function (block) {
	var _v0 = block.body;
	if (_v0.$ === 'Left') {
		var str = _v0.a;
		return '| table\n' + $elm$core$String$trim(str);
	} else {
		return '| table';
	}
};
var $author$project$Render$Export$LaTeXToScripta2$renderTheoremLike = F3(
	function (newMacroNames, envName, block) {
		var title = function () {
			var _v1 = block.args;
			if (!_v1.b) {
				return '';
			} else {
				var arg = _v1.a;
				return ' ' + arg;
			}
		}();
		var content = function () {
			var _v0 = block.body;
			if (_v0.$ === 'Left') {
				var str = _v0.a;
				return $elm$core$String$trim(str);
			} else {
				var exprs = _v0.a;
				return A2(
					$elm$core$String$join,
					' ',
					A2(
						$elm$core$List$map,
						$author$project$Render$Export$LaTeXToScripta2$renderExpression(newMacroNames),
						exprs));
			}
		}();
		return '| ' + (envName + (title + ('\n' + content)));
	});
var $author$project$Render$Export$LaTeXToScripta2$renderOrdinary = F3(
	function (newMacroNames, name, block) {
		switch (name) {
			case 'section':
				return $author$project$Render$Export$LaTeXToScripta2$renderSectionWithLevel(block);
			case 'subsection':
				return A2($author$project$Render$Export$LaTeXToScripta2$renderSection, 2, block);
			case 'subsubsection':
				return A2($author$project$Render$Export$LaTeXToScripta2$renderSection, 3, block);
			case 'itemize':
				return '';
			case 'enumerate':
				return '';
			case 'item':
				return A2($author$project$Render$Export$LaTeXToScripta2$renderItem, newMacroNames, block);
			case 'theorem':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderTheoremLike, newMacroNames, 'theorem', block);
			case 'lemma':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderTheoremLike, newMacroNames, 'lemma', block);
			case 'proposition':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderTheoremLike, newMacroNames, 'proposition', block);
			case 'corollary':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderTheoremLike, newMacroNames, 'corollary', block);
			case 'definition':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderTheoremLike, newMacroNames, 'definition', block);
			case 'example':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderNoteLike, newMacroNames, 'example', block);
			case 'remark':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderNoteLike, newMacroNames, 'remark', block);
			case 'note':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderNoteLike, newMacroNames, 'note', block);
			case 'abstract':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderEnvironment, newMacroNames, 'abstract', block);
			case 'quote':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderEnvironment, newMacroNames, 'quote', block);
			case 'center':
				return A3($author$project$Render$Export$LaTeXToScripta2$renderEnvironment, newMacroNames, 'center', block);
			case 'figure':
				return $author$project$Render$Export$LaTeXToScripta2$renderFigure(block);
			case 'table':
				return $author$project$Render$Export$LaTeXToScripta2$renderTable(block);
			default:
				return '| ' + name;
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$renderParagraph = F2(
	function (newMacroNames, block) {
		var _v0 = block.body;
		if (_v0.$ === 'Left') {
			var str = _v0.a;
			return $elm$core$String$trim(str);
		} else {
			var exprs = _v0.a;
			return $elm$core$String$trim(
				A2(
					$elm$core$String$join,
					' ',
					A2(
						$elm$core$List$map,
						$author$project$Render$Export$LaTeXToScripta2$renderExpression(newMacroNames),
						exprs)));
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$renderAlignedBlock = F2(
	function (newMacroNames, block) {
		var content = function () {
			var _v0 = block.body;
			if (_v0.$ === 'Left') {
				var str = _v0.a;
				return $elm$core$String$trim(str);
			} else {
				var _v1 = block.args;
				if (!_v1.b) {
					var sourceLines = $elm$core$String$lines(block.meta.sourceText);
					var extractContent = function (lines) {
						return $elm$core$String$trim(
							A2(
								$elm$core$String$join,
								'\n',
								A2(
									$elm$core$List$filter,
									function (line) {
										return (!A2($elm$core$String$contains, '\\begin{align}', line)) && (!A2($elm$core$String$contains, '\\end{align}', line));
									},
									lines)));
					};
					return extractContent(sourceLines);
				} else {
					var args = _v1;
					return A2($elm$core$String$join, '\n', args);
				}
			}
		}();
		return $elm$core$String$isEmpty(content) ? '| aligned' : ('| aligned\n' + A2($author$project$Render$Export$LaTeXToScripta2$convertLatexMathToScripta, newMacroNames, content));
	});
var $author$project$Render$Export$LaTeXToScripta2$renderCodeBlock = function (block) {
	var _v0 = block.body;
	if (_v0.$ === 'Left') {
		var str = _v0.a;
		return '| code\n' + str;
	} else {
		return 'Error: Invalid code block';
	}
};
var $author$project$Render$Export$LaTeXToScripta2$renderEquationBlock = F2(
	function (newMacroNames, block) {
		var _v0 = block.body;
		if (_v0.$ === 'Left') {
			var str = _v0.a;
			return '| equation\n' + A2($author$project$Render$Export$LaTeXToScripta2$convertLatexMathToScripta, newMacroNames, str);
		} else {
			return 'Error: Invalid equation block';
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$renderFigureVerbatim = function (block) {
	var _v0 = block.body;
	if (_v0.$ === 'Left') {
		var str = _v0.a;
		var lines = $elm$core$String$lines(str);
		var extractImageUrl = function (line) {
			return A2($elm$core$String$contains, '\\includegraphics', line) ? A2(
				$elm$core$Maybe$withDefault,
				'',
				$elm$core$List$head(
					A2(
						$elm$core$String$split,
						'}',
						A2(
							$elm$core$Maybe$withDefault,
							'',
							$elm$core$List$head(
								A2(
									$elm$core$List$drop,
									1,
									A2($elm$core$String$split, '{', line))))))) : '';
		};
		var imageUrl = A2(
			$elm$core$Maybe$withDefault,
			'',
			$elm$core$List$head(
				A2(
					$elm$core$List$filter,
					$elm$core$Basics$neq(''),
					A2($elm$core$List$map, extractImageUrl, lines))));
		var extractCaption = function (lines_) {
			return A2(
				$elm$core$Maybe$withDefault,
				'',
				A2(
					$elm$core$Maybe$map,
					function (line) {
						return A2(
							$elm$core$Maybe$withDefault,
							'',
							$elm$core$List$head(
								A2(
									$elm$core$String$split,
									'}',
									A2(
										$elm$core$String$join,
										'',
										A2(
											$elm$core$List$drop,
											1,
											A2($elm$core$String$split, '\\caption{', line))))));
					},
					$elm$core$List$head(
						A2(
							$elm$core$List$filter,
							$elm$core$String$contains('\\caption'),
							lines_))));
		};
		var caption = extractCaption(lines);
		return $elm$core$String$isEmpty(imageUrl) ? '| figure' : ($elm$core$String$isEmpty(caption) ? ('| image\n' + imageUrl) : ('| image caption:' + (caption + ('\n' + imageUrl))));
	} else {
		return '| figure';
	}
};
var $author$project$Render$Export$LaTeXToScripta2$renderMathBlock = F2(
	function (newMacroNames, block) {
		var _v0 = block.body;
		if (_v0.$ === 'Left') {
			var str = _v0.a;
			return '| math\n' + A2($author$project$Render$Export$LaTeXToScripta2$convertLatexMathToScripta, newMacroNames, str);
		} else {
			return '| math';
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$renderVerbatimBlock = function (block) {
	var _v0 = block.body;
	if (_v0.$ === 'Left') {
		var str = _v0.a;
		return '| verbatim\n' + str;
	} else {
		return '| verbatim';
	}
};
var $author$project$Render$Export$LaTeXToScripta2$renderVerbatim = F3(
	function (newMacroNames, name, block) {
		switch (name) {
			case 'math':
				return A2($author$project$Render$Export$LaTeXToScripta2$renderMathBlock, newMacroNames, block);
			case 'equation':
				return A2($author$project$Render$Export$LaTeXToScripta2$renderEquationBlock, newMacroNames, block);
			case 'align':
				return A2($author$project$Render$Export$LaTeXToScripta2$renderAlignedBlock, newMacroNames, block);
			case 'code':
				return $author$project$Render$Export$LaTeXToScripta2$renderCodeBlock(block);
			case 'verbatim':
				return $author$project$Render$Export$LaTeXToScripta2$renderVerbatimBlock(block);
			case 'lstlisting':
				return $author$project$Render$Export$LaTeXToScripta2$renderCodeBlock(block);
			case 'minted':
				return $author$project$Render$Export$LaTeXToScripta2$renderCodeBlock(block);
			case 'figure':
				return $author$project$Render$Export$LaTeXToScripta2$renderFigureVerbatim(block);
			default:
				return '| ' + name;
		}
	});
var $author$project$Render$Export$LaTeXToScripta2$renderBlock = F2(
	function (newMacroNames, block) {
		var _v0 = block.heading;
		switch (_v0.$) {
			case 'Paragraph':
				return A2($author$project$Render$Export$LaTeXToScripta2$renderParagraph, newMacroNames, block);
			case 'Ordinary':
				var name = _v0.a;
				return A3($author$project$Render$Export$LaTeXToScripta2$renderOrdinary, newMacroNames, name, block);
			default:
				var name = _v0.a;
				return A3($author$project$Render$Export$LaTeXToScripta2$renderVerbatim, newMacroNames, name, block);
		}
	});
var $maca$elm_rose_tree$RoseTree$Tree$value = function (_v0) {
	var a = _v0.a;
	return a;
};
var $author$project$Render$Export$LaTeXToScripta2$renderTree = F3(
	function (newMacroNames, indent, tree) {
		var indentStr = A2($elm$core$String$repeat, indent * 2, ' ');
		var currentBlock = $maca$elm_rose_tree$RoseTree$Tree$value(tree);
		var currentRendered = _Utils_ap(
			indentStr,
			A2($author$project$Render$Export$LaTeXToScripta2$renderBlock, newMacroNames, currentBlock));
		var children = $maca$elm_rose_tree$RoseTree$Tree$children(tree);
		var childrenRendered = function () {
			if (!children.b) {
				return '';
			} else {
				return function (s) {
					return '\n' + s;
				}(
					A2(
						$elm$core$String$join,
						'\n',
						A2(
							$elm$core$List$map,
							A2($author$project$Render$Export$LaTeXToScripta2$renderTree, newMacroNames, indent + 1),
							children)));
			}
		}();
		return _Utils_ap(currentRendered, childrenRendered);
	});
var $author$project$Render$Export$LaTeXToScripta2$renderS = F2(
	function (newMacroNames, forest) {
		return A2(
			$elm$core$String$join,
			'\n\n',
			A2(
				$elm$core$List$map,
				A2($author$project$Render$Export$LaTeXToScripta2$renderTree, newMacroNames, 0),
				forest));
	});
var $elm$virtual_dom$VirtualDom$style = _VirtualDom_style;
var $elm$html$Html$Attributes$style = $elm$virtual_dom$VirtualDom$style;
var $elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var $elm$html$Html$text = $elm$virtual_dom$VirtualDom$text;
var $elm$core$Debug$toString = _Debug_toString;
var $author$project$Main$view = function (model) {
	var input = '\\item{It provides a natural emergence of classical behavior from quantum mechanics}\n\n\\item{The measurement problem is partially resolved - definite outcomes emerge through environmental interaction}\n\n\\item{It explains why certain observables (like position) appear classical while others remain quantum}';
	var forest = $author$project$Render$Export$LaTeXToScripta2$parseL(input);
	var forestStr = $elm$core$Debug$toString(forest);
	var output = A2($author$project$Render$Export$LaTeXToScripta2$renderS, _List_Nil, forest);
	return A2(
		$elm$html$Html$div,
		_List_fromArray(
			[
				A2($elm$html$Html$Attributes$style, 'padding', '20px'),
				A2($elm$html$Html$Attributes$style, 'font-family', 'monospace'),
				A2($elm$html$Html$Attributes$style, 'white-space', 'pre-wrap')
			]),
		_List_fromArray(
			[
				A2(
				$elm$html$Html$h2,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('LaTeX to Scripta Item Debug')
					])),
				A2(
				$elm$html$Html$div,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$h2,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('Input:')
							])),
						A2(
						$elm$html$Html$pre,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text(input)
							]))
					])),
				A2(
				$elm$html$Html$div,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$h2,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('Parsed AST:')
							])),
						A2(
						$elm$html$Html$pre,
						_List_fromArray(
							[
								A2($elm$html$Html$Attributes$style, 'font-size', '10px')
							]),
						_List_fromArray(
							[
								$elm$html$Html$text(forestStr)
							]))
					])),
				A2(
				$elm$html$Html$div,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						$elm$html$Html$h2,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text('Output:')
							])),
						A2(
						$elm$html$Html$pre,
						_List_Nil,
						_List_fromArray(
							[
								$elm$html$Html$text(output)
							]))
					]))
			]));
};
var $author$project$Main$main = $elm$browser$Browser$sandbox(
	{init: $author$project$Main$init, update: $author$project$Main$update, view: $author$project$Main$view});
_Platform_export({'Main':{'init':$author$project$Main$main(
	$elm$json$Json$Decode$succeed(_Utils_Tuple0))(0)}});}(this));