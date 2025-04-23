module Web.IntersectionObserver.Unsafe where

import Prelude

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Nullable (Nullable)
import Effect.Uncurried as EFn
import Web.DOM as Web.DOM
import Web.IntersectionObserver.Entry.Unsafe (IntersectionObserverEntry)
import Web.IntersectionObserver.Margin (Margin)
import Web.IntersectionObserver.Percentage (Percentage)

data IntersectionObserver

type IntersectionObserverInit_Unsafe =
  { root :: Nullable Web.DOM.Node -- Element or Document
  , rootMargin :: Margin
  , scrollMargin :: Margin
  -- FrozenArray, but it is ok, bc in purescript everything is immutable
  , threshold :: NonEmptyArray Percentage
  , delay :: Int
  , trackVisibility :: Boolean
  }

foreign import _create :: EFn.EffectFn2 (EFn.EffectFn2 (Array IntersectionObserverEntry) IntersectionObserver Unit) IntersectionObserverInit_Unsafe IntersectionObserver
