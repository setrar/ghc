{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wall #-}
module Simple where

pattern Foo :: ()
pattern Foo = ()

a :: () -> ()
a Foo = ()

data A = B | C | D

{-#┬áCOMPLETE Foo #-}
{-#┬áCOMPLETE B,C #-}
{-#┬áCOMPLETE B #-}

b :: A -> A
b B = B
b C = C
