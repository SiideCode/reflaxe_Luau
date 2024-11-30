// A bit of code to compile with your custom compiler.
//
// This code has no relevance beyond testing purposes.
// Please modify and add your own test code!
package;

interface Lel {
	public function l():Int;
	public var lo:String;
	public var le:Int;
}

enum TestEnum {
	One;
	Two;
	Three;
}

/**dlocs*/
class TestClass {
	/** doc
	 * loc */
	static private var fld:TestEnum = Two;

	static public var hemlo:Int = 3;

	var field:TestEnum;

	public function new(hello:Int, bye:String, my:Bool) {
		trace("Create Code class!");
		field = One;
	}

	public function increment() {
		switch (field) {
			case One:
				field = Two;
				fld = Three;
			case Two:
				field = Three;
			case _:
		}
		trace(field);
	}
}

function main() {
	trace("Hello world!");

	final c = new TestClass(3, "g", false);
	for (i in 0...3) {
		c.increment();
	}
}
