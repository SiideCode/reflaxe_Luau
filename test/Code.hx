// A bit of code to compile with your custom compiler.
//
// This code has no relevance beyond testing purposes.
// Please modify and add your own test code!
package;

interface Lel
{
    public function l():Int;
    public var lo:String;
    public var le:Int;
}

enum TestEnum
{
    One;
    Two;
    Three;
}

enum abstract Hello(String)
{
    var One = "One";
    var Two = "Two";
}

/**dlocs*/
class TestClass
{
    /** doc
     * loc */
    static private var fld:TestEnum = Two;

    static private var foold:Hello = One;

    static public var hemlo:Int = 3;

    static public var lal:Int;

    var field:TestEnum;

    public function new(hello:Int, bye:String, my:Bool)
    {
        trace("Create Code class!");
        field = One;
    }

    public function increment()
    {
        switch (field)
        {
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

function main()
{
    trace("Hello world!");

    final c = new TestClass(3, "g", false);
    for (i in 0...3)
    {
        c.increment();
    }
}

// TODO: make this naming scheme a workaround for name.init.lua files, because you can't have a non-module-script-like behaviour in haxe
// (you can define functions, variables inside, stuff)
function something_init()
{
    function hello() {}
}
