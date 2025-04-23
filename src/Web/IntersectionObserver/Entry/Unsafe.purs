module Web.IntersectionObserver.Entry.Unsafe where

import Data.Nullable (Nullable)
import Effect.Uncurried as EFn
import Web.DOM as Web.DOM

type DOMHighResTimeStamp = Number

type DOMRectInit =
  { x :: Number
  , y :: Number
  , width :: Number
  , heigth :: Number
  }

type IntersectionObserverEntryInit_Unsafe =
  { boundingClientRect :: DOMRectInit
  , intersectionRect :: DOMRectInit
  , intersectionRatio :: Number
  , isIntersecting :: Boolean
  , rootBounds :: Nullable DOMRectInit
  , time :: DOMHighResTimeStamp
  , target :: Web.DOM.Element
  }

data IntersectionObserverEntry

-- Who can ever need it? Mocking lib https://github.com/w3c/IntersectionObserver/issues/33#issuecomment-146248475
foreign import _create :: EFn.EffectFn1 IntersectionObserverEntryInit_Unsafe IntersectionObserverEntry
