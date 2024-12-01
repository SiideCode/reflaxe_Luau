package luaucompiler.utils;

import haxe.macro.Expr.Position;
import reflaxe.helpers.Context;
#if (macro || luau_runtime)
import haxe.macro.Type;

using StringTools;

class Utils
{
    public static var compilerRef:Compiler;

    static public function typeToString(t:Type)
    {
        switch (t)
        {
            case TMono(t):
                var hhh = t.get();
                if (hhh != null)
                    return typeToString(hhh);
                else
                    return "any";
            case TEnum(t, params):
                trace("enum");
                return "";
            case TInst(t, params):
                var le = "";
                var type = t.get();

                switch (type.name)
                {
                    case "String":
                        le = "string";
                    default:
                        trace(type.name);
                }

                for (i in params)
                {
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
                trace(t.get().name);
                return "";
            default:
                trace("AHAHAHAHHAh");
                return "";
        }
    }

    // TODO: make this one use fullIdent
    public static function convertDocToLuau(doc:String, identation:Int = 0, identationIn:Int = 1)
    {
        var ret = "";
        if (doc.contains("\n") || doc.contains("\r"))
        {
            for (i in 0...identation)
                ret += "    ";
            ret += "--[[\n";

            for (i => k in doc.split("\n"))
            {
                for (i in 0...identation)
                    ret += "    ";
                for (i in 0...identationIn)
                    ret += "    ";
                ret += k.trim() + "\n";
            }

            for (i in 0...identation)
                ret += "    ";
            ret += "]]";
        } else
        {
            ret += "--" + doc.trim();
        }

        ret += "\n";
        return ret;
    }

    public static inline function oneIdent():String
    {
        var ident = "";
        // TODO: check how using Context.definedValue and Context.defined impacts performance and stuff
        // Cache the results if the impact is significant
        if (Context.definedValue("ident-with").toLowerCase() == "spaces" || !Context.defined("ident-with"))
        {
            for (i in 0...(Context.defined("ident-amount") ? Std.parseInt(Context.definedValue("ident-amount")) : 4))
            {
                ident += " ";
            }
        } else if (Context.definedValue("ident-with").toLowerCase() == "tabs")
        {
            for (i in 0...(Context.defined("ident-amount") ? Std.parseInt(Context.definedValue("ident-amount")) : 1))
            {
                ident += "	";
            }
        } else
        {
            // TODO: MAYBE warn for that instead of erroring, and use the defaults?
            @:privateAccess
            compilerRef.err("\033[1;41mReflaxe-Luau error:\033[0m \033[1;31mDefine ident-amount is set to an incorrect value\033[0m");
        }
        return ident;
    }

    public static function fullIdent(identLvl:Int)
    {
        var identFull = "";

        for (i in 0...identLvl)
        {
            identFull += oneIdent();
        }

        return identFull;
    }
}
#end
