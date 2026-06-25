{lib}:

getType = {
			__functor = self: arg: self.arg;
Int   = lib.isInt;
Bool  = lib.isBool;
String= lib.isString;
Path  = lib.isPath;
Set   = lib.isSet;
List  = lib.isList;
Lambda= lib.isLambda;
Float = lib.isFloat;
# "int"
# "bool"
# "string"
# "path"
# "null"
# "set"
# "list"
# "lambda"
# "float"
}
