#charset "us-ascii"

/*
 *   Krister's debugging suite. This extension contains the following
 *   debugging aids:
 *
 *   - a set of debugging actions:
 *      - 'purloin', for getting hold of objects that are out of scope
 *      - 'gonear', for teleporting to remote locations
 *      - 'frotz', for making objects emit light (or stop emitting light, if
 *        they already are)
 *
 *   - a framework for adding game-specific debugging actions (see comments
 *     below for how to do this)
 *
 *   - an in-game expression evaluator (again, see below for details)
 *
 *   Note that this extension automatically includes reflect.t for debug
 *   builds, so there is no need to do this manually.
 *
 *   kfDebug.t   Version 1
 *   Copyright 2010, Krister Fundin (fundin@yahoo.com)
 */

#ifdef __DEBUG

#include <adv3.h>
#include <en_us.h>

#include <reflect.t>

/* ---------------------------------------------------------------------- */
/*
 *   Purloin. This action allows the player to get hold of objects that are
 *   either out of scope or for other reasons unreachable. It makes no
 *   checks at all for logicalness, so it's quite possible to purloin
 *   buildings or people or anything at all.
 */
DefineTAction(Purloin)
    objInScope(obj) { return true; }
    
    verifyAction() { }
    execAction()
    {
        dobjCur_.moveIntoForTravel(gActor);
        "Purloined. ";
    }
;

VerbRule(Purloin)
    'purloin' dobjList
    : PurloinAction
    
    verbPhrase = 'purloin/purloining (what)'
;

/* ---------------------------------------------------------------------- */
/*
 *   Gonear. This action teleports the player to the location of a specified
 *   object. It works with NestedRooms as well as Rooms, so a bit of caution
 *   might be needed: if you type 'gonear bob' and Bob is sitting in an
 *   armchair, then the destination will be the armchair. You can of course
 *   name the rooms directly if you have assigned vocabulary words to them.
 */
DefineTAction(Gonear)
    objInScope(obj) { return true; }
    
    verifyAction() { }
    execAction()
    {
        local dest = dobjCur_.roomLocation;
        
        if (dest != nil)
        {
            gActor.moveIntoForTravel(dest);
            gActor.lookAround(true);
        }
        else
        {
            "You can't go there. ";
            return;
        }
    }
;

VerbRule(Gonear)
    'gonear' singleDobj
    : GonearAction
    
    verbPhrase = 'go/going near (what)'
;

/* ---------------------------------------------------------------------- */
/*
 *   Frotz. This action makes arbitrary objects start emitting light, or
 *   stop emitting light if they already are.
 */
DefineTAction(Frotz)
    verifyAction() { }
    execAction()
    {
        if (dobjCur_.brightness == 0)
        {
            dobjCur_.brightness = 3;
            
            "{The dobj/he} start{s} to glow. ";
        }
        else
        {
            dobjCur_.brightness = 0;
            
            "{The dobj/he} stop{s} glowing. ";
        }
    }
;

VerbRule(Frotz)
    'frotz' singleDobj
    : FrotzAction
    
    verbPhrase = 'frotz/frotzing (what)'
;

/* ---------------------------------------------------------------------- */
/*
 *   Game-specific debugging commands. These can be used E.G. to jump to a
 *   later chapter in the game. To add one, use this syntax:
 *
 *      grammar debugCommand:
 *          'chapter5'
 *          : BasicProd
 *
 *          execute()
 *          {
 *              // carry out the necessary steps here
 *          }
 *      ;
 *
 *   A definition such as this won't have any effect in a release build, so
 *   it's not necessary to put an #ifdef around it. One might want to set up
 *   a macro for creating these debug commands in order to save some typing,
 *   however. Here is one way to do so:
 *
 *      #ifdef __DEBUG
 *      #define dbgCommand(name, code) \
 *          grammar debugCommand : name : BasicProd execute() code
 *      #else
 *      #define dbgCommand(name, code)
 *      #endif
 *
 *   With this macro in place, the definition can be shortened to:
 *
 *      dbgCommand('chapter5',
 *      {
 *          // carry out the necessary steps here
 *      });
 *
 *   In any case, the command is then executed by typing 'debug chapter5'.
 */
DefineSystemAction(CustomDebug)
    execSystemAction()
    {
        cmd_.execute();
    }
;

VerbRule(CustomDebug)
    'debug' debugCommand->cmd_
    : CustomDebugAction
    
    verbPhrase = 'debug/debugging'
;

grammar debugCommand(unknown):
    [badness 500] miscWordList
    : BasicProd
    
    execute()
    {
        "Unknown debugging command. ";
    }
;

/* ---------------------------------------------------------------------- */
/*
 *   In-game expression evaluation. This part of the extension provides a
 *   quick way to look up variables from within the game. Any command line
 *   which starts with an equals sign is passed through a much simplified
 *   version of the 'evaluate' command from the TADS 3 debugger, and the
 *   result is then displayed if there was one.
 *
 *   The parser used here can evaluate properties and call methods on
 *   objects, possibly with arguments, and it recognizes simple strings and
 *   numbers, but that's as far as it goes. In particular, it should be
 *   noted that macros such as gDobj can't be evaluated this way.
 */
evalPreParser: StringPreParser
    doParsing(str, which)
    {
        if (which == rmcAskLiteral)
            return str;
        
        if (!str.startsWith('/'))
            return str;
        
        try
        {
            local toks = evalTokenizer.tokenize(str.substr(2));
            local match = evalExpr.parseTokens(toks, nil);
            
            if (match != [])
            {
                say (reflectionServices.valToSymbol(match[1].evaluate()));
                return nil;
            }
        }
        catch (Exception exc)
        {
            say('Couldn\'t parse. Was that a property or method of an object?');
            return nil;
        }
        
        return str;
    }
;

evalException: Exception;

evalTokenizer: Tokenizer
    rules_ = static
    [
        ['whitespace', new RexPattern('<space>+'), nil, &tokCvtSkip, nil],
        ['operators', new RexPattern('[.,()]'), tokPunct, nil, nil],
        ['strings', new RexPattern('<squote>.*?<squote>'),
            tokString, nil, nil],
        ['numbers', new RexPattern('<digit>+'), tokInt, nil, nil],
        ['symbols', new RexPattern('<alphanum|_>+'), tokWord, nil, nil]
    ]
;

grammar evalExpr(compound):
    evalExpr->lhs_ '.' evalObj->rhs_ evalArgList->args_
    : BasicProd
    
    evaluate()
    {
        local lhs = lhs_.evaluate();
        local rhs = rhs_.evaluate();
        local args = args_.evaluate();
        
        if (dataType(lhs) not in (TypeObject, TypeSString, TypeList)
            || dataType(rhs) != TypeProp)
        {
            throw evalException;
        }
        
        return lhs.(rhs)(args...);
    }
;

grammar evalExpr(simple):
    evalObj->obj_
    : BasicProd
    
    evaluate() { return obj_.evaluate(); }
;

grammar evalArgList(nonempty):
    '(' evalArgs->args_ ')'
    : BasicProd
    
    evaluate() { return args_.evaluate(); }
;

grammar evalArgList(empty):
    ('(' ')' | )
    : BasicProd
    
    evaluate() { return []; }
;

grammar evalArgs(compound):
    evalExpr->arg_ ',' evalArgs->args_
    : BasicProd
    
    evaluate() { return args_.evaluate().prepend(arg_.evaluate()); }
;

grammar evalArgs(single):
    evalExpr->arg_
    : BasicProd
    
    evaluate() { return [arg_.evaluate()]; }
;

grammar evalObj(symbol):
    tokWord->tok_
    : BasicProd
    
    evaluate()
    {
        switch (tok_)
        {
        case 'true': return true;
        case 'nil': return nil;
        default:
            local val = reflectionServices.symtab_[tok_];
        
            if (val != nil)
                return val;
            else
                throw evalException;
        }
    }
;

grammar evalObj(string):
    tokString->tok_
    : BasicProd
    
    evaluate() { return tok_.substr(2, tok_.length - 2); }
;

grammar evalObj(number):
    tokInt->tok_
    : BasicProd
    
    evaluate() { return toInteger(tok_); }
;

#endif // __DEBUG
