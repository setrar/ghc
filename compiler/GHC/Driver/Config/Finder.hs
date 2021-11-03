module GHC.Driver.Config.Finder (
    FinderOpts(..),
    initFinderOpts
  ) where

import GHC.Prelude

import GHC.Driver.Session
import GHC.Unit.Finder.Types


-- | Create a new 'FinderOpts' from DynFlags.
initFinderOpts :: DynFlags -> FinderOpts
initFinderOpts flags = FinderOpts
  { finder_importPaths = importPaths flags
  , finder_lookupHomeInterfaces = isOneShot (ghcMode flags)
  , finder_bypassHiFileCheck = MkDepend == (ghcMode flags)
  , finder_ways = ways flags
  , finder_enableSuggestions = gopt Opt_HelpfulErrors flags
  , finder_hieDir = hieDir flags
  , finder_hieSuf = hieSuf flags
  , finder_hiDir = hiDir flags
  , finder_hiSuf = hiSuf_ flags
  , finder_dynHiSuf = dynHiSuf_ flags
  , finder_objectDir = objectDir flags
  , finder_objectSuf = objectSuf_ flags
  , finder_dynObjectSuf = dynObjectSuf_ flags
  , finder_stubDir = stubDir flags
  }
