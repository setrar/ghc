{-# LANGUAGE BangPatterns #-}
module Main where

import GHC.Profiling
import Control.Exception

main = do
  let !t = [0..1000000]
  evaluate (length t)
  requestHeapCensus
  evaluate (length t)


