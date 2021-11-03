{-# LANGUAGE GADTs #-}
module GHC.Tc.Errors.Types (
  -- * Main types
    TcRnMessage(..)
  , TcRnMessageDetailed(..)
  , ErrInfo(..)
  , FixedRuntimeRepProvenance(..)
  , pprFixedRuntimeRepProvenance
  , ShadowedNameProvenance(..)
  , RecordFieldPart(..)
  , InjectivityErrReason(..)
  , HasKinds(..)
  , hasKinds
  , SuggestUndecidableInstances(..)
  , suggestUndecidableInstances
  , NotClosedReason(..)
  , SuggestPartialTypeSignatures(..)
  , suggestPartialTypeSignatures
  , DeriveInstanceErrReason(..)
  , UsingGeneralizedNewtypeDeriving(..)
  , usingGeneralizedNewtypeDeriving
  , DeriveAnyClassEnabled(..)
  , deriveAnyClassEnabled
  , DeriveInstanceBadConstructor(..)
  , HasWildcard(..)
  , hasWildcard
  , DeriveGenericsErrReason(..)
  , HasAssociatedDataFamInsts(..)
  , hasAssociatedDataFamInsts
  , AssociatedTyLastVarInKind(..)
  , associatedTyLastVarInKind
  , AssociatedTyNotParamOverLastTyVar(..)
  , associatedTyNotParamOverLastTyVar
  ) where

import GHC.Prelude

import GHC.Hs
import {-# SOURCE #-} GHC.Tc.Types (TcIdSigInfo)
import GHC.Tc.Types.Constraint
import GHC.Tc.Types.Rank (Rank)
import GHC.Tc.Utils.TcType (TcType)
import GHC.Types.Error
import GHC.Types.FieldLabel (FieldLabelString)
import GHC.Types.Name (Name, OccName)
import GHC.Types.Name.Reader
import GHC.Types.SrcLoc
import GHC.Types.TyThing (TyThing)
import GHC.Types.Var (Id)
import GHC.Types.Var.Set (TyVarSet, VarSet)
import GHC.Unit.Types (Module)
import GHC.Utils.Outputable
import GHC.Core.Class (Class)
import GHC.Core.Coercion.Axiom (CoAxBranch)
import GHC.Core.ConLike (ConLike)
import GHC.Core.DataCon (DataCon)
import GHC.Core.FamInstEnv (FamInst)
import GHC.Core.InstEnv (ClsInst)
import GHC.Core.TyCon (TyCon, TyConFlavour)
import GHC.Core.Type (Kind, Type, ThetaType, PredType)
import GHC.Unit.State (UnitState)
import GHC.Unit.Module.Name (ModuleName)
import GHC.Types.Basic
import qualified GHC.LanguageExtensions as LangExt

import qualified Data.List.NonEmpty as NE
import           Data.Typeable hiding (TyCon)

{-
Note [Migrating TcM Messages]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As part of #18516, we are slowly migrating the diagnostic messages emitted
and reported in the TcM from SDoc to TcRnMessage. Historically, GHC emitted
some diagnostics in 3 pieces, i.e. there were lots of error-reporting functions
that accepted 3 SDocs an input: one for the important part of the message,
one for the context and one for any supplementary information. Consider the following:

    • Couldn't match expected type ‘Int’ with actual type ‘Char’
    • In the expression: x4
      In a stmt of a 'do' block: return (x2, x4)
      In the expression:

Under the hood, the reporting functions in Tc.Utils.Monad were emitting "Couldn't match"
as the important part, "In the expression" as the context and "In a stmt..In the expression"
as the supplementary, with the context and supplementary usually smashed together so that
the final message would be composed only by two SDoc (which would then be bulletted like in
the example).

In order for us to smooth out the migration to the new diagnostic infrastructure, we
introduce the 'ErrInfo' and 'TcRnMessageDetailed' types, which serve exactly the purpose
of bridging the two worlds together without breaking the external API or the existing
format of messages reported by GHC.

Using 'ErrInfo' and 'TcRnMessageDetailed' also allows us to move away from the SDoc-ridden
diagnostic API inside Tc.Utils.Monad, enabling further refactorings.

In the future, once the conversion will be complete and we will successfully eradicate
any use of SDoc in the diagnostic reporting of GHC, we can surely revisit the usage and
existence of these two types, which for now remain a "necessary evil".

-}

-- The majority of TcRn messages come with extra context about the error,
-- and this newtype captures it. See Note [Migrating TcM messages].
data ErrInfo = ErrInfo {
    errInfoContext :: !SDoc
    -- ^ Extra context associated to the error.
  , errInfoSupplementary :: !SDoc
    -- ^ Extra supplementary info associated to the error.
  }


-- | 'TcRnMessageDetailed' is an \"internal\" type (used only inside
-- 'GHC.Tc.Utils.Monad' that wraps a 'TcRnMessage' while also providing
-- any extra info needed to correctly pretty-print this diagnostic later on.
data TcRnMessageDetailed
  = TcRnMessageDetailed !ErrInfo
                        -- ^ Extra info associated with the message
                        !TcRnMessage

-- | An error which might arise during typechecking/renaming.
data TcRnMessage where
  {-| Simply wraps a generic 'Diagnostic' message @a@. It can be used by plugins
      to provide custom diagnostic messages originated during typechecking/renaming.
  -}
  TcRnUnknownMessage :: (Diagnostic a, Typeable a) => a -> TcRnMessage

  {-| TcRnMessageWithInfo is a constructor which is used when extra information is needed
      to be provided in order to qualify a diagnostic and where it was originated (and why).
      It carries an extra 'UnitState' which can be used to pretty-print some names
      and it wraps a 'TcRnMessageDetailed', which includes any extra context associated
      with this diagnostic.
  -}
  TcRnMessageWithInfo :: !UnitState
                      -- ^ The 'UnitState' will allow us to pretty-print
                      -- some diagnostics with more detail.
                      -> !TcRnMessageDetailed
                      -> TcRnMessage

  {-| A type which was expected to have a fixed runtime representation
      does not have a fixed runtime representation.

      Example:

        data D (a :: TYPE r) = MkD a

      Test cases: T11724, T18534,
                  RepPolyPatSynArg, RepPolyPatSynUnliftedNewtype,
                  RepPolyPatSynRes, T20423
  -}
  TcRnTypeDoesNotHaveFixedRuntimeRep :: !Type
                                     -> !FixedRuntimeRepProvenance
                                     -> !ErrInfo -- Extra info accumulated in the TcM monad
                                     -> TcRnMessage

  {-| TcRnImplicitLift is a warning (controlled with -Wimplicit-lift) that occurs when
      a Template Haskell quote implicitly uses 'lift'.

     Example:
       warning1 :: Lift t => t -> Q Exp
       warning1 x = [| x |]

     Test cases: th/T17804
  -}
  TcRnImplicitLift :: Outputable var => var -> !ErrInfo -> TcRnMessage
  {-| TcRnUnusedPatternBinds is a warning (controlled with -Wunused-pattern-binds)
      that occurs if a pattern binding binds no variables at all, unless it is a
      lone wild-card pattern, or a banged pattern.

     Example:
        Just _ = rhs3    -- Warning: unused pattern binding
        (_, _) = rhs4    -- Warning: unused pattern binding
        _  = rhs3        -- No warning: lone wild-card pattern
        !() = rhs4       -- No warning: banged pattern; behaves like seq

     Test cases: rename/{T13646,T17c,T17e,T7085}
  -}
  TcRnUnusedPatternBinds :: HsBind GhcRn -> TcRnMessage
  {-| TcRnDodgyImports is a warning (controlled with -Wdodgy-imports) that occurs when
      a datatype 'T' is imported with all constructors, i.e. 'T(..)', but has been exported
      abstractly, i.e. 'T'.

     Test cases: rename/should_compile/T7167
  -}
  TcRnDodgyImports :: RdrName -> TcRnMessage
  {-| TcRnDodgyExports is a warning (controlled by -Wdodgy-exports) that occurs when a datatype
      'T' is exported with all constructors, i.e. 'T(..)', but is it just a type synonym or a
      type/data family.

     Example:
       module Foo (
           T(..)  -- Warning: T is a type synonym
         , A(..)  -- Warning: A is a type family
         , C(..)  -- Warning: C is a data family
         ) where

       type T = Int
       type family A :: * -> *
       data family C :: * -> *

     Test cases: warnings/should_compile/DodgyExports01
  -}
  TcRnDodgyExports :: Name -> TcRnMessage
  {-| TcRnMissingImportList is a warning (controlled by -Wmissing-import-lists) that occurs when
      an import declaration does not explicitly list all the names brought into scope.

     Test cases: rename/should_compile/T4489
  -}
  TcRnMissingImportList :: IE GhcPs -> TcRnMessage
  {-| When a module marked trustworthy or unsafe (using -XTrustworthy or -XUnsafe) is compiled
      with a plugin, the TcRnUnsafeDueToPlugin warning (controlled by -Wunsafe) is used as the
      reason the module was inferred to be unsafe. This warning is not raised if the
      -fplugin-trustworthy flag is passed.

     Test cases: plugins/T19926
  -}
  TcRnUnsafeDueToPlugin :: TcRnMessage
  {-| TcRnModMissingRealSrcSpan is an error that occurrs when compiling a module that lacks
      an associated 'RealSrcSpan'.

     Test cases: None
  -}
  TcRnModMissingRealSrcSpan :: Module -> TcRnMessage
  {-| TcRnIdNotExportedFromModuleSig is an error pertaining to backpack that occurs
      when an identifier required by a signature is not exported by the module
      or signature that is being used as a substitution for that signature.

      Example(s): None

     Test cases: backpack/should_fail/bkpfail36
  -}
  TcRnIdNotExportedFromModuleSig :: Name -> Module -> TcRnMessage
  {-| TcRnIdNotExportedFromLocalSig is an error pertaining to backpack that
      occurs when an identifier which is necessary for implementing a module
      signature is not exported from that signature.

      Example(s): None

     Test cases: backpack/should_fail/bkpfail30
                 backpack/should_fail/bkpfail31
                 backpack/should_fail/bkpfail34
  -}
  TcRnIdNotExportedFromLocalSig :: Name -> TcRnMessage

  {-| TcRnShadowedName is a warning (controlled by -Wname-shadowing) that occurs whenever
      an inner-scope value has the same name as an outer-scope value, i.e. the inner
      value shadows the outer one. This can catch typographical errors that turn into
      hard-to-find bugs. The warning is suppressed for names beginning with an underscore.

      Examples(s):
        f = ... let f = id in ... f ...  -- NOT OK, 'f' is shadowed
        f x = do { _ignore <- this; _ignore <- that; return (the other) } -- suppressed via underscore

     Test cases: typecheck/should_compile/T10971a
                 rename/should_compile/rn039
                 rename/should_compile/rn064
                 rename/should_compile/T1972
                 rename/should_fail/T2723
                 rename/should_compile/T3262
                 driver/werror
  -}
  TcRnShadowedName :: OccName -> ShadowedNameProvenance -> TcRnMessage

  {-| TcRnDuplicateWarningDecls is an error that occurs whenever
      a warning is declared twice.

      Examples(s):
        None.

     Test cases:
        None.
  -}
  TcRnDuplicateWarningDecls :: !(LocatedN RdrName) -> !RdrName -> TcRnMessage

  {-| TcRnDuplicateWarningDecls is an error that occurs whenever
      the constraint solver in the simplifier hits the iterations' limit.

      Examples(s):
        None.

     Test cases:
        None.
  -}
  TcRnSimplifierTooManyIterations :: Cts
                                  -> !IntWithInf
                                  -- ^ The limit.
                                  -> WantedConstraints
                                  -> TcRnMessage

  {-| TcRnIllegalPatSynDecl is an error that occurs whenever
      there is an illegal pattern synonym declaration.

      Examples(s):

      varWithLocalPatSyn x = case x of
          P -> ()
        where
          pattern P = ()   -- not valid, it can't be local, it must be defined at top-level.

     Test cases: patsyn/should_fail/local
  -}
  TcRnIllegalPatSynDecl :: !(LIdP GhcPs) -> TcRnMessage

  {-| TcRnLinearPatSyn is an error that occurs whenever a pattern
      synonym signature uses a field that is not unrestricted.

      Example(s): None

     Test cases: linear/should_fail/LinearPatSyn2
  -}
  TcRnLinearPatSyn :: !Type -> TcRnMessage

  {-| TcRnEmptyRecordUpdate is an error that occurs whenever
      a record is updated without specifying any field.

      Examples(s):

      $(deriveJSON defaultOptions{} ''Bad) -- not ok, no fields selected for update of defaultOptions

     Test cases: th/T12788
  -}
  TcRnEmptyRecordUpdate :: TcRnMessage

  {-| TcRnIllegalFieldPunning is an error that occurs whenever
      field punning is used without the 'NamedFieldPuns' extension enabled.

      Examples(s):

      data Foo = Foo { a :: Int }

      foo :: Foo -> Int
      foo Foo{a} = a  -- Not ok, punning used without extension.

     Test cases: parser/should_fail/RecordDotSyntaxFail12
  -}
  TcRnIllegalFieldPunning :: !(Located RdrName) -> TcRnMessage

  {-| TcRnIllegalWildcardsInRecord is an error that occurs whenever
      wildcards (..) are used in a record without the relevant
      extension being enabled.

      Examples(s):

      data Foo = Foo { a :: Int }

      foo :: Foo -> Int
      foo Foo{..} = a  -- Not ok, wildcards used without extension.

     Test cases: parser/should_fail/RecordWildCardsFail
  -}
  TcRnIllegalWildcardsInRecord :: !RecordFieldPart -> TcRnMessage

  {-| TcRnDuplicateFieldName is an error that occurs whenever
      there are duplicate field names in a record.

      Examples(s): None.

     Test cases: None.
  -}
  TcRnDuplicateFieldName :: !RecordFieldPart -> NE.NonEmpty RdrName -> TcRnMessage

  {-| TcRnIllegalViewPattern is an error that occurs whenever
      the ViewPatterns syntax is used but the ViewPatterns language extension
      is not enabled.

      Examples(s):
      data Foo = Foo { a :: Int }

      foo :: Foo -> Int
      foo (a -> l) = l -- not OK, the 'ViewPattern' extension is not enabled.

     Test cases: parser/should_fail/ViewPatternsFail
  -}
  TcRnIllegalViewPattern :: !(Pat GhcPs) -> TcRnMessage

  {-| TcRnCharLiteralOutOfRange is an error that occurs whenever
      a character is out of range.

      Examples(s): None

     Test cases: None
  -}
  TcRnCharLiteralOutOfRange :: !Char -> TcRnMessage

  {-| TcRnIllegalWildcardsInConstructor is an error that occurs whenever
      the record wildcards '..' are used inside a constructor without labeled fields.

      Examples(s): None

     Test cases: None
  -}
  TcRnIllegalWildcardsInConstructor :: !Name -> TcRnMessage

  {-| TcRnIgnoringAnnotations is a warning that occurs when the source code
      contains annotation pragmas but the platform in use does not support an
      external interpreter such as GHCi and therefore the annotations are ignored.

      Example(s): None

     Test cases: None
  -}
  TcRnIgnoringAnnotations :: [LAnnDecl GhcRn] -> TcRnMessage

  {-| TcRnAnnotationInSafeHaskell is an error that occurs if annotation pragmas
      are used in conjunction with Safe Haskell.

      Example(s): None

     Test cases: annotations/should_fail/T10826
  -}
  TcRnAnnotationInSafeHaskell :: TcRnMessage

  {-| TcRnInvalidTypeApplication is an error that occurs when a visible type application
      is used with an expression that does not accept "specified" type arguments.

      Example(s):
      foo :: forall {a}. a -> a
      foo x = x
      bar :: ()
      bar = let x = foo @Int 42
            in ()

     Test cases: overloadedrecflds/should_fail/overloadedlabelsfail03
                 typecheck/should_fail/ExplicitSpecificity1
                 typecheck/should_fail/ExplicitSpecificity10
                 typecheck/should_fail/ExplicitSpecificity2
                 typecheck/should_fail/T17173
                 typecheck/should_fail/VtaFail
  -}
  TcRnInvalidTypeApplication :: Type -> LHsWcType GhcRn -> TcRnMessage

  {-| TcRnTagToEnumMissingValArg is an error that occurs when the 'tagToEnum#'
      function is not applied to a single value argument.

      Example(s):
      tagToEnum# 1 2

     Test cases: None
  -}
  TcRnTagToEnumMissingValArg :: TcRnMessage

  {-| TcRnTagToEnumUnspecifiedResTy is an error that occurs when the 'tagToEnum#'
      function is not given a concrete result type.

      Example(s):
      foo :: forall a. a
      foo = tagToEnum# 0#

     Test cases: typecheck/should_fail/tcfail164
  -}
  TcRnTagToEnumUnspecifiedResTy :: Type -> TcRnMessage

  {-| TcRnTagToEnumResTyNotAnEnum is an error that occurs when the 'tagToEnum#'
      function is given a result type that is not an enumeration type.

      Example(s):
      foo :: Int -- not an enumeration TyCon
      foo = tagToEnum# 0#

     Test cases: typecheck/should_fail/tcfail164
  -}
  TcRnTagToEnumResTyNotAnEnum :: Type -> TcRnMessage

  {-| TcRnArrowIfThenElsePredDependsOnResultTy is an error that occurs when the
      predicate type of an ifThenElse expression in arrow notation depends on
      the type of the result.

      Example(s): None

     Test cases: None
  -}
  TcRnArrowIfThenElsePredDependsOnResultTy :: TcRnMessage

  {-| TcRnArrowCommandExpected is an error that occurs if a non-arrow command
      is used where an arrow command is expected.

      Example(s): None

     Test cases: None
  -}
  TcRnArrowCommandExpected :: HsCmd GhcRn -> TcRnMessage

  {-| TcRnIllegalHsBootFileDecl is an error that occurs when an hs-boot file
      contains declarations that are not allowed, such as bindings.

      Example(s): None

     Test cases: None
  -}
  TcRnIllegalHsBootFileDecl :: TcRnMessage

  {-| TcRnRecursivePatternSynonym is an error that occurs when a pattern synonym
      is defined in terms of itself, either directly or indirectly.

      Example(s):
      pattern A = B
      pattern B = A

     Test cases: patsyn/should_fail/T16900
  -}
  TcRnRecursivePatternSynonym :: LHsBinds GhcRn -> TcRnMessage

  {-| TcRnPartialTypeSigTyVarMismatch is an error that occurs when a partial type signature
      attempts to unify two different types.

      Example(s):
      f :: a -> b -> _
      f x y = [x, y]

     Test cases: partial-sigs/should_fail/T14449
  -}
  TcRnPartialTypeSigTyVarMismatch
    :: Name -- ^ first type variable
    -> Name -- ^ second type variable
    -> Name -- ^ function name
    -> LHsSigWcType GhcRn -> TcRnMessage

  {-| TcRnPartialTypeSigBadQuantifier is an error that occurs when a type variable
      being quantified over in the partial type signature of a function gets unified
      with a type that is free in that function's context.

      Example(s):
      foo :: Num a => a -> a
      foo xxx = g xxx
        where
          g :: forall b. Num b => _ -> b
          g y = xxx + y

     Test cases: partial-sig/should_fail/T14479
  -}
  TcRnPartialTypeSigBadQuantifier
    :: Name -- ^ type variable being quantified
    -> Name -- ^ function name
    -> LHsSigWcType GhcRn -> TcRnMessage

  {-| TcRnPolymorphicBinderMissingSig is a warning controlled by -Wmissing-local-signatures
      that occurs when a local polymorphic binding lacks a type signature.

      Example(s):
      id a = a

     Test cases: warnings/should_compile/T12574
  -}
  TcRnPolymorphicBinderMissingSig :: Name -> Type -> TcRnMessage

  {-| TcRnOverloadedSig is an error that occurs when a binding group conflicts
      with the monomorphism restriction.

      Example(s):
      data T a = T a
      mono = ... where
        x :: Applicative f => f a
        T x = ...

     Test cases: typecheck/should_compile/T11339
  -}
  TcRnOverloadedSig :: TcIdSigInfo -> TcRnMessage

  {-| TcRnTupleConstraintInst is an error that occurs whenever an instance
      for a tuple constraint is specified.

      Examples(s):
        class C m a
        class D m a
        f :: (forall a. Eq a => (C m a, D m a)) => m a
        f = undefined

      Test cases: quantified-constraints/T15334
  -}
  TcRnTupleConstraintInst :: !Class -> TcRnMessage

  {-| TcRnAbstractClassInst is an error that occurs whenever an instance
      of an abstract class is specified.

      Examples(s):
        -- A.hs-boot
        module A where
        class C a

        -- B.hs
        module B where
        import {-# SOURCE #-} A
        instance C Int where

        -- A.hs
        module A where
        import B
        class C a where
          f :: a

        -- Main.hs
        import A
        main = print (f :: Int)

      Test cases: typecheck/should_fail/T13068
  -}
  TcRnAbstractClassInst :: !Class -> TcRnMessage

  {-| TcRnNoClassInstHead is an error that occurs whenever an instance
      head is not headed by a class.

      Examples(s):
        instance c

      Test cases: typecheck/rename/T5513
                  typecheck/rename/T16385
  -}
  TcRnNoClassInstHead :: !Type -> TcRnMessage

  {-| TcRnUserTypeError is an error that occurs due to a user's custom type error,
      which can be triggered by adding a `TypeError` constraint in a type signature
      or typeclass instance.

      Examples(s):
        f :: TypeError (Text "This is a type error")
        f = undefined

      Test cases: typecheck/should_fail/CustomTypeErrors02
                  typecheck/should_fail/CustomTypeErrors03
  -}
  TcRnUserTypeError :: !Type -> TcRnMessage

  {-| TcRnConstraintInKind is an error that occurs whenever a constraint is specified
      in a kind.

      Examples(s):
        data Q :: Eq a => Type where {}

      Test cases: dependent/should_fail/T13895
                  polykinds/T16263
                  saks/should_fail/saks_fail004
                  typecheck/should_fail/T16059a
                  typecheck/should_fail/T18714
  -}
  TcRnConstraintInKind :: !Type -> TcRnMessage

  {-| TcRnUnboxedTupleTypeFuncArg is an error that occurs whenever an unboxed tuple type
      is specified as a function argument.

      Examples(s):
        -- T15073.hs
        import T15073a
        newtype Foo a = MkFoo a
          deriving P

        -- T15073a.hs
        class P a where
          p :: a -> (# a #)

      Test cases: deriving/should_fail/T15073.hs
                  deriving/should_fail/T15073a.hs
                  typecheck/should_fail/T16059d
  -}
  TcRnUnboxedTupleTypeFuncArg :: !Type -> TcRnMessage

  {-| TcRnLinearFuncInKind is an error that occurs whenever a linear function is
      specified in a kind.

      Examples(s):
        data A :: * %1 -> *

      Test cases: linear/should_fail/LinearKind
                  linear/should_fail/LinearKind2
                  linear/should_fail/LinearKind3
  -}
  TcRnLinearFuncInKind :: !Type -> TcRnMessage

  {-| TcRnForAllEscapeError is an error that occurs whenever a quantified type's kind
      mentions quantified type variable.

      Examples(s):
        type T :: TYPE (BoxedRep l)
        data T = MkT

      Test cases: unlifted-datatypes/should_fail/UnlDataNullaryPoly
  -}
  TcRnForAllEscapeError :: !Type -> !Kind -> TcRnMessage

  {-| TcRnVDQInTermType is an error that occurs whenever a visible dependent quantification
      is specified in the type of a term.

      Examples(s):
        a = (undefined :: forall k -> k -> Type) @Int

      Test cases: dependent/should_fail/T15859
                  dependent/should_fail/T16326_Fail1
                  dependent/should_fail/T16326_Fail2
                  dependent/should_fail/T16326_Fail3
                  dependent/should_fail/T16326_Fail4
                  dependent/should_fail/T16326_Fail5
                  dependent/should_fail/T16326_Fail6
                  dependent/should_fail/T16326_Fail7
                  dependent/should_fail/T16326_Fail8
                  dependent/should_fail/T16326_Fail9
                  dependent/should_fail/T16326_Fail10
                  dependent/should_fail/T16326_Fail11
                  dependent/should_fail/T16326_Fail12
                  dependent/should_fail/T17687
                  dependent/should_fail/T18271
  -}
  TcRnVDQInTermType :: !Type -> TcRnMessage

  {-| TcRnIllegalEqualConstraints is an error that occurs whenever an illegal equational
      constraint is specified.

      Examples(s):
        blah :: (forall a. a b ~ a c) => b -> c
        blah = undefined

      Test cases: typecheck/should_fail/T17563
  -}
  TcRnIllegalEqualConstraints :: !Type -> TcRnMessage

  {-| TcRnBadQuantPredHead is an error that occurs whenever a quantified predicate
      lacks a class or type variable head.

      Examples(s):
        class (forall a. A t a => A t [a]) => B t where
          type A t a :: Constraint

      Test cases: quantified-constraints/T16474
  -}
  TcRnBadQuantPredHead :: !Type -> TcRnMessage

  {-| TcRnIllegalTupleConstraint is an error that occurs whenever an illegal tuple
      constraint is specified.

      Examples(s):
        g :: ((Show a, Num a), Eq a) => a -> a
        g = undefined

      Test cases: typecheck/should_fail/tcfail209a
  -}
  TcRnIllegalTupleConstraint :: !Type -> TcRnMessage

  {-| TcRnNonTypeVarArgInConstraint is an error that occurs whenever a non type-variable
      argument is specified in a constraint.

      Examples(s):
        data T
        instance Eq Int => Eq T

      Test cases: ghci/scripts/T13202
                  ghci/scripts/T13202a
                  polykinds/T12055a
                  typecheck/should_fail/T10351
                  typecheck/should_fail/T19187
                  typecheck/should_fail/T6022
                  typecheck/should_fail/T8883
  -}
  TcRnNonTypeVarArgInConstraint :: !Type -> TcRnMessage

  {-| TcRnIllegalImplicitParam is an error that occurs whenever an illegal implicit
      parameter is specified.

      Examples(s):
        type Bla = ?x::Int
        data T = T
        instance Bla => Eq T

      Test cases: polykinds/T11466
                  typecheck/should_fail/T8912
                  typecheck/should_fail/tcfail041
                  typecheck/should_fail/tcfail211
                  typecheck/should_fail/tcrun045
  -}
  TcRnIllegalImplicitParam :: !Type -> TcRnMessage

  {-| TcRnIllegalConstraintSynonymOfKind is an error that occurs whenever an illegal constraint
      synonym of kind is specified.

      Examples(s):
        type Showish = Show
        f :: (Showish a) => a -> a
        f = undefined

      Test cases: typecheck/should_fail/tcfail209
  -}
  TcRnIllegalConstraintSynonymOfKind :: !Type -> TcRnMessage

  {-| TcRnIllegalClassInst is an error that occurs whenever a class instance is specified
      for a non-class.

      Examples(s):
        type C1 a = (Show (a -> Bool))
        instance C1 Int where

      Test cases: polykinds/T13267
  -}
  TcRnIllegalClassInst :: !TyConFlavour -> TcRnMessage

  {-| TcRnOversaturatedVisibleKindArg is an error that occurs whenever an illegal oversaturated
      visible kind argument is specified.

      Examples(s):
        type family
          F2 :: forall (a :: Type). Type where
          F2 @a = Maybe a

      Test cases: typecheck/should_fail/T15793
                  typecheck/should_fail/T16255
  -}
  TcRnOversaturatedVisibleKindArg :: !Type -> TcRnMessage

  {-| TcRnBadAssociatedType is an error that occurs whenever a class doesn't have an
      associated type.

      Examples(s):
        $(do d <- instanceD (cxt []) (conT ''Eq `appT` conT ''Foo)
                    [tySynInstD $ tySynEqn Nothing (conT ''Rep `appT` conT ''Foo) (conT ''Maybe)]
             return [d])
        ======>
        instance Eq Foo where
          type Rep Foo = Maybe

      Test cases: th/T12387a
  -}
  TcRnBadAssociatedType :: {-Class-} !Name -> {-TyCon-} !Name -> TcRnMessage

  {-| TcRnForAllRankErr is an error that occurs whenever an illegal ranked type
      is specified.

      Examples(s):
        foo :: (a,b) -> (a~b => t) -> (a,b)
        foo p x = p

      Test cases:
        - ghci/should_run/T15806
        - indexed-types/should_fail/SimpleFail15
        - typecheck/should_fail/T11355
        - typecheck/should_fail/T12083a
        - typecheck/should_fail/T12083b
        - typecheck/should_fail/T16059c
        - typecheck/should_fail/T16059e
        - typecheck/should_fail/T17213
        - typecheck/should_fail/T18939_Fail
        - typecheck/should_fail/T2538
        - typecheck/should_fail/T5957
        - typecheck/should_fail/T7019
        - typecheck/should_fail/T7019a
        - typecheck/should_fail/T7809
        - typecheck/should_fail/T9196
        - typecheck/should_fail/tcfail127
        - typecheck/should_fail/tcfail184
        - typecheck/should_fail/tcfail196
        - typecheck/should_fail/tcfail197
  -}
  TcRnForAllRankErr :: !Rank -> !Type -> TcRnMessage

  {-| TcRnMonomorphicBindings is a warning (controlled by -Wmonomorphism-restriction)
      that arise when the monomorphism restriction applies to the given bindings.

      Examples(s):
        {-# OPTIONS_GHC -Wmonomorphism-restriction #-}

        bar = 10

        foo :: Int
        foo = bar

        main :: IO ()
        main = print foo

      The example above emits the warning (for 'bar'), because without monomorphism
      restriction the inferred type for 'bar' is 'bar :: Num p => p'. This warning tells us
      that /if/ we were to enable '-XMonomorphismRestriction' we would make 'bar'
      less polymorphic, as its type would become 'bar :: Int', so GHC warns us about that.

      Test cases: typecheck/should_compile/T13785
  -}
  TcRnMonomorphicBindings :: [Name] -> TcRnMessage

  {-| TcRnOrphanInstance is a warning (controlled by -Wwarn-orphans)
      that arises when a typeclass instance is an \"orphan\", i.e. if it appears
      in a module in which neither the class nor the type being instanced are
      declared in the same module.

      Examples(s): None

      Test cases: warnings/should_compile/T9178
                  typecheck/should_compile/T4912
  -}
  TcRnOrphanInstance :: ClsInst -> TcRnMessage

  {-| TcRnFunDepConflict is an error that occurs when there are functional dependencies
      conflicts between instance declarations.

      Examples(s): None

      Test cases: typecheck/should_fail/T2307
                  typecheck/should_fail/tcfail096
                  typecheck/should_fail/tcfail202
  -}
  TcRnFunDepConflict :: !UnitState -> NE.NonEmpty ClsInst -> TcRnMessage

  {-| TcRnDupInstanceDecls is an error that occurs when there are duplicate instance
      declarations.

      Examples(s):
        class Foo a where
          foo :: a -> Int

        instance Foo Int where
          foo = id

        instance Foo Int where
          foo = const 42

      Test cases: cabal/T12733/T12733
                  typecheck/should_fail/tcfail035
                  typecheck/should_fail/tcfail023
                  backpack/should_fail/bkpfail18
                  typecheck/should_fail/TcNullaryTCFail
                  typecheck/should_fail/tcfail036
                  typecheck/should_fail/tcfail073
                  module/mod51
                  module/mod52
                  module/mod44
  -}
  TcRnDupInstanceDecls :: !UnitState -> NE.NonEmpty ClsInst -> TcRnMessage

  {-| TcRnConflictingFamInstDecls is an error that occurs when there are conflicting
      family instance declarations.

      Examples(s): None.

      Test cases: indexed-types/should_fail/ExplicitForAllFams4b
                  indexed-types/should_fail/NoGood
                  indexed-types/should_fail/Over
                  indexed-types/should_fail/OverDirectThisMod
                  indexed-types/should_fail/OverIndirectThisMod
                  indexed-types/should_fail/SimpleFail11a
                  indexed-types/should_fail/SimpleFail11b
                  indexed-types/should_fail/SimpleFail11c
                  indexed-types/should_fail/SimpleFail11d
                  indexed-types/should_fail/SimpleFail2a
                  indexed-types/should_fail/SimpleFail2b
                  indexed-types/should_fail/T13092/T13092
                  indexed-types/should_fail/T13092c/T13092c
                  indexed-types/should_fail/T14179
                  indexed-types/should_fail/T2334A
                  indexed-types/should_fail/T2677
                  indexed-types/should_fail/T3330b
                  indexed-types/should_fail/T4246
                  indexed-types/should_fail/T7102a
                  indexed-types/should_fail/T9371
                  polykinds/T7524
                  typecheck/should_fail/UnliftedNewtypesOverlap
  -}
  TcRnConflictingFamInstDecls :: NE.NonEmpty FamInst -> TcRnMessage

  TcRnFamInstNotInjective :: InjectivityErrReason -> TyCon -> NE.NonEmpty CoAxBranch -> TcRnMessage

  {-| TcRnBangOnUnliftedType is a warning (controlled by -Wredundant-strictness-flags) that
      occurs when a strictness annotation is applied to an unlifted type.

      Example(s):
      data T = MkT !Int# -- Strictness flag has no effect on unlifted types

     Test cases: typecheck/should_compile/T20187a
                 typecheck/should_compile/T20187b
  -}
  TcRnBangOnUnliftedType :: !Type -> TcRnMessage

  {-| TcRnMultipleDefaultDeclarations is an error that occurs when a module has
      more than one default declaration.

      Example:
      default (Integer, Int)
      default (Double, Float) -- 2nd default declaration not allowed

     Text cases: module/mod58
  -}
  TcRnMultipleDefaultDeclarations :: [LDefaultDecl GhcRn] -> TcRnMessage

  {-| TcRnBadDefaultType is an error that occurs when a type used in a default
      declaration does not have an instance for any of the applicable classes.

      Example(s):
      data Foo
      default (Foo)

     Test cases: typecheck/should_fail/T11974b
  -}
  TcRnBadDefaultType :: Type -> [Class] -> TcRnMessage

  {-| TcRnPatSynBundledWithNonDataCon is an error that occurs when a module's
      export list bundles a pattern synonym with a type that is not a proper
      `data` or `newtype` construction.

      Example(s):
      module Foo (MyClass(.., P)) where
      pattern P = Nothing
      class MyClass a where
        foo :: a -> Int

     Test cases: patsyn/should_fail/export-class
  -}
  TcRnPatSynBundledWithNonDataCon :: TcRnMessage

  {-| TcRnPatSynBundledWithWrongType is an error that occurs when the export list
      of a module has a pattern synonym bundled with a type that does not match
      the type of the pattern synonym.

      Example(s):
      module Foo (R(P,x)) where
      data Q = Q Int
      data R = R
      pattern P{x} = Q x

     Text cases: patsyn/should_fail/export-ps-rec-sel
                 patsyn/should_fail/export-type-synonym
                 patsyn/should_fail/export-type
  -}
  TcRnPatSynBundledWithWrongType :: Type -> Type -> TcRnMessage

  {-| TcRnDupeModuleExport is a warning controlled by @-Wduplicate-exports@ that
      occurs when a module appears more than once in an export list.

      Example(s):
      module Foo (module Bar, module Bar)
      import Bar

     Text cases: None
  -}
  TcRnDupeModuleExport :: ModuleName -> TcRnMessage

  {-| TcRnExportedModNotImported is an error that occurs when an export list
      contains a module that is not imported.

      Example(s): None

     Text cases: module/mod135
                 module/mod8
                 rename/should_fail/rnfail028
                 backpack/should_fail/bkpfail48
  -}
  TcRnExportedModNotImported :: ModuleName -> TcRnMessage

  {-| TcRnNullExportedModule is a warning controlled by -Wdodgy-exports that occurs
      when an export list contains a module that has no exports.

      Example(s):
      module Foo (module Bar) where
      import Bar ()

     Test cases: None
  -}
  TcRnNullExportedModule :: ModuleName -> TcRnMessage

  {-| TcRnMissingExportList is a warning controlled by -Wmissing-export-lists that
      occurs when a module does not have an explicit export list.

      Example(s): None

     Test cases: typecheck/should_fail/MissingExportList03
  -}
  TcRnMissingExportList :: ModuleName -> TcRnMessage

  {-| TcRnExportHiddenComponents is an error that occurs when an export contains
      constructor or class methods that are not visible.

      Example(s): None

     Test cases: None
  -}
  TcRnExportHiddenComponents :: IE GhcPs -> TcRnMessage

  {-| TcRnDuplicateExport is a warning (controlled by -Wduplicate-exports) that occurs
      when an identifier appears in an export list more than once.

      Example(s): None

     Test cases: module/MultiExport
                 module/mod128
                 module/mod14
                 module/mod5
                 overloadedrecflds/should_fail/DuplicateExports
                 patsyn/should_compile/T11959
  -}
  TcRnDuplicateExport :: GreName -> IE GhcPs -> IE GhcPs -> TcRnMessage

  {-| TcRnExportedParentChildMismatch is an error that occurs when an export is
      bundled with a parent that it does not belong to

      Example(s):
      module Foo (T(a)) where
      data T
      a = True

     Test cases: module/T11970
                 module/T11970B
                 module/mod17
                 module/mod3
                 overloadedrecflds/should_fail/NoParent
  -}
  TcRnExportedParentChildMismatch :: Name -> TyThing -> GreName -> [Name] -> TcRnMessage

  {-| TcRnConflictingExports is an error that occurs when different identifiers that
      have the same name are being exported by a module.

      Example(s):
      module Foo (Bar.f, module Baz) where
      import qualified Bar (f)
      import Baz (f)

     Test cases: module/mod131
                 module/mod142
                 module/mod143
                 module/mod144
                 module/mod145
                 module/mod146
                 module/mod150
                 module/mod155
                 overloadedrecflds/should_fail/T14953
                 overloadedrecflds/should_fail/overloadedrecfldsfail10
                 rename/should_fail/rnfail029
                 rename/should_fail/rnfail040
                 typecheck/should_fail/T16453E2
                 typecheck/should_fail/tcfail025
                 typecheck/should_fail/tcfail026
  -}
  TcRnConflictingExports
    :: OccName -- ^ Occurrence name shared by both exports
    -> GreName -- ^ Name of first export
    -> GlobalRdrElt -- ^ Provenance for definition site of first export
    -> IE GhcPs -- ^ Export decl of first export
    -> GreName -- ^ Name of second export
    -> GlobalRdrElt -- ^ Provenance for definition site of second export
    -> IE GhcPs -- ^ Export decl of second export
    -> TcRnMessage

  {-| TcRnAmbiguousField is a warning controlled by -Wambiguous-fields occurring
      when a record update's type cannot be precisely determined. This will not
      be supported by -XDuplicateRecordFields in future releases.

      Example(s):
      data Person  = MkPerson  { personId :: Int, name :: String }
      data Address = MkAddress { personId :: Int, address :: String }
      bad1 x = x { personId = 4 } :: Person -- ambiguous
      bad2 (x :: Person) = x { personId = 4 } -- ambiguous
      good x = (x :: Person) { personId = 4 } -- not ambiguous

     Test cases: overloadedrecflds/should_fail/overloadedrecfldsfail06
  -}
  TcRnAmbiguousField
    :: HsExpr GhcRn -- ^ Field update
    -> TyCon -- ^ Record type
    -> TcRnMessage

  {-| TcRnMissingFields is a warning controlled by -Wmissing-fields occurring
      when the intialisation of a record is missing one or more (lazy) fields.

      Example(s):
      data Rec = Rec { a :: Int, b :: String, c :: Bool }
      x = Rec { a = 1, b = "two" } -- missing field 'c'

     Test cases: deSugar/should_compile/T13870
                 deSugar/should_compile/ds041
                 patsyn/should_compile/T11283
                 rename/should_compile/T5334
                 rename/should_compile/T12229
                 rename/should_compile/T5892a
                 warnings/should_fail/WerrorFail2
  -}
  TcRnMissingFields :: ConLike -> [(FieldLabelString, TcType)] -> TcRnMessage

  {-| TcRnFieldUpdateInvalidType is an error occurring when an updated field's
      type mentions something that is outside the universally quantified variables
      of the data constructor, such as an existentially quantified type.

      Example(s):
      data X = forall a. MkX { f :: a }
      x = (MkX ()) { f = False }

      Test cases: patsyn/should_fail/records-exquant
                  typecheck/should_fail/T3323
  -}
  TcRnFieldUpdateInvalidType :: [(FieldLabelString,TcType)] -> TcRnMessage

  {-| TcRnNoConstructorHasAllFields is an error that occurs when a record update
      has fields that no single constructor encompasses.

      Example(s):
      data Foo = A { x :: Bool }
               | B { y :: Int }
      foo = (A False) { x = True, y = 5 }

     Test cases: overloadedrecflds/should_fail/overloadedrecfldsfail08
                 patsyn/should_fail/mixed-pat-syn-record-sels
                 typecheck/should_fail/T7989
  -}
  TcRnNoConstructorHasAllFields :: [FieldLabelString] -> TcRnMessage

  {- TcRnMixedSelectors is an error for when a mixture of pattern synonym and
      record selectors are used in the same record update block.

      Example(s):
      data Rec = Rec { foo :: Int, bar :: String }
      pattern Pat { f1, f2 } = Rec { foo = f1, bar = f2 }
      illegal :: Rec -> Rec
      illegal r = r { f1 = 1, bar = "two" }

     Test cases: patsyn/should_fail/records-mixing-fields
  -}
  TcRnMixedSelectors
    :: Name -- ^ Record
    -> [Id] -- ^ Record selectors
    -> Name -- ^ Pattern synonym
    -> [Id] -- ^ Pattern selectors
    -> TcRnMessage

  {- TcRnMissingStrictFields is an error occurring when a record field marked
     as strict is omitted when constructing said record.

     Example(s):
     data R = R { strictField :: !Bool, nonStrict :: Int }
     x = R { nonStrict = 1 }

    Test cases: typecheck/should_fail/T18869
                typecheck/should_fail/tcfail085
                typecheck/should_fail/tcfail112
  -}
  TcRnMissingStrictFields :: ConLike -> [(FieldLabelString, TcType)] -> TcRnMessage

  {- TcRnNoPossibleParentForFields is an error thrown when the fields used in a
     record update block do not all belong to any one type.

     Example(s):
     data R1 = R1 { x :: Int, y :: Int }
     data R2 = R2 { y :: Int, z :: Int }
     update r = r { x = 1, y = 2, z = 3 }

    Test cases: overloadedrecflds/should_fail/overloadedrecfldsfail01
                overloadedrecflds/should_fail/overloadedrecfldsfail14
  -}
  TcRnNoPossibleParentForFields :: [LHsRecUpdField GhcRn] -> TcRnMessage

  {- TcRnBadOverloadedRecordUpdate is an error for a record update that cannot
     be pinned down to any one constructor and thus must be given a type signature.

     Example(s):
     data R1 = R1 { x :: Int }
     data R2 = R2 { x :: Int }
     update r = r { x = 1 } -- needs a type signature

    Test cases: overloadedrecflds/should_fail/overloadedrecfldsfail01
  -}
  TcRnBadOverloadedRecordUpdate :: [LHsRecUpdField GhcRn] -> TcRnMessage

  {- TcRnStaticFormNotClosed is an error pertaining to terms that are marked static
     using the -XStaticPointers extension but which are not closed terms.

     Example(s):
     f x = static x

    Test cases: rename/should_fail/RnStaticPointersFail01
                rename/should_fail/RnStaticPointersFail03
  -}
  TcRnStaticFormNotClosed :: Name -> NotClosedReason -> TcRnMessage
  {-| TcRnSpecialClassInst is an error that occurs when a user
      attempts to define an instance for a built-in typeclass such as
      'Coercible', 'Typeable', or 'KnownNat', outside of a signature file.

     Test cases: deriving/should_fail/T9687
                 deriving/should_fail/T14916
                 polykinds/T8132
                 typecheck/should_fail/TcCoercibleFail2
                 typecheck/should_fail/T12837
                 typecheck/should_fail/T14390

  -}
  TcRnSpecialClassInst :: !Class
                       -> !Bool -- ^ Whether the error is due to Safe Haskell being enabled
                       -> TcRnMessage

  {-| TcRnUselessTypeable is a warning (controlled by -Wderiving-typeable) that
      occurs when trying to derive an instance of the 'Typeable' class. Deriving
      'Typeable' is no longer necessary (hence the \"useless\") as all types
      automatically derive 'Typeable' in modern GHC versions.

      Example(s): None.

     Test cases: warnings/should_compile/DerivingTypeable
  -}
  TcRnUselessTypeable :: TcRnMessage

  {-| TcRnDerivingDefaults is a warning (controlled by -Wderiving-defaults) that
      occurs when both 'DeriveAnyClass' and 'GeneralizedNewtypeDeriving' are
      enabled, and therefore GHC defaults to 'DeriveAnyClass', which might not
      be what the user wants.

      Example(s): None.

     Test cases: typecheck/should_compile/T15839a
                 deriving/should_compile/T16179
  -}
  TcRnDerivingDefaults :: !Class -> TcRnMessage

  {-| TcRnNonUnaryTypeclassConstraint is an error that occurs when GHC
      encounters a non-unary constraint when trying to derive a typeclass.

      Example(s):
        class A
        deriving instance A
        data B deriving A  -- We cannot derive A, is not unary (i.e. 'class A a').

     Test cases: deriving/should_fail/T7959
                 deriving/should_fail/drvfail005
                 deriving/should_fail/drvfail009
                 deriving/should_fail/drvfail006
  -}
  TcRnNonUnaryTypeclassConstraint :: !(LHsSigType GhcRn) -> TcRnMessage

  {-| TcRnPartialTypeSignatures is a warning (controlled by -Wpartial-type-signatures)
      that occurs when a wildcard '_' is found in place of a type in a signature or a
      type class derivation

      Example(s):
        foo :: _ -> Int
        foo = ...

        deriving instance _ => Eq (Foo a)

     Test cases: dependent/should_compile/T11241
                 dependent/should_compile/T15076
                 dependent/should_compile/T14880-2
                 typecheck/should_compile/T17024
                 typecheck/should_compile/T10072
                 partial-sigs/should_fail/TidyClash2
                 partial-sigs/should_fail/Defaulting1MROff
                 partial-sigs/should_fail/WildcardsInPatternAndExprSig
                 partial-sigs/should_fail/T10615
                 partial-sigs/should_fail/T14584a
                 partial-sigs/should_fail/TidyClash
                 partial-sigs/should_fail/T11122
                 partial-sigs/should_fail/T14584
                 partial-sigs/should_fail/T10045
                 partial-sigs/should_fail/PartialTypeSignaturesDisabled
                 partial-sigs/should_fail/T10999
                 partial-sigs/should_fail/ExtraConstraintsWildcardInExpressionSignature
                 partial-sigs/should_fail/ExtraConstraintsWildcardInPatternSplice
                 partial-sigs/should_fail/WildcardInstantiations
                 partial-sigs/should_run/T15415
                 partial-sigs/should_compile/T10463
                 partial-sigs/should_compile/T15039a
                 partial-sigs/should_compile/T16728b
                 partial-sigs/should_compile/T15039c
                 partial-sigs/should_compile/T10438
                 partial-sigs/should_compile/SplicesUsed
                 partial-sigs/should_compile/T18008
                 partial-sigs/should_compile/ExprSigLocal
                 partial-sigs/should_compile/T11339a
                 partial-sigs/should_compile/T11670
                 partial-sigs/should_compile/WarningWildcardInstantiations
                 partial-sigs/should_compile/T16728
                 partial-sigs/should_compile/T12033
                 partial-sigs/should_compile/T15039b
                 partial-sigs/should_compile/T10403
                 partial-sigs/should_compile/T11192
                 partial-sigs/should_compile/T16728a
                 partial-sigs/should_compile/TypedSplice
                 partial-sigs/should_compile/T15039d
                 partial-sigs/should_compile/T11016
                 partial-sigs/should_compile/T13324_compile2
                 linear/should_fail/LinearPartialSig
                 polykinds/T14265
                 polykinds/T14172
  -}
  TcRnPartialTypeSignatures :: !SuggestPartialTypeSignatures -> !ThetaType -> TcRnMessage

  {-| TcRnCannotDeriveInstance is an error that occurs every time a typeclass instance
      can't be derived. The 'DeriveInstanceErrReason' will contain the specific reason
      this error arose.

      Example(s): None.

      Test cases: generics/T10604/T10604_no_PolyKinds
                  deriving/should_fail/drvfail009
                  deriving/should_fail/drvfail-functor2
                  deriving/should_fail/T10598_fail3
                  deriving/should_fail/deriving-via-fail2
                  deriving/should_fail/deriving-via-fail
                  deriving/should_fail/T16181
  -}
  TcRnCannotDeriveInstance :: !Class
                           -- ^ The typeclass we are trying to derive
                           -- an instance for
                           -> [Type]
                           -- ^ The typeclass arguments, if any.
                           -> !(Maybe (DerivStrategy GhcTc))
                           -- ^ The derivation strategy, if any.
                           -> !UsingGeneralizedNewtypeDeriving
                           -- ^ Is '-XGeneralizedNewtypeDeriving' enabled?
                           -> !DeriveInstanceErrReason
                           -- ^ The specific reason why we couldn't derive
                           -- an instance for the class.
                           -> TcRnMessage

  {-| TcRnLazyGADTPattern is an error that occurs when a user writes a nested
      GADT pattern match inside a lazy (~) pattern.

      Test case: gadt/lazypat
  -}
  TcRnLazyGADTPattern :: TcRnMessage

  {-| TcRnArrowProcGADTPattern is an error that occurs when a user writes a
      GADT pattern inside arrow proc notation.

      Test case: arrows/should_fail/arrowfail004.
  -}
  TcRnArrowProcGADTPattern :: TcRnMessage

-- | Which parts of a record field are affected by a particular error or warning.
data RecordFieldPart
  = RecordFieldConstructor !Name
  | RecordFieldPattern !Name
  | RecordFieldUpdate

-- | Where a shadowed name comes from
data ShadowedNameProvenance
  = ShadowedNameProvenanceLocal !SrcLoc
    -- ^ The shadowed name is local to the module
  | ShadowedNameProvenanceGlobal [GlobalRdrElt]
    -- ^ The shadowed name is global, typically imported from elsewhere.

-- | In what context did we require a type to have a fixed runtime representation?
--
-- Used by 'GHC.Tc.Utils.TcMType.checkTypeHasFixedRuntimeRep' for throwing
-- representation polymorphism errors when validity checking.
--
-- See Note [Representation polymorphism checking] in GHC.Tc.Utils.Concrete
data FixedRuntimeRepProvenance
  -- | Data constructor fields must have a fixed runtime representation.
  --
  -- Tests: T11734, T18534.
  = FixedRuntimeRepDataConField

  -- | Pattern synonym signature arguments must have a fixed runtime representation.
  --
  -- Test: RepPolyPatSynArg.
  | FixedRuntimeRepPatSynSigArg

  -- | Pattern synonym signature scrutinee must have a fixed runtime representation.
  --
  -- Test: RepPolyPatSynRes.
  | FixedRuntimeRepPatSynSigRes

pprFixedRuntimeRepProvenance :: FixedRuntimeRepProvenance -> SDoc
pprFixedRuntimeRepProvenance FixedRuntimeRepDataConField = text "data constructor field"
pprFixedRuntimeRepProvenance FixedRuntimeRepPatSynSigArg = text "pattern synonym argument"
pprFixedRuntimeRepProvenance FixedRuntimeRepPatSynSigRes = text "pattern synonym scrutinee"

-- | Why the particular injectivity error arose together with more information,
-- if any.
data InjectivityErrReason
  = InjErrRhsBareTyVar [Type]
  | InjErrRhsCannotBeATypeFam
  | InjErrRhsOverlap
  | InjErrCannotInferFromRhs !TyVarSet !HasKinds !SuggestUndecidableInstances

data HasKinds
  = YesHasKinds
  | NoHasKinds
  deriving (Show, Eq)

hasKinds :: Bool -> HasKinds
hasKinds True  = YesHasKinds
hasKinds False = NoHasKinds

data SuggestUndecidableInstances
  = YesSuggestUndecidableInstaces
  | NoSuggestUndecidableInstaces
  deriving (Show, Eq)

suggestUndecidableInstances :: Bool -> SuggestUndecidableInstances
suggestUndecidableInstances True  = YesSuggestUndecidableInstaces
suggestUndecidableInstances False = NoSuggestUndecidableInstaces

-- | A data type to describe why a variable is not closed.
-- See Note [Not-closed error messages] in GHC.Tc.Gen.Expr
data NotClosedReason = NotLetBoundReason
                     | NotTypeClosed VarSet
                     | NotClosed Name NotClosedReason

data SuggestPartialTypeSignatures
  = YesSuggestPartialTypeSignatures
  | NoSuggestPartialTypeSignatures
  deriving (Show, Eq)

suggestPartialTypeSignatures :: Bool -> SuggestPartialTypeSignatures
suggestPartialTypeSignatures True  = YesSuggestPartialTypeSignatures
suggestPartialTypeSignatures False = NoSuggestPartialTypeSignatures

data UsingGeneralizedNewtypeDeriving
  = YesGeneralizedNewtypeDeriving
  | NoGeneralizedNewtypeDeriving
  deriving Eq

usingGeneralizedNewtypeDeriving :: Bool -> UsingGeneralizedNewtypeDeriving
usingGeneralizedNewtypeDeriving True  = YesGeneralizedNewtypeDeriving
usingGeneralizedNewtypeDeriving False = NoGeneralizedNewtypeDeriving

data DeriveAnyClassEnabled
  = YesDeriveAnyClassEnabled
  | NoDeriveAnyClassEnabled
  deriving Eq

deriveAnyClassEnabled :: Bool -> DeriveAnyClassEnabled
deriveAnyClassEnabled True  = YesDeriveAnyClassEnabled
deriveAnyClassEnabled False = NoDeriveAnyClassEnabled

-- | Why a particular typeclass instance couldn't be derived.
data DeriveInstanceErrReason
  =
    -- | The typeclass instance is not well-kinded.
    DerivErrNotWellKinded !TyCon
                          -- ^ The type constructor that occurs in
                          -- the typeclass instance declaration.
                          !Kind
                          -- ^ The typeclass kind.
                          !Int
                          -- ^ The number of typeclass arguments that GHC
                          -- kept. See Note [tc_args and tycon arity] in
                          -- GHC.Tc.Deriv.
  -- | Generic instances can only be derived using the stock strategy
  -- in Safe Haskell.
  | DerivErrSafeHaskellGenericInst
  | DerivErrDerivingViaWrongKind !Kind !Type !Kind
  | DerivErrNoEtaReduce !Type
                        -- ^ The instance type
  -- | We cannot derive instances in boot files
  | DerivErrBootFileFound
  | DerivErrDataConsNotAllInScope !TyCon
  -- | We cannot use GND on non-newtype types
  | DerivErrGNDUsedOnData
  -- | We cannot derive instances of nullary classes
  | DerivErrNullaryClasses
  -- | Last arg must be newtype or data application
  | DerivErrLastArgMustBeApp
  | DerivErrNoFamilyInstance !TyCon [Type]
  | DerivErrNotStockDeriveable !DeriveAnyClassEnabled
  | DerivErrHasAssociatedDatatypes !HasAssociatedDataFamInsts
                                   !AssociatedTyLastVarInKind
                                   !AssociatedTyNotParamOverLastTyVar
  | DerivErrNewtypeNonDeriveableClass
  | DerivErrCannotEtaReduceEnough !Bool -- Is eta-reduction OK?
  | DerivErrOnlyAnyClassDeriveable !TyCon
                                   -- ^ Type constructor for which the instance
                                   -- is requested
                                   !DeriveAnyClassEnabled
                                   -- ^ Whether or not -XDeriveAnyClass is enabled
                                   -- already.
  -- | Stock deriving won't work, but perhas DeriveAnyClass will.
  | DerivErrNotDeriveable !DeriveAnyClassEnabled
  -- | The given 'PredType' is not a class.
  | DerivErrNotAClass !PredType
  -- | The given (representation of the) 'TyCon' has no
  -- data constructors.
  | DerivErrNoConstructors !TyCon
  | DerivErrLangExtRequired !LangExt.Extension
  -- | GHC simply doesn't how to how derive the input 'Class' for the given
  -- 'Type'.
  | DerivErrDunnoHowToDeriveForType !Type
  -- | The given 'TyCon' must be an enumeration.
  -- See Note [Enumeration types] in GHC.Core.TyCon
  | DerivErrMustBeEnumType !TyCon
  -- | The given 'TyCon' must have /precisely/ one constructor.
  | DerivErrMustHaveExactlyOneConstructor !TyCon
  -- | The given data type must have some parameters.
  | DerivErrMustHaveSomeParameters !TyCon
  -- | The given data type must not have a class context.
  | DerivErrMustNotHaveClassContext !TyCon !ThetaType
  -- | We couldn't derive an instance for a particular data constructor
  -- for a variety of reasons.
  | DerivErrBadConstructor !(Maybe HasWildcard) [DeriveInstanceBadConstructor]
  -- | We couldn't derive a 'Generic' instance for the given type for a
  -- variety of reasons
  | DerivErrGenerics [DeriveGenericsErrReason]
  -- | We couldn't derive an instance either because the type was not an
  -- enum type or because it did have more than one constructor.
  | DerivErrEnumOrProduct !DeriveInstanceErrReason !DeriveInstanceErrReason

data DeriveInstanceBadConstructor
  =
  -- | The given 'DataCon' must be truly polymorphic in the
  -- last argument of the data type.
    DerivErrBadConExistential !DataCon
  -- | The given 'DataCon' must not use the type variable in a function argument"
  | DerivErrBadConCovariant !DataCon
  -- | The given 'DataCon' must not contain function types
  | DerivErrBadConFunTypes !DataCon
  -- | The given 'DataCon' must use the type variable only
  -- as the last argument of a data type
  | DerivErrBadConWrongArg !DataCon
  -- | The given 'DataCon' is a GADT so we cannot directly
  -- derive an istance for it.
  | DerivErrBadConIsGADT !DataCon
  -- | The given 'DataCon' has existentials type vars in its type.
  | DerivErrBadConHasExistentials !DataCon
  -- | The given 'DataCon' has constraints in its type.
  | DerivErrBadConHasConstraints !DataCon
  -- | The given 'DataCon' has a higher-rank type.
  | DerivErrBadConHasHigherRankType !DataCon

data DeriveGenericsErrReason
  = -- | The type must not have some datatype context.
    DerivErrGenericsMustNotHaveDatatypeContext !TyCon
    -- | The data constructor must not have exotic unlifted
    -- or polymorphic arguments.
  | DerivErrGenericsMustNotHaveExoticArgs !DataCon
    -- | The data constructor must be a vanilla constructor.
  | DerivErrGenericsMustBeVanillaDataCon  !DataCon
    -- | The type must have some type parameters.
    -- check (d) from Note [Requirements for deriving Generic and Rep]
    -- in GHC.Tc.Deriv.Generics.
  | DerivErrGenericsMustHaveSomeTypeParams !TyCon
    -- | The data constructor must not have existential arguments.
  | DerivErrGenericsMustNotHaveExistentials !DataCon
    -- | The derivation applies a type to an argument involving
    -- the last parameter but the applied type is not of kind * -> *.
  | DerivErrGenericsWrongArgKind !DataCon

data HasWildcard
  = YesHasWildcard
  | NoHasWildcard
  deriving Eq

hasWildcard :: Bool -> HasWildcard
hasWildcard True  = YesHasWildcard
hasWildcard False = NoHasWildcard

-- | A type representing whether or not the input type has associated data family instances.
data HasAssociatedDataFamInsts
  = YesHasAdfs
  | NoHasAdfs
  deriving Eq

hasAssociatedDataFamInsts :: Bool -> HasAssociatedDataFamInsts
hasAssociatedDataFamInsts True = YesHasAdfs
hasAssociatedDataFamInsts False = NoHasAdfs

-- | If 'YesAssocTyLastVarInKind', the associated type of a typeclass
-- contains the last type variable of the class in a kind, which is not (yet) allowed
-- by GHC.
data AssociatedTyLastVarInKind
  = YesAssocTyLastVarInKind !TyCon -- ^ The associated type family of the class
  | NoAssocTyLastVarInKind
  deriving Eq

associatedTyLastVarInKind :: Maybe TyCon -> AssociatedTyLastVarInKind
associatedTyLastVarInKind (Just tc) = YesAssocTyLastVarInKind tc
associatedTyLastVarInKind Nothing   = NoAssocTyLastVarInKind

-- | If 'NoAssociatedTyNotParamOverLastTyVar', the associated type of a
-- typeclass is not parameterized over the last type variable of the class
data AssociatedTyNotParamOverLastTyVar
  = YesAssociatedTyNotParamOverLastTyVar !TyCon -- ^ The associated type family of the class
  | NoAssociatedTyNotParamOverLastTyVar
  deriving Eq

associatedTyNotParamOverLastTyVar :: Maybe TyCon -> AssociatedTyNotParamOverLastTyVar
associatedTyNotParamOverLastTyVar (Just tc) = YesAssociatedTyNotParamOverLastTyVar tc
associatedTyNotParamOverLastTyVar Nothing   = NoAssociatedTyNotParamOverLastTyVar
