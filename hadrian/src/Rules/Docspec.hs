module Rules.Docspec
  ( docspecRules
  ) where

import System.Directory (findExecutable)

import Base
import Context.Path
import Settings.Builders.Common
import qualified Packages as P

docspecRules :: Rules ()
docspecRules = do
  "docspec:base" ~> docspec base

docspec :: Action () -> Action ()
docspec lintAction = do
  isExecutablePresent <- isJust <$> liftIO (findExecutable "cabal-docspec")
  if isExecutablePresent
  then do
    putBuild "| Running cabal-docspec…"
    lintAction
    putSuccess "| Done."
  else
    putFailure "| Please make sure you have the `cabal-docspec` executable in your $PATH"

base :: Action ()
base = do
  topDir   <- topDirectory
  let context = vanillaContext Stage1 P.base
  stage1GHCPath <- P.programPath (vanillaContext Stage1 P.ghc)
  let stage1GHC = topDir </> stage1GHCPath
  stage1Lib <- stageLibPath Stage1
  let cabalFile = pkgCabalFile P.base
  let topIncludes = topDir </> "includes"
  includeDeps' <- includesDependencies Stage1
  buildPath' <- buildPath context
  let buildIncludesPath = topDir </> buildPath' </> "include"
  let includeDeps = fmap (topDir </>) includeDeps'
  mtlConfFile <- pkgConfFile $ vanillaContext Stage1 P.mtl
  deepseqConfFile <- pkgConfFile $ vanillaContext Stage1 P.deepseq
  bytestringConfFile <- pkgConfFile $ vanillaContext Stage1 P.bytestring
  let neededIncludes = includeDeps ++ [mtlConfFile, deepseqConfFile, bytestringConfFile]
  need neededIncludes

  command_ [] "cabal-docspec" [ "-w", stage1GHC
                              , "--no-cabal-plan"
                              , "--strip-comments"
                              , "--timeout", "2"
                              , "--ghci-rtsopts=-K500K"
                              , "--extra-package=mtl", "--extra-package=deepseq", "--extra-package=bytestring"
                              , "-XNoImplicitPrelude"
                              , "-I", topIncludes
                              , "-I", buildIncludesPath
                              , "-I", stage1Lib
                              , cabalFile
                              ]
