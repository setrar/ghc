/* -----------------------------------------------------------------------------
 *
 * (c) The GHC Team, 1998-2009
 *
 * Rts settings.
 *
 * NOTE: assumes #include "ghcconfig.h"
 *
 * NB: THIS FILE IS INCLUDED IN NON-C CODE AND DATA!  #defines only please.
 *
 * To understand the structure of the RTS headers, see the wiki:
 *   https://gitlab.haskell.org/ghc/ghc/wikis/commentary/source-tree/includes
 *
 * ---------------------------------------------------------------------------*/

#pragma once

#if defined(TICKY_TICKY) && defined(THREADED_RTS)
#error TICKY_TICKY is incompatible with THREADED_RTS
#endif

/*
 * Whether the runtime system will use libbfd for debugging purposes.
 */
#if defined(DEBUG) && defined(HAVE_BFD_H) && defined(HAVE_LIBBFD) && !defined(_WIN32)
#define USING_LIBBFD 1
#endif

/* DEBUG and PROFILING both imply TRACING */
#if defined(DEBUG) || defined(PROFILING)
#if !defined(TRACING)
#define TRACING
#endif
#endif

/* DEBUG implies TICKY_TICKY */
#if defined(DEBUG)
#if !defined(TICKY_TICKY)
#define TICKY_TICKY
#endif
#endif


/* -----------------------------------------------------------------------------
   Signals - supported on non-PAR versions of the runtime.  See RtsSignals.h.
   -------------------------------------------------------------------------- */

#define RTS_USER_SIGNALS 1

/* Profile spin locks */

#define PROF_SPIN
