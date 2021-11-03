{-# LANGUAGE Haskell2010 #-}
{-# LANGUAGE DuplicateRecordFields #-}
module DuplicateRecordFields (RawReplay(..)) where

import Prelude hiding (Int)

data Int = Int

data RawReplay = RawReplay
    { headerSize :: Int
    -- ^ The byte size of the first section.
    , headerCRC :: Int
    -- ^ The CRC of the first section.
    , header :: Int
    -- ^ The first section.
    , contentSize :: Int
    -- ^ The byte size of the second section.
    , contentCRC :: Int
    -- ^ The CRC of the second section.
    , content :: Int
    -- ^ The second section.
    , footer :: Int
    -- ^ Arbitrary data after the second section. In replays generated by
    -- Rocket League, this is always empty. However it is not technically
    -- invalid to put something here.
    }