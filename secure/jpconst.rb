class JPConst
	R_PACKAGE = /package\s*(?<package>[a-zA-Z.]*)/
	R_IMPORT = /import\s*(?<package>[a-zA-Z.]*)/

	R_CLASS = /(?<attrs>((public|private|abstract)\s+)*)class\s+(?<name>[A-Za-z0-9_]+)\s*(extends\s*(?<extends>[A-Za-z0-9_\<\>]+))?\s*(implements\s*(?<implements>[A-Za-z0-9_\.]+))?/
	R_FUNCTION = /(?<accessor>(public|private|protected))*\s*(?<attr>((synchronized|final|static|field)\s+)*)(?<ret>[A-Za-z0-9_\[\]]*)\s+(?<name>[A-Za-z0-9_]+)\s*\((?<args>[A-Za-z0-9_ ,\[\]]*)/
	
	R_GLB_VAR = /(?<accessor>(public|private|protected))*\s*(?<attr>((final|static|field)\s+)*)(?<type>[A-Za-z0-9_\[\]\.]*)\s+(?<name>.*)/
	R_GLB_VAR_INIT = /(?<accessor>(public|private|protected))*\s*(?<attr>((final|static|field)\s+)*)(?<type>[A-Za-z0-9_\[\]\.]*)\s+(?<name>.*)\s*=\s*(?<value>.*)/
	R_LOC_VAR = /(?<type>[A-Za-z0-9_\[\]\.]*)\s+(?<name>.*)/
	R_LOC_VAR_INIT = /(?<type>[A-Za-z0-9_\[\]\.]*)\s+(?<name>.*)\s*=\s*(?<value>.*)/
	R_OP = /^(?<a>[a-zA-Z0-9_]*)\s*(?<op>(\+|\-|\*|\/)?)=\s*(?<b>.*);/
	R_A_IS_B = /(?<a>[a-zA-Z0-9._]*)\s*=\s*(?<b>.*)/
	
	R_IF = /if\s*\(\s*(?<expr>.*)\s*\)/
	R_ELSE = /else.*/
	
	R_WHILE = /while\((?<condition>.*)\)/
	R_FOR = /for\s*\((?<a>.*);(?<b>.*);(?<c>.*)\s*\)/
	
	R_CALLFUNC = /^((?<class>[a-zA-Z0-9_]*)\.)?(?<method>[a-zA-Z0-9_]+)\((?<param>.*)\)/
	
	R_TRY = /^try/
	R_FINALLY = /^finally/
	R_CATCH = /catch\s*\(\s*(?<arg>[a-zA-Z\s]*)\s*\)\s*/
	R_THROW = /throw (?<exception>.*);/
	
	R_RETURN = /return(\s+(?<value>[a-zA-Z0-9._]+))?/

	EndLine = [";", "{", "}", ")", "eol"]

	NoIndent = 0
	PushIndent = 1
	PopIndent = 2
	SingleLineIndent = 3
end