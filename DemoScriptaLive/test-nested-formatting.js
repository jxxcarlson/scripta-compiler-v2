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


// CREATE

var _Regex_never = /.^/;

var _Regex_fromStringWith = F2(function(options, string)
{
	var flags = 'g';
	if (options.multiline) { flags += 'm'; }
	if (options.caseInsensitive) { flags += 'i'; }

	try
	{
		return $elm$core$Maybe$Just(new RegExp(string, flags));
	}
	catch(error)
	{
		return $elm$core$Maybe$Nothing;
	}
});


// USE

var _Regex_contains = F2(function(re, string)
{
	return string.match(re) !== null;
});


var _Regex_findAtMost = F3(function(n, re, str)
{
	var out = [];
	var number = 0;
	var string = str;
	var lastIndex = re.lastIndex;
	var prevLastIndex = -1;
	var result;
	while (number++ < n && (result = re.exec(string)))
	{
		if (prevLastIndex == re.lastIndex) break;
		var i = result.length - 1;
		var subs = new Array(i);
		while (i > 0)
		{
			var submatch = result[i];
			subs[--i] = submatch
				? $elm$core$Maybe$Just(submatch)
				: $elm$core$Maybe$Nothing;
		}
		out.push(A4($elm$regex$Regex$Match, result[0], result.index, number, _List_fromArray(subs)));
		prevLastIndex = re.lastIndex;
	}
	re.lastIndex = lastIndex;
	return _List_fromArray(out);
});


var _Regex_replaceAtMost = F4(function(n, re, replacer, string)
{
	var count = 0;
	function jsReplacer(match)
	{
		if (count++ >= n)
		{
			return match;
		}
		var i = arguments.length - 3;
		var submatches = new Array(i);
		while (i > 0)
		{
			var submatch = arguments[i];
			submatches[--i] = submatch
				? $elm$core$Maybe$Just(submatch)
				: $elm$core$Maybe$Nothing;
		}
		return replacer(A4($elm$regex$Regex$Match, match, arguments[arguments.length - 2], count, _List_fromArray(submatches)));
	}
	return string.replace(re, jsReplacer);
});

var _Regex_splitAtMost = F3(function(n, re, str)
{
	var string = str;
	var out = [];
	var start = re.lastIndex;
	var restoreLastIndex = re.lastIndex;
	while (n--)
	{
		var result = re.exec(string);
		if (!result) break;
		out.push(string.slice(start, result.index));
		start = re.lastIndex;
	}
	out.push(string.slice(start));
	re.lastIndex = restoreLastIndex;
	return _List_fromArray(out);
});

var _Regex_infinity = Infinity;



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
var $elm$core$List$cons = _List_cons;
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
var $elm$core$Basics$EQ = {$: 'EQ'};
var $elm$core$Basics$GT = {$: 'GT'};
var $elm$core$Basics$LT = {$: 'LT'};
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
var $elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $author$project$Render$Settings$defaultDisplaySettings = {counter: 0, data: $elm$core$Dict$empty, idsOfOpenNodes: _List_Nil, longEquationLimit: 800, numberToLevel: 1, scale: 1, selectedId: '', selectedSlug: $elm$core$Maybe$Nothing, windowWidth: 800};
var $author$project$Render$Theme$Light = {$: 'Light'};
var $author$project$Render$Settings$DefaultDisplay = {$: 'DefaultDisplay'};
var $avh4$elm_color$Color$RgbaSpace = F4(
	function (a, b, c, d) {
		return {$: 'RgbaSpace', a: a, b: b, c: c, d: d};
	});
var $avh4$elm_color$Color$rgba = F4(
	function (r, g, b, a) {
		return A4($avh4$elm_color$Color$RgbaSpace, r, g, b, a);
	});
var $author$project$Render$NewColor$blue300 = A4($avh4$elm_color$Color$rgba, 0.54, 0.71, 0.94, 1);
var $author$project$Render$NewColor$gray100 = A4($avh4$elm_color$Color$rgba, 0.96, 0.96, 0.96, 1);
var $author$project$Render$NewColor$gray700 = A4($avh4$elm_color$Color$rgba, 0.33, 0.35, 0.37, 1);
var $author$project$Render$NewColor$gray900 = A4($avh4$elm_color$Color$rgba, 0.19, 0.21, 0.23, 1);
var $author$project$Render$NewColor$indigo500 = A4($avh4$elm_color$Color$rgba, 0.35, 0.38, 0.67, 1);
var $author$project$Render$Settings$darkTheme = {
	background: $author$project$Render$NewColor$gray900,
	border: $author$project$Render$NewColor$gray700,
	codeBackground: A4($avh4$elm_color$Color$rgba, 0.298, 0.314, 0.329, 1),
	codeText: $author$project$Render$NewColor$gray100,
	highlight: $author$project$Render$NewColor$indigo500,
	link: $author$project$Render$NewColor$blue300,
	offsetBackground: $author$project$Render$NewColor$gray900,
	offsetText: A4($avh4$elm_color$Color$rgba, 0.835, 0.847, 0.882, 1),
	text: A4($avh4$elm_color$Color$rgba, 0.835, 0.847, 0.882, 1)
};
var $author$project$Render$NewColor$blue500 = A4($avh4$elm_color$Color$rgba, 0.0, 0.48, 1.0, 1);
var $author$project$Render$NewColor$gray300 = A4($avh4$elm_color$Color$rgba, 0.82, 0.82, 0.82, 1);
var $author$project$Render$NewColor$gray950 = A4($avh4$elm_color$Color$rgba, 0.09, 0.11, 0.13, 1);
var $author$project$Render$NewColor$indigo200 = A4($avh4$elm_color$Color$rgba, 0.82, 0.84, 0.93, 1);
var $avh4$elm_color$Color$rgb = F3(
	function (r, g, b) {
		return A4($avh4$elm_color$Color$RgbaSpace, r, g, b, 1.0);
	});
var $author$project$Render$Settings$lightTheme = {
	background: A4($avh4$elm_color$Color$rgba, 1, 1, 1, 1),
	border: $author$project$Render$NewColor$gray300,
	codeBackground: A4($avh4$elm_color$Color$rgba, 0.835, 0.847, 0.882, 1),
	codeText: $author$project$Render$NewColor$gray900,
	highlight: $author$project$Render$NewColor$indigo200,
	link: $author$project$Render$NewColor$blue500,
	offsetBackground: A3($avh4$elm_color$Color$rgb, 1, 1, 1),
	offsetText: $author$project$Render$NewColor$gray950,
	text: $author$project$Render$NewColor$gray950
};
var $author$project$Render$Settings$getThemedColor = F2(
	function (keyAccess, theme) {
		return keyAccess(
			function () {
				if (theme.$ === 'Dark') {
					return $author$project$Render$Settings$darkTheme;
				} else {
					return $author$project$Render$Settings$lightTheme;
				}
			}());
	});
var $mdgriffith$elm_ui$Internal$Model$Rgba = F4(
	function (a, b, c, d) {
		return {$: 'Rgba', a: a, b: b, c: c, d: d};
	});
var $mdgriffith$elm_ui$Element$rgba = $mdgriffith$elm_ui$Internal$Model$Rgba;
var $avh4$elm_color$Color$toRgba = function (_v0) {
	var r = _v0.a;
	var g = _v0.b;
	var b = _v0.c;
	var a = _v0.d;
	return {alpha: a, blue: b, green: g, red: r};
};
var $author$project$Render$Settings$toElementColor = function (color) {
	var c = $avh4$elm_color$Color$toRgba(color);
	return A4($mdgriffith$elm_ui$Element$rgba, c.red, c.green, c.blue, c.alpha);
};
var $author$project$Render$Settings$getThemedElementColor = F2(
	function (keyAccess, theme) {
		return $author$project$Render$Settings$toElementColor(
			A2($author$project$Render$Settings$getThemedColor, keyAccess, theme));
	});
var $mdgriffith$elm_ui$Element$rgb = F3(
	function (r, g, b) {
		return A4($mdgriffith$elm_ui$Internal$Model$Rgba, r, g, b, 1);
	});
var $elm$core$Basics$round = _Basics_round;
var $author$project$Render$Settings$makeSettings = F7(
	function (displaySettings, theme, selectedId, selectedSlug, scale, windowWidth, data) {
		var titleSize = 32;
		return {
			backgroundColor: A2(
				$author$project$Render$Settings$getThemedElementColor,
				function ($) {
					return $.background;
				},
				theme),
			codeBackground: A2(
				$author$project$Render$Settings$getThemedElementColor,
				function ($) {
					return $.codeBackground;
				},
				theme),
			codeColor: A2(
				$author$project$Render$Settings$getThemedElementColor,
				function ($) {
					return $.codeText;
				},
				theme),
			data: data,
			display: $author$project$Render$Settings$DefaultDisplay,
			highlight: A2(
				$author$project$Render$Settings$getThemedElementColor,
				function ($) {
					return $.highlight;
				},
				theme),
			isStandaloneDocument: false,
			leftIndent: 0,
			leftIndentation: 18,
			leftRightIndentation: 18,
			linkColor: A2(
				$author$project$Render$Settings$getThemedElementColor,
				function ($) {
					return $.link;
				},
				theme),
			longEquationLimit: 1 * windowWidth,
			maxHeadingFontSize: titleSize * 0.72,
			paddingBottom: 0,
			paddingTop: 0,
			paragraphSpacing: 28,
			properties: $elm$core$Dict$empty,
			redColor: A3($mdgriffith$elm_ui$Element$rgb, 0.7, 0, 0),
			selectedId: selectedId,
			selectedSlug: selectedSlug,
			showErrorMessages: false,
			showTOC: true,
			textColor: A2(
				$author$project$Render$Settings$getThemedElementColor,
				function ($) {
					return $.text;
				},
				theme),
			theme: theme,
			titlePrefix: '',
			titleSize: titleSize,
			topMarginForChildren: 6,
			wideLeftIndentation: 54,
			width: $elm$core$Basics$round(scale * windowWidth),
			windowWidthScale: 0.3
		};
	});
var $author$project$Render$Settings$defaultSettings = function (displaySettings) {
	return A7($author$project$Render$Settings$makeSettings, displaySettings, $author$project$Render$Theme$Light, '', $elm$core$Maybe$Nothing, 1, 600, $elm$core$Dict$empty);
};
var $elm$html$Html$div = _VirtualDom_node('div');
var $elm$core$Maybe$andThen = F2(
	function (callback, maybeValue) {
		if (maybeValue.$ === 'Just') {
			var value = maybeValue.a;
			return callback(value);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
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
var $maca$elm_rose_tree$RoseTree$Tree$Tree = F2(
	function (a, b) {
		return {$: 'Tree', a: a, b: b};
	});
var $maca$elm_rose_tree$RoseTree$Tree$foldr = F3(
	function (f, acc, _v0) {
		var a = _v0.a;
		var ns = _v0.b;
		return A3(
			$elm$core$Array$foldr,
			F2(
				function (n, acc_) {
					return A3($maca$elm_rose_tree$RoseTree$Tree$foldr, f, acc_, n);
				}),
			A2(
				f,
				A2($maca$elm_rose_tree$RoseTree$Tree$Tree, a, ns),
				acc),
			ns);
	});
var $maca$elm_rose_tree$RoseTree$Tree$value = function (_v0) {
	var a = _v0.a;
	return a;
};
var $author$project$Library$Tree$flatten = A2(
	$maca$elm_rose_tree$RoseTree$Tree$foldr,
	F2(
		function (n, acc) {
			return A2(
				$elm$core$List$cons,
				$maca$elm_rose_tree$RoseTree$Tree$value(n),
				acc);
		}),
	_List_Nil);
var $author$project$Generic$Language$getExpressionContent = function (block) {
	var _v0 = block.body;
	if (_v0.$ === 'Left') {
		return _List_Nil;
	} else {
		var exprs = _v0.a;
		return exprs;
	}
};
var $author$project$Generic$Language$getFunctionName = function (expression) {
	switch (expression.$) {
		case 'Fun':
			var name = expression.a;
			return $elm$core$Maybe$Just(name);
		case 'VFun':
			return $elm$core$Maybe$Nothing;
		case 'Text':
			return $elm$core$Maybe$Nothing;
		default:
			return $elm$core$Maybe$Nothing;
	}
};
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
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $elm$core$List$sortBy = _List_sortBy;
var $elm$core$List$sort = function (xs) {
	return A2($elm$core$List$sortBy, $elm$core$Basics$identity, xs);
};
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
var $elm_community$list_extra$List$Extra$uniqueHelp = F4(
	function (f, existing, remaining, accumulator) {
		uniqueHelp:
		while (true) {
			if (!remaining.b) {
				return $elm$core$List$reverse(accumulator);
			} else {
				var first = remaining.a;
				var rest = remaining.b;
				var computedFirst = f(first);
				if (A2($elm$core$List$member, computedFirst, existing)) {
					var $temp$f = f,
						$temp$existing = existing,
						$temp$remaining = rest,
						$temp$accumulator = accumulator;
					f = $temp$f;
					existing = $temp$existing;
					remaining = $temp$remaining;
					accumulator = $temp$accumulator;
					continue uniqueHelp;
				} else {
					var $temp$f = f,
						$temp$existing = A2($elm$core$List$cons, computedFirst, existing),
						$temp$remaining = rest,
						$temp$accumulator = A2($elm$core$List$cons, first, accumulator);
					f = $temp$f;
					existing = $temp$existing;
					remaining = $temp$remaining;
					accumulator = $temp$accumulator;
					continue uniqueHelp;
				}
			}
		}
	});
var $elm_community$list_extra$List$Extra$unique = function (list) {
	return A4($elm_community$list_extra$List$Extra$uniqueHelp, $elm$core$Basics$identity, _List_Nil, list, _List_Nil);
};
var $elm_community$maybe_extra$Maybe$Extra$cons = F2(
	function (item, list) {
		if (item.$ === 'Just') {
			var v = item.a;
			return A2($elm$core$List$cons, v, list);
		} else {
			return list;
		}
	});
var $elm_community$maybe_extra$Maybe$Extra$values = A2($elm$core$List$foldr, $elm_community$maybe_extra$Maybe$Extra$cons, _List_Nil);
var $author$project$Generic$ASTTools$expressionNames = function (forest) {
	return $elm$core$List$sort(
		$elm_community$list_extra$List$Extra$unique(
			$elm_community$maybe_extra$Maybe$Extra$values(
				A2(
					$elm$core$List$map,
					$author$project$Generic$Language$getFunctionName,
					$elm$core$List$concat(
						A2(
							$elm$core$List$map,
							$author$project$Generic$Language$getExpressionContent,
							$elm$core$List$concat(
								A2($elm$core$List$map, $author$project$Library$Tree$flatten, forest))))))));
};
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
var $author$project$Generic$ASTTools$handleEmptyDocInfo = function (strings) {
	return _Utils_eq(
		strings,
		_List_fromArray(
			['(docinfo)'])) ? _List_fromArray(
		['date:']) : strings;
};
var $author$project$Generic$ASTTools$loop = F2(
	function (s, nextState_) {
		loop:
		while (true) {
			var _v0 = nextState_(s);
			if (_v0.$ === 'Loop') {
				var s_ = _v0.a;
				var $temp$s = s_,
					$temp$nextState_ = nextState_;
				s = $temp$s;
				nextState_ = $temp$nextState_;
				continue loop;
			} else {
				var b = _v0.a;
				return b;
			}
		}
	});
var $author$project$Generic$ASTTools$Done = function (a) {
	return {$: 'Done', a: a};
};
var $author$project$Generic$ASTTools$Loop = function (a) {
	return {$: 'Loop', a: a};
};
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
var $elm$core$String$slice = _String_slice;
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $elm$core$String$replace = F3(
	function (before, after, string) {
		return A2(
			$elm$core$String$join,
			after,
			A2($elm$core$String$split, before, string));
	});
var $author$project$Generic$ASTTools$nextStepFix = function (state) {
	var _v0 = $elm$core$List$head(state.input);
	if (_v0.$ === 'Nothing') {
		return $author$project$Generic$ASTTools$Done(state.output);
	} else {
		var line = _v0.a;
		return (line === '') ? $author$project$Generic$ASTTools$Loop(
			_Utils_update(
				state,
				{
					input: A2($elm$core$List$drop, 1, state.input)
				})) : ((A2($elm$core$String$left, 7, line) === 'author:') ? $author$project$Generic$ASTTools$Loop(
			_Utils_update(
				state,
				{
					count: state.count + 1,
					input: A2($elm$core$List$drop, 1, state.input),
					output: A2(
						$elm$core$List$cons,
						A3(
							$elm$core$String$replace,
							'author:',
							'author' + ($elm$core$String$fromInt(state.count) + ':'),
							line),
						state.output)
				})) : $author$project$Generic$ASTTools$Loop(
			_Utils_update(
				state,
				{
					input: A2($elm$core$List$drop, 1, state.input),
					output: A2($elm$core$List$cons, line, state.output)
				})));
	}
};
var $author$project$Generic$ASTTools$fixFrontMatterList = function (strings) {
	return $author$project$Generic$ASTTools$handleEmptyDocInfo(
		$elm$core$List$reverse(
			A2(
				$author$project$Generic$ASTTools$loop,
				{count: 1, input: strings, output: _List_Nil},
				$author$project$Generic$ASTTools$nextStepFix)));
};
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
var $author$project$Generic$Language$getNameFromHeading = function (heading) {
	switch (heading.$) {
		case 'Paragraph':
			return $elm$core$Maybe$Nothing;
		case 'Ordinary':
			var name = heading.a;
			return $elm$core$Maybe$Just(name);
		default:
			var name = heading.a;
			return $elm$core$Maybe$Just(name);
	}
};
var $author$project$Generic$Language$getName = function (block) {
	return $author$project$Generic$Language$getNameFromHeading(block.heading);
};
var $author$project$Generic$ASTTools$matchBlockName = F2(
	function (key, block) {
		return _Utils_eq(
			$elm$core$Maybe$Just(key),
			$author$project$Generic$Language$getName(block));
	});
var $author$project$Generic$ASTTools$filterBlocksOnName = F2(
	function (name, blocks) {
		return A2(
			$elm$core$List$filter,
			$author$project$Generic$ASTTools$matchBlockName(name),
			blocks);
	});
var $author$project$Generic$ASTTools$getBlockByName = F2(
	function (name, ast) {
		return $elm$core$List$head(
			A2(
				$author$project$Generic$ASTTools$filterBlocksOnName,
				name,
				$elm$core$List$concat(
					A2($elm$core$List$map, $author$project$Library$Tree$flatten, ast))));
	});
var $author$project$Generic$Language$getVerbatimContent = function (block) {
	var _v0 = block.body;
	if (_v0.$ === 'Left') {
		var str = _v0.a;
		return $elm$core$Maybe$Just(str);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Generic$ASTTools$getVerbatimBlockValue = F2(
	function (key, ast) {
		var _v0 = A2($author$project$Generic$ASTTools$getBlockByName, key, ast);
		if (_v0.$ === 'Nothing') {
			return '(' + (key + ')');
		} else {
			var block = _v0.a;
			var _v1 = $author$project$Generic$Language$getVerbatimContent(block);
			if (_v1.$ === 'Just') {
				var str = _v1.a;
				return str;
			} else {
				return '(' + (key + ')');
			}
		}
	});
var $elm$core$Dict$Black = {$: 'Black'};
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
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
var $author$project$Generic$ASTTools$pairFromList = function (strings) {
	if ((strings.b && strings.b.b) && (!strings.b.b.b)) {
		var x = strings.a;
		var _v1 = strings.b;
		var y = _v1.a;
		return $elm$core$Maybe$Just(
			_Utils_Tuple2(x, y));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm$core$String$trim = _String_trim;
var $author$project$Generic$ASTTools$keyValueDict = function (strings_) {
	return $elm$core$Dict$fromList(
		$elm_community$maybe_extra$Maybe$Extra$values(
			A2(
				$elm$core$List$map,
				$author$project$Generic$ASTTools$pairFromList,
				A2(
					$elm$core$List$map,
					$elm$core$List$map($elm$core$String$trim),
					A2(
						$elm$core$List$map,
						$elm$core$String$split(':'),
						strings_)))));
};
var $author$project$Generic$ASTTools$frontMatterDict = function (ast) {
	return $author$project$Generic$ASTTools$keyValueDict(
		$author$project$Generic$ASTTools$fixFrontMatterList(
			A2(
				$elm$core$String$split,
				'\n',
				A2($author$project$Generic$ASTTools$getVerbatimBlockValue, 'docinfo', ast))));
};
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
var $author$project$Generic$ASTTools$getText = function (expression) {
	switch (expression.$) {
		case 'Text':
			var str = expression.a;
			return $elm$core$Maybe$Just(str);
		case 'VFun':
			var str = expression.b;
			return $elm$core$Maybe$Just(
				A3($elm$core$String$replace, '`', '', str));
		case 'Fun':
			var expressions = expression.b;
			return $elm$core$Maybe$Just(
				A2(
					$elm$core$String$join,
					' ',
					$elm_community$maybe_extra$Maybe$Extra$values(
						A2($elm$core$List$map, $author$project$Generic$ASTTools$getText, expressions))));
		default:
			var exprList = expression.a;
			return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Generic$ASTTools$getValue = F2(
	function (key, ast) {
		var _v0 = A2($author$project$Generic$ASTTools$getBlockByName, key, ast);
		if (_v0.$ === 'Nothing') {
			return '(' + (key + ')');
		} else {
			var block = _v0.a;
			return A2(
				$elm$core$String$join,
				'',
				$elm_community$maybe_extra$Maybe$Extra$values(
					A2(
						$elm$core$List$map,
						$author$project$Generic$ASTTools$getText,
						$author$project$Generic$Language$getExpressionContent(block))));
		}
	});
var $author$project$Generic$ASTTools$title = function (ast) {
	return A2($author$project$Generic$ASTTools$getValue, 'title', ast);
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
var $author$project$Render$Export$LaTeX$frontMatter = F2(
	function (currentTime, ast) {
		var title = function (title_) {
			return '\\title{' + (title_ + '}');
		}(
			$author$project$Generic$ASTTools$title(ast));
		var dict = $author$project$Generic$ASTTools$frontMatterDict(ast);
		var date = A2(
			$elm$core$Maybe$withDefault,
			'',
			A2(
				$elm$core$Maybe$map,
				function (date_) {
					return '\\date{' + (date_ + '}');
				},
				A2($elm$core$Dict$get, 'date', dict)));
		var author4 = A2($elm$core$Dict$get, 'author4', dict);
		var author3 = A2($elm$core$Dict$get, 'author3', dict);
		var author2 = A2($elm$core$Dict$get, 'author2', dict);
		var author1 = A2($elm$core$Dict$get, 'author1', dict);
		var authors = function () {
			var authorList = A2(
				$elm$core$List$filterMap,
				$elm$core$Basics$identity,
				_List_fromArray(
					[author1, author2, author3, author4]));
			if (!authorList.b) {
				return '\\author{}';
			} else {
				return function (s) {
					return '\\author{\n' + (s + '\n}');
				}(
					A2($elm$core$String$join, '\n\\and\n', authorList));
			}
		}();
		return A2(
			$elm$core$String$join,
			'\n\n',
			A2(
				$elm$core$List$cons,
				'\\begin{document}',
				A2(
					$elm$core$List$cons,
					title,
					A2(
						$elm$core$List$cons,
						date,
						A2(
							$elm$core$List$cons,
							authors,
							A2($elm$core$List$cons, '\\maketitle', _List_Nil))))));
	});
var $author$project$Generic$TextMacro$insert = F2(
	function (data, dict) {
		if (data.$ === 'Nothing') {
			return dict;
		} else {
			var macro = data.a;
			return A3($elm$core$Dict$insert, macro.name, macro, dict);
		}
	});
var $elm$core$String$words = _String_words;
var $author$project$Generic$TextMacro$extract = function (expr_) {
	if ((((expr_.$ === 'Fun') && (expr_.a === 'macro')) && expr_.b.b) && (expr_.b.a.$ === 'Text')) {
		var _v1 = expr_.b;
		var _v2 = _v1.a;
		var argString = _v2.a;
		var exprs = _v1.b;
		var _v3 = $elm$core$String$words(
			$elm$core$String$trim(argString));
		if (_v3.b) {
			var name = _v3.a;
			var rest = _v3.b;
			return $elm$core$Maybe$Just(
				{body: exprs, name: name, vars: rest});
		} else {
			return $elm$core$Maybe$Nothing;
		}
	} else {
		return $elm$core$Maybe$Nothing;
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
var $author$project$Tools$Loop$Done = function (a) {
	return {$: 'Done', a: a};
};
var $author$project$Tools$Loop$Loop = function (a) {
	return {$: 'Loop', a: a};
};
var $author$project$M$Expression$advanceTokenIndex = function (state) {
	return _Utils_update(
		state,
		{tokenIndex: state.tokenIndex + 1});
};
var $elm_community$list_extra$List$Extra$getAt = F2(
	function (idx, xs) {
		return (idx < 0) ? $elm$core$Maybe$Nothing : $elm$core$List$head(
			A2($elm$core$List$drop, idx, xs));
	});
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
var $author$project$Generic$Language$VFun = F3(
	function (a, b, c) {
		return {$: 'VFun', a: a, b: b, c: c};
	});
var $author$project$ScriptaV2$Config$expressionIdPrefix = 'e-';
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
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
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
var $elm$core$Basics$ge = _Utils_ge;
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
var $elm$core$List$sum = function (numbers) {
	return A3($elm$core$List$foldl, $elm$core$Basics$add, 0, numbers);
};
var $elm$core$Basics$negate = function (n) {
	return -n;
};
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
var $elm$core$String$length = _String_length;
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
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
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
var $author$project$Tools$ParserTools$ExpectingPrefix = {$: 'ExpectingPrefix'};
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
var $elm$core$Basics$not = _Basics_not;
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
var $author$project$Generic$TextMacro$macroFromL0String = function (str) {
	return A2(
		$elm$core$Maybe$andThen,
		$author$project$Generic$TextMacro$extract,
		$elm$core$List$head(
			A2($author$project$M$Expression$parse, 0, str)));
};
var $author$project$Generic$TextMacroParser$ExpectingHash = {$: 'ExpectingHash'};
var $author$project$Generic$TextMacroParser$ExpectingInt = {$: 'ExpectingInt'};
var $author$project$Generic$TextMacroParser$InvalidNumber = {$: 'InvalidNumber'};
var $elm$parser$Parser$Advanced$Token = F2(
	function (a, b) {
		return {$: 'Token', a: a, b: b};
	});
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
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
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
var $author$project$Generic$TextMacroParser$paramParser2 = A2(
	$elm$parser$Parser$Advanced$keeper,
	A2(
		$elm$parser$Parser$Advanced$ignorer,
		A2(
			$elm$parser$Parser$Advanced$ignorer,
			$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
			$elm$parser$Parser$Advanced$chompUntil(
				A2($elm$parser$Parser$Advanced$Token, '#', $author$project$Generic$TextMacroParser$ExpectingHash))),
		$elm$parser$Parser$Advanced$symbol(
			A2($elm$parser$Parser$Advanced$Token, '#', $author$project$Generic$TextMacroParser$ExpectingHash))),
	A2($elm$parser$Parser$Advanced$int, $author$project$Generic$TextMacroParser$ExpectingInt, $author$project$Generic$TextMacroParser$InvalidNumber));
var $author$project$Generic$TextMacroParser$getParam = function (str) {
	var _v0 = A2($elm$parser$Parser$Advanced$run, $author$project$Generic$TextMacroParser$paramParser2, str);
	if (_v0.$ === 'Ok') {
		var n = _v0.a;
		return $elm$core$Maybe$Just(
			'#' + $elm$core$String$fromInt(n));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Generic$TextMacro$getParam = function (str) {
	var _v0 = $author$project$Generic$TextMacroParser$getParam(str);
	if (_v0.$ === 'Just') {
		var result = _v0.a;
		return _List_fromArray(
			[result]);
	} else {
		return _List_Nil;
	}
};
var $author$project$Generic$TextMacro$getVars_ = function (expr) {
	switch (expr.$) {
		case 'Text':
			var str = expr.a;
			return $author$project$Generic$TextMacro$getParam(str);
		case 'Fun':
			var exprs = expr.b;
			return $elm$core$List$concat(
				A2($elm$core$List$map, $author$project$Generic$TextMacro$getVars_, exprs));
		default:
			return _List_Nil;
	}
};
var $author$project$Generic$TextMacro$getVars = function (exprs) {
	return $elm$core$List$sort(
		$elm_community$list_extra$List$Extra$unique(
			$elm$core$List$concat(
				A2($elm$core$List$map, $author$project$Generic$TextMacro$getVars_, exprs))));
};
var $author$project$Generic$TextMacro$extract3Aux = F3(
	function (name, rest, meta) {
		return {
			body: rest,
			name: name,
			vars: $author$project$Generic$TextMacro$getVars(rest)
		};
	});
var $author$project$Generic$TextMacro$extract2Aux = F2(
	function (body, meta) {
		if (body.b && (body.a.$ === 'Fun')) {
			var _v1 = body.a;
			var name = _v1.a;
			var rest = body.b;
			return $elm$core$Maybe$Just(
				A3($author$project$Generic$TextMacro$extract3Aux, name, rest, meta));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$Generic$TextMacro$extract2 = function (expr) {
	if (expr.$ === 'Fun') {
		var name = expr.a;
		var body = expr.b;
		var meta = expr.c;
		return (name === 'newcommand') ? A2($author$project$Generic$TextMacro$extract2Aux, body, meta) : $elm$core$Maybe$Nothing;
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Generic$TextMacro$parseMicroLaTeX = function (str) {
	return A2($author$project$M$Expression$parse, 0, str);
};
var $author$project$Generic$TextMacro$macroFromMicroLaTeXString = function (macroS) {
	return A2(
		$elm$core$Maybe$andThen,
		$author$project$Generic$TextMacro$extract2,
		$elm$core$List$head(
			$author$project$Generic$TextMacro$parseMicroLaTeX(macroS)));
};
var $author$project$Generic$TextMacro$macroFromString = function (str) {
	var _v0 = A2($elm$core$String$left, 1, str);
	switch (_v0) {
		case '\\':
			return $author$project$Generic$TextMacro$macroFromMicroLaTeXString(str);
		case '[':
			return $author$project$Generic$TextMacro$macroFromL0String(str);
		default:
			return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Generic$TextMacro$buildDictionary = function (lines) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (line, acc) {
				return A2(
					$author$project$Generic$TextMacro$insert,
					$author$project$Generic$TextMacro$macroFromString(line),
					acc);
			}),
		$elm$core$Dict$empty,
		lines);
};
var $author$project$Generic$TextMacro$functionNames_ = function (expr) {
	switch (expr.$) {
		case 'Fun':
			var name = expr.a;
			var body = expr.b;
			return A2(
				$elm$core$List$cons,
				name,
				$elm$core$List$concat(
					A2($elm$core$List$map, $author$project$Generic$TextMacro$functionNames_, body)));
		case 'Text':
			return _List_Nil;
		case 'VFun':
			return _List_Nil;
		default:
			return _List_Nil;
	}
};
var $author$project$Generic$TextMacro$functionNames = function (exprs) {
	return $elm$core$List$concat(
		A2($elm$core$List$map, $author$project$Generic$TextMacro$functionNames_, exprs));
};
var $elm$core$String$lines = _String_lines;
var $elm$core$Tuple$second = function (_v0) {
	var y = _v0.b;
	return y;
};
var $author$project$Generic$TextMacro$getTextMacroFunctionNames = function (str) {
	return $elm$core$List$sort(
		$elm_community$list_extra$List$Extra$unique(
			$elm$core$List$concat(
				A2(
					$elm$core$List$map,
					$author$project$Generic$TextMacro$functionNames,
					A2(
						$elm$core$List$map,
						function ($) {
							return $.body;
						},
						A2(
							$elm$core$List$map,
							$elm$core$Tuple$second,
							$elm$core$Dict$toList(
								$author$project$Generic$TextMacro$buildDictionary(
									$elm$core$String$lines(str)))))))));
};
var $author$project$Render$Export$Preamble$commands = '\n%% Commands\n\n\\newcommand{\\hang}[1]{%\n  {%\n    \\setlength{\\leftskip}{1em}%\n    \\setlength{\\hangindent}{1em}%\n    \\hangafter=1 %\n    #1\\ \\vpace{4}%\n  }%\n}\n\n\\renewcommand{\\labelitemi}{\\scalebox{0.7}{\\textbullet}}\n\n% Dot box = 1em, gap = 1em → total = 2em\n\\newcommand{\\compactItem}[1]{%\n  \\par\n\\noindent\n  \\hangindent=2em \\hangafter=1%\n  \\makebox[1em][l]{\\labelitemi}\\hspace{1em}#1\\par\n}\n\n\\newcommand{\\code}[1]{{\\tt #1}}\n\\newcommand{\\ellie}[1]{\\href{#1}{Link to Ellie}}\n% \\newcommand{\\image}[3]{\\includegraphics[width=3cm]{#1}}\n\n%% width=4truein,keepaspectratio]\n\n\n% imagecentercaptioned command removed - using standard figure environment instead\n\n\\newcommand{\\imagecenter}[2]{\n   \\medskip\n   \\begin{figure}[htp]\n   \\centering\n    \\includegraphics[width=#2]{#1}\n    \\vglue0pt\n    \\end{figure}\n    \\medskip\n}\n\n\\newcommand{\\imagefloat}[4]{\n    \\begin{wrapfigure}{#4}{#2}\n    \\includegraphics[width=#2]{#1}\n    \\caption{#3}\n    \\end{wrapfigure}\n}\n\n\n\\newcommand{\\imagefloatright}[3]{\n    \\begin{wrapfigure}{R}{0.30\\textwidth}\n    \\includegraphics[width=0.30\\textwidth]{#1}\n    \\caption{#2}\n    \\end{wrapfigure}\n}\n\n\\newcommand{\\hide}[1]{}\n\n\n\\newcommand{\\imagefloatleft}[3]{\n    \\begin{wrapfigure}{L}{0.3-\\textwidth}\n    \\includegraphics[width=0.30\\textwidth]{#1}\n    \\caption{#2}\n    \\end{wrapfigure}\n}\n% Font style\n\\newcommand{\\italic}[1]{{\\sl #1}}\n\\newcommand{\\strong}[1]{{\\bf #1}}\n\\newcommand{\\strike}[1]{\\st{#1}}\n\n% Scripta\n\\newcommand{\\ilink}[2]{\\href{{https://scripta.io/s/#1}}{#2}}\n\\newcommand{\\markwith}[1]{}\n\\newcommand{\\anchor}[1]{#1}\n\n% Color\n\\newcommand{\\red}[1]{\\textcolor{red}{#1}}\n\\newcommand{\\blue}[1]{\\textcolor{blue}{#1}}\n\\newcommand{\\violet}[1]{\\textcolor{violet}{#1}}\n\\newcommand{\\highlight}[1]{\\hl{#1}}\n\\newcommand{\\note}[2]{\\textcolor{blue}{#1}{\\hl{#1}}}\n\n% WTF?\n\\newcommand{\\remote}[1]{\\textcolor{red}{#1}}\n\\newcommand{\\local}[1]{\\textcolor{blue}{#1}}\n\n% Unclassified\n\\newcommand{\\subheading}[1]{{\\bf #1}\\par}\n\\newcommand{\\term}[1]{{\\sl #1}}\n\\newcommand{\\termx}[1]{}\n\\newcommand{\\comment}[1]{}\n\\newcommand{\\innertableofcontents}{}\n\n\n% Special character\n\\newcommand{\\dollarSign}[0]{{\\$}}\n\\newcommand{\\backTick}[0]{\\`{}}\n\n%% Theorems\n\\newtheorem{remark}{Remark}\n\\newtheorem{theorem}{Theorem}\n\\newtheorem{axiom}{Axiom}\n\\newtheorem{lemma}{Lemma}\n\\newtheorem{proposition}{Proposition}\n\\newtheorem{corollary}{Corollary}\n\\newtheorem{definition}{Definition}\n\\newtheorem{example}{Example}\n\\newtheorem{exercise}{Exercise}\n\\newtheorem{problem}{Problem}\n\\newtheorem{exercises}{Exercises}\n\\newcommand{\\bs}[1]{$\\backslash$#1}\n\\newcommand{\\texarg}[1]{\\{#1\\}}\n\n\n%% Environments\n\\renewenvironment{quotation}\n  {\\begin{adjustwidth}{2cm}{} \\footnotesize}\n  {\\end{adjustwidth}}\n\n\\def\\changemargin#1#2{\\list{}{\\rightmargin#2\\leftmargin#1}\\item[]}\n\\let\\endchangemargin=\\endlist\n\n\\renewenvironment{indent}\n  {\\begin{adjustwidth}{0.75cm}{}}\n  {\\end{adjustwidth}}\n\n\n%% NEWCOMMAND\n\n% \\definecolor{mypink1}{rgb}{0.858, 0.188, 0.478}\n% \\definecolor{mypink2}{RGB}{219, 48, 122}\n\\newcommand{\\fontRGB}[4]{\n    \\definecolor{mycolor}{RGB}{#1, #2, #3}\n    \\textcolor{mycolor}{#4}\n    }\n\n\\newcommand{\\highlightRGB}[4]{\n    \\definecolor{mycolor}{RGB}{#1, #2, #3}\n    \\sethlcolor{mycolor}\n    \\hl{#4}\n     \\sethlcolor{yellow}\n    }\n\n\\newcommand{\\gray}[2]{\n\\definecolor{mygray}{gray}{#1}\n\\textcolor{mygray}{#2}\n}\n\n\\newcommand{\\white}[1]{\\gray{1}[#1]}\n\\newcommand{\\medgray}[1]{\\gray{0.5}[#1]}\n\\newcommand{\\black}[1]{\\gray{0}[#1]}\n\n% Spacing\n\\parindent0pt\n\\parskip5pt\n\n';
var $author$project$Render$Export$Preamble$newPackageText = function (packagesNeeded_) {
	return A2(
		$elm$core$String$join,
		'\n',
		A2(
			$elm$core$List$map,
			function (name) {
				return '\\usepackage{' + (name + '}');
			},
			packagesNeeded_));
};
var $author$project$Render$Export$Preamble$addPackage = F4(
	function (namesInDocument, entityName, packageNames, packages_) {
		return A2($elm$core$List$member, entityName, namesInDocument) ? _Utils_ap(packageNames, packages_) : packages_;
	});
var $author$project$Render$Export$Preamble$packageList = _List_fromArray(
	[
		_Utils_Tuple2(
		'quiver',
		_List_fromArray(
			['quiver'])),
		_Utils_Tuple2(
		'tikz',
		_List_fromArray(
			['tikz'])),
		_Utils_Tuple2(
		'link',
		_List_fromArray(
			['hyperref'])),
		_Utils_Tuple2(
		'ilink',
		_List_fromArray(
			['hyperref'])),
		_Utils_Tuple2(
		'href',
		_List_fromArray(
			['hyperref'])),
		_Utils_Tuple2(
		'textcolor',
		_List_fromArray(
			['xcolor'])),
		_Utils_Tuple2(
		'blue',
		_List_fromArray(
			['xcolor'])),
		_Utils_Tuple2(
		'red',
		_List_fromArray(
			['xcolor'])),
		_Utils_Tuple2(
		'green',
		_List_fromArray(
			['xcolor'])),
		_Utils_Tuple2(
		'gray',
		_List_fromArray(
			['xcolor'])),
		_Utils_Tuple2(
		'magenta',
		_List_fromArray(
			['xcolor'])),
		_Utils_Tuple2(
		'violet',
		_List_fromArray(
			['xcolor'])),
		_Utils_Tuple2(
		'pink',
		_List_fromArray(
			['xcolor'])),
		_Utils_Tuple2(
		'highlight',
		_List_fromArray(
			['xcolor'])),
		_Utils_Tuple2(
		'highlight',
		_List_fromArray(
			['soul'])),
		_Utils_Tuple2(
		'strike',
		_List_fromArray(
			['soul'])),
		_Utils_Tuple2(
		'errorHighlight',
		_List_fromArray(
			['xcolor'])),
		_Utils_Tuple2(
		'image',
		_List_fromArray(
			['graphicx', 'wrapfig', 'float']))
	]);
var $author$project$Render$Export$Preamble$newPackageList = function (names) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, acc) {
				var entityName = _v0.a;
				var packageNames = _v0.b;
				return A4($author$project$Render$Export$Preamble$addPackage, names, entityName, packageNames, acc);
			}),
		_List_Nil,
		$author$project$Render$Export$Preamble$packageList);
};
var $author$project$Render$Export$Preamble$packagesNeeded = function (names) {
	return $elm$core$List$sort(
		$elm_community$list_extra$List$Extra$unique(
			$author$project$Render$Export$Preamble$newPackageList(names)));
};
var $author$project$Render$Export$Preamble$standardPackages = '\n%% Packages\n\n%% Standard packages\n\\usepackage{geometry}\n\\geometry{letterpaper}\n\\usepackage{changepage}  % for the adjustwidth environment\n\\usepackage{graphicx}    % for \\includegraphics\n\n%% AMS\n\\usepackage{amssymb}\n\\usepackage{amsmath}\n\n\\usepackage{amscd}\n\n\\usepackage{fancyvrb} %% for inline verbatim\n';
var $author$project$Render$Export$Preamble$addCode = F4(
	function (packagesInDocument, _package, codeText, accumulatedCodeText) {
		return A2($elm$core$List$member, _package, packagesInDocument) ? (codeText + ('\n\n' + accumulatedCodeText)) : accumulatedCodeText;
	});
var $author$project$Render$Export$Preamble$hypersetup = '\n\\hypersetup{\n    colorlinks=true,\n    linkcolor=blue,\n    filecolor=magenta,\n    urlcolor=blue,\n}\n';
var $author$project$Render$Export$Preamble$setupCode = _List_fromArray(
	[
		_Utils_Tuple2('graphicx', '\\graphicspath{ {image/} }'),
		_Utils_Tuple2('hyperref', $author$project$Render$Export$Preamble$hypersetup)
	]);
var $author$project$Render$Export$Preamble$supportingCode = function (packagesInDocument) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, acc) {
				var entityName = _v0.a;
				var packageNames = _v0.b;
				return A4($author$project$Render$Export$Preamble$addCode, packagesInDocument, entityName, packageNames, acc);
			}),
		'',
		$author$project$Render$Export$Preamble$setupCode);
};
var $author$project$Render$Export$Preamble$make = F2(
	function (blockNames_, expressionNames_) {
		var names = _Utils_ap(blockNames_, expressionNames_);
		var packagesUsed = $author$project$Render$Export$Preamble$packagesNeeded(names);
		return A2(
			$elm$core$String$join,
			'\n',
			_List_fromArray(
				[
					'\\documentclass[11pt, oneside]{article}',
					$author$project$Render$Export$Preamble$newPackageText(packagesUsed),
					$author$project$Render$Export$Preamble$supportingCode(packagesUsed),
					$author$project$Render$Export$Preamble$standardPackages,
					$author$project$Render$Export$Preamble$commands
				]));
	});
var $author$project$Generic$ASTTools$rawBlockNames = function (forest) {
	return $elm_community$maybe_extra$Maybe$Extra$values(
		A2(
			$elm$core$List$map,
			$author$project$Generic$Language$getName,
			$elm$core$List$concat(
				A2($elm$core$List$map, $author$project$Library$Tree$flatten, forest))));
};
var $author$project$Generic$Language$Verbatim = function (a) {
	return {$: 'Verbatim', a: a};
};
var $toastal$either$Either$Right = function (a) {
	return {$: 'Right', a: a};
};
var $author$project$Generic$BlockUtilities$smashUrl = function (url) {
	return A3(
		$elm$core$String$replace,
		'http://',
		'',
		A3($elm$core$String$replace, 'https://', '', url));
};
var $author$project$Generic$BlockUtilities$condenseUrl = function (expr) {
	if ((((expr.$ === 'Fun') && (expr.a === 'image')) && expr.b.b) && (expr.b.a.$ === 'Text')) {
		var _v1 = expr.b;
		var _v2 = _v1.a;
		var url = _v2.a;
		var meta1 = _v2.b;
		var rest = _v1.b;
		var meta2 = expr.c;
		return A3(
			$author$project$Generic$Language$Fun,
			'image',
			A2(
				$elm$core$List$cons,
				A2(
					$author$project$Generic$Language$Text,
					$author$project$Generic$BlockUtilities$smashUrl(url),
					meta1),
				rest),
			meta2);
	} else {
		return expr;
	}
};
var $author$project$Generic$BlockUtilities$condenseUrls = function (block) {
	var _v0 = block.body;
	if (_v0.$ === 'Left') {
		return block;
	} else {
		var exprList = _v0.a;
		return _Utils_update(
			block,
			{
				body: $toastal$either$Either$Right(
					A2($elm$core$List$map, $author$project$Generic$BlockUtilities$condenseUrl, exprList))
			});
	}
};
var $author$project$Render$Export$LaTeX$OutsideList = {$: 'OutsideList'};
var $author$project$Render$Export$LaTeX$InsideDescriptionList = {$: 'InsideDescriptionList'};
var $author$project$Render$Export$LaTeX$InsideItemizedList = {$: 'InsideItemizedList'};
var $author$project$Render$Export$LaTeX$InsideNumberedList = {$: 'InsideNumberedList'};
var $author$project$Generic$Language$Ordinary = function (a) {
	return {$: 'Ordinary', a: a};
};
var $author$project$Generic$Language$Paragraph = {$: 'Paragraph'};
var $author$project$Generic$Language$emptyBlockMeta = {error: $elm$core$Maybe$Nothing, id: '', lineNumber: 0, messages: _List_Nil, numberOfLines: 0, position: 0, sourceText: ''};
var $author$project$Generic$Language$expressionBlockEmpty = {
	args: _List_Nil,
	body: $toastal$either$Either$Right(_List_Nil),
	firstLine: '',
	heading: $author$project$Generic$Language$Paragraph,
	indent: 0,
	meta: $author$project$Generic$Language$emptyBlockMeta,
	properties: $elm$core$Dict$empty,
	style: $elm$core$Maybe$Nothing
};
var $author$project$Render$Export$LaTeX$emptyExpressionBlock = $author$project$Generic$Language$expressionBlockEmpty;
var $author$project$Generic$BlockUtilities$updateMeta = F2(
	function (transformMeta, block) {
		var oldMeta = block.meta;
		var newMeta = transformMeta(oldMeta);
		return _Utils_update(
			block,
			{meta: newMeta});
	});
var $author$project$Render$Export$LaTeX$beginDescriptionBlock = A2(
	$author$project$Generic$BlockUtilities$updateMeta,
	function (m) {
		return _Utils_update(
			m,
			{numberOfLines: 2, sourceText: '| beginBlock\ndescription'});
	},
	_Utils_update(
		$author$project$Render$Export$LaTeX$emptyExpressionBlock,
		{
			body: $toastal$either$Either$Right(
				_List_fromArray(
					[
						A2(
						$author$project$Generic$Language$Text,
						'description',
						{begin: 0, end: 7, id: 'begin', index: 0})
					])),
			heading: $author$project$Generic$Language$Ordinary('beginDescriptionBlock'),
			indent: 1
		}));
var $author$project$Render$Export$LaTeX$beginItemizedBlock = A2(
	$author$project$Generic$BlockUtilities$updateMeta,
	function (m) {
		return _Utils_update(
			m,
			{numberOfLines: 2, sourceText: '| beginBlock\nitemize'});
	},
	_Utils_update(
		$author$project$Render$Export$LaTeX$emptyExpressionBlock,
		{
			body: $toastal$either$Either$Right(
				_List_fromArray(
					[
						A2(
						$author$project$Generic$Language$Text,
						'itemize',
						{begin: 0, end: 7, id: '', index: 0})
					])),
			heading: $author$project$Generic$Language$Ordinary('beginBlock'),
			indent: 1
		}));
var $author$project$Render$Export$LaTeX$beginNumberedBlock = A2(
	$author$project$Generic$BlockUtilities$updateMeta,
	function (m) {
		return _Utils_update(
			m,
			{numberOfLines: 2, sourceText: '| beginBlock\nitemize'});
	},
	_Utils_update(
		$author$project$Render$Export$LaTeX$emptyExpressionBlock,
		{
			body: $toastal$either$Either$Right(
				_List_fromArray(
					[
						A2(
						$author$project$Generic$Language$Text,
						'enumerate',
						{begin: 0, end: 7, id: 'begin', index: 0})
					])),
			heading: $author$project$Generic$Language$Ordinary('beginNumberedBlock'),
			indent: 1
		}));
var $author$project$Render$Export$LaTeX$endDescriptionBlock = A2(
	$author$project$Generic$BlockUtilities$updateMeta,
	function (m) {
		return _Utils_update(
			m,
			{numberOfLines: 2, sourceText: '| endBlock\ndescription'});
	},
	_Utils_update(
		$author$project$Render$Export$LaTeX$emptyExpressionBlock,
		{
			body: $toastal$either$Either$Right(
				_List_fromArray(
					[
						A2(
						$author$project$Generic$Language$Text,
						'description',
						{begin: 0, end: 7, id: 'end', index: 0})
					])),
			heading: $author$project$Generic$Language$Ordinary('endDescriptionBlock'),
			indent: 1
		}));
var $author$project$Render$Export$LaTeX$endItemizedBlock = A2(
	$author$project$Generic$BlockUtilities$updateMeta,
	function (m) {
		return _Utils_update(
			m,
			{numberOfLines: 2, sourceText: '| endBlock\nitemize'});
	},
	_Utils_update(
		$author$project$Render$Export$LaTeX$emptyExpressionBlock,
		{
			body: $toastal$either$Either$Right(
				_List_fromArray(
					[
						A2(
						$author$project$Generic$Language$Text,
						'itemize',
						{begin: 0, end: 7, id: 'end', index: 0})
					])),
			heading: $author$project$Generic$Language$Ordinary('endBlock'),
			indent: 1
		}));
var $author$project$Render$Export$LaTeX$endNumberedBlock = A2(
	$author$project$Generic$BlockUtilities$updateMeta,
	function (m) {
		return _Utils_update(
			m,
			{numberOfLines: 2, sourceText: '| endBlock\nitemize'});
	},
	_Utils_update(
		$author$project$Render$Export$LaTeX$emptyExpressionBlock,
		{
			body: $toastal$either$Either$Right(
				_List_fromArray(
					[
						A2(
						$author$project$Generic$Language$Text,
						'enumerate',
						{begin: 0, end: 7, id: 'begin', index: 0})
					])),
			heading: $author$project$Generic$Language$Ordinary('endNumberedBlock'),
			indent: 1
		}));
var $author$project$Generic$BlockUtilities$getExpressionBlockName = function (block) {
	var _v0 = block.heading;
	switch (_v0.$) {
		case 'Paragraph':
			return $elm$core$Maybe$Nothing;
		case 'Ordinary':
			var name = _v0.a;
			return $elm$core$Maybe$Just(name);
		default:
			var name = _v0.a;
			return $elm$core$Maybe$Just(name);
	}
};
var $maca$elm_rose_tree$RoseTree$Tree$leaf = function (a) {
	return A2($maca$elm_rose_tree$RoseTree$Tree$Tree, a, $elm$core$Array$empty);
};
var $author$project$Render$Export$LaTeX$nextState = F2(
	function (tree, state) {
		var name_ = $author$project$Generic$BlockUtilities$getExpressionBlockName(
			$maca$elm_rose_tree$RoseTree$Tree$value(tree));
		var _v0 = _Utils_Tuple2(state.status, name_);
		_v0$9:
		while (true) {
			switch (_v0.a.$) {
				case 'InsideItemizedList':
					if ((_v0.b.$ === 'Just') && (_v0.b.a === 'item')) {
						var _v2 = _v0.a;
						return _Utils_update(
							state,
							{
								input: A2($elm$core$List$drop, 1, state.input),
								itemNumber: state.itemNumber + 1,
								output: A2($elm$core$List$cons, tree, state.output)
							});
					} else {
						var _v3 = _v0.a;
						return _Utils_update(
							state,
							{
								input: A2($elm$core$List$drop, 1, state.input),
								itemNumber: 0,
								output: A2(
									$elm$core$List$cons,
									tree,
									A2(
										$elm$core$List$cons,
										$maca$elm_rose_tree$RoseTree$Tree$leaf($author$project$Render$Export$LaTeX$endItemizedBlock),
										state.output)),
								status: $author$project$Render$Export$LaTeX$OutsideList
							});
					}
				case 'InsideNumberedList':
					if ((_v0.b.$ === 'Just') && (_v0.b.a === 'numbered')) {
						var _v5 = _v0.a;
						return _Utils_update(
							state,
							{
								input: A2($elm$core$List$drop, 1, state.input),
								itemNumber: state.itemNumber + 1,
								output: A2($elm$core$List$cons, tree, state.output)
							});
					} else {
						var _v6 = _v0.a;
						return _Utils_update(
							state,
							{
								input: A2($elm$core$List$drop, 1, state.input),
								itemNumber: 0,
								output: A2(
									$elm$core$List$cons,
									tree,
									A2(
										$elm$core$List$cons,
										$maca$elm_rose_tree$RoseTree$Tree$leaf($author$project$Render$Export$LaTeX$endNumberedBlock),
										state.output)),
								status: $author$project$Render$Export$LaTeX$OutsideList
							});
					}
				case 'InsideDescriptionList':
					if ((_v0.b.$ === 'Just') && (_v0.b.a === 'desc')) {
						var _v8 = _v0.a;
						return _Utils_update(
							state,
							{
								input: A2($elm$core$List$drop, 1, state.input),
								itemNumber: state.itemNumber + 1,
								output: A2($elm$core$List$cons, tree, state.output)
							});
					} else {
						var _v9 = _v0.a;
						return _Utils_update(
							state,
							{
								input: A2($elm$core$List$drop, 1, state.input),
								itemNumber: 0,
								output: A2(
									$elm$core$List$cons,
									tree,
									A2(
										$elm$core$List$cons,
										$maca$elm_rose_tree$RoseTree$Tree$leaf($author$project$Render$Export$LaTeX$endDescriptionBlock),
										state.output)),
								status: $author$project$Render$Export$LaTeX$OutsideList
							});
					}
				default:
					if (_v0.b.$ === 'Just') {
						switch (_v0.b.a) {
							case 'item':
								var _v1 = _v0.a;
								return _Utils_update(
									state,
									{
										input: A2($elm$core$List$drop, 1, state.input),
										itemNumber: 1,
										output: A2(
											$elm$core$List$cons,
											tree,
											A2(
												$elm$core$List$cons,
												$maca$elm_rose_tree$RoseTree$Tree$leaf($author$project$Render$Export$LaTeX$beginItemizedBlock),
												state.output)),
										status: $author$project$Render$Export$LaTeX$InsideItemizedList
									});
							case 'numbered':
								var _v4 = _v0.a;
								return _Utils_update(
									state,
									{
										input: A2($elm$core$List$drop, 1, state.input),
										itemNumber: 1,
										output: A2(
											$elm$core$List$cons,
											tree,
											A2(
												$elm$core$List$cons,
												$maca$elm_rose_tree$RoseTree$Tree$leaf($author$project$Render$Export$LaTeX$beginNumberedBlock),
												state.output)),
										status: $author$project$Render$Export$LaTeX$InsideNumberedList
									});
							case 'desc':
								var _v7 = _v0.a;
								return _Utils_update(
									state,
									{
										input: A2($elm$core$List$drop, 1, state.input),
										itemNumber: 1,
										output: A2(
											$elm$core$List$cons,
											tree,
											A2(
												$elm$core$List$cons,
												$maca$elm_rose_tree$RoseTree$Tree$leaf($author$project$Render$Export$LaTeX$beginDescriptionBlock),
												state.output)),
										status: $author$project$Render$Export$LaTeX$InsideDescriptionList
									});
							default:
								break _v0$9;
						}
					} else {
						break _v0$9;
					}
			}
		}
		var _v10 = _v0.a;
		return _Utils_update(
			state,
			{
				input: A2($elm$core$List$drop, 1, state.input),
				output: A2($elm$core$List$cons, tree, state.output)
			});
	});
var $author$project$Render$Export$LaTeX$nextStep = function (state) {
	var _v0 = $elm$core$List$head(state.input);
	if (_v0.$ === 'Nothing') {
		return $author$project$Tools$Loop$Done(state.output);
	} else {
		var tree = _v0.a;
		return $author$project$Tools$Loop$Loop(
			A2($author$project$Render$Export$LaTeX$nextState, tree, state));
	}
};
var $author$project$Render$Export$LaTeX$encloseLists = function (blocks) {
	return $elm$core$List$reverse(
		A2(
			$author$project$Tools$Loop$loop,
			{input: blocks, itemNumber: 0, output: _List_Nil, status: $author$project$Render$Export$LaTeX$OutsideList},
			$author$project$Render$Export$LaTeX$nextStep));
};
var $maca$elm_rose_tree$RoseTree$Tree$children = function (_v0) {
	var ns = _v0.b;
	return $elm$core$Array$toList(ns);
};
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $author$project$Render$Export$LaTeX$addTikzPictureClosing = F2(
	function (flagUp, str) {
		return flagUp ? (str + '\n\\end{tikzpicture}') : str;
	});
var $elm$core$String$contains = _String_contains;
var $author$project$Render$Export$LaTeX$argString = function (args) {
	return A2(
		$elm$core$String$join,
		' ',
		A2(
			$elm$core$List$filter,
			function (arg) {
				return !A2($elm$core$String$contains, 'label:', arg);
			},
			args));
};
var $author$project$Render$Export$LaTeX$descriptionItem = F2(
	function (args, body) {
		var arg = $author$project$Render$Export$LaTeX$argString(args);
		if (!args.b) {
			return '\\item{' + (body + '}');
		} else {
			return '\\item[' + (arg + (']{' + (body + '}')));
		}
	});
var $author$project$Render$Export$LaTeX$functionDict = $elm$core$Dict$fromList(
	_List_fromArray(
		[
			_Utils_Tuple2('italic', 'textit'),
			_Utils_Tuple2('i', 'textit'),
			_Utils_Tuple2('bold', 'textbf'),
			_Utils_Tuple2('b', 'textbf'),
			_Utils_Tuple2('image', 'imagecenter'),
			_Utils_Tuple2('contents', 'tableofcontents')
		]));
var $author$project$Render$Export$LaTeX$mapChars2 = function (str) {
	return A3($elm$core$String$replace, '_', '\\_', str);
};
var $elm$core$String$trimLeft = _String_trimLeft;
var $author$project$Render$Export$LaTeX$aliases = $elm$core$Dict$fromList(
	_List_fromArray(
		[
			_Utils_Tuple2('i', 'textit'),
			_Utils_Tuple2('italic', 'textit'),
			_Utils_Tuple2('b', 'textbf'),
			_Utils_Tuple2('bold', 'textbf')
		]));
var $author$project$Render$Export$LaTeX$unalias = function (str) {
	var _v0 = A2($elm$core$Dict$get, str, $author$project$Render$Export$LaTeX$aliases);
	if (_v0.$ === 'Nothing') {
		return str;
	} else {
		var realName_ = _v0.a;
		return realName_;
	}
};
var $author$project$Render$Export$LaTeX$macro1 = F2(
	function (name, arg) {
		if (name === 'math') {
			return '$' + (arg + '$');
		} else {
			if (name === 'group') {
				return arg;
			} else {
				if (name === 'tags') {
					return '';
				} else {
					var _v0 = A2($elm$core$Dict$get, name, $author$project$Render$Export$LaTeX$functionDict);
					if (_v0.$ === 'Nothing') {
						return '\\' + ($author$project$Render$Export$LaTeX$unalias(name) + ('{' + ($author$project$Render$Export$LaTeX$mapChars2(
							$elm$core$String$trimLeft(arg)) + '}')));
					} else {
						var fName = _v0.a;
						return '\\' + (fName + ('{' + ($author$project$Render$Export$LaTeX$mapChars2(
							$elm$core$String$trimLeft(arg)) + '}')));
					}
				}
			}
		}
	});
var $author$project$Render$Utility$getArg = F3(
	function (_default, index, args) {
		var _v0 = A2($elm_community$list_extra$List$Extra$getAt, index, args);
		if (_v0.$ === 'Nothing') {
			return _default;
		} else {
			var a = _v0.a;
			return a;
		}
	});
var $elm$regex$Regex$Match = F4(
	function (match, index, number, submatches) {
		return {index: index, match: match, number: number, submatches: submatches};
	});
var $elm$regex$Regex$fromStringWith = _Regex_fromStringWith;
var $elm$regex$Regex$fromString = function (string) {
	return A2(
		$elm$regex$Regex$fromStringWith,
		{caseInsensitive: false, multiline: false},
		string);
};
var $elm$regex$Regex$replace = _Regex_replaceAtMost(_Regex_infinity);
var $author$project$Tools$Utility$userReplace = F3(
	function (regexString, replacer, string) {
		var _v0 = $elm$regex$Regex$fromString(regexString);
		if (_v0.$ === 'Nothing') {
			return string;
		} else {
			var regex = _v0.a;
			return A3($elm$regex$Regex$replace, regex, replacer, string);
		}
	});
var $author$project$Tools$Utility$removeNonAlphaNum = function (string) {
	return A3(
		$author$project$Tools$Utility$userReplace,
		'[^A-Za-z0-9\\-]',
		function (_v0) {
			return '';
		},
		string);
};
var $elm$core$String$toLower = _String_toLower;
var $author$project$MicroLaTeX$Util$normalizedWord = function (words) {
	return A2(
		$elm$core$String$join,
		'-',
		A2(
			$elm$core$List$map,
			A2($elm$core$Basics$composeR, $elm$core$String$toLower, $author$project$Tools$Utility$removeNonAlphaNum),
			words));
};
var $author$project$Render$Export$LaTeX$section = F3(
	function (settings, args, body) {
		var tag = $author$project$MicroLaTeX$Util$normalizedWord(
			$elm$core$String$words(body));
		var suffix = function () {
			var _v2 = A2($elm_community$list_extra$List$Extra$getAt, 1, args);
			if (_v2.$ === 'Nothing') {
				return '';
			} else {
				if (_v2.a === '-') {
					return '*';
				} else {
					return '';
				}
			}
		}();
		var maxNumberedLevel = A2(
			$elm$core$Maybe$withDefault,
			3,
			A2(
				$elm$core$Maybe$andThen,
				$elm$core$String$toFloat,
				A2($elm$core$Dict$get, 'number-to-level', settings.properties)));
		var levelAsString = A3($author$project$Render$Utility$getArg, '4', 0, args);
		var levelAsFloat = function () {
			var _v1 = $elm$core$String$toFloat(levelAsString);
			if (_v1.$ === 'Just') {
				var n = _v1.a;
				return n;
			} else {
				return 0;
			}
		}();
		var label = ' \\label{' + (tag + '}');
		var depthForNumbering = levelAsFloat - 1;
		switch (levelAsString) {
			case '1':
				return (_Utils_cmp(depthForNumbering, maxNumberedLevel) < 0) ? _Utils_ap(
					A2($author$project$Render$Export$LaTeX$macro1, 'section' + suffix, body),
					label) : _Utils_ap(
					A2($author$project$Render$Export$LaTeX$macro1, 'section*' + suffix, body),
					label);
			case '2':
				return (_Utils_cmp(depthForNumbering, maxNumberedLevel) < 0) ? _Utils_ap(
					A2($author$project$Render$Export$LaTeX$macro1, 'subsection' + suffix, body),
					label) : _Utils_ap(
					A2($author$project$Render$Export$LaTeX$macro1, 'subsection*' + suffix, body),
					label);
			case '3':
				return (_Utils_cmp(depthForNumbering, maxNumberedLevel) < 0) ? _Utils_ap(
					A2($author$project$Render$Export$LaTeX$macro1, 'subsubsection' + suffix, body),
					label) : _Utils_ap(
					A2($author$project$Render$Export$LaTeX$macro1, 'subsubsection*' + suffix, body),
					label);
			case '4':
				return (_Utils_cmp(depthForNumbering, maxNumberedLevel) < 0) ? _Utils_ap(
					A2($author$project$Render$Export$LaTeX$macro1, 'paragraph' + suffix, body),
					label) : _Utils_ap(
					A2($author$project$Render$Export$LaTeX$macro1, 'paragraph*' + suffix, body),
					label);
			default:
				return _Utils_ap(
					A2($author$project$Render$Export$LaTeX$macro1, 'subheading' + suffix, body),
					label);
		}
	});
var $author$project$Render$Export$LaTeX$smallsubheading = F3(
	function (settings, args, body) {
		return '\\vspace{4pt{\\large{' + (body + '}');
	});
var $author$project$Render$Export$LaTeX$subheading = F3(
	function (settings, args, body) {
		return '\\vspace{8pt{\\Large{' + (body + '}');
	});
var $author$project$Render$Export$LaTeX$putPercent = function (str) {
	return (A2($elm$core$String$left, 1, str) === '%') ? str : ('% ' + str);
};
var $author$project$Render$Export$LaTeX$texComment = function (lines) {
	return A2(
		$elm$core$String$join,
		'\n',
		A2($elm$core$List$map, $author$project$Render$Export$LaTeX$putPercent, lines));
};
var $author$project$Render$Export$LaTeX$blockDict = function (mathMacroDict) {
	return $elm$core$Dict$fromList(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'title',
				F3(
					function (_v0, _v1, _v2) {
						return '';
					})),
				_Utils_Tuple2(
				'subtitle',
				F3(
					function (_v3, _v4, _v5) {
						return '';
					})),
				_Utils_Tuple2(
				'author',
				F3(
					function (_v6, _v7, _v8) {
						return '';
					})),
				_Utils_Tuple2(
				'date',
				F3(
					function (_v9, _v10, _v11) {
						return '';
					})),
				_Utils_Tuple2(
				'contents',
				F3(
					function (_v12, _v13, _v14) {
						return '';
					})),
				_Utils_Tuple2(
				'hide',
				F3(
					function (_v15, _v16, _v17) {
						return '';
					})),
				_Utils_Tuple2(
				'texComment',
				F3(
					function (_v18, lines, _v19) {
						return $author$project$Render$Export$LaTeX$texComment(lines);
					})),
				_Utils_Tuple2(
				'tags',
				F3(
					function (_v20, _v21, _v22) {
						return '';
					})),
				_Utils_Tuple2(
				'docinfo',
				F3(
					function (_v23, _v24, _v25) {
						return '';
					})),
				_Utils_Tuple2(
				'banner',
				F3(
					function (_v26, _v27, _v28) {
						return '';
					})),
				_Utils_Tuple2(
				'set-key',
				F3(
					function (_v29, _v30, _v31) {
						return '';
					})),
				_Utils_Tuple2(
				'endnotes',
				F3(
					function (_v32, _v33, _v34) {
						return '';
					})),
				_Utils_Tuple2(
				'index',
				F3(
					function (_v35, _v36, _v37) {
						return 'Index: not implemented';
					})),
				_Utils_Tuple2(
				'section',
				F3(
					function (settings_, args, body) {
						return A3($author$project$Render$Export$LaTeX$section, settings_, args, body);
					})),
				_Utils_Tuple2(
				'subheading',
				F3(
					function (settings_, args, body) {
						return A3($author$project$Render$Export$LaTeX$subheading, settings_, args, body);
					})),
				_Utils_Tuple2(
				'smallsubheading',
				F3(
					function (settings_, args, body) {
						return A3($author$project$Render$Export$LaTeX$smallsubheading, settings_, args, body);
					})),
				_Utils_Tuple2(
				'item',
				F3(
					function (_v38, _v39, body) {
						return A2($author$project$Render$Export$LaTeX$macro1, 'item', body);
					})),
				_Utils_Tuple2(
				'itemList',
				F3(
					function (_v40, _v41, body) {
						return body;
					})),
				_Utils_Tuple2(
				'descriptionItem',
				F3(
					function (_v42, args, body) {
						return A2($author$project$Render$Export$LaTeX$descriptionItem, args, body);
					})),
				_Utils_Tuple2(
				'numbered',
				F3(
					function (_v43, _v44, body) {
						return A2($author$project$Render$Export$LaTeX$macro1, 'item', body);
					})),
				_Utils_Tuple2(
				'desc',
				F3(
					function (_v45, args, body) {
						return A2($author$project$Render$Export$LaTeX$descriptionItem, args, body);
					})),
				_Utils_Tuple2(
				'beginBlock',
				F3(
					function (_v46, _v47, _v48) {
						return '\\begin{itemize}';
					})),
				_Utils_Tuple2(
				'endBlock',
				F3(
					function (_v49, _v50, _v51) {
						return '\\end{itemize}';
					})),
				_Utils_Tuple2(
				'beginNumberedBlock',
				F3(
					function (_v52, _v53, _v54) {
						return '\\begin{enumerate}';
					})),
				_Utils_Tuple2(
				'endNumberedBlock',
				F3(
					function (_v55, _v56, _v57) {
						return '\\end{enumerate}';
					})),
				_Utils_Tuple2(
				'beginDescriptionBlock',
				F3(
					function (_v58, _v59, _v60) {
						return '\\begin{description}';
					})),
				_Utils_Tuple2(
				'endDescriptionBlock',
				F3(
					function (_v61, _v62, _v63) {
						return '\\end{description}';
					})),
				_Utils_Tuple2(
				'mathmacros',
				F3(
					function (_v64, _v65, body) {
						return body + '\nHa ha ha!';
					})),
				_Utils_Tuple2(
				'setcounter',
				F3(
					function (_v66, _v67, _v68) {
						return '';
					}))
			]));
};
var $author$project$Render$Export$LaTeX$commentBlankLine = function (line) {
	return (line === '') ? '%' : line;
};
var $elm$core$String$dropRight = F2(
	function (n, string) {
		return (n < 1) ? string : A3($elm$core$String$slice, 0, -n, string);
	});
var $author$project$Render$Export$LaTeX$tagged = F2(
	function (name, body) {
		return '\\' + (name + ('{' + (body + '}')));
	});
var $author$project$Render$Export$LaTeX$environment = F2(
	function (name, body) {
		return A2(
			$elm$core$String$join,
			'\n',
			_List_fromArray(
				[
					A2($author$project$Render$Export$LaTeX$tagged, 'begin', name),
					body,
					A2($author$project$Render$Export$LaTeX$tagged, 'end', name)
				]));
	});
var $elm$core$String$filter = _String_filter;
var $author$project$Render$Export$Image$exportCenteredFigure = F3(
	function (url, options, caption) {
		if ((caption === 'none') || (caption === '')) {
			return A2(
				$elm$core$String$join,
				'',
				_List_fromArray(
					['\\begin{center}\n', '\\includegraphics[width=' + (options + (']{' + (url + '}\n'))), '\\end{center}']));
		} else {
			var label = A2(
				$elm$core$String$filter,
				$elm$core$Char$isAlphaNum,
				$elm$core$String$toLower(
					A2(
						$elm$core$String$join,
						'',
						A2(
							$elm$core$List$take,
							2,
							$elm$core$String$words(caption)))));
			return A2(
				$elm$core$String$join,
				'',
				_List_fromArray(
					['\\begin{figure}[h]\n', '  \\centering\n', '  \\includegraphics[width=' + (options + (']{' + (url + '}\n'))), '  \\caption{' + (caption + '}\n'), '  \\label{fig:' + (label + '}\n'), '\\end{figure}']));
		}
	});
var $elm$core$String$fromFloat = _String_fromNumber;
var $author$project$Render$Export$Image$fractionaRescale = function (k) {
	var f = $elm$core$String$fromFloat(k / 600.0);
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			[f, '\\textwidth']));
};
var $author$project$Render$Export$Image$rescale = F2(
	function (displayWidth, k) {
		return $elm$core$String$fromFloat(k * (6.0 / displayWidth)) + 'truein';
	});
var $elm$core$String$toInt = _String_toInt;
var $author$project$Render$Export$Image$imageParametersForBlock = F2(
	function (settings, block) {
		var url = function () {
			var _v5 = block.body;
			if (_v5.$ === 'Left') {
				var str = _v5.a;
				return str;
			} else {
				return 'bad block';
			}
		}();
		var placement = function () {
			var _v4 = A2($elm$core$Dict$get, 'placement', block.properties);
			if (_v4.$ === 'Nothing') {
				return 'C';
			} else {
				switch (_v4.a) {
					case 'left':
						return 'L';
					case 'right':
						return 'R';
					case 'center':
						return 'C';
					default:
						return 'C';
				}
			}
		}();
		var displayWidth = settings.width;
		var fractionalWidth = function () {
			var _v2 = A2($elm$core$Dict$get, 'width', block.properties);
			if (_v2.$ === 'Nothing') {
				return '0.51\\textwidth';
			} else {
				if (_v2.a === 'fill') {
					return $author$project$Render$Export$Image$fractionaRescale(displayWidth);
				} else {
					var w_ = _v2.a;
					var _v3 = $elm$core$String$toInt(w_);
					if (_v3.$ === 'Nothing') {
						return $author$project$Render$Export$Image$fractionaRescale(displayWidth);
					} else {
						var w = _v3.a;
						return $author$project$Render$Export$Image$fractionaRescale(w);
					}
				}
			}
		}();
		var width = function () {
			var _v0 = A2($elm$core$Dict$get, 'width', block.properties);
			if (_v0.$ === 'Nothing') {
				return A2($author$project$Render$Export$Image$rescale, displayWidth, displayWidth);
			} else {
				if (_v0.a === 'fill') {
					return A2($author$project$Render$Export$Image$rescale, displayWidth, displayWidth);
				} else {
					var w_ = _v0.a;
					var _v1 = $elm$core$String$toInt(w_);
					if (_v1.$ === 'Nothing') {
						return A2($author$project$Render$Export$Image$rescale, displayWidth, displayWidth);
					} else {
						var w = _v1.a;
						return A2($author$project$Render$Export$Image$rescale, displayWidth, w);
					}
				}
			}
		}();
		var caption = A3(
			$elm$core$String$replace,
			':',
			'',
			A2(
				$elm$core$Maybe$withDefault,
				'',
				A2($elm$core$Dict$get, 'caption', block.properties)));
		return {caption: caption, description: caption, fractionalWidth: fractionalWidth, placement: placement, url: url, width: width};
	});
var $author$project$Render$Export$Image$exportBlock = F2(
	function (settings, block) {
		var params = A2($author$project$Render$Export$Image$imageParametersForBlock, settings, block);
		var widthOption = (params.fractionalWidth === '') ? '0.75\\textwidth' : params.fractionalWidth;
		return A3($author$project$Render$Export$Image$exportCenteredFigure, params.url, widthOption, params.caption);
	});
var $author$project$Render$Export$LaTeX$blindIndex = '';
var $author$project$Generic$ASTTools$exprListToStringList = function (exprList) {
	return A2(
		$elm$core$List$filter,
		function (s) {
			return s !== '';
		},
		A2(
			$elm$core$List$map,
			$elm$core$String$trim,
			$elm_community$maybe_extra$Maybe$Extra$values(
				A2($elm$core$List$map, $author$project$Generic$ASTTools$getText, exprList))));
};
var $author$project$Render$Export$Util$getArgs = A2(
	$elm$core$Basics$composeR,
	$author$project$Generic$ASTTools$exprListToStringList,
	A2(
		$elm$core$Basics$composeR,
		$elm$core$List$map($elm$core$String$words),
		A2(
			$elm$core$Basics$composeR,
			$elm$core$List$concat,
			$elm$core$List$filter(
				function (x) {
					return x !== '';
				}))));
var $author$project$Render$Export$LaTeX$bolditalic = function (exprs) {
	var args = A2(
		$elm$core$String$join,
		' ',
		$author$project$Render$Export$Util$getArgs(exprs));
	return '\\textbf{\\emph{' + (args + '}}');
};
var $author$project$Render$Export$LaTeX$brackets = function (exprs) {
	return '[' + (A2(
		$elm$core$String$join,
		' ',
		$author$project$Render$Export$Util$getArgs(exprs)) + ']');
};
var $author$project$Render$Export$LaTeX$bt = function (_v0) {
	return '`';
};
var $author$project$Render$Export$LaTeX$dontRender = F2(
	function (_v0, _v1) {
		return '';
	});
var $author$project$Render$Export$Image$exportWrappedFigure = F4(
	function (placement, url, options, caption) {
		var placementChar = function () {
			switch (placement) {
				case 'L':
					return 'l';
				case 'R':
					return 'r';
				default:
					return 'r';
			}
		}();
		if ((caption === 'none') || (caption === '')) {
			return A2(
				$elm$core$String$join,
				'',
				_List_fromArray(
					['\\begin{wrapfigure}{' + (placementChar + ('}{' + (options + '}\n'))), '\\centering\n', '\\includegraphics[width=' + (options + (']{' + (url + '}\n'))), '\\end{wrapfigure}']));
		} else {
			var label = A2(
				$elm$core$String$filter,
				$elm$core$Char$isAlphaNum,
				$elm$core$String$toLower(
					A2(
						$elm$core$String$join,
						'',
						A2(
							$elm$core$List$take,
							2,
							$elm$core$String$words(caption)))));
			return A2(
				$elm$core$String$join,
				'',
				_List_fromArray(
					['\\begin{wrapfigure}{' + (placementChar + ('}{' + (options + '}\n'))), '\\centering\n', '\\includegraphics[width=' + (options + (']{' + (url + '}\n'))), '\\caption{' + (caption + '}\n'), '\\label{fig:' + (label + '}\n'), '\\end{wrapfigure}']));
		}
	});
var $author$project$Tools$Utility$pairFromList = function (strings) {
	if ((strings.b && strings.b.b) && (!strings.b.b.b)) {
		var x = strings.a;
		var _v1 = strings.b;
		var y = _v1.a;
		return $elm$core$Maybe$Just(
			_Utils_Tuple2(x, y));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Tools$Utility$keyValueDict = function (strings_) {
	return $elm$core$Dict$fromList(
		$elm_community$maybe_extra$Maybe$Extra$values(
			A2(
				$elm$core$List$map,
				$author$project$Tools$Utility$pairFromList,
				A2(
					$elm$core$List$map,
					$elm$core$List$map($elm$core$String$trim),
					A2(
						$elm$core$List$map,
						$elm$core$String$split(':'),
						strings_)))));
};
var $author$project$Render$Export$Image$imageParameters = F2(
	function (settings, body) {
		var displayWidth = settings.width;
		var _arguments = $elm$core$List$concat(
			A2(
				$elm$core$List$map,
				$elm$core$String$words,
				$author$project$Generic$ASTTools$exprListToStringList(body)));
		var remainingArguments = A2($elm$core$List$drop, 1, _arguments);
		var keyValueStrings_ = A2(
			$elm$core$List$filter,
			function (s) {
				return A2($elm$core$String$contains, ':', s);
			},
			remainingArguments);
		var captionLeadString = A3(
			$elm$core$String$replace,
			'caption:',
			'',
			A2(
				$elm$core$String$join,
				'',
				A2(
					$elm$core$List$filter,
					function (s) {
						return A2($elm$core$String$contains, 'caption', s);
					},
					keyValueStrings_)));
		var caption = A2(
			$elm$core$String$join,
			' ',
			A2(
				$elm$core$List$cons,
				captionLeadString,
				A2(
					$elm$core$List$filter,
					function (s) {
						return !A2($elm$core$String$contains, ':', s);
					},
					remainingArguments)));
		var keyValueStrings = A2(
			$elm$core$List$filter,
			function (s) {
				return !A2($elm$core$String$contains, 'caption', s);
			},
			keyValueStrings_);
		var dict = $author$project$Tools$Utility$keyValueDict(keyValueStrings);
		var description = A2(
			$elm$core$Maybe$withDefault,
			'',
			A2($elm$core$Dict$get, 'caption', dict));
		var fractionalWidth = function () {
			var _v3 = A2($elm$core$Dict$get, 'width', dict);
			if (_v3.$ === 'Nothing') {
				return $author$project$Render$Export$Image$fractionaRescale(displayWidth);
			} else {
				if (_v3.a === 'fill') {
					return $author$project$Render$Export$Image$fractionaRescale(displayWidth);
				} else {
					var w_ = _v3.a;
					var _v4 = $elm$core$String$toInt(w_);
					if (_v4.$ === 'Nothing') {
						return $author$project$Render$Export$Image$fractionaRescale(displayWidth);
					} else {
						var w = _v4.a;
						return $author$project$Render$Export$Image$fractionaRescale(w);
					}
				}
			}
		}();
		var placement = function () {
			var _v2 = A2($elm$core$Dict$get, 'placement', dict);
			if (_v2.$ === 'Nothing') {
				return 'C';
			} else {
				switch (_v2.a) {
					case 'left':
						return 'L';
					case 'right':
						return 'R';
					case 'center':
						return 'C';
					default:
						return 'C';
				}
			}
		}();
		var width = function () {
			var _v0 = A2($elm$core$Dict$get, 'width', dict);
			if (_v0.$ === 'Nothing') {
				return A2($author$project$Render$Export$Image$rescale, displayWidth, displayWidth);
			} else {
				if (_v0.a === 'fill') {
					return A2($author$project$Render$Export$Image$rescale, displayWidth, displayWidth);
				} else {
					var w_ = _v0.a;
					var _v1 = $elm$core$String$toInt(w_);
					if (_v1.$ === 'Nothing') {
						return A2($author$project$Render$Export$Image$rescale, displayWidth, displayWidth);
					} else {
						var w = _v1.a;
						return A2($author$project$Render$Export$Image$rescale, displayWidth, w);
					}
				}
			}
		}();
		var url = A2(
			$elm$core$Maybe$withDefault,
			'no-image',
			$elm$core$List$head(_arguments));
		return {caption: caption, description: description, fractionalWidth: fractionalWidth, placement: placement, url: url, width: width};
	});
var $author$project$Render$Export$Image$export = F2(
	function (s, exprs) {
		var params = A2($author$project$Render$Export$Image$imageParameters, s, exprs);
		var widthOption = (params.fractionalWidth === '') ? '0.75\\textwidth' : params.fractionalWidth;
		return (params.url === 'no-image') ? 'ERROR IN IMAGE' : ((params.placement === 'C') ? A3($author$project$Render$Export$Image$exportCenteredFigure, params.url, widthOption, params.caption) : A4($author$project$Render$Export$Image$exportWrappedFigure, params.placement, params.url, params.fractionalWidth, params.caption));
	});
var $author$project$Render$Export$Util$getTwoArgs = function (exprs) {
	var args = $author$project$Render$Export$Util$getArgs(exprs);
	var n = $elm$core$List$length(args);
	var first = A2(
		$elm$core$String$join,
		' ',
		A2($elm$core$List$take, n - 1, args));
	var second = A2(
		$elm$core$String$join,
		'',
		A2($elm$core$List$drop, n - 1, args));
	return {first: first, second: second};
};
var $author$project$Render$Export$LaTeX$ilink = function (exprs) {
	var args = $author$project$Render$Export$Util$getTwoArgs(exprs);
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\\href{', 'https://scripta.io/s/', args.second, '}{', args.first, '}']));
};
var $author$project$Render$Export$LaTeX$lb = function (_v0) {
	return '[';
};
var $author$project$Render$Export$LaTeX$link = function (exprs) {
	var args = $author$project$Render$Export$Util$getTwoArgs(exprs);
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\\href{', args.second, '}{', args.first, '}']));
};
var $author$project$Render$Export$Util$getOneArg = function (exprs) {
	var _v0 = $elm$core$List$head(
		$author$project$Render$Export$Util$getArgs(exprs));
	if (_v0.$ === 'Nothing') {
		return '';
	} else {
		var str = _v0.a;
		return str;
	}
};
var $author$project$Render$Export$LaTeX$markwith = function (exprs) {
	var arg = $author$project$Render$Export$Util$getOneArg(exprs);
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\\markwith{', arg, '}']));
};
var $author$project$Render$Export$LaTeX$par = function (_v0) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\\par\\par']));
};
var $author$project$Render$Export$LaTeX$rb = function (_v0) {
	return ']';
};
var $author$project$Render$Export$LaTeX$underscore = function (_v0) {
	return '$\\_$';
};
var $author$project$Render$Export$LaTeX$vspace = function (exprs) {
	var arg = function (x) {
		return x + 'pt';
	}(
		$elm$core$String$fromFloat(
			function (x) {
				return x / 4.0;
			}(
				A2(
					$elm$core$Maybe$withDefault,
					0,
					$elm$core$String$toFloat(
						$author$project$Render$Export$Util$getOneArg(exprs))))));
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\\par\\vspace{', arg, '}']));
};
var $author$project$Render$Export$LaTeX$macroDict = $elm$core$Dict$fromList(
	_List_fromArray(
		[
			_Utils_Tuple2(
			'link',
			function (_v0) {
				return $author$project$Render$Export$LaTeX$link;
			}),
			_Utils_Tuple2(
			'ilink',
			function (_v1) {
				return $author$project$Render$Export$LaTeX$ilink;
			}),
			_Utils_Tuple2(
			'mark',
			function (_v2) {
				return $author$project$Render$Export$LaTeX$markwith;
			}),
			_Utils_Tuple2(
			'par',
			function (_v3) {
				return $author$project$Render$Export$LaTeX$par;
			}),
			_Utils_Tuple2(
			'index_',
			F2(
				function (_v4, _v5) {
					return $author$project$Render$Export$LaTeX$blindIndex;
				})),
			_Utils_Tuple2('image', $author$project$Render$Export$Image$export),
			_Utils_Tuple2(
			'vspace',
			function (_v6) {
				return $author$project$Render$Export$LaTeX$vspace;
			}),
			_Utils_Tuple2(
			'bolditalic',
			function (_v7) {
				return $author$project$Render$Export$LaTeX$bolditalic;
			}),
			_Utils_Tuple2(
			'brackets',
			function (_v8) {
				return $author$project$Render$Export$LaTeX$brackets;
			}),
			_Utils_Tuple2(
			'lb',
			function (_v9) {
				return $author$project$Render$Export$LaTeX$lb;
			}),
			_Utils_Tuple2(
			'rb',
			function (_v10) {
				return $author$project$Render$Export$LaTeX$rb;
			}),
			_Utils_Tuple2(
			'bt',
			function (_v11) {
				return $author$project$Render$Export$LaTeX$bt;
			}),
			_Utils_Tuple2(
			'underscore',
			function (_v12) {
				return $author$project$Render$Export$LaTeX$underscore;
			}),
			_Utils_Tuple2('tags', $author$project$Render$Export$LaTeX$dontRender)
		]));
var $author$project$Render$Export$LaTeX$mapChars1 = function (str) {
	return A3($elm$core$String$replace, '\\term_', '\\termx', str);
};
var $author$project$Render$Export$LaTeX$fixChars = function (str) {
	return A3(
		$elm$core$String$replace,
		'}',
		'\\}',
		A3($elm$core$String$replace, '{', '\\{', str));
};
var $author$project$ETeX$Transform$encloseB = function (str) {
	return '{' + (str + '}');
};
var $author$project$ETeX$Transform$encloseP = function (str) {
	return '(' + (str + ')');
};
var $author$project$ETeX$Transform$print = function (expr) {
	switch (expr.$) {
		case 'AlphaNum':
			var str = expr.a;
			return str;
		case 'LeftMathBrace':
			return '\\{';
		case 'RightMathBrace':
			return '\\}';
		case 'LeftParen':
			return '(';
		case 'RightParen':
			return ')';
		case 'MathSmallSpace':
			return '\\,';
		case 'MathMediumSpace':
			return '\\;';
		case 'MathSpace':
			return '\\ ';
		case 'F0':
			var str = expr.a;
			return '\\' + str;
		case 'Param':
			var k = expr.a;
			return '#' + $elm$core$String$fromInt(k);
		case 'Arg':
			var exprs = expr.a;
			return $author$project$ETeX$Transform$encloseB(
				$author$project$ETeX$Transform$printList(exprs));
		case 'PArg':
			var exprs = expr.a;
			return $author$project$ETeX$Transform$encloseP(
				$author$project$ETeX$Transform$printList(exprs));
		case 'Sub':
			var deco = expr.a;
			return '_' + $author$project$ETeX$Transform$printDeco(deco);
		case 'Super':
			var deco = expr.a;
			return '^' + $author$project$ETeX$Transform$printDeco(deco);
		case 'MathSymbols':
			var str = expr.a;
			return str;
		case 'WS':
			return ' ';
		case 'Macro':
			var name = expr.a;
			var body = expr.b;
			_v8$2:
			while (true) {
				if (body.b && (!body.b.b)) {
					switch (body.a.$) {
						case 'PArg':
							var exprs = body.a.a;
							return '\\' + (name + $author$project$ETeX$Transform$encloseB(
								$author$project$ETeX$Transform$printList(exprs)));
						case 'ParenthExpr':
							var exprs = body.a.a;
							return '\\' + (name + $author$project$ETeX$Transform$encloseB(
								$author$project$ETeX$Transform$printList(exprs)));
						default:
							break _v8$2;
					}
				} else {
					break _v8$2;
				}
			}
			if (body.b && (body.a.$ === 'PArg')) {
				return '\\' + (name + $author$project$ETeX$Transform$printMacroArgs(body));
			} else {
				return '\\' + (name + $author$project$ETeX$Transform$printList(body));
			}
		case 'FCall':
			var name = expr.a;
			var args = expr.b;
			return name + ('(' + ($author$project$ETeX$Transform$printArgList(args) + ')'));
		case 'Expr':
			var exprs = expr.a;
			return A2(
				$elm$core$String$join,
				'',
				A2($elm$core$List$map, $author$project$ETeX$Transform$print, exprs));
		case 'Comma':
			return ',';
		case 'ParenthExpr':
			var exprs = expr.a;
			return $author$project$ETeX$Transform$encloseP(
				$author$project$ETeX$Transform$printList(exprs));
		default:
			var str = expr.a;
			return '\\text{' + (str + '}');
	}
};
var $author$project$ETeX$Transform$printArgList = function (exprs) {
	if (!exprs.b) {
		return '';
	} else {
		if (exprs.a.$ === 'PArg') {
			if (!exprs.b.b) {
				var contents = exprs.a.a;
				return $author$project$ETeX$Transform$printList(contents);
			} else {
				if (exprs.b.a.$ === 'Comma') {
					var contents = exprs.a.a;
					var _v5 = exprs.b;
					var _v6 = _v5.a;
					var rest = _v5.b;
					return $author$project$ETeX$Transform$printList(contents) + (',' + $author$project$ETeX$Transform$printArgList(rest));
				} else {
					var contents = exprs.a.a;
					var rest = exprs.b;
					return _Utils_ap(
						$author$project$ETeX$Transform$printList(contents),
						$author$project$ETeX$Transform$printArgList(rest));
				}
			}
		} else {
			var other = exprs.a;
			var rest = exprs.b;
			return _Utils_ap(
				$author$project$ETeX$Transform$print(other),
				$author$project$ETeX$Transform$printArgList(rest));
		}
	}
};
var $author$project$ETeX$Transform$printDeco = function (deco) {
	if (deco.$ === 'DecoM') {
		var expr = deco.a;
		return $author$project$ETeX$Transform$print(expr);
	} else {
		var k = deco.a;
		return $elm$core$String$fromInt(k);
	}
};
var $author$project$ETeX$Transform$printList = function (exprs) {
	return A2(
		$elm$core$String$join,
		'',
		A2($elm$core$List$map, $author$project$ETeX$Transform$print, exprs));
};
var $author$project$ETeX$Transform$printMacroArgs = function (exprs) {
	if (!exprs.b) {
		return '';
	} else {
		if (exprs.a.$ === 'PArg') {
			if (!exprs.b.b) {
				var contents = exprs.a.a;
				return $author$project$ETeX$Transform$encloseB(
					$author$project$ETeX$Transform$printList(contents));
			} else {
				if (exprs.b.a.$ === 'Comma') {
					var contents = exprs.a.a;
					var _v1 = exprs.b;
					var _v2 = _v1.a;
					var rest = _v1.b;
					return _Utils_ap(
						$author$project$ETeX$Transform$encloseB(
							$author$project$ETeX$Transform$printList(contents)),
						$author$project$ETeX$Transform$printMacroArgs(rest));
				} else {
					var contents = exprs.a.a;
					var rest = exprs.b;
					return _Utils_ap(
						$author$project$ETeX$Transform$encloseB(
							$author$project$ETeX$Transform$printList(contents)),
						$author$project$ETeX$Transform$printMacroArgs(rest));
				}
			}
		} else {
			var other = exprs.a;
			var rest = exprs.b;
			return _Utils_ap(
				$author$project$ETeX$Transform$print(other),
				$author$project$ETeX$Transform$printMacroArgs(rest));
		}
	}
};
var $elm$core$Result$map = F2(
	function (func, ra) {
		if (ra.$ === 'Ok') {
			var a = ra.a;
			return $elm$core$Result$Ok(
				func(a));
		} else {
			var e = ra.a;
			return $elm$core$Result$Err(e);
		}
	});
var $elm$core$Result$map2 = F3(
	function (func, ra, rb) {
		if (ra.$ === 'Err') {
			var x = ra.a;
			return $elm$core$Result$Err(x);
		} else {
			var a = ra.a;
			if (rb.$ === 'Err') {
				var x = rb.a;
				return $elm$core$Result$Err(x);
			} else {
				var b = rb.a;
				return $elm$core$Result$Ok(
					A2(func, a, b));
			}
		}
	});
var $elm_community$result_extra$Result$Extra$combine = A2(
	$elm$core$List$foldr,
	$elm$core$Result$map2($elm$core$List$cons),
	$elm$core$Result$Ok(_List_Nil));
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
var $author$project$ETeX$Transform$manyHelp = F2(
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
var $author$project$ETeX$Transform$many = function (p) {
	return A2(
		$elm$parser$Parser$Advanced$loop,
		_List_Nil,
		$author$project$ETeX$Transform$manyHelp(p));
};
var $author$project$ETeX$Transform$AlphaNum = function (a) {
	return {$: 'AlphaNum', a: a};
};
var $author$project$ETeX$Transform$Arg = function (a) {
	return {$: 'Arg', a: a};
};
var $author$project$ETeX$Transform$DecoM = function (a) {
	return {$: 'DecoM', a: a};
};
var $author$project$ETeX$Transform$ExpectingBackslash = {$: 'ExpectingBackslash'};
var $author$project$ETeX$Transform$ExpectingCaret = {$: 'ExpectingCaret'};
var $author$project$ETeX$Transform$ExpectingLeftBrace = {$: 'ExpectingLeftBrace'};
var $author$project$ETeX$Transform$ExpectingLeftParen = {$: 'ExpectingLeftParen'};
var $author$project$ETeX$Transform$ExpectingRightBrace = {$: 'ExpectingRightBrace'};
var $author$project$ETeX$Transform$ExpectingRightParen = {$: 'ExpectingRightParen'};
var $author$project$ETeX$Transform$ExpectingUnderscore = {$: 'ExpectingUnderscore'};
var $author$project$ETeX$Transform$FCall = F2(
	function (a, b) {
		return {$: 'FCall', a: a, b: b};
	});
var $author$project$ETeX$Transform$Macro = F2(
	function (a, b) {
		return {$: 'Macro', a: a, b: b};
	});
var $author$project$ETeX$Transform$PArg = function (a) {
	return {$: 'PArg', a: a};
};
var $author$project$ETeX$Transform$ParenthExpr = function (a) {
	return {$: 'ParenthExpr', a: a};
};
var $author$project$ETeX$Transform$Sub = function (a) {
	return {$: 'Sub', a: a};
};
var $author$project$ETeX$Transform$Super = function (a) {
	return {$: 'Super', a: a};
};
var $author$project$ETeX$Transform$ExpectingAlpha = {$: 'ExpectingAlpha'};
var $author$project$ETeX$Transform$alphaNumParser_ = A2(
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
					A2($elm$parser$Parser$Advanced$chompIf, $elm$core$Char$isAlpha, $author$project$ETeX$Transform$ExpectingAlpha)),
				$elm$parser$Parser$Advanced$chompWhile($elm$core$Char$isAlphaNum))),
		$elm$parser$Parser$Advanced$getOffset),
	$elm$parser$Parser$Advanced$getSource);
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
var $author$project$ETeX$Transform$isUserDefinedMacro = F2(
	function (dict, name) {
		return A2($elm$core$Dict$member, name, dict);
	});
var $author$project$ETeX$Transform$alphaNumOrMacroParser = function (userMacroDict) {
	return A2(
		$elm$parser$Parser$Advanced$map,
		function (name) {
			return ($author$project$ETeX$KaTeX$isKaTeX(name) || A2($author$project$ETeX$Transform$isUserDefinedMacro, userMacroDict, name)) ? A2($author$project$ETeX$Transform$Macro, name, _List_Nil) : $author$project$ETeX$Transform$AlphaNum(name);
		},
		$author$project$ETeX$Transform$alphaNumParser_);
};
var $author$project$ETeX$Transform$Comma = {$: 'Comma'};
var $author$project$ETeX$Transform$ExpectingComma = {$: 'ExpectingComma'};
var $author$project$ETeX$Transform$commaParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$Transform$Comma),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, ',', $author$project$ETeX$Transform$ExpectingComma)));
var $author$project$ETeX$Transform$F0 = function (a) {
	return {$: 'F0', a: a};
};
var $author$project$ETeX$Transform$second = F2(
	function (p, q) {
		return A2(
			$elm$parser$Parser$Advanced$andThen,
			function (_v0) {
				return q;
			},
			p);
	});
var $author$project$ETeX$Transform$f0Parser = A2(
	$elm$parser$Parser$Advanced$map,
	$author$project$ETeX$Transform$F0,
	A2(
		$author$project$ETeX$Transform$second,
		$elm$parser$Parser$Advanced$symbol(
			A2($elm$parser$Parser$Advanced$Token, '\\', $author$project$ETeX$Transform$ExpectingBackslash)),
		$author$project$ETeX$Transform$alphaNumParser_));
var $elm$parser$Parser$Advanced$lazy = function (thunk) {
	return $elm$parser$Parser$Advanced$Parser(
		function (s) {
			var _v0 = thunk(_Utils_Tuple0);
			var parse = _v0.a;
			return parse(s);
		});
};
var $author$project$ETeX$Transform$ExpectingLeftMathBrace = {$: 'ExpectingLeftMathBrace'};
var $author$project$ETeX$Transform$LeftMathBrace = {$: 'LeftMathBrace'};
var $author$project$ETeX$Transform$leftBraceParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$Transform$LeftMathBrace),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '\\{', $author$project$ETeX$Transform$ExpectingLeftMathBrace)));
var $author$project$ETeX$Transform$many1 = function (p) {
	return A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			$elm$parser$Parser$Advanced$succeed($elm$core$List$cons),
			p),
		$author$project$ETeX$Transform$many(p));
};
var $author$project$ETeX$Transform$ExpectingMathMediumSpace = {$: 'ExpectingMathMediumSpace'};
var $author$project$ETeX$Transform$MathMediumSpace = {$: 'MathMediumSpace'};
var $author$project$ETeX$Transform$mathMediumSpaceParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$Transform$MathMediumSpace),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '\\;', $author$project$ETeX$Transform$ExpectingMathMediumSpace)));
var $author$project$ETeX$Transform$ExpectingMathSmallSpace = {$: 'ExpectingMathSmallSpace'};
var $author$project$ETeX$Transform$MathSmallSpace = {$: 'MathSmallSpace'};
var $author$project$ETeX$Transform$mathSmallSpaceParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$Transform$MathSmallSpace),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '\\,', $author$project$ETeX$Transform$ExpectingMathSmallSpace)));
var $author$project$ETeX$Transform$ExpectingMathSpace = {$: 'ExpectingMathSpace'};
var $author$project$ETeX$Transform$MathSpace = {$: 'MathSpace'};
var $author$project$ETeX$Transform$mathSpaceParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$Transform$MathSpace),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '\\ ', $author$project$ETeX$Transform$ExpectingMathSpace)));
var $author$project$ETeX$Transform$ExpectingNotAlpha = {$: 'ExpectingNotAlpha'};
var $author$project$ETeX$Transform$MathSymbols = function (a) {
	return {$: 'MathSymbols', a: a};
};
var $author$project$ETeX$Transform$mathSymbolsParser = A2(
	$elm$parser$Parser$Advanced$map,
	$author$project$ETeX$Transform$MathSymbols,
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
											_Utils_chr(','),
											_Utils_chr('\"')
										])));
							},
							$author$project$ETeX$Transform$ExpectingNotAlpha)),
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
										_Utils_chr(','),
										_Utils_chr('\"')
									])));
						}))),
			$elm$parser$Parser$Advanced$getOffset),
		$elm$parser$Parser$Advanced$getSource));
var $author$project$ETeX$Transform$DecoI = function (a) {
	return {$: 'DecoI', a: a};
};
var $author$project$ETeX$Transform$ExpectingInt = {$: 'ExpectingInt'};
var $author$project$ETeX$Transform$InvalidNumber = {$: 'InvalidNumber'};
var $author$project$ETeX$Transform$numericDecoParser = A2(
	$elm$parser$Parser$Advanced$map,
	$author$project$ETeX$Transform$DecoI,
	A2($elm$parser$Parser$Advanced$int, $author$project$ETeX$Transform$ExpectingInt, $author$project$ETeX$Transform$InvalidNumber));
var $author$project$ETeX$Transform$ExpectingHash = {$: 'ExpectingHash'};
var $author$project$ETeX$Transform$Param = function (a) {
	return {$: 'Param', a: a};
};
var $author$project$ETeX$Transform$paramParser = A2(
	$elm$parser$Parser$Advanced$map,
	$author$project$ETeX$Transform$Param,
	A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$ignorer,
			$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
			$elm$parser$Parser$Advanced$symbol(
				A2($elm$parser$Parser$Advanced$Token, '#', $author$project$ETeX$Transform$ExpectingHash))),
		A2($elm$parser$Parser$Advanced$int, $author$project$ETeX$Transform$ExpectingInt, $author$project$ETeX$Transform$InvalidNumber)));
var $author$project$ETeX$Transform$ExpectingRightMathBrace = {$: 'ExpectingRightMathBrace'};
var $author$project$ETeX$Transform$RightMathBrace = {$: 'RightMathBrace'};
var $author$project$ETeX$Transform$rightBraceParser = A2(
	$elm$parser$Parser$Advanced$ignorer,
	$elm$parser$Parser$Advanced$succeed($author$project$ETeX$Transform$RightMathBrace),
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, '\\}', $author$project$ETeX$Transform$ExpectingRightMathBrace)));
var $author$project$ETeX$Transform$sepByCommaHelp = F2(
	function (itemParser, revItems) {
		return $elm$parser$Parser$Advanced$oneOf(
			_List_fromArray(
				[
					A2(
					$elm$parser$Parser$Advanced$keeper,
					A2(
						$elm$parser$Parser$Advanced$ignorer,
						$elm$parser$Parser$Advanced$succeed(
							function (item) {
								return $elm$parser$Parser$Advanced$Loop(
									A2(
										$elm$core$List$cons,
										item,
										A2($elm$core$List$cons, $author$project$ETeX$Transform$Comma, revItems)));
							}),
						$elm$parser$Parser$Advanced$symbol(
							A2($elm$parser$Parser$Advanced$Token, ',', $author$project$ETeX$Transform$ExpectingComma))),
					itemParser),
					$elm$parser$Parser$Advanced$succeed(
					$elm$parser$Parser$Advanced$Done(
						$elm$core$List$reverse(revItems)))
				]));
	});
var $author$project$ETeX$Transform$sepByComma = function (itemParser) {
	return $elm$parser$Parser$Advanced$oneOf(
		_List_fromArray(
			[
				A2(
				$elm$parser$Parser$Advanced$andThen,
				function (firstItem) {
					return A2(
						$elm$parser$Parser$Advanced$loop,
						_List_fromArray(
							[firstItem]),
						$author$project$ETeX$Transform$sepByCommaHelp(itemParser));
				},
				itemParser),
				$elm$parser$Parser$Advanced$succeed(_List_Nil)
			]));
};
var $author$project$ETeX$Transform$ExpectingQuote = {$: 'ExpectingQuote'};
var $author$project$ETeX$Transform$Text = function (a) {
	return {$: 'Text', a: a};
};
var $elm$parser$Parser$Advanced$mapChompedString = F2(
	function (func, _v0) {
		var parse = _v0.a;
		return $elm$parser$Parser$Advanced$Parser(
			function (s0) {
				var _v1 = parse(s0);
				if (_v1.$ === 'Bad') {
					var p = _v1.a;
					var x = _v1.b;
					return A2($elm$parser$Parser$Advanced$Bad, p, x);
				} else {
					var p = _v1.a;
					var a = _v1.b;
					var s1 = _v1.c;
					return A3(
						$elm$parser$Parser$Advanced$Good,
						p,
						A2(
							func,
							A3($elm$core$String$slice, s0.offset, s1.offset, s0.src),
							a),
						s1);
				}
			});
	});
var $elm$parser$Parser$Advanced$getChompedString = function (parser) {
	return A2($elm$parser$Parser$Advanced$mapChompedString, $elm$core$Basics$always, parser);
};
var $author$project$ETeX$Transform$textParser = A2(
	$elm$parser$Parser$Advanced$keeper,
	A2(
		$elm$parser$Parser$Advanced$ignorer,
		$elm$parser$Parser$Advanced$succeed($author$project$ETeX$Transform$Text),
		$elm$parser$Parser$Advanced$symbol(
			A2($elm$parser$Parser$Advanced$Token, '\"', $author$project$ETeX$Transform$ExpectingQuote))),
	A2(
		$elm$parser$Parser$Advanced$ignorer,
		$elm$parser$Parser$Advanced$getChompedString(
			$elm$parser$Parser$Advanced$chompWhile(
				function (c) {
					return !_Utils_eq(
						c,
						_Utils_chr('\"'));
				})),
		$elm$parser$Parser$Advanced$symbol(
			A2($elm$parser$Parser$Advanced$Token, '\"', $author$project$ETeX$Transform$ExpectingQuote))));
var $author$project$ETeX$Transform$ExpectingSpace = {$: 'ExpectingSpace'};
var $author$project$ETeX$Transform$WS = {$: 'WS'};
var $author$project$ETeX$Transform$whitespaceParser = A2(
	$elm$parser$Parser$Advanced$map,
	function (_v0) {
		return $author$project$ETeX$Transform$WS;
	},
	$elm$parser$Parser$Advanced$symbol(
		A2($elm$parser$Parser$Advanced$Token, ' ', $author$project$ETeX$Transform$ExpectingSpace)));
var $author$project$ETeX$Transform$alphaNumWithLookaheadParser = function (userMacroDict) {
	return A2(
		$elm$parser$Parser$Advanced$andThen,
		function (name) {
			return $elm$parser$Parser$Advanced$oneOf(
				_List_fromArray(
					[
						A2(
						$elm$parser$Parser$Advanced$map,
						function (args) {
							return ($author$project$ETeX$KaTeX$isKaTeX(name) || A2($author$project$ETeX$Transform$isUserDefinedMacro, userMacroDict, name)) ? A2($author$project$ETeX$Transform$Macro, name, args) : A2($author$project$ETeX$Transform$FCall, name, args);
						},
						$author$project$ETeX$Transform$functionArgsParser(userMacroDict)),
						$elm$parser$Parser$Advanced$succeed(
						($author$project$ETeX$KaTeX$isKaTeX(name) || A2($author$project$ETeX$Transform$isUserDefinedMacro, userMacroDict, name)) ? A2($author$project$ETeX$Transform$Macro, name, _List_Nil) : $author$project$ETeX$Transform$AlphaNum(name))
					]));
		},
		A2(
			$elm$parser$Parser$Advanced$keeper,
			$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
			$author$project$ETeX$Transform$alphaNumParser_));
};
var $author$project$ETeX$Transform$argParser = function (userMacroDict) {
	return A2(
		$elm$parser$Parser$Advanced$map,
		$author$project$ETeX$Transform$Arg,
		A2(
			$elm$parser$Parser$Advanced$ignorer,
			A2(
				$elm$parser$Parser$Advanced$keeper,
				A2(
					$elm$parser$Parser$Advanced$ignorer,
					$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
					$elm$parser$Parser$Advanced$symbol(
						A2($elm$parser$Parser$Advanced$Token, '{', $author$project$ETeX$Transform$ExpectingLeftBrace))),
				$elm$parser$Parser$Advanced$lazy(
					function (_v7) {
						return $author$project$ETeX$Transform$many(
							$author$project$ETeX$Transform$mathExprParser(userMacroDict));
					})),
			$elm$parser$Parser$Advanced$symbol(
				A2($elm$parser$Parser$Advanced$Token, '}', $author$project$ETeX$Transform$ExpectingRightBrace))));
};
var $author$project$ETeX$Transform$decoParser = function (userMacroDict) {
	return $elm$parser$Parser$Advanced$oneOf(
		_List_fromArray(
			[
				$author$project$ETeX$Transform$numericDecoParser,
				A2(
				$elm$parser$Parser$Advanced$map,
				$author$project$ETeX$Transform$DecoM,
				$elm$parser$Parser$Advanced$lazy(
					function (_v6) {
						return $author$project$ETeX$Transform$mathExprParser(userMacroDict);
					}))
			]));
};
var $author$project$ETeX$Transform$functionArgListParser = function (userMacroDict) {
	var argContentParser = $elm$parser$Parser$Advanced$oneOf(
		_List_fromArray(
			[
				$author$project$ETeX$Transform$textParser,
				$author$project$ETeX$Transform$mathMediumSpaceParser,
				$author$project$ETeX$Transform$mathSmallSpaceParser,
				$author$project$ETeX$Transform$mathSpaceParser,
				$author$project$ETeX$Transform$leftBraceParser,
				$author$project$ETeX$Transform$rightBraceParser,
				$author$project$ETeX$Transform$macroParser(userMacroDict),
				$author$project$ETeX$Transform$alphaNumOrMacroParser(userMacroDict),
				$author$project$ETeX$Transform$mathSymbolsParser,
				$elm$parser$Parser$Advanced$lazy(
				function (_v4) {
					return $author$project$ETeX$Transform$argParser(userMacroDict);
				}),
				$elm$parser$Parser$Advanced$lazy(
				function (_v5) {
					return $author$project$ETeX$Transform$standaloneParenthExprParser(userMacroDict);
				}),
				$author$project$ETeX$Transform$paramParser,
				$author$project$ETeX$Transform$whitespaceParser,
				$author$project$ETeX$Transform$f0Parser,
				$author$project$ETeX$Transform$subscriptParser(userMacroDict),
				$author$project$ETeX$Transform$superscriptParser(userMacroDict)
			]));
	return $author$project$ETeX$Transform$sepByComma(
		A2(
			$elm$parser$Parser$Advanced$map,
			$author$project$ETeX$Transform$PArg,
			$author$project$ETeX$Transform$many1(argContentParser)));
};
var $author$project$ETeX$Transform$functionArgsParser = function (userMacroDict) {
	return A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$ignorer,
			$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
			$elm$parser$Parser$Advanced$symbol(
				A2($elm$parser$Parser$Advanced$Token, '(', $author$project$ETeX$Transform$ExpectingLeftParen))),
		A2(
			$elm$parser$Parser$Advanced$ignorer,
			$elm$parser$Parser$Advanced$lazy(
				function (_v3) {
					return $author$project$ETeX$Transform$functionArgListParser(userMacroDict);
				}),
			$elm$parser$Parser$Advanced$symbol(
				A2($elm$parser$Parser$Advanced$Token, ')', $author$project$ETeX$Transform$ExpectingRightParen))));
};
var $author$project$ETeX$Transform$macroParser = function (userMacroDict) {
	return A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$ignorer,
				$elm$parser$Parser$Advanced$succeed($author$project$ETeX$Transform$Macro),
				$elm$parser$Parser$Advanced$symbol(
					A2($elm$parser$Parser$Advanced$Token, '\\', $author$project$ETeX$Transform$ExpectingBackslash))),
			$author$project$ETeX$Transform$alphaNumParser_),
		$author$project$ETeX$Transform$many(
			$author$project$ETeX$Transform$argParser(userMacroDict)));
};
var $author$project$ETeX$Transform$mathExprParser = function (userMacroDict) {
	return $elm$parser$Parser$Advanced$oneOf(
		_List_fromArray(
			[
				$author$project$ETeX$Transform$textParser,
				$author$project$ETeX$Transform$mathMediumSpaceParser,
				$author$project$ETeX$Transform$mathSmallSpaceParser,
				$author$project$ETeX$Transform$mathSpaceParser,
				$author$project$ETeX$Transform$leftBraceParser,
				$author$project$ETeX$Transform$rightBraceParser,
				$author$project$ETeX$Transform$macroParser(userMacroDict),
				$author$project$ETeX$Transform$alphaNumWithLookaheadParser(userMacroDict),
				$elm$parser$Parser$Advanced$lazy(
				function (_v1) {
					return $author$project$ETeX$Transform$standaloneParenthExprParser(userMacroDict);
				}),
				$author$project$ETeX$Transform$commaParser,
				$author$project$ETeX$Transform$mathSymbolsParser,
				$elm$parser$Parser$Advanced$lazy(
				function (_v2) {
					return $author$project$ETeX$Transform$argParser(userMacroDict);
				}),
				$author$project$ETeX$Transform$paramParser,
				$author$project$ETeX$Transform$whitespaceParser,
				$author$project$ETeX$Transform$f0Parser,
				$author$project$ETeX$Transform$subscriptParser(userMacroDict),
				$author$project$ETeX$Transform$superscriptParser(userMacroDict)
			]));
};
var $author$project$ETeX$Transform$standaloneParenthExprParser = function (userMacroDict) {
	return A2(
		$elm$parser$Parser$Advanced$map,
		$author$project$ETeX$Transform$ParenthExpr,
		A2(
			$elm$parser$Parser$Advanced$ignorer,
			A2(
				$elm$parser$Parser$Advanced$keeper,
				A2(
					$elm$parser$Parser$Advanced$ignorer,
					$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
					$elm$parser$Parser$Advanced$symbol(
						A2($elm$parser$Parser$Advanced$Token, '(', $author$project$ETeX$Transform$ExpectingLeftParen))),
				$elm$parser$Parser$Advanced$lazy(
					function (_v0) {
						return $author$project$ETeX$Transform$many(
							$author$project$ETeX$Transform$mathExprParser(userMacroDict));
					})),
			$elm$parser$Parser$Advanced$symbol(
				A2($elm$parser$Parser$Advanced$Token, ')', $author$project$ETeX$Transform$ExpectingRightParen))));
};
var $author$project$ETeX$Transform$subscriptParser = function (userMacroDict) {
	return A2(
		$elm$parser$Parser$Advanced$map,
		$author$project$ETeX$Transform$Sub,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$ignorer,
				$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
				$elm$parser$Parser$Advanced$symbol(
					A2($elm$parser$Parser$Advanced$Token, '_', $author$project$ETeX$Transform$ExpectingUnderscore))),
			$author$project$ETeX$Transform$decoParser(userMacroDict)));
};
var $author$project$ETeX$Transform$superscriptParser = function (userMacroDict) {
	return A2(
		$elm$parser$Parser$Advanced$map,
		$author$project$ETeX$Transform$Super,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$ignorer,
				$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
				$elm$parser$Parser$Advanced$symbol(
					A2($elm$parser$Parser$Advanced$Token, '^', $author$project$ETeX$Transform$ExpectingCaret))),
			$author$project$ETeX$Transform$decoParser(userMacroDict)));
};
var $author$project$ETeX$Transform$parseWithDict = F2(
	function (userMacroDict, str) {
		return A2(
			$elm$parser$Parser$Advanced$run,
			$author$project$ETeX$Transform$many(
				$author$project$ETeX$Transform$mathExprParser(userMacroDict)),
			str);
	});
var $author$project$ETeX$Transform$parseManyWithDict = F2(
	function (userMacroDict, str) {
		return A2(
			$elm$core$Result$map,
			$elm$core$List$concat,
			$elm_community$result_extra$Result$Extra$combine(
				A2(
					$elm$core$List$map,
					$author$project$ETeX$Transform$parseWithDict(userMacroDict),
					A2(
						$elm$core$List$map,
						$elm$core$String$trim,
						$elm$core$String$lines(
							$elm$core$String$trim(str))))));
	});
var $author$project$ETeX$Transform$parseMany = F2(
	function (userDefinedMacroDict, str) {
		return A2($author$project$ETeX$Transform$parseManyWithDict, userDefinedMacroDict, str);
	});
var $author$project$ETeX$Transform$Expr = function (a) {
	return {$: 'Expr', a: a};
};
var $author$project$ETeX$Transform$LeftParen = {$: 'LeftParen'};
var $author$project$ETeX$Transform$RightParen = {$: 'RightParen'};
var $author$project$ETeX$Dictionary$symbolDict = $elm$core$Dict$fromList(
	_List_fromArray(
		[
			_Utils_Tuple2('qquad', '\\qquad'),
			_Utils_Tuple2('alpha', '\\alpha'),
			_Utils_Tuple2('beta', '\\beta'),
			_Utils_Tuple2('gamma', '\\gamma'),
			_Utils_Tuple2('delta', '\\delta'),
			_Utils_Tuple2('epsilon', '\\epsilon'),
			_Utils_Tuple2('zeta', '\\zeta'),
			_Utils_Tuple2('eta', '\\eta'),
			_Utils_Tuple2('theta', '\\theta'),
			_Utils_Tuple2('iota', '\\iota'),
			_Utils_Tuple2('kappa', '\\kappa'),
			_Utils_Tuple2('lambda', '\\lambda'),
			_Utils_Tuple2('mu', '\\mu'),
			_Utils_Tuple2('nu', '\\nu'),
			_Utils_Tuple2('xi', '\\xi'),
			_Utils_Tuple2('omicron', '\\omicron'),
			_Utils_Tuple2('pi', '\\pi'),
			_Utils_Tuple2('rho', '\\rho'),
			_Utils_Tuple2('sigma', '\\sigma'),
			_Utils_Tuple2('tau', '\\tau'),
			_Utils_Tuple2('upsilon', '\\upsilon'),
			_Utils_Tuple2('phi', '\\phi'),
			_Utils_Tuple2('chi', '\\chi'),
			_Utils_Tuple2('psi', '\\psi'),
			_Utils_Tuple2('omega', '\\omega'),
			_Utils_Tuple2('Alpha', '\\Alpha'),
			_Utils_Tuple2('Beta', '\\Beta'),
			_Utils_Tuple2('Gamma', '\\Gamma'),
			_Utils_Tuple2('Delta', '\\Delta'),
			_Utils_Tuple2('Epsilon', '\\Epsilon'),
			_Utils_Tuple2('Zeta', '\\Zeta'),
			_Utils_Tuple2('Eta', '\\Eta'),
			_Utils_Tuple2('Theta', '\\Theta'),
			_Utils_Tuple2('Iota', '\\Iota'),
			_Utils_Tuple2('Kappa', '\\Kappa'),
			_Utils_Tuple2('Lambda', '\\Lambda'),
			_Utils_Tuple2('Mu', '\\Mu'),
			_Utils_Tuple2('Nu', '\\Nu'),
			_Utils_Tuple2('Xi', '\\Xi'),
			_Utils_Tuple2('Omicron', '\\Omicron'),
			_Utils_Tuple2('Pi', '\\Pi'),
			_Utils_Tuple2('Rho', '\\Rho'),
			_Utils_Tuple2('Sigma', '\\Sigma'),
			_Utils_Tuple2('Tau', '\\Tau'),
			_Utils_Tuple2('Upsilon', '\\Upsilon'),
			_Utils_Tuple2('Phi', '\\Phi'),
			_Utils_Tuple2('Chi', '\\Chi'),
			_Utils_Tuple2('Psi', '\\Psi'),
			_Utils_Tuple2('Omega', '\\Omega'),
			_Utils_Tuple2('varepsilon', '\\varepsilon'),
			_Utils_Tuple2('vartheta', '\\vartheta'),
			_Utils_Tuple2('varpi', '\\varpi'),
			_Utils_Tuple2('varrho', '\\varrho'),
			_Utils_Tuple2('varsigma', '\\varsigma'),
			_Utils_Tuple2('varphi', '\\varphi')
		]));
var $author$project$ETeX$Transform$resolveSymbolName = function (expr) {
	switch (expr.$) {
		case 'AlphaNum':
			var str = expr.a;
			var _v2 = A2($elm$core$Dict$get, str, $author$project$ETeX$Dictionary$symbolDict);
			if (_v2.$ === 'Just') {
				return $author$project$ETeX$Transform$AlphaNum('\\' + str);
			} else {
				return $author$project$ETeX$Transform$AlphaNum(str);
			}
		case 'PArg':
			var exprs = expr.a;
			return $author$project$ETeX$Transform$PArg(
				A2($elm$core$List$map, $author$project$ETeX$Transform$resolveSymbolName, exprs));
		case 'ParenthExpr':
			var exprs = expr.a;
			return $author$project$ETeX$Transform$ParenthExpr(
				A2($elm$core$List$map, $author$project$ETeX$Transform$resolveSymbolName, exprs));
		case 'Macro':
			var name = expr.a;
			var args = expr.b;
			return A2(
				$author$project$ETeX$Transform$Macro,
				name,
				A2($elm$core$List$map, $author$project$ETeX$Transform$resolveSymbolName, args));
		case 'F0':
			var str = expr.a;
			return $author$project$ETeX$Transform$F0(str);
		case 'Arg':
			var exprs = expr.a;
			return $author$project$ETeX$Transform$Arg(
				A2($elm$core$List$map, $author$project$ETeX$Transform$resolveSymbolName, exprs));
		case 'Sub':
			var deco = expr.a;
			return $author$project$ETeX$Transform$Sub(
				$author$project$ETeX$Transform$resolveSymbolNameInDeco(deco));
		case 'Super':
			var deco = expr.a;
			return $author$project$ETeX$Transform$Super(
				$author$project$ETeX$Transform$resolveSymbolNameInDeco(deco));
		case 'Param':
			var n = expr.a;
			return $author$project$ETeX$Transform$Param(n);
		case 'WS':
			return $author$project$ETeX$Transform$WS;
		case 'MathSpace':
			return $author$project$ETeX$Transform$MathSpace;
		case 'MathSmallSpace':
			return $author$project$ETeX$Transform$MathSmallSpace;
		case 'MathMediumSpace':
			return $author$project$ETeX$Transform$MathMediumSpace;
		case 'LeftMathBrace':
			return $author$project$ETeX$Transform$LeftMathBrace;
		case 'RightMathBrace':
			return $author$project$ETeX$Transform$RightMathBrace;
		case 'LeftParen':
			return $author$project$ETeX$Transform$LeftParen;
		case 'RightParen':
			return $author$project$ETeX$Transform$RightParen;
		case 'Comma':
			return $author$project$ETeX$Transform$Comma;
		case 'MathSymbols':
			var str = expr.a;
			return $author$project$ETeX$Transform$MathSymbols(str);
		case 'FCall':
			var name = expr.a;
			var args = expr.b;
			return A2(
				$author$project$ETeX$Transform$FCall,
				name,
				A2($elm$core$List$map, $author$project$ETeX$Transform$resolveSymbolName, args));
		case 'Expr':
			var exprs = expr.a;
			return $author$project$ETeX$Transform$Expr(
				A2($elm$core$List$map, $author$project$ETeX$Transform$resolveSymbolName, exprs));
		default:
			var str = expr.a;
			return $author$project$ETeX$Transform$Text(str);
	}
};
var $author$project$ETeX$Transform$resolveSymbolNameInDeco = function (deco) {
	if (deco.$ === 'DecoM') {
		var expr = deco.a;
		return $author$project$ETeX$Transform$DecoM(
			$author$project$ETeX$Transform$resolveSymbolName(expr));
	} else {
		var n = deco.a;
		return $author$project$ETeX$Transform$DecoI(n);
	}
};
var $author$project$ETeX$Transform$resolveSymbolNames = function (exprs) {
	return A2($elm$core$List$map, $author$project$ETeX$Transform$resolveSymbolName, exprs);
};
var $author$project$ETeX$Transform$transformETeX_ = F2(
	function (userdefinedMacroDict, src) {
		return A2(
			$elm$core$Result$map,
			$author$project$ETeX$Transform$resolveSymbolNames,
			A2($author$project$ETeX$Transform$parseMany, userdefinedMacroDict, src));
	});
var $author$project$ETeX$Transform$transformETeX = F2(
	function (userdefinedMacroDict, src) {
		var _v0 = A2($author$project$ETeX$Transform$transformETeX_, userdefinedMacroDict, src);
		if (_v0.$ === 'Ok') {
			var result = _v0.a;
			return A2(
				$elm$core$String$join,
				'',
				A2($elm$core$List$map, $author$project$ETeX$Transform$print, result));
		} else {
			return src;
		}
	});
var $author$project$MicroLaTeX$Util$transformLabel = function (str) {
	var normalize = function (m) {
		return $elm$core$String$trim(
			A2(
				$elm$core$String$join,
				'',
				A2(
					$elm$core$List$map,
					$elm$core$Maybe$withDefault(''),
					m)));
	};
	return A3(
		$author$project$Tools$Utility$userReplace,
		'\\[label(.*)\\]',
		function (m) {
			return '\\label{' + (normalize(m.submatches) + '}');
		},
		str);
};
var $author$project$Render$Export$LaTeX$inlineCode = function (str) {
	return '\\verb`' + (str + '`');
};
var $author$project$Render$Export$LaTeX$inlineMath = function (str) {
	return '$' + (str + '$');
};
var $author$project$Render$Export$LaTeX$verbatimExprDict = $elm$core$Dict$fromList(
	_List_fromArray(
		[
			_Utils_Tuple2('code', $author$project$Render$Export$LaTeX$inlineCode),
			_Utils_Tuple2('math', $author$project$Render$Export$LaTeX$inlineMath)
		]));
var $author$project$Render$Export$LaTeX$renderVerbatim = F3(
	function (mathMacroDict, name, body) {
		var _v0 = A2($elm$core$Dict$get, name, $author$project$Render$Export$LaTeX$verbatimExprDict);
		if (_v0.$ === 'Nothing') {
			return name + ('(' + (body + ') — unimplemented '));
		} else {
			var f = _v0.a;
			return A2(
				$elm$core$List$member,
				name,
				_List_fromArray(
					['equation', 'aligned', 'math'])) ? f(
				A2(
					$author$project$ETeX$Transform$transformETeX,
					mathMacroDict,
					$author$project$MicroLaTeX$Util$transformLabel(body))) : f(
				$author$project$MicroLaTeX$Util$transformLabel(
					$author$project$Render$Export$LaTeX$fixChars(body)));
		}
	});
var $author$project$Generic$TextMacro$toString = F2(
	function (exprToString, macro) {
		return A2(
			$elm$core$String$join,
			'',
			_List_fromArray(
				[
					'\\newcommand{\\',
					macro.name,
					'}[',
					$elm$core$String$fromInt(
					$elm$core$List$length(macro.vars)),
					']{',
					A2(
					$elm$core$String$join,
					'',
					A2($elm$core$List$map, exprToString, macro.body)),
					'}    '
				]));
	});
var $author$project$Render$Export$LaTeX$exportExpr = F3(
	function (mathMacroDict, settings, expr) {
		switch (expr.$) {
			case 'Fun':
				var name = expr.a;
				var exps_ = expr.b;
				if (name === 'lambda') {
					var _v1 = $author$project$Generic$TextMacro$extract(expr);
					if (_v1.$ === 'Just') {
						var lambda = _v1.a;
						return A2(
							$author$project$Generic$TextMacro$toString,
							A2($author$project$Render$Export$LaTeX$exportExpr, mathMacroDict, settings),
							lambda);
					} else {
						return 'Error extracting lambda';
					}
				} else {
					var _v2 = A2($elm$core$Dict$get, name, $author$project$Render$Export$LaTeX$macroDict);
					if (_v2.$ === 'Just') {
						var f = _v2.a;
						return A2(f, settings, exps_);
					} else {
						var exportedExprs = A2(
							$elm$core$List$map,
							A2($author$project$Render$Export$LaTeX$exportExpr, mathMacroDict, settings),
							exps_);
						var combinedContent = A2($elm$core$String$join, '', exportedExprs);
						return '\\' + ($author$project$Render$Export$LaTeX$unalias(name) + ('{' + (combinedContent + '}')));
					}
				}
			case 'Text':
				var str = expr.a;
				return $author$project$Render$Export$LaTeX$mapChars2(str);
			case 'VFun':
				var name = expr.a;
				var body = expr.b;
				return A3($author$project$Render$Export$LaTeX$renderVerbatim, mathMacroDict, name, body);
			default:
				var itemExprs = expr.a;
				return A3($author$project$Render$Export$LaTeX$exportExprList, mathMacroDict, settings, itemExprs);
		}
	});
var $author$project$Render$Export$LaTeX$exportExprList = F3(
	function (mathMacroDict, settings, exprs) {
		return $author$project$Render$Export$LaTeX$mapChars1(
			A2(
				$elm$core$String$join,
				'',
				A2(
					$elm$core$List$map,
					A2($author$project$Render$Export$LaTeX$exportExpr, mathMacroDict, settings),
					exprs)));
	});
var $author$project$Generic$TextMacro$toLaTeXString = function (expr) {
	switch (expr.$) {
		case 'Fun':
			var name = expr.a;
			var expressions = expr.b;
			var body_ = A2(
				$elm$core$String$join,
				'',
				A2($elm$core$List$map, $author$project$Generic$TextMacro$toLaTeXString, expressions));
			var body = (body_ === '') ? body_ : ((A2($elm$core$String$left, 1, body_) === '[') ? body_ : ((A2($elm$core$String$left, 1, body_) === ' ') ? body_ : (' ' + body_)));
			return '\\' + (name + ('{' + (body + '}')));
		case 'Text':
			var str = expr.a;
			return str;
		case 'VFun':
			var name = expr.a;
			var str = expr.b;
			switch (name) {
				case 'math':
					return '$' + (str + '$');
				case 'code':
					return '`' + (str + '`');
				default:
					return 'error: verbatim ' + (name + ' not recognized');
			}
		default:
			return '[ExprList]';
	}
};
var $author$project$Generic$TextMacro$printLaTeXMacro = function (macro) {
	return (!$elm$core$List$length(macro.vars)) ? ('\\newcommand{\\' + (macro.name + ('}{' + (A2(
		$elm$core$String$join,
		'',
		A2($elm$core$List$map, $author$project$Generic$TextMacro$toLaTeXString, macro.body)) + '}')))) : ('\\newcommand{\\' + (macro.name + ('}' + ('[' + ($elm$core$String$fromInt(
		$elm$core$List$length(macro.vars)) + (']{' + (A2(
		$elm$core$String$join,
		'',
		A2($elm$core$List$map, $author$project$Generic$TextMacro$toLaTeXString, macro.body)) + '}')))))));
};
var $author$project$Generic$TextMacro$exportTexMacros = function (str) {
	return A2(
		$elm$core$String$join,
		'\n',
		A2(
			$elm$core$List$map,
			$author$project$Generic$TextMacro$printLaTeXMacro,
			A2(
				$elm$core$List$map,
				$elm$core$Tuple$second,
				$elm$core$Dict$toList(
					$author$project$Generic$TextMacro$buildDictionary(
						$elm$core$String$lines(str))))));
};
var $author$project$Render$Export$LaTeX$hideToPercentComment = function (str) {
	return (A2($elm$core$String$left, 6, str) === '\\hide{') ? function (s) {
		return '%% ' + s;
	}(
		A2(
			$elm$core$String$dropRight,
			1,
			A2($elm$core$String$dropLeft, 6, str))) : str;
};
var $elm$core$String$cons = _String_cons;
var $elm$core$String$fromChar = function (_char) {
	return A2($elm$core$String$cons, _char, '');
};
var $elm$core$Bitwise$and = _Bitwise_and;
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
var $elm$core$String$padRight = F3(
	function (n, _char, string) {
		return _Utils_ap(
			string,
			A2(
				$elm$core$String$repeat,
				n - $elm$core$String$length(string),
				$elm$core$String$fromChar(_char)));
	});
var $author$project$Render$Data$getVerbatimContent = function (block) {
	var _v0 = block.body;
	if (_v0.$ === 'Left') {
		var str = _v0.a;
		return str;
	} else {
		return '';
	}
};
var $elm$core$List$maximum = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(
			A3($elm$core$List$foldl, $elm$core$Basics$max, x, xs));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm_community$list_extra$List$Extra$rowsLength = function (listOfLists) {
	if (!listOfLists.b) {
		return 0;
	} else {
		var x = listOfLists.a;
		return $elm$core$List$length(x);
	}
};
var $elm_community$list_extra$List$Extra$transpose = function (listOfLists) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$List$map2($elm$core$List$cons),
		A2(
			$elm$core$List$repeat,
			$elm_community$list_extra$List$Extra$rowsLength(listOfLists),
			_List_Nil),
		listOfLists);
};
var $author$project$Render$Data$prepareTable = F2(
	function (fontWidth_, block) {
		var title = A2($elm$core$Dict$get, 'title', block.properties);
		var lines = A2(
			$elm$core$String$split,
			'\n',
			$author$project$Render$Data$getVerbatimContent(block));
		var rawCells = A2(
			$elm$core$List$map,
			$elm$core$List$map($elm$core$String$trim),
			A2(
				$elm$core$List$map,
				$elm$core$String$split(','),
				lines));
		var columnsToDisplay = A2(
			$elm$core$List$map,
			function (n) {
				return n - 1;
			},
			$elm_community$maybe_extra$Maybe$Extra$values(
				A2(
					$elm$core$List$map,
					A2($elm$core$Basics$composeR, $elm$core$String$trim, $elm$core$String$toInt),
					A2(
						$elm$core$Maybe$withDefault,
						_List_Nil,
						A2(
							$elm$core$Maybe$map,
							$elm$core$String$split(','),
							A2($elm$core$Dict$get, 'columns', block.properties))))));
		var selectedCells = function () {
			if (_Utils_eq(columnsToDisplay, _List_Nil)) {
				return rawCells;
			} else {
				var updater = F2(
					function (_v0, acc_) {
						var k = _v0.a;
						var col = _v0.b;
						return A2($elm$core$List$member, k, columnsToDisplay) ? A2($elm$core$List$cons, col, acc_) : acc_;
					});
				var cols = A2(
					$elm$core$List$indexedMap,
					F2(
						function (k, col) {
							return _Utils_Tuple2(k, col);
						}),
					$elm_community$list_extra$List$Extra$transpose(rawCells));
				var selectedCols = A3($elm$core$List$foldl, updater, _List_Nil, cols);
				return $elm_community$list_extra$List$Extra$transpose(
					$elm$core$List$reverse(selectedCols));
			}
		}();
		var columnWidths = A2(
			$elm$core$List$map,
			function (w) {
				return fontWidth_ * w;
			},
			A2(
				$elm$core$List$map,
				function (column) {
					return A2(
						$elm$core$Maybe$withDefault,
						1,
						$elm$core$List$maximum(column));
				},
				$elm_community$list_extra$List$Extra$transpose(
					A2(
						$elm$core$List$map,
						$elm$core$List$map($elm$core$String$length),
						selectedCells))));
		var totalWidth = $elm$core$List$sum(columnWidths);
		return {columnWidths: columnWidths, selectedCells: selectedCells, title: title, totalWidth: totalWidth};
	});
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $author$project$ETeX$MathMacros$MacroBody = F2(
	function (a, b) {
		return {$: 'MacroBody', a: a, b: b};
	});
var $author$project$ETeX$Transform$findMaxParamInMathMacros = function (exprs) {
	findMaxParamInMathMacros:
	while (true) {
		_v0$7:
		while (true) {
			if (!exprs.b) {
				return 0;
			} else {
				switch (exprs.a.$) {
					case 'Param':
						var n = exprs.a.a;
						var rest = exprs.b;
						return A2(
							$elm$core$Basics$max,
							n,
							$author$project$ETeX$Transform$findMaxParamInMathMacros(rest));
					case 'Arg':
						var innerExprs = exprs.a.a;
						var rest = exprs.b;
						return A2(
							$elm$core$Basics$max,
							$author$project$ETeX$Transform$findMaxParamInMathMacros(innerExprs),
							$author$project$ETeX$Transform$findMaxParamInMathMacros(rest));
					case 'Macro':
						var _v1 = exprs.a;
						var args = _v1.b;
						var rest = exprs.b;
						return A2(
							$elm$core$Basics$max,
							$author$project$ETeX$Transform$findMaxParamInMathMacros(args),
							$author$project$ETeX$Transform$findMaxParamInMathMacros(rest));
					case 'Expr':
						var innerExprs = exprs.a.a;
						var rest = exprs.b;
						return A2(
							$elm$core$Basics$max,
							$author$project$ETeX$Transform$findMaxParamInMathMacros(innerExprs),
							$author$project$ETeX$Transform$findMaxParamInMathMacros(rest));
					case 'Sub':
						if (exprs.a.a.$ === 'DecoM') {
							var expr = exprs.a.a.a;
							var rest = exprs.b;
							return A2(
								$elm$core$Basics$max,
								$author$project$ETeX$Transform$findMaxParamInMathMacros(
									_List_fromArray(
										[expr])),
								$author$project$ETeX$Transform$findMaxParamInMathMacros(rest));
						} else {
							break _v0$7;
						}
					case 'Super':
						if (exprs.a.a.$ === 'DecoM') {
							var expr = exprs.a.a.a;
							var rest = exprs.b;
							return A2(
								$elm$core$Basics$max,
								$author$project$ETeX$Transform$findMaxParamInMathMacros(
									_List_fromArray(
										[expr])),
								$author$project$ETeX$Transform$findMaxParamInMathMacros(rest));
						} else {
							break _v0$7;
						}
					default:
						break _v0$7;
				}
			}
		}
		var rest = exprs.b;
		var $temp$exprs = rest;
		exprs = $temp$exprs;
		continue findMaxParamInMathMacros;
	}
};
var $author$project$ETeX$Transform$makeEntry = function (newCommand_) {
	if (((((newCommand_.$ === 'Ok') && (newCommand_.a.a.$ === 'MacroName')) && newCommand_.a.c.b) && (newCommand_.a.c.a.$ === 'Arg')) && (!newCommand_.a.c.b.b)) {
		var _v1 = newCommand_.a;
		var name = _v1.a.a;
		var arity = _v1.b;
		var _v2 = _v1.c;
		var body = _v2.a.a;
		var deducedArity = (arity > 0) ? arity : $author$project$ETeX$Transform$findMaxParamInMathMacros(body);
		return $elm$core$Maybe$Just(
			_Utils_Tuple2(
				name,
				A2($author$project$ETeX$MathMacros$MacroBody, deducedArity, body)));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$ETeX$Transform$ExpectingNewCommand = {$: 'ExpectingNewCommand'};
var $author$project$ETeX$MathMacros$NewCommand = F3(
	function (a, b, c) {
		return {$: 'NewCommand', a: a, b: b, c: c};
	});
var $author$project$ETeX$MathMacros$AlphaNum = function (a) {
	return {$: 'AlphaNum', a: a};
};
var $author$project$ETeX$MathMacros$Arg = function (a) {
	return {$: 'Arg', a: a};
};
var $author$project$ETeX$MathMacros$Comma = {$: 'Comma'};
var $author$project$ETeX$MathMacros$DecoI = function (a) {
	return {$: 'DecoI', a: a};
};
var $author$project$ETeX$MathMacros$DecoM = function (a) {
	return {$: 'DecoM', a: a};
};
var $author$project$ETeX$MathMacros$Expr = function (a) {
	return {$: 'Expr', a: a};
};
var $author$project$ETeX$MathMacros$LeftMathBrace = {$: 'LeftMathBrace'};
var $author$project$ETeX$MathMacros$LeftParen = {$: 'LeftParen'};
var $author$project$ETeX$MathMacros$Macro = F2(
	function (a, b) {
		return {$: 'Macro', a: a, b: b};
	});
var $author$project$ETeX$MathMacros$MacroName = function (a) {
	return {$: 'MacroName', a: a};
};
var $author$project$ETeX$MathMacros$MathMediumSpace = {$: 'MathMediumSpace'};
var $author$project$ETeX$MathMacros$MathSmallSpace = {$: 'MathSmallSpace'};
var $author$project$ETeX$MathMacros$MathSpace = {$: 'MathSpace'};
var $author$project$ETeX$MathMacros$MathSymbols = function (a) {
	return {$: 'MathSymbols', a: a};
};
var $author$project$ETeX$MathMacros$Param = function (a) {
	return {$: 'Param', a: a};
};
var $author$project$ETeX$MathMacros$RightMathBrace = {$: 'RightMathBrace'};
var $author$project$ETeX$MathMacros$RightParen = {$: 'RightParen'};
var $author$project$ETeX$MathMacros$Sub = function (a) {
	return {$: 'Sub', a: a};
};
var $author$project$ETeX$MathMacros$Super = function (a) {
	return {$: 'Super', a: a};
};
var $author$project$ETeX$MathMacros$WS = {$: 'WS'};
var $author$project$ETeX$Transform$convertToETeXDeco = function (deco) {
	if (deco.$ === 'DecoM') {
		var mathExpr = deco.a;
		return $author$project$ETeX$MathMacros$DecoM(
			$author$project$ETeX$Transform$convertToETeXMathExpr(mathExpr));
	} else {
		var n = deco.a;
		return $author$project$ETeX$MathMacros$DecoI(n);
	}
};
var $author$project$ETeX$Transform$convertToETeXMathExpr = function (expr) {
	switch (expr.$) {
		case 'AlphaNum':
			var str = expr.a;
			return $author$project$ETeX$MathMacros$AlphaNum(str);
		case 'F0':
			var str = expr.a;
			return $author$project$ETeX$MathMacros$MacroName(str);
		case 'Param':
			var n = expr.a;
			return $author$project$ETeX$MathMacros$Param(n);
		case 'WS':
			return $author$project$ETeX$MathMacros$WS;
		case 'MathSpace':
			return $author$project$ETeX$MathMacros$MathSpace;
		case 'MathSmallSpace':
			return $author$project$ETeX$MathMacros$MathSmallSpace;
		case 'MathMediumSpace':
			return $author$project$ETeX$MathMacros$MathMediumSpace;
		case 'LeftMathBrace':
			return $author$project$ETeX$MathMacros$LeftMathBrace;
		case 'RightMathBrace':
			return $author$project$ETeX$MathMacros$RightMathBrace;
		case 'MathSymbols':
			var str = expr.a;
			return $author$project$ETeX$MathMacros$MathSymbols(str);
		case 'Arg':
			var exprs = expr.a;
			return $author$project$ETeX$MathMacros$Arg(
				A2($elm$core$List$map, $author$project$ETeX$Transform$convertToETeXMathExpr, exprs));
		case 'PArg':
			var exprs = expr.a;
			return $author$project$ETeX$MathMacros$Arg(
				A2($elm$core$List$map, $author$project$ETeX$Transform$convertToETeXMathExpr, exprs));
		case 'ParenthExpr':
			var exprs = expr.a;
			return $author$project$ETeX$MathMacros$Expr(
				A2($elm$core$List$map, $author$project$ETeX$Transform$convertToETeXMathExpr, exprs));
		case 'Sub':
			var decoExpr = expr.a;
			return $author$project$ETeX$MathMacros$Sub(
				$author$project$ETeX$Transform$convertToETeXDeco(decoExpr));
		case 'Super':
			var decoExpr = expr.a;
			return $author$project$ETeX$MathMacros$Super(
				$author$project$ETeX$Transform$convertToETeXDeco(decoExpr));
		case 'Macro':
			var name = expr.a;
			var args = expr.b;
			return A2(
				$author$project$ETeX$MathMacros$Macro,
				name,
				A2($elm$core$List$map, $author$project$ETeX$Transform$convertToETeXMathExpr, args));
		case 'FCall':
			var name = expr.a;
			var args = expr.b;
			return A2(
				$author$project$ETeX$MathMacros$Macro,
				name,
				A2($elm$core$List$map, $author$project$ETeX$Transform$convertToETeXMathExpr, args));
		case 'Expr':
			var exprs = expr.a;
			return $author$project$ETeX$MathMacros$Expr(
				A2($elm$core$List$map, $author$project$ETeX$Transform$convertToETeXMathExpr, exprs));
		case 'LeftParen':
			return $author$project$ETeX$MathMacros$LeftParen;
		case 'RightParen':
			return $author$project$ETeX$MathMacros$RightParen;
		case 'Comma':
			return $author$project$ETeX$MathMacros$Comma;
		default:
			var str = expr.a;
			return $author$project$ETeX$MathMacros$MathSymbols(str);
	}
};
var $author$project$ETeX$Transform$ExpectingLeftBracket = {$: 'ExpectingLeftBracket'};
var $author$project$ETeX$Transform$ExpectingRightBracket = {$: 'ExpectingRightBracket'};
var $author$project$ETeX$Transform$optionalParamParser = A2(
	$elm$parser$Parser$Advanced$keeper,
	A2(
		$elm$parser$Parser$Advanced$ignorer,
		$elm$parser$Parser$Advanced$succeed($elm$core$Basics$identity),
		$elm$parser$Parser$Advanced$symbol(
			A2($elm$parser$Parser$Advanced$Token, '[', $author$project$ETeX$Transform$ExpectingLeftBracket))),
	A2(
		$elm$parser$Parser$Advanced$ignorer,
		A2($elm$parser$Parser$Advanced$int, $author$project$ETeX$Transform$ExpectingInt, $author$project$ETeX$Transform$InvalidNumber),
		$elm$parser$Parser$Advanced$symbol(
			A2($elm$parser$Parser$Advanced$Token, ']', $author$project$ETeX$Transform$ExpectingRightBracket))));
var $author$project$ETeX$Transform$newCommandParser1 = function (userMacroDict) {
	return A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$keeper,
				A2(
					$elm$parser$Parser$Advanced$ignorer,
					A2(
						$elm$parser$Parser$Advanced$ignorer,
						$elm$parser$Parser$Advanced$succeed(
							F3(
								function (name, arity, body) {
									return A3(
										$author$project$ETeX$MathMacros$NewCommand,
										$author$project$ETeX$Transform$convertToETeXMathExpr(name),
										arity,
										A2($elm$core$List$map, $author$project$ETeX$Transform$convertToETeXMathExpr, body));
								})),
						$elm$parser$Parser$Advanced$symbol(
							A2($elm$parser$Parser$Advanced$Token, '\\newcommand', $author$project$ETeX$Transform$ExpectingNewCommand))),
					$elm$parser$Parser$Advanced$symbol(
						A2($elm$parser$Parser$Advanced$Token, '{', $author$project$ETeX$Transform$ExpectingLeftBrace))),
				A2(
					$elm$parser$Parser$Advanced$ignorer,
					$author$project$ETeX$Transform$f0Parser,
					$elm$parser$Parser$Advanced$symbol(
						A2($elm$parser$Parser$Advanced$Token, '}', $author$project$ETeX$Transform$ExpectingRightBrace)))),
			$author$project$ETeX$Transform$optionalParamParser),
		$author$project$ETeX$Transform$many(
			$author$project$ETeX$Transform$mathExprParser(userMacroDict)));
};
var $author$project$ETeX$Transform$newCommandParser2 = function (userMacroDict) {
	return A2(
		$elm$parser$Parser$Advanced$keeper,
		A2(
			$elm$parser$Parser$Advanced$keeper,
			A2(
				$elm$parser$Parser$Advanced$ignorer,
				A2(
					$elm$parser$Parser$Advanced$ignorer,
					$elm$parser$Parser$Advanced$succeed(
						F2(
							function (name, body) {
								return A3(
									$author$project$ETeX$MathMacros$NewCommand,
									$author$project$ETeX$Transform$convertToETeXMathExpr(name),
									0,
									A2($elm$core$List$map, $author$project$ETeX$Transform$convertToETeXMathExpr, body));
							})),
					$elm$parser$Parser$Advanced$symbol(
						A2($elm$parser$Parser$Advanced$Token, '\\newcommand', $author$project$ETeX$Transform$ExpectingNewCommand))),
				$elm$parser$Parser$Advanced$symbol(
					A2($elm$parser$Parser$Advanced$Token, '{', $author$project$ETeX$Transform$ExpectingLeftBrace))),
			A2(
				$elm$parser$Parser$Advanced$ignorer,
				$author$project$ETeX$Transform$f0Parser,
				$elm$parser$Parser$Advanced$symbol(
					A2($elm$parser$Parser$Advanced$Token, '}', $author$project$ETeX$Transform$ExpectingRightBrace)))),
		$author$project$ETeX$Transform$many(
			$author$project$ETeX$Transform$mathExprParser(userMacroDict)));
};
var $author$project$ETeX$Transform$newCommandParser = function (userMacroDict) {
	return $elm$parser$Parser$Advanced$oneOf(
		_List_fromArray(
			[
				$elm$parser$Parser$Advanced$backtrackable(
				$author$project$ETeX$Transform$newCommandParser1(userMacroDict)),
				$author$project$ETeX$Transform$newCommandParser2(userMacroDict)
			]));
};
var $author$project$ETeX$Transform$parseNewCommand = F2(
	function (userMacroDict, str) {
		return A2(
			$elm$parser$Parser$Advanced$run,
			$author$project$ETeX$Transform$newCommandParser(userMacroDict),
			str);
	});
var $elm$core$String$concat = function (strings) {
	return A2($elm$core$String$join, '', strings);
};
var $author$project$ETeX$Transform$SimpleBrace = F2(
	function (a, b) {
		return {$: 'SimpleBrace', a: a, b: b};
	});
var $author$project$ETeX$Transform$SimpleSpace = function (a) {
	return {$: 'SimpleSpace', a: a};
};
var $author$project$ETeX$Transform$SimpleSymbol = function (a) {
	return {$: 'SimpleSymbol', a: a};
};
var $author$project$ETeX$Transform$SimpleWord = function (a) {
	return {$: 'SimpleWord', a: a};
};
var $author$project$ETeX$Transform$tokenToString = function (token) {
	switch (token.$) {
		case 'SimpleWord':
			var word = token.a;
			return word;
		case 'SimpleBackslash':
			return '\\';
		case 'SimpleSpace':
			var s = token.a;
			return s;
		case 'SimpleSymbol':
			var s = token.a;
			return s;
		case 'SimpleBrace':
			var open = token.a;
			var content = token.b;
			return open + (content + '}');
		default:
			var n = token.a;
			return '#' + $elm$core$String$fromInt(n);
	}
};
var $author$project$ETeX$Transform$convertArgsToBraces = function (args) {
	return A2(
		$elm$core$List$map,
		function (arg) {
			return A2(
				$author$project$ETeX$Transform$SimpleBrace,
				'{',
				$elm$core$String$concat(
					A2($elm$core$List$map, $author$project$ETeX$Transform$tokenToString, arg)));
		},
		args);
};
var $author$project$ETeX$Transform$extractParenArgs = F2(
	function (tokens, currentArg) {
		extractParenArgs:
		while (true) {
			_v0$3:
			while (true) {
				if (!tokens.b) {
					return $elm$core$List$isEmpty(currentArg) ? _Utils_Tuple2(_List_Nil, _List_Nil) : _Utils_Tuple2(
						_List_fromArray(
							[
								$elm$core$List$reverse(currentArg)
							]),
						_List_Nil);
				} else {
					if (tokens.a.$ === 'SimpleSymbol') {
						switch (tokens.a.a) {
							case ')':
								var rest = tokens.b;
								return $elm$core$List$isEmpty(currentArg) ? _Utils_Tuple2(_List_Nil, rest) : _Utils_Tuple2(
									_List_fromArray(
										[
											$elm$core$List$reverse(currentArg)
										]),
									rest);
							case ',':
								var rest = tokens.b;
								var _v1 = A2($author$project$ETeX$Transform$extractParenArgs, rest, _List_Nil);
								var args = _v1.a;
								var remaining = _v1.b;
								return _Utils_Tuple2(
									A2(
										$elm$core$List$cons,
										$elm$core$List$reverse(currentArg),
										args),
									remaining);
							default:
								break _v0$3;
						}
					} else {
						break _v0$3;
					}
				}
			}
			var token = tokens.a;
			var rest = tokens.b;
			var $temp$tokens = rest,
				$temp$currentArg = A2($elm$core$List$cons, token, currentArg);
			tokens = $temp$tokens;
			currentArg = $temp$currentArg;
			continue extractParenArgs;
		}
	});
var $author$project$ETeX$Transform$needsBraceConversion = function (cmd) {
	return A2(
		$elm$core$List$member,
		cmd,
		_List_fromArray(
			['frac', 'binom', 'overset', 'underset', 'stackrel', 'tfrac', 'dfrac', 'cfrac', 'dbinom', 'tbinom']));
};
var $author$project$ETeX$Transform$processTokensWithLookahead = F2(
	function (knownMacros, tokens) {
		_v0$4:
		while (true) {
			if (!tokens.b) {
				return _List_Nil;
			} else {
				if (tokens.a.$ === 'SimpleWord') {
					if (tokens.b.b) {
						switch (tokens.b.a.$) {
							case 'SimpleSpace':
								if (tokens.b.b.b && (tokens.b.b.a.$ === 'SimpleWord')) {
									var word1 = tokens.a.a;
									var _v1 = tokens.b;
									var space = _v1.a.a;
									var _v2 = _v1.b;
									var word2 = _v2.a.a;
									var rest = _v2.b;
									return ((word1 === 'mathbb') && ($elm$core$String$length(word2) === 1)) ? A2(
										$elm$core$List$cons,
										$author$project$ETeX$Transform$SimpleWord('\\mathbb'),
										A2(
											$elm$core$List$cons,
											A2($author$project$ETeX$Transform$SimpleBrace, '{', word2),
											A2($author$project$ETeX$Transform$processTokensWithLookahead, knownMacros, rest))) : A2(
										$elm$core$List$cons,
										$author$project$ETeX$Transform$SimpleWord(word1),
										A2(
											$elm$core$List$cons,
											$author$project$ETeX$Transform$SimpleSpace(space),
											A2(
												$author$project$ETeX$Transform$processTokensWithLookahead,
												knownMacros,
												A2(
													$elm$core$List$cons,
													$author$project$ETeX$Transform$SimpleWord(word2),
													rest))));
								} else {
									break _v0$4;
								}
							case 'SimpleSymbol':
								switch (tokens.b.a.a) {
									case '^':
										var word = tokens.a.a;
										var _v3 = tokens.b;
										var rest = _v3.b;
										return ($author$project$ETeX$KaTeX$isKaTeX(word) || A2($elm$core$List$member, word, knownMacros)) ? A2(
											$elm$core$List$cons,
											$author$project$ETeX$Transform$SimpleWord('\\' + word),
											A2(
												$elm$core$List$cons,
												$author$project$ETeX$Transform$SimpleSymbol('^'),
												A2($author$project$ETeX$Transform$processTokensWithLookahead, knownMacros, rest))) : A2(
											$elm$core$List$cons,
											$author$project$ETeX$Transform$SimpleWord(word),
											A2(
												$elm$core$List$cons,
												$author$project$ETeX$Transform$SimpleSymbol('^'),
												A2($author$project$ETeX$Transform$processTokensWithLookahead, knownMacros, rest)));
									case '(':
										var word = tokens.a.a;
										var _v4 = tokens.b;
										var rest = _v4.b;
										if ($author$project$ETeX$KaTeX$isKaTeX(word) && $author$project$ETeX$Transform$needsBraceConversion(word)) {
											var _v5 = A2($author$project$ETeX$Transform$extractParenArgs, rest, _List_Nil);
											var args = _v5.a;
											var remaining = _v5.b;
											var processedArgs = A2(
												$elm$core$List$map,
												$author$project$ETeX$Transform$processTokensWithLookahead(knownMacros),
												args);
											return A2(
												$elm$core$List$cons,
												$author$project$ETeX$Transform$SimpleWord('\\' + word),
												_Utils_ap(
													$author$project$ETeX$Transform$convertArgsToBraces(processedArgs),
													A2($author$project$ETeX$Transform$processTokensWithLookahead, knownMacros, remaining)));
										} else {
											if ($author$project$ETeX$KaTeX$isKaTeX(word)) {
												return A2(
													$elm$core$List$cons,
													$author$project$ETeX$Transform$SimpleWord('\\' + word),
													A2(
														$elm$core$List$cons,
														$author$project$ETeX$Transform$SimpleSymbol('('),
														A2($author$project$ETeX$Transform$processTokensWithLookahead, knownMacros, rest)));
											} else {
												if (A2($elm$core$List$member, word, knownMacros)) {
													return A2(
														$elm$core$List$cons,
														$author$project$ETeX$Transform$SimpleWord('\\' + word),
														A2(
															$elm$core$List$cons,
															$author$project$ETeX$Transform$SimpleSymbol('('),
															A2($author$project$ETeX$Transform$processTokensWithLookahead, knownMacros, rest)));
												} else {
													return A2(
														$elm$core$List$cons,
														$author$project$ETeX$Transform$SimpleWord(word),
														A2(
															$elm$core$List$cons,
															$author$project$ETeX$Transform$SimpleSymbol('('),
															A2($author$project$ETeX$Transform$processTokensWithLookahead, knownMacros, rest)));
												}
											}
										}
									default:
										break _v0$4;
								}
							default:
								break _v0$4;
						}
					} else {
						break _v0$4;
					}
				} else {
					var token = tokens.a;
					var rest = tokens.b;
					return A2(
						$elm$core$List$cons,
						token,
						A2($author$project$ETeX$Transform$processTokensWithLookahead, knownMacros, rest));
				}
			}
		}
		var word = tokens.a.a;
		var rest = tokens.b;
		return ($author$project$ETeX$KaTeX$isKaTeX(word) || A2($elm$core$List$member, word, knownMacros)) ? A2(
			$elm$core$List$cons,
			$author$project$ETeX$Transform$SimpleWord('\\' + word),
			A2($author$project$ETeX$Transform$processTokensWithLookahead, knownMacros, rest)) : A2(
			$elm$core$List$cons,
			$author$project$ETeX$Transform$SimpleWord(word),
			A2($author$project$ETeX$Transform$processTokensWithLookahead, knownMacros, rest));
	});
var $elm$core$String$foldr = _String_foldr;
var $elm$core$String$toList = function (string) {
	return A3($elm$core$String$foldr, $elm$core$List$cons, _List_Nil, string);
};
var $author$project$ETeX$Transform$SimpleBackslash = {$: 'SimpleBackslash'};
var $author$project$ETeX$Transform$SimpleParam = function (a) {
	return {$: 'SimpleParam', a: a};
};
var $author$project$ETeX$Transform$collectUntilCloseBrace = F3(
	function (chars, depth, acc) {
		collectUntilCloseBrace:
		while (true) {
			if (!chars.b) {
				return _Utils_Tuple2(
					$elm$core$List$reverse(acc),
					_List_Nil);
			} else {
				switch (chars.a.valueOf()) {
					case '{':
						var rest = chars.b;
						var $temp$chars = rest,
							$temp$depth = depth + 1,
							$temp$acc = A2(
							$elm$core$List$cons,
							_Utils_chr('{'),
							acc);
						chars = $temp$chars;
						depth = $temp$depth;
						acc = $temp$acc;
						continue collectUntilCloseBrace;
					case '}':
						var rest = chars.b;
						if (depth === 1) {
							return _Utils_Tuple2(
								$elm$core$List$reverse(acc),
								rest);
						} else {
							var $temp$chars = rest,
								$temp$depth = depth - 1,
								$temp$acc = A2(
								$elm$core$List$cons,
								_Utils_chr('}'),
								acc);
							chars = $temp$chars;
							depth = $temp$depth;
							acc = $temp$acc;
							continue collectUntilCloseBrace;
						}
					default:
						var c = chars.a;
						var rest = chars.b;
						var $temp$chars = rest,
							$temp$depth = depth,
							$temp$acc = A2($elm$core$List$cons, c, acc);
						chars = $temp$chars;
						depth = $temp$depth;
						acc = $temp$acc;
						continue collectUntilCloseBrace;
				}
			}
		}
	});
var $elm$core$String$fromList = _String_fromList;
var $author$project$ETeX$Transform$takeAlphas = function (chars) {
	if (!chars.b) {
		return _Utils_Tuple2(_List_Nil, _List_Nil);
	} else {
		var c = chars.a;
		var rest = chars.b;
		if ($elm$core$Char$isAlpha(c)) {
			var _v1 = $author$project$ETeX$Transform$takeAlphas(rest);
			var alphas = _v1.a;
			var remaining = _v1.b;
			return _Utils_Tuple2(
				A2($elm$core$List$cons, c, alphas),
				remaining);
		} else {
			return _Utils_Tuple2(_List_Nil, chars);
		}
	}
};
var $author$project$ETeX$Transform$takeDigits = function (chars) {
	if (!chars.b) {
		return _Utils_Tuple2(_List_Nil, _List_Nil);
	} else {
		var c = chars.a;
		var rest = chars.b;
		if ($elm$core$Char$isDigit(c)) {
			var _v1 = $author$project$ETeX$Transform$takeDigits(rest);
			var digits = _v1.a;
			var remaining = _v1.b;
			return _Utils_Tuple2(
				A2($elm$core$List$cons, c, digits),
				remaining);
		} else {
			return _Utils_Tuple2(_List_Nil, chars);
		}
	}
};
var $author$project$ETeX$Transform$takeSpaces = function (chars) {
	if (!chars.b) {
		return _Utils_Tuple2(_List_Nil, _List_Nil);
	} else {
		var c = chars.a;
		var rest = chars.b;
		if (_Utils_eq(
			c,
			_Utils_chr(' ')) || (_Utils_eq(
			c,
			_Utils_chr('\t')) || _Utils_eq(
			c,
			_Utils_chr('\n')))) {
			var _v1 = $author$project$ETeX$Transform$takeSpaces(rest);
			var spaces = _v1.a;
			var remaining = _v1.b;
			return _Utils_Tuple2(
				A2($elm$core$List$cons, c, spaces),
				remaining);
		} else {
			return _Utils_Tuple2(_List_Nil, chars);
		}
	}
};
var $author$project$ETeX$Transform$tokenizeHelper = F2(
	function (chars, acc) {
		tokenizeHelper:
		while (true) {
			if (!chars.b) {
				return acc;
			} else {
				switch (chars.a.valueOf()) {
					case '\\':
						var rest = chars.b;
						var $temp$chars = rest,
							$temp$acc = A2($elm$core$List$cons, $author$project$ETeX$Transform$SimpleBackslash, acc);
						chars = $temp$chars;
						acc = $temp$acc;
						continue tokenizeHelper;
					case '#':
						var rest = chars.b;
						var _v1 = $author$project$ETeX$Transform$takeDigits(rest);
						var digits = _v1.a;
						var remaining = _v1.b;
						var _v2 = $elm$core$String$toInt(
							$elm$core$String$fromList(digits));
						if (_v2.$ === 'Just') {
							var n = _v2.a;
							var $temp$chars = remaining,
								$temp$acc = A2(
								$elm$core$List$cons,
								$author$project$ETeX$Transform$SimpleParam(n),
								acc);
							chars = $temp$chars;
							acc = $temp$acc;
							continue tokenizeHelper;
						} else {
							var $temp$chars = rest,
								$temp$acc = A2(
								$elm$core$List$cons,
								$author$project$ETeX$Transform$SimpleSymbol('#'),
								acc);
							chars = $temp$chars;
							acc = $temp$acc;
							continue tokenizeHelper;
						}
					case '{':
						var rest = chars.b;
						var _v3 = A3($author$project$ETeX$Transform$collectUntilCloseBrace, rest, 1, _List_Nil);
						var content = _v3.a;
						var remaining = _v3.b;
						var $temp$chars = remaining,
							$temp$acc = A2(
							$elm$core$List$cons,
							A2(
								$author$project$ETeX$Transform$SimpleBrace,
								'{',
								$elm$core$String$fromList(content)),
							acc);
						chars = $temp$chars;
						acc = $temp$acc;
						continue tokenizeHelper;
					default:
						var c = chars.a;
						var rest = chars.b;
						if ($elm$core$Char$isAlpha(c)) {
							var _v4 = $author$project$ETeX$Transform$takeAlphas(
								A2($elm$core$List$cons, c, rest));
							var word = _v4.a;
							var remaining = _v4.b;
							var $temp$chars = remaining,
								$temp$acc = A2(
								$elm$core$List$cons,
								$author$project$ETeX$Transform$SimpleWord(
									$elm$core$String$fromList(word)),
								acc);
							chars = $temp$chars;
							acc = $temp$acc;
							continue tokenizeHelper;
						} else {
							if (_Utils_eq(
								c,
								_Utils_chr(' ')) || (_Utils_eq(
								c,
								_Utils_chr('\t')) || _Utils_eq(
								c,
								_Utils_chr('\n')))) {
								var _v5 = $author$project$ETeX$Transform$takeSpaces(
									A2($elm$core$List$cons, c, rest));
								var spaces = _v5.a;
								var remaining = _v5.b;
								var $temp$chars = remaining,
									$temp$acc = A2(
									$elm$core$List$cons,
									$author$project$ETeX$Transform$SimpleSpace(
										$elm$core$String$fromList(spaces)),
									acc);
								chars = $temp$chars;
								acc = $temp$acc;
								continue tokenizeHelper;
							} else {
								var $temp$chars = rest,
									$temp$acc = A2(
									$elm$core$List$cons,
									$author$project$ETeX$Transform$SimpleSymbol(
										$elm$core$String$fromChar(c)),
									acc);
								chars = $temp$chars;
								acc = $temp$acc;
								continue tokenizeHelper;
							}
						}
				}
			}
		}
	});
var $author$project$ETeX$Transform$tokenizeSimpleMacroBody = function (body) {
	return $elm$core$List$reverse(
		A2(
			$author$project$ETeX$Transform$tokenizeHelper,
			$elm$core$String$toList(body),
			_List_Nil));
};
var $author$project$ETeX$Transform$processSimpleMacroBodyWithContext = F2(
	function (knownMacros, body) {
		return $elm$core$String$concat(
			A2(
				$elm$core$List$map,
				$author$project$ETeX$Transform$tokenToString,
				A2(
					$author$project$ETeX$Transform$processTokensWithLookahead,
					knownMacros,
					$author$project$ETeX$Transform$tokenizeSimpleMacroBody(body))));
	});
var $author$project$ETeX$Transform$parseSimpleMacroWithContext = F2(
	function (knownMacros, line) {
		var _v0 = A2($elm$core$String$split, ':', line);
		if ((_v0.b && _v0.b.b) && (!_v0.b.b.b)) {
			var name = _v0.a;
			var _v1 = _v0.b;
			var body = _v1.a;
			var trimmedName = $elm$core$String$trim(name);
			var trimmedBody = $elm$core$String$trim(body);
			var processedBody = A2($author$project$ETeX$Transform$processSimpleMacroBodyWithContext, knownMacros, trimmedBody);
			var newCommandStr = '\\newcommand{\\' + (trimmedName + ('}{' + (processedBody + '}')));
			return $author$project$ETeX$Transform$makeEntry(
				A2($author$project$ETeX$Transform$parseNewCommand, $elm$core$Dict$empty, newCommandStr));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$ETeX$Transform$processSimpleMacroBody = function (body) {
	return A2($author$project$ETeX$Transform$processSimpleMacroBodyWithContext, _List_Nil, body);
};
var $author$project$ETeX$Transform$simpleMacroToLaTeX = function (line) {
	if (A2($elm$core$String$contains, ':', line)) {
		var _v0 = A2($author$project$ETeX$Transform$parseSimpleMacroWithContext, _List_Nil, line);
		if (_v0.$ === 'Just') {
			var _v1 = _v0.a;
			var name = _v1.a;
			var _v2 = _v1.b;
			var arity = _v2.a;
			var processedBody = $author$project$ETeX$Transform$processSimpleMacroBody(
				$elm$core$String$trim(
					A2(
						$elm$core$String$join,
						':',
						A2(
							$elm$core$List$drop,
							1,
							A2($elm$core$String$split, ':', line)))));
			var arityStr = (arity > 0) ? ('[' + ($elm$core$String$fromInt(arity) + ']')) : '';
			return '\\newcommand{\\' + (name + ('}' + (arityStr + ('{' + (processedBody + '}')))));
		} else {
			return '';
		}
	} else {
		return '';
	}
};
var $author$project$ETeX$Transform$toLaTeXNewCommands = function (input) {
	return A2(
		$elm$core$String$join,
		'\n',
		A2(
			$elm$core$List$filter,
			$elm$core$Basics$neq(''),
			A2(
				$elm$core$List$map,
				$author$project$ETeX$Transform$simpleMacroToLaTeX,
				A2(
					$elm$core$List$filter,
					A2($elm$core$Basics$composeL, $elm$core$Basics$not, $elm$core$String$isEmpty),
					A2(
						$elm$core$List$map,
						$elm$core$String$trim,
						$elm$core$String$lines(
							$elm$core$String$trim(input)))))));
};
var $author$project$Render$Export$LaTeX$exportBlock = F3(
	function (mathMacroDict, settings, block) {
		var _v0 = block.heading;
		switch (_v0.$) {
			case 'Paragraph':
				var _v1 = block.body;
				if (_v1.$ === 'Left') {
					var str = _v1.a;
					return $author$project$Render$Export$LaTeX$mapChars2(str);
				} else {
					var exprs_ = _v1.a;
					return A3($author$project$Render$Export$LaTeX$exportExprList, mathMacroDict, settings, exprs_);
				}
			case 'Ordinary':
				if (_v0.a === 'table') {
					var _v2 = block.body;
					if (_v2.$ === 'Left') {
						var str = _v2.a;
						return str;
					} else {
						var exprs_ = _v2.a;
						var _v3 = $elm$core$List$head(exprs_);
						if (((_v3.$ === 'Just') && (_v3.a.$ === 'Fun')) && (_v3.a.a === 'table')) {
							var _v4 = _v3.a;
							var body = _v4.b;
							var renderRow = function (rowExpr) {
								if ((rowExpr.$ === 'Fun') && (rowExpr.a === 'row')) {
									var cells = rowExpr.b;
									return cells;
								} else {
									return _List_Nil;
								}
							};
							var makeRow = function (row) {
								return A2($elm$core$String$join, '& ', row);
							};
							var exportCell = function (expr) {
								if ((expr.$ === 'Fun') && (expr.a === 'cell')) {
									var exprs2 = expr.b;
									return A3($author$project$Render$Export$LaTeX$exportExprList, mathMacroDict, settings, exprs2);
								} else {
									return 'error constructing table cell';
								}
							};
							var cellTable = A2($elm$core$List$map, renderRow, body);
							var stringTable = A2(
								$elm$core$List$map,
								$elm$core$List$map(exportCell),
								cellTable);
							var columns = $elm$core$List$length(
								$elm_community$list_extra$List$Extra$transpose(stringTable));
							var defaultFormat = function (x) {
								return '{' + (x + '}');
							}(
								A2(
									$elm$core$String$join,
									' ',
									A2($elm$core$List$repeat, columns, 'l')));
							var format = A2(
								$elm$core$Maybe$withDefault,
								defaultFormat,
								A2($elm$core$Dict$get, 'format', block.properties));
							var output = A2(
								$elm$core$String$join,
								' \\\\\n',
								A2($elm$core$List$map, makeRow, stringTable));
							return '\\begin{tabular}' + (format + ('\n' + (output + '\n\\end{tabular}')));
						} else {
							return 'error in constructing table';
						}
					}
				} else {
					var name = _v0.a;
					var _v7 = block.body;
					if (_v7.$ === 'Left') {
						return '';
					} else {
						var exprs_ = _v7.a;
						var _v8 = A2(
							$elm$core$Dict$get,
							name,
							$author$project$Render$Export$LaTeX$blockDict(mathMacroDict));
						if (_v8.$ === 'Just') {
							var f = _v8.a;
							return A3(
								f,
								settings,
								block.args,
								A3($author$project$Render$Export$LaTeX$exportExprList, mathMacroDict, settings, exprs_));
						} else {
							return A2(
								$author$project$Render$Export$LaTeX$environment,
								name,
								A3($author$project$Render$Export$LaTeX$exportExprList, mathMacroDict, settings, exprs_));
						}
					}
				}
			default:
				var name = _v0.a;
				var _v9 = block.body;
				if (_v9.$ === 'Left') {
					var str = _v9.a;
					switch (name) {
						case 'math':
							var fix_ = function (str_) {
								return $author$project$MicroLaTeX$Util$transformLabel(
									A2(
										$author$project$ETeX$Transform$transformETeX,
										mathMacroDict,
										A2(
											$elm$core$String$join,
											'\n',
											A2(
												$elm$core$List$filter,
												function (line) {
													return A2($elm$core$String$left, 2, line) !== '$$';
												},
												$elm$core$String$lines(str_)))));
							};
							return A2(
								$elm$core$String$join,
								'\n',
								_List_fromArray(
									[
										'$$',
										fix_(str),
										'$$'
									]));
						case 'csvtable':
							var renderRow = F3(
								function (rowNumber, widths_, rowOfCells) {
									return (!rowNumber) ? A3(
										$elm$core$String$replace,
										'_',
										' ',
										A2(
											$elm$core$String$join,
											' ',
											A3(
												$elm$core$List$map2,
												F2(
													function (cell, width) {
														return A3(
															$elm$core$String$padRight,
															width,
															_Utils_chr(' '),
															cell);
													}),
												rowOfCells,
												widths_))) : A2(
										$elm$core$String$join,
										' ',
										A3(
											$elm$core$List$map2,
											F2(
												function (cell, width) {
													return A3(
														$elm$core$String$padRight,
														width,
														_Utils_chr(' '),
														cell);
												}),
											rowOfCells,
											widths_));
								});
							var data = A2($author$project$Render$Data$prepareTable, 1, block);
							var renderedRows = A2(
								$elm$core$String$join,
								'\n',
								A2(
									$elm$core$List$indexedMap,
									function (rowNumber) {
										return A2(renderRow, rowNumber, data.columnWidths);
									},
									data.selectedCells));
							var _v11 = data.title;
							if (_v11.$ === 'Nothing') {
								return A2(
									$elm$core$String$join,
									'\n',
									_List_fromArray(
										['\\begin{verbatim}', renderedRows, '\\end{verbatim}']));
							} else {
								var title = _v11.a;
								var separator = A2($elm$core$String$repeat, data.totalWidth, '-');
								return A2(
									$elm$core$String$join,
									'\n',
									_List_fromArray(
										['\\begin{verbatim}', title, separator, renderedRows, '\\end{verbatim}']));
							}
						case 'equation':
							return A2(
								$elm$core$String$join,
								'\n',
								_List_fromArray(
									[
										'\\begin{equation}',
										$author$project$MicroLaTeX$Util$transformLabel(
										A2($author$project$ETeX$Transform$transformETeX, mathMacroDict, str)),
										'\\end{equation}'
									]));
						case 'aligned':
							var processedLines = A2(
								$elm$core$String$join,
								'\\\\\n',
								A2(
									$elm$core$List$map,
									$author$project$MicroLaTeX$Util$transformLabel,
									A2(
										$elm$core$List$map,
										$author$project$ETeX$Transform$transformETeX(mathMacroDict),
										A2(
											$elm$core$List$map,
											$elm$core$String$trim,
											A2($elm$core$String$split, '\\\\', str)))));
							return A2(
								$elm$core$String$join,
								'\n',
								_List_fromArray(
									['\\begin{align}', processedLines, '\\end{align}']));
						case 'code':
							return function (s) {
								return '\\begin{verbatim}\n' + (s + '\n\\end{verbatim}');
							}(
								$author$project$Render$Export$LaTeX$fixChars(str));
						case 'tabular':
							return function (s) {
								return '\\begin{tabular}{' + (A2($elm$core$String$join, ' ', block.args) + ('}\n' + (s + '\n\\end{tabular}')));
							}(
								$author$project$Render$Export$LaTeX$fixChars(str));
						case 'verbatim':
							return function (s) {
								return '\\begin{verbatim}\n' + (s + '\n\\end{verbatim}');
							}(
								$author$project$Render$Export$LaTeX$fixChars(str));
						case 'verse':
							return function (s) {
								return '\\begin{verbatim}\n' + (s + '\n\\end{verbatim}');
							}(
								$author$project$Render$Export$LaTeX$fixChars(str));
						case 'load-files':
							return '';
						case 'mathmacros':
							return $author$project$ETeX$Transform$toLaTeXNewCommands(str);
						case 'texComment':
							return $author$project$Render$Export$LaTeX$texComment(
								$elm$core$String$lines(str));
						case 'textmacros':
							return $author$project$Generic$TextMacro$exportTexMacros(str);
						case 'image':
							return A2($author$project$Render$Export$Image$exportBlock, settings, block);
						case 'quiver':
							var lines = A2(
								$elm$core$List$filter,
								function (line) {
									return line !== '';
								},
								$elm$core$String$lines(
									A2(
										$elm$core$String$join,
										'\n',
										A2(
											$elm$core$List$drop,
											1,
											A2($elm$core$String$split, '---', str)))));
							var line1 = $elm$core$String$trim(
								A2(
									$elm$core$Maybe$withDefault,
									'%%',
									$elm$core$List$head(lines)));
							var line1b = A2($elm$core$String$contains, '\\hide{', line1) ? function (x) {
								return '%% ' + x;
							}(
								A2(
									$elm$core$String$dropRight,
									1,
									A3($elm$core$String$replace, '\\hide{', '', line1))) : line1;
							var data = A2(
								$elm$core$String$join,
								'\n',
								function (x) {
									return A2(
										$elm$core$List$cons,
										line1b,
										A2(
											$elm$core$List$cons,
											'\\[\\begin{tikzcd}',
											_Utils_ap(
												x,
												_List_fromArray(
													['\\end{tikzcd}\\]']))));
								}(
									A2(
										$elm$core$List$filter,
										function (line) {
											return !A2($elm$core$String$contains, '\\end{tikzcd}\\]', line);
										},
										A2(
											$elm$core$List$filter,
											function (line) {
												return !A2($elm$core$String$contains, '\\[\\begin{tikzcd}', line);
											},
											A2($elm$core$List$drop, 1, lines)))));
							return data;
						case 'tikz':
							var renderedAsLaTeX = A2($elm$core$String$contains, '\\hide{', str);
							var data = A2(
								$author$project$Render$Export$LaTeX$addTikzPictureClosing,
								renderedAsLaTeX,
								A2(
									$elm$core$String$join,
									'\n',
									A2(
										$elm$core$List$map,
										A2($elm$core$Basics$composeR, $author$project$Render$Export$LaTeX$hideToPercentComment, $author$project$Render$Export$LaTeX$commentBlankLine),
										$elm$core$String$lines(
											A2(
												$elm$core$String$join,
												'',
												A2(
													$elm$core$List$drop,
													1,
													A2($elm$core$String$split, '---', str)))))));
							return A2(
								$elm$core$String$join,
								'',
								_List_fromArray(
									['\\[\n', data, '\n\\]']));
						case 'docinfo':
							return '';
						case 'hide':
							return '';
						default:
							return ': export of this block is unimplemented';
					}
				} else {
					return '???(13)';
				}
		}
	});
var $author$project$Generic$Language$getHeadingFromBlock = function (block) {
	return block.heading;
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
var $author$project$Render$Export$LaTeX$exportTree = F3(
	function (mathMacroDict, settings, tree) {
		var _v0 = $author$project$Generic$Language$getHeadingFromBlock(
			$maca$elm_rose_tree$RoseTree$Tree$value(tree));
		_v0$2:
		while (true) {
			if (_v0.$ === 'Ordinary') {
				switch (_v0.a) {
					case 'itemList':
						var exprList = function () {
							var _v1 = $maca$elm_rose_tree$RoseTree$Tree$value(tree).body;
							if (_v1.$ === 'Left') {
								return _List_Nil;
							} else {
								var exprs = _v1.a;
								return exprs;
							}
						}();
						var compactItem = function (x) {
							return '\\compactItem{' + (x + '}');
						};
						var renderExprList = function (exprs) {
							return A2(
								$elm$core$String$join,
								'\n',
								A2(
									$elm$core$List$map,
									A2(
										$elm$core$Basics$composeR,
										A2($author$project$Render$Export$LaTeX$exportExpr, mathMacroDict, settings),
										compactItem),
									exprs));
						};
						return renderExprList(exprList);
					case 'numberedList':
						var label = function (n) {
							return $elm$core$String$fromInt(n + 1) + '. ';
						};
						var hang = function (str) {
							return '\\leftskip=1em\\hangindent=1em\n\\hangafter=1\n' + str;
						};
						var renderExprList = function (exprs) {
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$indexedMap,
									function (k) {
										return A2(
											$elm$core$Basics$composeR,
											A2($author$project$Render$Export$LaTeX$exportExpr, mathMacroDict, settings),
											function (x) {
												return _Utils_ap(
													label(k),
													hang(x));
											});
									},
									exprs));
						};
						var exprList = function () {
							var _v2 = $maca$elm_rose_tree$RoseTree$Tree$value(tree).body;
							if (_v2.$ === 'Left') {
								return _List_Nil;
							} else {
								var exprs = _v2.a;
								return exprs;
							}
						}();
						return renderExprList(exprList);
					default:
						break _v0$2;
				}
			} else {
				break _v0$2;
			}
		}
		var _v3 = $maca$elm_rose_tree$RoseTree$Tree$children(tree);
		if (!_v3.b) {
			return A3(
				$author$project$Render$Export$LaTeX$exportBlock,
				mathMacroDict,
				settings,
				$maca$elm_rose_tree$RoseTree$Tree$value(tree));
		} else {
			var children = _v3;
			var root = $elm$core$String$lines(
				A3(
					$author$project$Render$Export$LaTeX$exportBlock,
					mathMacroDict,
					settings,
					$maca$elm_rose_tree$RoseTree$Tree$value(tree)));
			var renderedChildren = $elm$core$List$concat(
				A2(
					$elm$core$List$map,
					$elm$core$String$lines,
					A2(
						$elm$core$List$map,
						A2($author$project$Render$Export$LaTeX$exportTree, mathMacroDict, settings),
						children)));
			var _v4 = $elm_community$list_extra$List$Extra$unconsLast(root);
			if (_v4.$ === 'Nothing') {
				return '';
			} else {
				var _v5 = _v4.a;
				var lastLine = _v5.a;
				var firstLines = _v5.b;
				var _v6 = firstLines;
				var _v7 = renderedChildren;
				var _v8 = lastLine;
				return A2(
					$elm$core$String$join,
					'\n',
					_Utils_ap(
						firstLines,
						_Utils_ap(
							renderedChildren,
							_List_fromArray(
								[lastLine]))));
			}
		}
	});
var $author$project$Generic$ASTTools$labelName = function (tree) {
	return $author$project$Generic$Language$getName(
		$maca$elm_rose_tree$RoseTree$Tree$value(tree));
};
var $author$project$Generic$ASTTools$filterForestOnLabelNames = F2(
	function (predicate, forest) {
		return A2(
			$elm$core$List$filter,
			function (tree) {
				return predicate(
					$author$project$Generic$ASTTools$labelName(tree));
			},
			forest);
	});
var $elm$core$String$startsWith = _String_startsWith;
var $author$project$ETeX$Transform$addMixedFormatMacro = F2(
	function (line, dict) {
		var knownMacros = $elm$core$Dict$keys(dict);
		if (A2($elm$core$String$startsWith, '\\newcommand', line)) {
			var _v0 = $author$project$ETeX$Transform$makeEntry(
				A2($author$project$ETeX$Transform$parseNewCommand, $elm$core$Dict$empty, line));
			if (_v0.$ === 'Just') {
				var _v1 = _v0.a;
				var name = _v1.a;
				var body = _v1.b;
				return A3($elm$core$Dict$insert, name, body, dict);
			} else {
				return dict;
			}
		} else {
			if (A2($elm$core$String$contains, ':', line)) {
				var _v2 = A2($author$project$ETeX$Transform$parseSimpleMacroWithContext, knownMacros, line);
				if (_v2.$ === 'Just') {
					var _v3 = _v2.a;
					var name = _v3.a;
					var body = _v3.b;
					return A3($elm$core$Dict$insert, name, body, dict);
				} else {
					return dict;
				}
			} else {
				return dict;
			}
		}
	});
var $author$project$ETeX$Transform$makeMacroDictFromMixedLines = function (lines) {
	return A3($elm$core$List$foldl, $author$project$ETeX$Transform$addMixedFormatMacro, $elm$core$Dict$empty, lines);
};
var $author$project$ETeX$Transform$makeMacroDict = function (str) {
	return $author$project$ETeX$Transform$makeMacroDictFromMixedLines(
		A2(
			$elm$core$List$filter,
			A2($elm$core$Basics$composeL, $elm$core$Basics$not, $elm$core$String$isEmpty),
			A2(
				$elm$core$List$map,
				$elm$core$String$trim,
				$elm$core$String$lines(
					$elm$core$String$trim(str)))));
};
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
var $maca$elm_rose_tree$RoseTree$Tree$map = F2(
	function (f, _v0) {
		var a = _v0.a;
		var ns = _v0.b;
		return f(
			A2(
				$maca$elm_rose_tree$RoseTree$Tree$Tree,
				a,
				A2(
					$elm$core$Array$map,
					$maca$elm_rose_tree$RoseTree$Tree$map(f),
					ns)));
	});
var $author$project$Render$Export$LaTeX$rawExport = F2(
	function (settings, ast_) {
		var mathMacroDict = $author$project$ETeX$Transform$makeMacroDict(
			A2($author$project$Generic$ASTTools$getVerbatimBlockValue, 'mathmacros', ast_));
		var mathMacroBlock_ = A2($author$project$Generic$ASTTools$getBlockByName, 'mathmacros', ast_);
		var hideMathMacros = function (_v2) {
			var val = _v2.a;
			var children = _v2.b;
			var outputTree = function () {
				var _v1 = val.heading;
				switch (_v1.$) {
					case 'Paragraph':
						return A2($maca$elm_rose_tree$RoseTree$Tree$Tree, val, children);
					case 'Ordinary':
						return A2($maca$elm_rose_tree$RoseTree$Tree$Tree, val, children);
					default:
						if (_v1.a === 'mathmacros') {
							return A2(
								$maca$elm_rose_tree$RoseTree$Tree$Tree,
								_Utils_update(
									val,
									{
										heading: $author$project$Generic$Language$Verbatim('hide')
									}),
								children);
						} else {
							return A2($maca$elm_rose_tree$RoseTree$Tree$Tree, val, children);
						}
				}
			}();
			return outputTree;
		};
		var ast = function () {
			if (mathMacroBlock_.$ === 'Nothing') {
				return ast_;
			} else {
				var mathMacroBlock = mathMacroBlock_.a;
				return A2(
					$elm$core$List$cons,
					$maca$elm_rose_tree$RoseTree$Tree$leaf(mathMacroBlock),
					A2(
						$elm$core$List$map,
						$maca$elm_rose_tree$RoseTree$Tree$map(hideMathMacros),
						ast_));
			}
		}();
		return A2(
			$elm$core$String$join,
			'\n\n',
			A2(
				$elm$core$List$map,
				A2($author$project$Render$Export$LaTeX$exportTree, mathMacroDict, settings),
				$author$project$Render$Export$LaTeX$encloseLists(
					A2(
						$author$project$Generic$Forest$map,
						$author$project$Generic$BlockUtilities$condenseUrls,
						A2(
							$author$project$Generic$ASTTools$filterForestOnLabelNames,
							function (name) {
								return !_Utils_eq(
									name,
									$elm$core$Maybe$Just('runninghead'));
							},
							ast)))));
	});
var $author$project$Render$Export$LaTeX$tableofcontents = F2(
	function (properties, rawBlockNames_) {
		var sectionCount = $elm$core$List$length(
			A2(
				$elm$core$List$filter,
				function (name) {
					return (name === 'section') || (name === 'section*');
				},
				rawBlockNames_));
		var numberToLevel = A2(
			$elm$core$Maybe$withDefault,
			3,
			A2(
				$elm$core$Maybe$andThen,
				$elm$core$String$toFloat,
				A2($elm$core$Dict$get, 'number-to-level', properties)));
		var shouldShowTOC = (sectionCount > 1) && (numberToLevel > 0);
		return shouldShowTOC ? '\n\n\\tableofcontents' : '';
	});
var $author$project$Render$Export$LaTeX$export = F3(
	function (currentTime, settings_, ast) {
		var titleData = A2($author$project$Generic$ASTTools$getBlockByName, 'title', ast);
		var textMacroDefinitions = A2($author$project$Generic$ASTTools$getVerbatimBlockValue, 'textmacros', ast);
		var rawBlockNames = $author$project$Generic$ASTTools$rawBlockNames(ast);
		var properties = A2(
			$elm$core$Maybe$withDefault,
			$elm$core$Dict$empty,
			A2(
				$elm$core$Maybe$map,
				function ($) {
					return $.properties;
				},
				titleData));
		var settings = _Utils_update(
			settings_,
			{properties: properties});
		var macrosInTextMacroDefinitions = $author$project$Generic$TextMacro$getTextMacroFunctionNames(textMacroDefinitions);
		var expressionNames = _Utils_ap(
			$author$project$Generic$ASTTools$expressionNames(ast),
			macrosInTextMacroDefinitions);
		var counterValue_ = A2(
			$elm$core$Maybe$map,
			function (x) {
				return x - 1;
			},
			A2(
				$elm$core$Maybe$andThen,
				$elm$core$String$toInt,
				A2($elm$core$Dict$get, 'first-section', properties)));
		var setTheFirstSection = function () {
			if (counterValue_.$ === 'Nothing') {
				return '';
			} else {
				var k = counterValue_.a;
				return '\n\\setcounter{section}{' + ($elm$core$String$fromInt(k) + '}\n');
			}
		}();
		return A2($author$project$Render$Export$Preamble$make, rawBlockNames, expressionNames) + (A2($author$project$Render$Export$LaTeX$frontMatter, currentTime, ast) + (setTheFirstSection + (A2($author$project$Render$Export$LaTeX$tableofcontents, properties, rawBlockNames) + ('\n\n' + (A2($author$project$Render$Export$LaTeX$rawExport, settings, ast) + '\n\n\\end{document}\n')))));
	});
var $elm$html$Html$h2 = _VirtualDom_node('h2');
var $elm$time$Time$Posix = function (a) {
	return {$: 'Posix', a: a};
};
var $elm$time$Time$millisToPosix = $elm$time$Time$Posix;
var $elm$html$Html$pre = _VirtualDom_node('pre');
var $author$project$ScriptaV2$Config$idPrefix = 'L';
var $author$project$ScriptaV2$Language$EnclosureLang = {$: 'EnclosureLang'};
var $author$project$M$Regex$Numbered = function (a) {
	return {$: 'Numbered', a: a};
};
var $author$project$M$Regex$Unknown = {$: 'Unknown'};
var $author$project$M$Regex$Unnumbered = function (a) {
	return {$: 'Unnumbered', a: a};
};
var $elm$regex$Regex$find = _Regex_findAtMost(_Regex_infinity);
var $elm$regex$Regex$never = _Regex_never;
var $author$project$M$Regex$titleOrAsteriskSectionRegex = A2(
	$elm$core$Maybe$withDefault,
	$elm$regex$Regex$never,
	$elm$regex$Regex$fromString('^(#+|\\*+)\\s*'));
var $author$project$M$Regex$findSectionPrefix_ = function (string) {
	return A2(
		$elm$core$Maybe$map,
		$elm$core$String$trim,
		$elm$core$List$head(
			A2(
				$elm$core$List$map,
				function ($) {
					return $.match;
				},
				A2($elm$regex$Regex$find, $author$project$M$Regex$titleOrAsteriskSectionRegex, string))));
};
var $author$project$M$Regex$findSectionType = function (string) {
	var _v0 = $author$project$M$Regex$findSectionPrefix_(string);
	if (_v0.$ === 'Just') {
		var prefix = _v0.a;
		return A2($elm$core$String$startsWith, '#', prefix) ? $author$project$M$Regex$Numbered(prefix) : (A2($elm$core$String$startsWith, '*', prefix) ? $author$project$M$Regex$Unnumbered(prefix) : $author$project$M$Regex$Unknown);
	} else {
		return $author$project$M$Regex$Unknown;
	}
};
var $author$project$M$Regex$findSectionPrefix = function (string) {
	var _v0 = $author$project$M$Regex$findSectionType(string);
	switch (_v0.$) {
		case 'Numbered':
			var prefix = _v0.a;
			return $elm$core$Maybe$Just(prefix);
		case 'Unnumbered':
			var prefix = _v0.a;
			return $elm$core$Maybe$Just(prefix);
		default:
			return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Generic$Line$HEMissingName = {$: 'HEMissingName'};
var $author$project$Generic$Line$HENoContent = {$: 'HENoContent'};
var $elm_community$list_extra$List$Extra$findIndexHelp = F3(
	function (index, predicate, list) {
		findIndexHelp:
		while (true) {
			if (!list.b) {
				return $elm$core$Maybe$Nothing;
			} else {
				var x = list.a;
				var xs = list.b;
				if (predicate(x)) {
					return $elm$core$Maybe$Just(index);
				} else {
					var $temp$index = index + 1,
						$temp$predicate = predicate,
						$temp$list = xs;
					index = $temp$index;
					predicate = $temp$predicate;
					list = $temp$list;
					continue findIndexHelp;
				}
			}
		}
	});
var $elm_community$list_extra$List$Extra$findIndex = $elm_community$list_extra$List$Extra$findIndexHelp(0);
var $author$project$Tools$KV$cleanArgs = function (strs) {
	var _v0 = A2(
		$elm_community$list_extra$List$Extra$findIndex,
		function (t) {
			return A2($elm$core$String$contains, ':', t);
		},
		strs);
	if (_v0.$ === 'Nothing') {
		return strs;
	} else {
		var k = _v0.a;
		return A2($elm$core$List$take, k, strs);
	}
};
var $author$project$Tools$KV$KVInKey = {$: 'KVInKey'};
var $author$project$Tools$KV$KVInValue = {$: 'KVInValue'};
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
var $author$project$Tools$KV$nextKVStep = function (state) {
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
		return $author$project$Tools$Loop$Done(
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
					return $author$project$Tools$Loop$Loop(
						_Utils_update(
							state,
							{
								currentKey: $elm$core$Maybe$Just(
									A2($elm$core$String$dropRight, 1, item)),
								input: rest,
								kvStatus: $author$project$Tools$KV$KVInValue
							}));
				} else {
					var key = _v6.a;
					return $author$project$Tools$Loop$Loop(
						{
							currentKey: $elm$core$Maybe$Just(
								A2($elm$core$String$dropRight, 1, item)),
							currentValue: _List_Nil,
							input: rest,
							kvList: A2(
								$elm$core$List$cons,
								_Utils_Tuple2(key, state.currentValue),
								state.kvList),
							kvStatus: $author$project$Tools$KV$KVInValue
						});
				}
			} else {
				return $author$project$Tools$Loop$Loop(
					_Utils_update(
						state,
						{input: rest}));
			}
		} else {
			if (A2($elm$core$String$contains, ':', item)) {
				var _v7 = state.currentKey;
				if (_v7.$ === 'Nothing') {
					return $author$project$Tools$Loop$Loop(
						_Utils_update(
							state,
							{
								currentKey: $elm$core$Maybe$Just(
									A2($elm$core$String$dropRight, 1, item)),
								currentValue: _List_Nil,
								input: rest,
								kvStatus: $author$project$Tools$KV$KVInValue
							}));
				} else {
					var key = _v7.a;
					return $author$project$Tools$Loop$Loop(
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
								kvStatus: $author$project$Tools$KV$KVInValue
							}));
				}
			} else {
				return $author$project$Tools$Loop$Loop(
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
var $author$project$Tools$KV$prepareKVData = function (data_) {
	var initialState = {currentKey: $elm$core$Maybe$Nothing, currentValue: _List_Nil, input: data_, kvList: _List_Nil, kvStatus: $author$project$Tools$KV$KVInKey};
	return A2($author$project$Tools$Loop$loop, initialState, $author$project$Tools$KV$nextKVStep);
};
var $author$project$Tools$KV$explode = function (txt) {
	return A2(
		$elm$core$List$map,
		$elm$core$String$split(':'),
		txt);
};
var $author$project$Tools$KV$fix = function (strs) {
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
var $author$project$Tools$KV$prepareList = function (strs) {
	return A2(
		$elm$core$List$filter,
		function (s) {
			return s !== '';
		},
		$elm$core$List$concat(
			A2(
				$elm$core$List$map,
				$author$project$Tools$KV$fix,
				$author$project$Tools$KV$explode(strs))));
};
var $author$project$Tools$KV$argsAndProperties = function (words) {
	var args = $author$project$Tools$KV$cleanArgs(words);
	var namedArgs = A2(
		$elm$core$List$drop,
		$elm$core$List$length(args),
		words);
	var properties = $author$project$Tools$KV$prepareKVData(
		$author$project$Tools$KV$prepareList(namedArgs));
	return _Utils_Tuple2(args, properties);
};
var $elm$core$Dict$singleton = F2(
	function (key, value) {
		return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
	});
var $author$project$M$PrimitiveBlock$verbatimWords = _List_fromArray(
	['math', 'chem', 'compute', 'equation', 'aligned', 'array', 'textarray', 'table', 'code', 'verse', 'verbatim', 'load', 'load-data', 'hide', 'texComment', 'docinfo', 'mathmacros', 'textmacros', 'csvtable', 'table', 'chart', 'svg', 'quiver', 'image', 'tikz', 'load-files', 'include', 'setup', 'iframe']);
var $author$project$M$PrimitiveBlock$getHeadingData = function (line_) {
	var line = $elm$core$String$trim(line_);
	var _v0 = $author$project$Tools$KV$argsAndProperties(
		$elm$core$String$words(line));
	var args1 = _v0.a;
	var properties = _v0.b;
	var _v1 = $author$project$M$Regex$findSectionType(line);
	switch (_v1.$) {
		case 'Numbered':
			var prefixSection = _v1.a;
			return $elm$core$Result$Ok(
				{
					args: _List_fromArray(
						[
							$elm$core$String$fromInt(
							$elm$core$String$length(
								$elm$core$String$trim(prefixSection)))
						]),
					heading: $author$project$Generic$Language$Ordinary('section'),
					properties: A2($elm$core$Dict$singleton, 'section-type', 'markdown')
				});
		case 'Unnumbered':
			var unnumberedPrefix = _v1.a;
			return $elm$core$Result$Ok(
				{
					args: _List_fromArray(
						[
							$elm$core$String$fromInt(
							$elm$core$String$length(
								$elm$core$String$trim(unnumberedPrefix)))
						]),
					heading: $author$project$Generic$Language$Ordinary('section*'),
					properties: A2($elm$core$Dict$singleton, 'section-type', 'markdown')
				});
		default:
			if (!args1.b) {
				return $elm$core$Result$Ok(
					{args: _List_Nil, heading: $author$project$Generic$Language$Paragraph, properties: $elm$core$Dict$empty});
			} else {
				var prefix = args1.a;
				var args = args1.b;
				switch (prefix) {
					case '||':
						if (!args.b) {
							return $elm$core$Result$Err($author$project$Generic$Line$HEMissingName);
						} else {
							var name = args.a;
							var args2 = args.b;
							return $elm$core$Result$Ok(
								{
									args: args2,
									heading: $author$project$Generic$Language$Verbatim(name),
									properties: properties
								});
						}
					case '|':
						if (!args.b) {
							return $elm$core$Result$Err($author$project$Generic$Line$HEMissingName);
						} else {
							var name = args.a;
							var args2 = args.b;
							return $elm$core$Result$Ok(
								A2($elm$core$List$member, name, $author$project$M$PrimitiveBlock$verbatimWords) ? {
									args: args2,
									heading: $author$project$Generic$Language$Verbatim(name),
									properties: properties
								} : {
									args: args2,
									heading: $author$project$Generic$Language$Ordinary(name),
									properties: properties
								});
						}
					case '-':
						var reducedLine = A3($elm$core$String$replace, '- ', '', line);
						return $elm$core$String$isEmpty(reducedLine) ? $elm$core$Result$Err($author$project$Generic$Line$HENoContent) : $elm$core$Result$Ok(
							{
								args: _List_Nil,
								heading: $author$project$Generic$Language$Ordinary('item'),
								properties: A2(
									$elm$core$Dict$singleton,
									'firstLine',
									A3($elm$core$String$replace, '- ', '', line))
							});
					case '.':
						var reducedLine = A3($elm$core$String$replace, '. ', '', line);
						return $elm$core$String$isEmpty(reducedLine) ? $elm$core$Result$Err($author$project$Generic$Line$HENoContent) : $elm$core$Result$Ok(
							{
								args: _List_Nil,
								heading: $author$project$Generic$Language$Ordinary('numbered'),
								properties: A2(
									$elm$core$Dict$singleton,
									'firstLine',
									A3($elm$core$String$replace, '. ', '', line))
							});
					case '```':
						return $elm$core$Result$Ok(
							{
								args: _List_Nil,
								heading: $author$project$Generic$Language$Verbatim('code'),
								properties: $elm$core$Dict$empty
							});
					case '$$':
						return $elm$core$Result$Ok(
							{
								args: _List_Nil,
								heading: $author$project$Generic$Language$Verbatim('math'),
								properties: $elm$core$Dict$empty
							});
					default:
						return $elm$core$Result$Ok(
							{args: _List_Nil, heading: $author$project$Generic$Language$Paragraph, properties: $elm$core$Dict$empty});
				}
			}
	}
};
var $author$project$M$PrimitiveBlock$isVerbatimLine = function (str) {
	return (A2($elm$core$String$left, 2, str) === '||') || ((A2($elm$core$String$left, 3, str) === '```') || (A2($elm$core$String$left, 2, str) === '$$'));
};
var $author$project$M$PrimitiveBlock$functionData = {findSectionPrefix: $author$project$M$Regex$findSectionPrefix, getHeadingData: $author$project$M$PrimitiveBlock$getHeadingData, isVerbatimBlock: $author$project$M$PrimitiveBlock$isVerbatimLine};
var $author$project$Generic$PrimitiveBlock$init = F4(
	function (parserFunctions, initialId, outerCount, lines) {
		return {blocks: _List_Nil, blocksCommitted: 0, count: 0, currentBlock: $elm$core$Maybe$Nothing, error: $elm$core$Maybe$Nothing, idPrefix: initialId, inBlock: false, inVerbatim: false, indent: 0, label: '0, START', lineNumber: 0, lines: lines, outerCount: outerCount, parserFunctions: parserFunctions, position: 0};
	});
var $author$project$Generic$PrimitiveBlock$addCurrentLine_ = F2(
	function (line, block) {
		var prefix = line.prefix;
		var content = line.content;
		var oldMeta = block.meta;
		var newMeta = _Utils_update(
			oldMeta,
			{sourceText: block.meta.sourceText + ('\n' + (prefix + content))});
		return _Utils_update(
			block,
			{
				body: A2($elm$core$List$cons, line.content, block.body),
				meta: newMeta
			});
	});
var $author$project$Generic$PrimitiveBlock$addCurrentLine2 = F2(
	function (state, currentLine) {
		var _v0 = state.currentBlock;
		if (_v0.$ === 'Nothing') {
			return _Utils_update(
				state,
				{
					lines: A2($elm$core$List$drop, 1, state.lines)
				});
		} else {
			var block = _v0.a;
			return _Utils_update(
				state,
				{
					count: state.count + 1,
					currentBlock: $elm$core$Maybe$Just(
						A2($author$project$Generic$PrimitiveBlock$addCurrentLine_, currentLine, block)),
					lineNumber: state.lineNumber + 1,
					lines: A2($elm$core$List$drop, 1, state.lines)
				});
		}
	});
var $author$project$Generic$PrimitiveBlock$advance = F2(
	function (newPosition, state) {
		return _Utils_update(
			state,
			{
				count: state.count + 1,
				lineNumber: state.lineNumber + 1,
				lines: A2($elm$core$List$drop, 1, state.lines),
				position: newPosition
			});
	});
var $elm$parser$Parser$chompWhile = $elm$parser$Parser$Advanced$chompWhile;
var $elm$parser$Parser$getOffset = $elm$parser$Parser$Advanced$getOffset;
var $elm$parser$Parser$getSource = $elm$parser$Parser$Advanced$getSource;
var $elm$parser$Parser$ignorer = $elm$parser$Parser$Advanced$ignorer;
var $elm$parser$Parser$keeper = $elm$parser$Parser$Advanced$keeper;
var $elm$parser$Parser$succeed = $elm$parser$Parser$Advanced$succeed;
var $author$project$Generic$Line$prefixParser = F2(
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
										content: content,
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
var $author$project$Generic$Line$classify = F3(
	function (position, lineNumber, str) {
		var _v0 = A2(
			$elm$parser$Parser$run,
			A2($author$project$Generic$Line$prefixParser, position, lineNumber),
			str);
		if (_v0.$ === 'Err') {
			return {content: '!!ERROR', indent: 0, lineNumber: lineNumber, position: position, prefix: ''};
		} else {
			var result = _v0.a;
			return result;
		}
	});
var $author$project$Generic$BlockUtilities$dropLast = function (list) {
	var n = $elm$core$List$length(list);
	return A2($elm$core$List$take, n - 1, list);
};
var $author$project$Generic$PrimitiveBlock$finalize = function (block) {
	var properties = function () {
		var _v3 = block.heading;
		if ((_v3.$ === 'Ordinary') && (_v3.a === 'document')) {
			var docId = A2(
				$elm$core$Maybe$withDefault,
				'noDocId',
				A2(
					$elm$core$Maybe$map,
					function (_v4) {
						var a = _v4.a;
						var b = _v4.b;
						return a + (':' + b);
					},
					$elm$core$List$head(
						$elm$core$Dict$toList(block.properties))));
			return A3($elm$core$Dict$insert, 'docId', docId, block.properties);
		} else {
			return block.properties;
		}
	}();
	var oldMeta = block.meta;
	var content_ = $elm$core$List$reverse(block.body);
	var args = function () {
		var _v2 = A2($elm$core$Dict$get, 'label', properties);
		if (_v2.$ === 'Just') {
			return A2($elm$core$List$member, 'numbered', block.args) ? block.args : A2($elm$core$List$cons, 'numbered', block.args);
		} else {
			return block.args;
		}
	}();
	var addLabel = function (content__) {
		var _v1 = A2($elm$core$Dict$get, 'label', block.properties);
		if (_v1.$ === 'Just') {
			var lbl = _v1.a;
			return A2($elm$core$List$cons, '\\label{' + (lbl + '}'), content__);
		} else {
			return content__;
		}
	};
	var content = function () {
		var _v0 = block.heading;
		_v0$2:
		while (true) {
			if (_v0.$ === 'Verbatim') {
				switch (_v0.a) {
					case 'equation':
						return addLabel(content_);
					case 'aligned':
						return addLabel(content_);
					default:
						break _v0$2;
				}
			} else {
				break _v0$2;
			}
		}
		return content_;
	}();
	var sourceText = (!_Utils_eq(block.heading, $author$project$Generic$Language$Paragraph)) ? A2(
		$elm$core$String$join,
		'\n',
		A2($elm$core$List$cons, block.firstLine, content)) : A2($elm$core$String$join, '\n', content);
	var newMeta = _Utils_update(
		oldMeta,
		{sourceText: sourceText});
	return _Utils_update(
		block,
		{args: args, body: content, meta: newMeta, properties: properties});
};
var $author$project$Generic$PrimitiveBlock$fixMarkdownTitleBlock = F2(
	function (findTitlePrefix, block) {
		var _v0 = findTitlePrefix(block.firstLine);
		if (_v0.$ === 'Nothing') {
			return block;
		} else {
			var prefix = _v0.a;
			return (prefix === '!!') ? _Utils_update(
				block,
				{
					body: A2(
						$elm$core$List$cons,
						A3($elm$core$String$replace, prefix, '', block.firstLine),
						block.body),
					heading: $author$project$Generic$Language$Ordinary('title')
				}) : ((A2(
				$elm$core$String$left,
				1,
				$elm$core$String$trim(prefix)) === '#') ? _Utils_update(
				block,
				{
					body: A2(
						$elm$core$List$cons,
						A3($elm$core$String$replace, prefix, '', block.firstLine),
						block.body),
					heading: $author$project$Generic$Language$Ordinary('section')
				}) : ((A2(
				$elm$core$String$left,
				1,
				$elm$core$String$trim(prefix)) === '*') ? _Utils_update(
				block,
				{
					body: A2(
						$elm$core$List$cons,
						A3($elm$core$String$replace, prefix, '', block.firstLine),
						block.body),
					heading: $author$project$Generic$Language$Ordinary('section*')
				}) : _Utils_update(
				block,
				{
					body: A2(
						$elm$core$List$cons,
						A3($elm$core$String$replace, prefix, '', block.firstLine),
						block.body)
				})));
		}
	});
var $author$project$Generic$PrimitiveBlock$acceptBlock = F2(
	function (tag, block) {
		return !_Utils_eq(
			block.heading,
			$author$project$Generic$Language$Ordinary(tag));
	});
var $author$project$Tools$Utility$ordinaryTagAtEndRegex = A2(
	$elm$core$Maybe$withDefault,
	$elm$regex$Regex$never,
	$elm$regex$Regex$fromString('.*\n| .*$'));
var $author$project$Tools$Utility$findOrdinaryTagAtEnd = function (string) {
	return A2(
		$elm$core$Maybe$map,
		$elm$core$String$trim,
		$elm$core$List$head(
			$elm$core$List$reverse(
				A2(
					$elm$core$List$map,
					function ($) {
						return $.match;
					},
					A2($elm$regex$Regex$find, $author$project$Tools$Utility$ordinaryTagAtEndRegex, string)))));
};
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
var $author$project$Generic$PrimitiveBlock$findOrdinaryTagAtEnd = function (primitiveBlock) {
	return $author$project$Tools$Utility$findOrdinaryTagAtEnd(
		A2(
			$elm$core$Maybe$withDefault,
			'',
			$elm_community$list_extra$List$Extra$last(primitiveBlock.body)));
};
var $author$project$Generic$PrimitiveBlock$raiseBlockLevelsIfNeeded_ = F2(
	function (lastBlock, blocks) {
		var _v0 = $author$project$Generic$PrimitiveBlock$findOrdinaryTagAtEnd(lastBlock);
		if (_v0.$ === 'Nothing') {
			return blocks;
		} else {
			var tag = _v0.a;
			if (!A2(
				$elm$core$List$member,
				tag,
				_List_fromArray(
					['quotation', 'indent', 'theorem']))) {
				return blocks;
			} else {
				var candidateBlocksToRaise = A2(
					$elm_community$list_extra$List$Extra$takeWhile,
					$author$project$Generic$PrimitiveBlock$acceptBlock(tag),
					blocks);
				var raisedBlocks_ = A2(
					$elm$core$List$map,
					function (b) {
						return _Utils_update(
							b,
							{indent: b.indent + 2});
					},
					candidateBlocksToRaise);
				var n = $elm$core$List$length(raisedBlocks_);
				var tail = A2($elm$core$List$drop, n, blocks);
				var raisedBlocks = function () {
					var _v1 = $elm_community$list_extra$List$Extra$uncons(raisedBlocks_);
					if (_v1.$ === 'Nothing') {
						return raisedBlocks_;
					} else {
						var _v2 = _v1.a;
						var first = _v2.a;
						var rest = _v2.b;
						var m = $elm$core$List$length(first.body);
						return A2(
							$elm$core$List$cons,
							_Utils_update(
								first,
								{
									body: A2($elm$core$List$take, m - 1, first.body)
								}),
							rest);
					}
				}();
				return _Utils_ap(raisedBlocks, tail);
			}
		}
	});
var $author$project$Generic$BlockUtilities$getPrimitiveBlockName = function (block) {
	var _v0 = block.heading;
	switch (_v0.$) {
		case 'Paragraph':
			return $elm$core$Maybe$Nothing;
		case 'Ordinary':
			var name = _v0.a;
			return $elm$core$Maybe$Just(name);
		default:
			var name = _v0.a;
			return $elm$core$Maybe$Just(name);
	}
};
var $author$project$Tools$Utility$replaceLeadingDashSpace = function (str) {
	var regex = A2(
		$elm$core$Maybe$withDefault,
		$elm$regex$Regex$never,
		$elm$regex$Regex$fromString('^- '));
	return A3(
		$elm$regex$Regex$replace,
		regex,
		function (_v0) {
			return '';
		},
		str);
};
var $author$project$Tools$Utility$replaceLeadingDotSpace = function (str) {
	var regex = A2(
		$elm$core$Maybe$withDefault,
		$elm$regex$Regex$never,
		$elm$regex$Regex$fromString('^\\. '));
	return A3(
		$elm$regex$Regex$replace,
		regex,
		function (_v0) {
			return '';
		},
		str);
};
var $author$project$Generic$PrimitiveBlock$transformBlock = F2(
	function (findTitlePrefix, block) {
		var _v0 = $author$project$Generic$BlockUtilities$getPrimitiveBlockName(block);
		_v0$6:
		while (true) {
			if (_v0.$ === 'Just') {
				switch (_v0.a) {
					case 'section':
						var _v1 = $elm$core$List$head(block.args);
						if (_v1.$ === 'Nothing') {
							return _Utils_update(
								block,
								{
									properties: A3($elm$core$Dict$insert, 'level', '1', block.properties)
								});
						} else {
							var level = _v1.a;
							return _Utils_update(
								block,
								{
									properties: A3($elm$core$Dict$insert, 'level', level, block.properties)
								});
						}
					case 'section*':
						var _v2 = $elm$core$List$head(block.args);
						if (_v2.$ === 'Nothing') {
							return _Utils_update(
								block,
								{
									properties: A3($elm$core$Dict$insert, 'level', '1', block.properties)
								});
						} else {
							var level = _v2.a;
							return _Utils_update(
								block,
								{
									properties: A3($elm$core$Dict$insert, 'level', level, block.properties)
								});
						}
					case 'subsection':
						return _Utils_update(
							block,
							{
								heading: $author$project$Generic$Language$Ordinary('section'),
								properties: A3($elm$core$Dict$insert, 'level', '2', block.properties)
							});
					case 'subsubsection':
						return _Utils_update(
							block,
							{
								heading: $author$project$Generic$Language$Ordinary('section'),
								properties: A3($elm$core$Dict$insert, 'level', '3', block.properties)
							});
					case 'item':
						return _Utils_update(
							block,
							{
								body: A2(
									$elm$core$List$cons,
									$author$project$Tools$Utility$replaceLeadingDashSpace(
										A3(
											$elm$core$String$replace,
											'| item',
											'',
											$elm$core$String$trim(block.firstLine))),
									block.body)
							});
					case 'numbered':
						return _Utils_update(
							block,
							{
								body: A2(
									$elm$core$List$cons,
									$author$project$Tools$Utility$replaceLeadingDotSpace(
										A3(
											$elm$core$String$replace,
											'| numbered',
											'',
											$elm$core$String$trim(block.firstLine))),
									block.body)
							});
					default:
						break _v0$6;
				}
			} else {
				break _v0$6;
			}
		}
		return block;
	});
var $author$project$Generic$PrimitiveBlock$commitBlock = F2(
	function (state, currentLine) {
		var _v0 = state.currentBlock;
		if (_v0.$ === 'Nothing') {
			return _Utils_update(
				state,
				{
					indent: currentLine.indent,
					lines: A2($elm$core$List$drop, 1, state.lines)
				});
		} else {
			var block__ = _v0.a;
			var block_ = function () {
				var id = $elm$core$String$fromInt(state.lineNumber) + ('-' + $elm$core$String$fromInt(state.blocksCommitted));
				return function (b) {
					return _Utils_update(
						b,
						{
							properties: A3($elm$core$Dict$insert, 'outerId', id, b.properties)
						});
				}(
					A2(
						$author$project$Generic$BlockUtilities$updateMeta,
						function (m) {
							return _Utils_update(
								m,
								{
									numberOfLines: $elm$core$List$length(block__.body)
								});
						},
						A2(
							$author$project$Generic$BlockUtilities$updateMeta,
							function (m) {
								return _Utils_update(
									m,
									{id: id});
							},
							block__)));
			}();
			var block = function () {
				var _v1 = block_.heading;
				switch (_v1.$) {
					case 'Paragraph':
						return $author$project$Generic$PrimitiveBlock$finalize(block_);
					case 'Ordinary':
						var _v2 = A2($elm$core$Dict$get, 'section-type', block_.properties);
						if ((_v2.$ === 'Just') && (_v2.a === 'markdown')) {
							return A2(
								$author$project$Generic$PrimitiveBlock$fixMarkdownTitleBlock,
								state.parserFunctions.findSectionPrefix,
								A2(
									$author$project$Generic$PrimitiveBlock$transformBlock,
									state.parserFunctions.findSectionPrefix,
									$author$project$Generic$PrimitiveBlock$finalize(
										_Utils_update(
											block_,
											{
												body: $author$project$Generic$BlockUtilities$dropLast(block_.body)
											}))));
						} else {
							return A2(
								$author$project$Generic$PrimitiveBlock$transformBlock,
								state.parserFunctions.findSectionPrefix,
								$author$project$Generic$PrimitiveBlock$finalize(
									_Utils_update(
										block_,
										{
											body: $author$project$Generic$BlockUtilities$dropLast(block_.body)
										})));
						}
					default:
						var str = _v1.a;
						return _Utils_eq(
							$elm$core$List$head(block_.body),
							$elm$core$Maybe$Just('```')) ? $author$project$Generic$PrimitiveBlock$finalize(
							_Utils_update(
								block_,
								{
									body: A2(
										$elm$core$List$filter,
										function (l) {
											return l !== '```';
										},
										block_.body)
								})) : $author$project$Generic$PrimitiveBlock$finalize(
							_Utils_update(
								block_,
								{
									body: $author$project$Generic$BlockUtilities$dropLast(block_.body)
								}));
				}
			}();
			return _Utils_update(
				state,
				{
					blocks: A2(
						$author$project$Generic$PrimitiveBlock$raiseBlockLevelsIfNeeded_,
						block,
						A2($elm$core$List$cons, block, state.blocks)),
					blocksCommitted: state.blocksCommitted + 1,
					count: state.count + 1,
					currentBlock: $elm$core$Maybe$Nothing,
					inBlock: false,
					inVerbatim: state.parserFunctions.isVerbatimBlock(currentLine.content),
					lineNumber: state.lineNumber + 1,
					lines: A2($elm$core$List$drop, 1, state.lines)
				});
		}
	});
var $author$project$Generic$PrimitiveBlock$bogusBlockFromLine = F2(
	function (message_, _v0) {
		var indent = _v0.indent;
		var lineNumber = _v0.lineNumber;
		var position = _v0.position;
		var prefix = _v0.prefix;
		var content = _v0.content;
		var message = '[b [red ' + (content + (']] [blue [i ' + (message_ + ']]')));
		var meta = _Utils_update(
			$author$project$Generic$Language$emptyBlockMeta,
			{lineNumber: lineNumber, numberOfLines: 1, position: position, sourceText: message});
		return {
			args: _List_Nil,
			body: _List_fromArray(
				[message]),
			firstLine: '',
			heading: $author$project$Generic$Language$Paragraph,
			indent: indent,
			meta: meta,
			properties: $elm$core$Dict$empty,
			style: $elm$core$Maybe$Nothing
		};
	});
var $author$project$Generic$PrimitiveBlock$blockFromLine = F2(
	function (parserFunctions, line) {
		var indent = line.indent;
		var lineNumber = line.lineNumber;
		var position = line.position;
		var prefix = line.prefix;
		var content = line.content;
		var _v0 = parserFunctions.getHeadingData(content);
		if (_v0.$ === 'Err') {
			var err = _v0.a;
			return $elm$core$Result$Ok(
				A2($author$project$Generic$PrimitiveBlock$bogusBlockFromLine, '<= something missing', line));
		} else {
			var heading = _v0.a.heading;
			var args = _v0.a.args;
			var properties = _v0.a.properties;
			var meta = _Utils_update(
				$author$project$Generic$Language$emptyBlockMeta,
				{lineNumber: lineNumber, numberOfLines: 1, position: position, sourceText: ''});
			return $elm$core$Result$Ok(
				{
					args: args,
					body: _List_fromArray(
						[
							_Utils_ap(prefix, content)
						]),
					firstLine: content,
					heading: heading,
					indent: indent,
					meta: meta,
					properties: properties,
					style: $elm$core$Maybe$Nothing
				});
		}
	});
var $author$project$Generic$PrimitiveBlock$createBlock = F2(
	function (state, currentLine) {
		var rNewBlock = A2($author$project$Generic$PrimitiveBlock$blockFromLine, state.parserFunctions, currentLine);
		var blocks = function () {
			var _v1 = state.currentBlock;
			if (_v1.$ === 'Nothing') {
				return state.blocks;
			} else {
				var block = _v1.a;
				return _Utils_eq(
					block.body,
					_List_fromArray(
						[''])) ? state.blocks : A2($elm$core$List$cons, block, state.blocks);
			}
		}();
		if (rNewBlock.$ === 'Err') {
			var err = rNewBlock.a;
			return _Utils_update(
				state,
				{
					blocks: blocks,
					count: state.count + 1,
					currentBlock: $elm$core$Maybe$Just(
						A2($author$project$Generic$PrimitiveBlock$bogusBlockFromLine, 'error', currentLine)),
					inBlock: true,
					indent: currentLine.indent,
					lineNumber: state.lineNumber + 1,
					lines: A2($elm$core$List$drop, 1, state.lines),
					position: state.position
				});
		} else {
			var newBlock = rNewBlock.a;
			return _Utils_update(
				state,
				{
					blocks: blocks,
					count: state.count + 1,
					currentBlock: $elm$core$Maybe$Just(newBlock),
					inBlock: true,
					indent: currentLine.indent,
					lineNumber: state.lineNumber + 1,
					lines: A2($elm$core$List$drop, 1, state.lines),
					position: state.position
				});
		}
	});
var $author$project$Generic$PrimitiveBlock$inspectHeading = F2(
	function (parserFunctions, _v0) {
		var indent = _v0.indent;
		var lineNumber = _v0.lineNumber;
		var position = _v0.position;
		var prefix = _v0.prefix;
		var content = _v0.content;
		var _v1 = parserFunctions.getHeadingData(content);
		if (_v1.$ === 'Err') {
			var err = _v1.a;
			return $elm$core$Maybe$Nothing;
		} else {
			var heading = _v1.a.heading;
			var args = _v1.a.args;
			var properties = _v1.a.properties;
			return $elm$core$Maybe$Just(heading);
		}
	});
var $author$project$Generic$Line$isEmpty = function (line) {
	return (!line.indent) && (line.content === '');
};
var $author$project$Generic$Line$isNonEmptyBlank = function (line) {
	return (line.indent > 0) && (line.content === '');
};
var $author$project$Generic$PrimitiveBlock$nextStep = function (state) {
	var _v0 = $elm$core$List$head(state.lines);
	if (_v0.$ === 'Nothing') {
		var _v1 = state.currentBlock;
		if (_v1.$ === 'Nothing') {
			return $author$project$Tools$Loop$Done(
				$elm$core$List$reverse(state.blocks));
		} else {
			var block_ = _v1.a;
			var block = _Utils_update(
				block_,
				{
					body: $author$project$Generic$BlockUtilities$dropLast(block_.body)
				});
			var blocks = _Utils_eq(
				block.body,
				_List_fromArray(
					[''])) ? $elm$core$List$reverse(state.blocks) : $elm$core$List$reverse(
				A2($elm$core$List$cons, block, state.blocks));
			return $author$project$Tools$Loop$Done(blocks);
		}
	} else {
		var rawLine = _v0.a;
		var newPosition = (state.position + $elm$core$String$length(rawLine)) + 1;
		var currentLine = A3($author$project$Generic$Line$classify, state.position, state.lineNumber + 1, rawLine);
		var _v2 = _Utils_Tuple3(
			state.inBlock,
			$author$project$Generic$Line$isEmpty(currentLine),
			$author$project$Generic$Line$isNonEmptyBlank(currentLine));
		if (!_v2.a) {
			if (_v2.b) {
				return $author$project$Tools$Loop$Loop(
					A2(
						$author$project$Generic$PrimitiveBlock$advance,
						newPosition,
						_Utils_update(
							state,
							{label: '1, EMPTY'})));
			} else {
				if (_v2.c) {
					return $author$project$Tools$Loop$Loop(
						A2(
							$author$project$Generic$PrimitiveBlock$advance,
							newPosition,
							_Utils_update(
								state,
								{label: '2, PASS'})));
				} else {
					return $author$project$Tools$Loop$Loop(
						A2(
							$author$project$Generic$PrimitiveBlock$createBlock,
							_Utils_update(
								state,
								{label: '3, NEW', position: newPosition}),
							currentLine));
				}
			}
		} else {
			if (!_v2.b) {
				var match = _Utils_eq(
					A2(
						$elm$core$Maybe$map,
						function ($) {
							return $.heading;
						},
						state.currentBlock),
					A2($author$project$Generic$PrimitiveBlock$inspectHeading, state.parserFunctions, currentLine));
				var newCurrentBlock = function () {
					if (match && A2(
						$elm$core$List$member,
						A2(
							$elm$core$Maybe$map,
							function ($) {
								return $.heading;
							},
							state.currentBlock),
						_List_fromArray(
							[
								$elm$core$Maybe$Just(
								$author$project$Generic$Language$Ordinary('item')),
								$elm$core$Maybe$Just(
								$author$project$Generic$Language$Ordinary('itemList'))
							]))) {
						var _v3 = state.currentBlock;
						if (_v3.$ === 'Nothing') {
							return $elm$core$Maybe$Nothing;
						} else {
							var block = _v3.a;
							return $elm$core$Maybe$Just(
								_Utils_update(
									block,
									{
										heading: $author$project$Generic$Language$Ordinary('itemList')
									}));
						}
					} else {
						if (match && A2(
							$elm$core$List$member,
							A2(
								$elm$core$Maybe$map,
								function ($) {
									return $.heading;
								},
								state.currentBlock),
							_List_fromArray(
								[
									$elm$core$Maybe$Just(
									$author$project$Generic$Language$Ordinary('numbered')),
									$elm$core$Maybe$Just(
									$author$project$Generic$Language$Ordinary('numberedList'))
								]))) {
							var _v4 = state.currentBlock;
							if (_v4.$ === 'Nothing') {
								return $elm$core$Maybe$Nothing;
							} else {
								var block = _v4.a;
								return $elm$core$Maybe$Just(
									_Utils_update(
										block,
										{
											heading: $author$project$Generic$Language$Ordinary('numberedList')
										}));
							}
						} else {
							return state.currentBlock;
						}
					}
				}();
				return $author$project$Tools$Loop$Loop(
					A2(
						$author$project$Generic$PrimitiveBlock$addCurrentLine2,
						_Utils_update(
							state,
							{currentBlock: newCurrentBlock, label: '4, ADD', position: newPosition}),
						currentLine));
			} else {
				return $author$project$Tools$Loop$Loop(
					A2(
						$author$project$Generic$PrimitiveBlock$commitBlock,
						_Utils_update(
							state,
							{label: '5, COMMIT', position: newPosition}),
						currentLine));
			}
		}
	}
};
var $author$project$Generic$PrimitiveBlock$parse = F4(
	function (functionData, initialId, outerCount, lines) {
		return A2(
			$author$project$Tools$Loop$loop,
			A4($author$project$Generic$PrimitiveBlock$init, functionData, initialId, outerCount, lines),
			$author$project$Generic$PrimitiveBlock$nextStep);
	});
var $author$project$M$PrimitiveBlock$parse = F3(
	function (initialId, outerCount, lines) {
		return A4($author$project$Generic$PrimitiveBlock$parse, $author$project$M$PrimitiveBlock$functionData, initialId, outerCount, lines);
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
var $author$project$Generic$Language$boost = F2(
	function (position, meta) {
		return _Utils_update(
			meta,
			{begin: meta.begin + position, end: meta.end + position});
	});
var $toastal$either$Either$Left = function (a) {
	return {$: 'Left', a: a};
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
var $author$project$ScriptaV2$Compiler$parseM = F3(
	function (idPrefix, outerCount, lines) {
		return A6($author$project$Generic$Compiler$parse_, $author$project$ScriptaV2$Language$EnclosureLang, $author$project$M$PrimitiveBlock$parse, $author$project$M$Expression$parse, idPrefix, outerCount, lines);
	});
var $author$project$ScriptaV2$Compiler$ps = function (str) {
	return A3(
		$author$project$ScriptaV2$Compiler$parseM,
		$author$project$ScriptaV2$Config$idPrefix,
		0,
		$elm$core$String$lines(str));
};
var $elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var $elm$html$Html$text = $elm$virtual_dom$VirtualDom$text;
var $author$project$TestNestedFormatting$main = function () {
	var sourceText = '\n[b [i Bold Italic Text]]\n\n[i [b Italic Bold Text]]\n\n[b Normal bold [i with italic inside] and more bold]\n';
	var settings = $author$project$Render$Settings$defaultSettings($author$project$Render$Settings$defaultDisplaySettings);
	var ast = $author$project$ScriptaV2$Compiler$ps(sourceText);
	var latexOutput = A3(
		$author$project$Render$Export$LaTeX$export,
		$elm$time$Time$millisToPosix(0),
		settings,
		ast);
	return A2(
		$elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				$elm$html$Html$h2,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('Source:')
					])),
				A2(
				$elm$html$Html$pre,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text(sourceText)
					])),
				A2(
				$elm$html$Html$h2,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text('LaTeX Output:')
					])),
				A2(
				$elm$html$Html$pre,
				_List_Nil,
				_List_fromArray(
					[
						$elm$html$Html$text(latexOutput)
					]))
			]));
}();
_Platform_export({'TestNestedFormatting':{'init':_VirtualDom_init($author$project$TestNestedFormatting$main)(0)(0)}});}(this));