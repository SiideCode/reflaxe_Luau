package luaucompiler;

import reflaxe.BaseCompiler.LambdaWrapType;
#if (macro || luau_runtime)
import reflaxe.ReflectCompiler;

final reservedNames = [
	"if", "else", "elseif", "then", "end", "local", "nil", "repeat", "break", "until", "for", "in", "do", "true", "false", "and", "or", "not", "function",
	"while", "assert", "error", "gcinfo", "getfenv", "getmetatable", "next", "newproxy", "print", "rawequal", "rawget", "rawset", "select", "setfenv",
	"setmetatable", "tonumber", "tostring", "type", "typeof", "ipairs", "pairs", "pcall", "xpcall", "unpack"
];

class CompilerInit {
	public static function Start() {
		#if !eval
		Sys.println("CompilerInit.Start can only be called from a macro context.");
		return;
		#end

		#if (haxe_ver < "4.3.0")
		Sys.println("Reflaxe/Luau requires Haxe version 4.3.0 or greater.");
		return;
		#end

		var compiler = new Compiler();

		ReflectCompiler.AddCompiler(compiler, {
			fileOutputExtension: ".lua",
			outputDirDefineName: "luau-output",
			fileOutputType: FilePerModule,
			reservedVarNames: reservedNames,
			targetCodeInjectionName: "__luau__",
			smartDCE: true,
			// trackUsedTypes: true,
			// ignoreTypes: ["", ""],
			// unwrapTypedefs: false,
			// TODO: make it a define (ALLOW_SHADOWING)
			// preventRepeatVars: true,
			convertNullCoal: true,
			convertUnopIncrement: true,
			// wrapFunctionReferences: ExternOnly,
			// wrapFunctionMetadata:
			// [
			//	":native",
			//	":nativeFunctionCode"
			// ],
			// just to get rid of the stdlib junk
			// dynamicDCE: true,
			// trackClassHierarchy: true,
			// ignoreBodylessFunctions: true,
			// allowMetaMetadata: false,
			// ignoreNonPhysicalFields: false,
			// metadataTemplates:
		});
	}
}
#end
