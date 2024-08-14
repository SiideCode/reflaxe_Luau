package luaucompiler.utils;

#if (macro || luau_runtime)
import haxe.macro.Type;

using StringTools;

class Utils {
	static public function typeToString(t:Type) {
		switch (t) {
			case TMono(t):
				var hhh = t.get();
				if (hhh != null)
					trace(typeToString(hhh));

				return "unknown";
			case TEnum(t, params):
				trace("enum");
				return "";
			case TInst(t, params):
				var le = "";
				var type = t.get();

				switch (type.name) {
					case "String":
						le = "string";
				}

				for (i in params) {
					trace(typeToString(i));
				}

				return le;
			case TType(t, params):
				trace("Typedef");
				return "";
			case TFun(args, ret):
				trace("Function");
				return "";
			case TAnonymous(a):
				trace("Anon Struct");
				return "";
			case TDynamic(t):
				return "any";
			case TLazy(f):
				trace("Lazy");
				return "";
			case TAbstract(t, params):
				trace("Abstract");
				return "";
			default:
				trace("AHAHAHAHHAh");
				return "";
		}
	}

	public static function convertDocToLuau(doc:String, tabulation:Int = 0, tabulationIn:Int = 1) {
		var ret = "";
		if (doc.contains("\n") || doc.contains("\r")) {
			for (i in 0...tabulation)
				ret += "    ";
			ret += "--[[\n";

			for (i => k in doc.split("\n")) {
				for (i in 0...tabulation)
					ret += "    ";
				for (i in 0...tabulationIn)
					ret += "    ";
				ret += k.trim() + "\n";
			}

			for (i in 0...tabulation)
				ret += "    ";
			ret += "]]";
		} else {
			ret += "--" + doc.trim();
		}

		ret += "\n";
		return ret;
	}
}
#end
