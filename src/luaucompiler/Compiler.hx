package luaucompiler;

// Make sure this code only exists at compile-time.
import reflaxe.helpers.Context;
#if (macro || luau_runtime)
// Import relevant Haxe macro types.
import haxe.macro.Type;
// Import Reflaxe types
import reflaxe.DirectToStringCompiler;
import reflaxe.data.ClassFuncData;
import reflaxe.data.ClassVarData;
import reflaxe.data.EnumOptionData;
import luaucompiler.utils.Utils;

using StringTools;

/**
    The class used to compile the Haxe AST into your target language's code.

    This must extend from `BaseCompiler`. `PluginCompiler<T>` is a child class
    that provides the ability for people to make plugins for your compiler.
**/
class Compiler extends DirectToStringCompiler
{
    /**
        This is the function from the BaseCompiler to override to compile Haxe classes.
        Given the haxe.macro.ClassType and its variables and fields, return the output String.
        If `null` is returned, the class is ignored and nothing is compiled for it.

        https://api.haxe.org/haxe/macro/ClassType.html
    **/
    public function compileClassImpl(classType:ClassType, varFields:Array<ClassVarData>, funcFields:Array<ClassFuncData>):Null<String>
    {
        // TODO: add a proper class type definition generation and make it optional
        if (classType.isExtern)
        {
            return null;
        }

        var ret = "";

        if (!Context.defined("no-watermark"))
        {
            ret += "-- Generated by reflaxe.Luau " + (Context.defined("reflaxe_Luau") ? "v" + Context.definedValue("reflaxe_Luau") : "Dev") + "\n\n";
        }

        if (classType.doc != null)
        {
            ret += Utils.convertDocToLuau(classType.doc);
        }

        // class declaration
        ret += classType.name + " = " + "{}" + "\n\n";

        for (i in varFields)
        {
            // TODO: make a function to extract the constant from typedexpr (compileClassVarExpr doesn't work)
            var l = i.field.expr();
            if (l != null)
            {
                trace('TypedExpr: ${compileClassVarExpr(l)}');
            }
            if (i.isStatic)
            {
                if (i.field.doc != null)
                    ret += Utils.convertDocToLuau(i.field.doc);

                if (i.field.isPublic)
                    ret += '${classType.name}.${i.field.name} ${i.hasDefaultValue() ? "= nil" : "= nil"}\n'
                else
                    ret += 'local ${i.field.name}${i.hasDefaultValue() ? "= nil" : ':${Utils.typeToString(i.field.type)}'}\n';
            }
        }

        for (i in funcFields)
        {
            // i.args[0] != null ? i.args[0].getName() : null
            trace(i.field.name, i.args);

            // Documentation
            if (i.field.doc != null)
                ret += Utils.convertDocToLuau(i.field.doc);

            // Declaration
            ret += "function " + classType.name;
            ret += i.isStatic ? "." : ":";
            ret += '${i.field.name}(';

            for (k in i.args)
            {
                trace(k);
            }
            ret += ")\n";

            // Function body
            if (i.field.name == "new")
            {
                ret += Utils.fullIdent(1) + "local instance = {}\n";

                // do constructor stuff, add non-static vars
                for (i in varFields)
                {
                    if (!i.isStatic) {}
                }

                ret += Utils.fullIdent(1) + "setmetatable(instance, " + classType.name + ")\n";
            }

            // End
            ret += "end";
        }

        var construct;

        return ret;
    }

    /**
        Works just like `compileClassImpl`, but for Haxe enums.
        Since we're returning `null` here, all Haxe enums are ignored.

        https://api.haxe.org/haxe/macro/EnumType.html
    **/
    public function compileEnumImpl(enumType:EnumType, constructs:Array<EnumOptionData>):Null<String>
    {
        // TODO: implement
        return null;
    }

    // public function compileAbstractImpl()

    /**
        This is the final required function.
        It compiles the expressions generated from Haxe.

        PLEASE NOTE: to recusively compile sub-expressions:
            BaseCompiler.compileExpression(expr: TypedExpr): Null<String>
            BaseCompiler.compileExpressionOrError(expr: TypedExpr): String

        https://api.haxe.org/haxe/macro/TypedExpr.html
    **/
    public function compileExpressionImpl(expr:TypedExpr, topLevel:Bool):Null<String>
    {
        // TODO: implement
        switch (expr.expr)
        {
            case TConst(c):
                switch (c)
                {
                    case TInt(i):
                        return Std.string(i);
                    case TFloat(s):
                        return s;
                    case TString(s):
                        return s;
                    case TBool(b):
                        return b;
                    case TNull:
                        return "nil";
                    case TThis:
                        return "self";
                    case TSuper:
                        /*
                            TODO: figure out how to make the super keyword work cause:
                            super() is a superclass constructor call (in roblox it's className.new())
                            super.function() is a superclass function call (in roblox it's className.function())
                         */
                        trace("super");
                        return null;
                }
            default:
                trace(expr.expr.getName());
                // trace(expr.pos);
        }
        return null;
    }
}
#end
