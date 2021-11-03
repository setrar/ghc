{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

-- typechecking goes really fast if you uncomment this line

-- {-# OPTIONS_GHC -fmax-valid-hole-fits=0 #-}

module SlowTypecheck where

import Language.Haskell.Syntax.Expr
import GHC (GhcPs)

testMe :: HsExpr GhcPs -> Int
testMe (HsVar a b) = _
testMe (HsUnboundVar xuv uv) = _
testMe (HsOverLabel xol m_ip) = _
testMe (HsIPVar xv hin) = _
testMe (HsOverLit xole hol) = _
testMe (HsLit xle hl) = _
testMe (HsLam xl mg) = _
testMe (HsLamCase xlc mg) = _
testMe (HsApp xa gl gl') = _
testMe (HsAppType xate gl hwcb) = _
testMe (OpApp xoa gl gl' gl2) = _
testMe (NegApp xna gl se) = _
testMe (HsPar xp gl ab ac) = _
testMe (SectionL xsl gl gl') = _
testMe (SectionR xsr gl gl') = _
testMe (ExplicitTuple xet gls box) = _
testMe (ExplicitSum xes n i gl) = _
testMe (HsCase xc gl mg) = _
testMe (HsIf xi m_se gl gl' ) = _
testMe (HsMultiIf xmi gls) = _
testMe (HsLet xl tkLet gl tkIn gl') = _
testMe (HsDo xd hsc gl) = _
testMe (ExplicitList xel m_se) = _
testMe (RecordCon xrc gl hrf) = _
testMe (RecordUpd xru gl gls) = _
testMe (ExprWithTySig xewts gl hwcb) = _
testMe (ArithSeq xas m_se asi) = _
testMe (HsBracket xb hb) = _
testMe (HsRnBracketOut xrbo hb prss) = _
testMe (HsTcBracketOut xtbo hb ptss as) = _
testMe (HsSpliceE xse hs) = _
testMe (HsProc xp pat gl) = _
testMe (HsStatic xs gl) = _
testMe (XExpr xe) = _

