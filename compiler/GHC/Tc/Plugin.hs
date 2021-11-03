
-- | This module provides an interface for typechecker plugins to
-- access select functions of the 'TcM', principally those to do with
-- reading parts of the state.
module GHC.Tc.Plugin (
        -- * Basic TcPluginM functionality
        TcPluginM,
        tcPluginIO,
        tcPluginTrace,
        unsafeTcPluginTcM,

        -- * Finding Modules and Names
        Finder.FindResult(..),
        findImportedModule,
        lookupOrig,

        -- * Looking up Names in the typechecking environment
        tcLookupGlobal,
        tcLookupTyCon,
        tcLookupDataCon,
        tcLookupClass,
        tcLookup,
        tcLookupId,

        -- * Getting the TcM state
        getTopEnv,
        getTargetPlatform,
        getEnvs,
        getInstEnvs,
        getFamInstEnvs,
        matchFam,

        -- * Type variables
        newUnique,
        newFlexiTyVar,
        isTouchableTcPluginM,

        -- * Zonking
        zonkTcType,
        zonkCt,

        -- * Creating constraints
        newWanted,
        newDerived,
        newGiven,
        newCoercionHole,

        -- * Manipulating evidence bindings
        newEvVar,
        setEvBind,
    ) where

import GHC.Prelude

import GHC.Platform (Platform)

import qualified GHC.Tc.Utils.Monad     as TcM
import qualified GHC.Tc.Solver.Monad    as TcS
import qualified GHC.Tc.Utils.Env       as TcM
import qualified GHC.Tc.Utils.TcMType   as TcM
import qualified GHC.Tc.Instance.Family as TcM
import qualified GHC.Iface.Env          as IfaceEnv
import qualified GHC.Unit.Finder        as Finder

import GHC.Core.FamInstEnv     ( FamInstEnv )
import GHC.Tc.Utils.Monad      ( TcGblEnv, TcLclEnv, TcPluginM
                               , unsafeTcPluginTcM
                               , liftIO, traceTc )
import GHC.Tc.Types.Constraint ( Ct, CtLoc, CtEvidence(..), ctLocOrigin )
import GHC.Tc.Utils.TcMType    ( TcTyVar, TcType )
import GHC.Tc.Utils.Env        ( TcTyThing )
import GHC.Tc.Types.Evidence   ( CoercionHole, EvTerm(..)
                               , EvExpr, EvBindsVar, EvBind, mkGivenEvBind )
import GHC.Types.Var           ( EvVar )

import GHC.Unit.Module    ( ModuleName, Module )
import GHC.Types.Name     ( OccName, Name )
import GHC.Types.TyThing  ( TyThing )
import GHC.Core.Reduction ( Reduction )
import GHC.Core.TyCon     ( TyCon )
import GHC.Core.DataCon   ( DataCon )
import GHC.Core.Class     ( Class )
import GHC.Driver.Config.Finder ( initFinderOpts )
import GHC.Driver.Env       ( HscEnv(..), hsc_home_unit, hsc_units )
import GHC.Utils.Outputable ( SDoc )
import GHC.Core.Type        ( Kind, Type, PredType )
import GHC.Types.Id         ( Id )
import GHC.Core.InstEnv     ( InstEnvs )
import GHC.Types.Unique     ( Unique )
import GHC.Types.PkgQual    ( PkgQual )


-- | Perform some IO, typically to interact with an external tool.
tcPluginIO :: IO a -> TcPluginM a
tcPluginIO a = unsafeTcPluginTcM (liftIO a)

-- | Output useful for debugging the compiler.
tcPluginTrace :: String -> SDoc -> TcPluginM ()
tcPluginTrace a b = unsafeTcPluginTcM (traceTc a b)


findImportedModule :: ModuleName -> PkgQual -> TcPluginM Finder.FindResult
findImportedModule mod_name mb_pkg = do
    hsc_env <- getTopEnv
    let fc        = hsc_FC hsc_env
    let home_unit = hsc_home_unit hsc_env
    let units     = hsc_units hsc_env
    let dflags    = hsc_dflags hsc_env
    let fopts     = initFinderOpts dflags
    tcPluginIO $ Finder.findImportedModule fc fopts units home_unit mod_name mb_pkg

lookupOrig :: Module -> OccName -> TcPluginM Name
lookupOrig mod = unsafeTcPluginTcM . IfaceEnv.lookupOrig mod


tcLookupGlobal :: Name -> TcPluginM TyThing
tcLookupGlobal = unsafeTcPluginTcM . TcM.tcLookupGlobal

tcLookupTyCon :: Name -> TcPluginM TyCon
tcLookupTyCon = unsafeTcPluginTcM . TcM.tcLookupTyCon

tcLookupDataCon :: Name -> TcPluginM DataCon
tcLookupDataCon = unsafeTcPluginTcM . TcM.tcLookupDataCon

tcLookupClass :: Name -> TcPluginM Class
tcLookupClass = unsafeTcPluginTcM . TcM.tcLookupClass

tcLookup :: Name -> TcPluginM TcTyThing
tcLookup = unsafeTcPluginTcM . TcM.tcLookup

tcLookupId :: Name -> TcPluginM Id
tcLookupId = unsafeTcPluginTcM . TcM.tcLookupId


getTopEnv :: TcPluginM HscEnv
getTopEnv = unsafeTcPluginTcM TcM.getTopEnv

getTargetPlatform :: TcPluginM Platform
getTargetPlatform = unsafeTcPluginTcM TcM.getPlatform


getEnvs :: TcPluginM (TcGblEnv, TcLclEnv)
getEnvs = unsafeTcPluginTcM TcM.getEnvs

getInstEnvs :: TcPluginM InstEnvs
getInstEnvs = unsafeTcPluginTcM TcM.tcGetInstEnvs

getFamInstEnvs :: TcPluginM (FamInstEnv, FamInstEnv)
getFamInstEnvs = unsafeTcPluginTcM TcM.tcGetFamInstEnvs

matchFam :: TyCon -> [Type]
         -> TcPluginM (Maybe Reduction)
matchFam tycon args = unsafeTcPluginTcM $ TcS.matchFamTcM tycon args

newUnique :: TcPluginM Unique
newUnique = unsafeTcPluginTcM TcM.newUnique

newFlexiTyVar :: Kind -> TcPluginM TcTyVar
newFlexiTyVar = unsafeTcPluginTcM . TcM.newFlexiTyVar

isTouchableTcPluginM :: TcTyVar -> TcPluginM Bool
isTouchableTcPluginM = unsafeTcPluginTcM . TcM.isTouchableTcM

-- Confused by zonking? See Note [What is zonking?] in GHC.Tc.Utils.TcMType.
zonkTcType :: TcType -> TcPluginM TcType
zonkTcType = unsafeTcPluginTcM . TcM.zonkTcType

zonkCt :: Ct -> TcPluginM Ct
zonkCt = unsafeTcPluginTcM . TcM.zonkCt

-- | Create a new wanted constraint.
newWanted :: CtLoc -> PredType -> TcPluginM CtEvidence
newWanted loc pty
  = unsafeTcPluginTcM (TcM.newWanted (ctLocOrigin loc) Nothing pty)

-- | Create a new derived constraint.
newDerived :: CtLoc -> PredType -> TcPluginM CtEvidence
newDerived loc pty = return CtDerived { ctev_pred = pty, ctev_loc = loc }

-- | Create a new given constraint, with the supplied evidence.
--
-- This should only be invoked within 'tcPluginSolve'.
newGiven :: EvBindsVar -> CtLoc -> PredType -> EvExpr -> TcPluginM CtEvidence
newGiven tc_evbinds loc pty evtm = do
   new_ev <- newEvVar pty
   setEvBind tc_evbinds $ mkGivenEvBind new_ev (EvExpr evtm)
   return CtGiven { ctev_pred = pty, ctev_evar = new_ev, ctev_loc = loc }

-- | Create a fresh evidence variable.
--
-- This should only be invoked within 'tcPluginSolve'.
newEvVar :: PredType -> TcPluginM EvVar
newEvVar = unsafeTcPluginTcM . TcM.newEvVar

-- | Create a fresh coercion hole.
-- This should only be invoked within 'tcPluginSolve'.
newCoercionHole :: PredType -> TcPluginM CoercionHole
newCoercionHole = unsafeTcPluginTcM . TcM.newCoercionHole

-- | Bind an evidence variable.
--
-- This should only be invoked within 'tcPluginSolve'.
setEvBind :: EvBindsVar -> EvBind -> TcPluginM ()
setEvBind tc_evbinds ev_bind = do
    unsafeTcPluginTcM $ TcM.addTcEvBind tc_evbinds ev_bind
