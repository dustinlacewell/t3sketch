#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

/*
To use this extension, which was created by Ben Cressey and Eric Eve, define Test objects like so:
    
foo: Test
    testName = 'foo'
    testList =
    [
        'x me',
        'i'
    ]
;

bar: Test
    testName = 'bar'
    testList =
    [
        'look',
        'listen'
    ]
;

all: Test
    testName = 'all'
    testList =
    [
        'test foo',
        'test bar'
    ]
; 

Alternatively, you can include the following line at the head of your file of test scripts:
    
Test template 'testName' [testList];

...and then use the template structure to create your test objects more conveniently:
    
someTest: Test 'foo' ['x me', 'i'];

Unless you're planning to refer to the Test object in some other part of your code,
you can save a bit of typing by making it an anonymous object:
    
Test 'foo' ['x me', 'i'];  

*/
    
    /*
     *   The 'list tests' and 'list tests fully' commands can be used to list 
     *   your test scripts from within the running game.
     */
    
#ifdef __DEBUG
    
DefineSystemAction(ListTests)
    execSystemAction
    {

        if(allTests.lst.length == 0)
        {
            reportFailure('There are no test scripts defined in this game. ');
            exit;
        }
       
        foreach(local testObj in allTests.lst)
        {
            "<<testObj.testName>>";
            if(gAction.fully)               
            {
                ": ";
                foreach(local txt in testObj.testList)
                    "<<txt>>/";
            }
            "\n";
        }
    }
    fully = nil
;

VerbRule(ListTests)
    ('list' | 'l') 'tests' (| 'fully' -> fully)
    : ListTestsAction
    verbPhrase = 'list/listing test scripts'
;

    /*
     *   The 'test X' command can be used with any Test object defined in the source code:
     */

DefineLiteralAction(Test)
   execAction()
   {
      local target = getLiteral().toLower();
      local script = allTests.valWhich({x: x.testName.toLower == target});
      if (script)
         script.run();
      else
         "Test sequence not found. ";
   }
;

VerbRule(Test)
   'test' singleLiteral
   : TestAction
   verbPhrase = 'test/testing (what)'
;

class Test: object
   testName = 'nil'
   testList = [ 'z' ]
   testFile = 'TEST_' + testName + '.TCMD'

   run
   {
      "Testing sequence: \"<<testName>>\". ";
      local out = File.openTextFile(testFile, FileAccessWrite);
      testList.forEach({x: out.writeFile('>' + x + '\n')});
      out.closeFile();
      setScriptFile(testFile);
   }
;

allTests: object
   lst()
   {
      if (lst_ == nil)
         initLst();
      return lst_;
   }

   initLst()
   {
      lst_ = new Vector(50);
      local obj = firstObj();
      while (obj != nil)
      {
         if(obj.ofKind(Test))
            lst_.append(obj);
         obj = nextObj(obj);
      }
      lst_ = lst_.toList();
   }

   valWhich(cond)
   {
      if (lst_ == nil)
         initLst();
      return lst_.valWhich(cond);
   }

   lst_ = nil
;

#endif // __DEBUG