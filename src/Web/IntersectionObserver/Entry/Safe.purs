module Web.IntersectionObserver.Entry.Safe where

import Prelude

import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried as EFn
import Web.DOM as Web.DOM
import Web.IntersectionObserver.Entry.Unsafe as Unsafe
import Web.IntersectionObserver.Entry.Unsafe (DOMRectInit, DOMHighResTimeStamp, IntersectionObserverEntry)

-- https://drafts.fxtf.org/geometry-1/#domrectreadonly
type DOMRectReadOnly =
  { x :: Number
  , y :: Number
  , width :: Number
  , height :: Number
  , top :: Number
  , right :: Number
  , bottom :: Number
  , left :: Number
  }

type IntersectionObserverEntryInit =
  { boundingClientRect :: DOMRectInit
  , intersectionRect :: DOMRectInit
  , intersectionRatio :: Number
  , isIntersecting :: Boolean
  , rootBounds :: Maybe DOMRectInit
  , time :: DOMHighResTimeStamp
  , target :: Web.DOM.Element
  }

-- Who can ever need it? Mocking lib https://github.com/w3c/IntersectionObserver/issues/33#issuecomment-146248475
create :: IntersectionObserverEntryInit -> Effect IntersectionObserverEntry
create options = EFn.runEffectFn1 Unsafe._create (options { rootBounds = Nullable.toNullable options.rootBounds })

---------------- https://w3c.github.io/IntersectionObserver/#intersection-observer-entry

foreign import time :: IntersectionObserverEntry -> DOMHighResTimeStamp
foreign import _rootBounds :: IntersectionObserverEntry -> Nullable DOMRectReadOnly

rootBounds :: IntersectionObserverEntry -> Maybe DOMRectReadOnly
rootBounds = Nullable.toMaybe <<< _rootBounds

foreign import boundingClientRect :: IntersectionObserverEntry -> DOMRectReadOnly
foreign import intersectionRect :: IntersectionObserverEntry -> DOMRectReadOnly
foreign import isIntersecting :: IntersectionObserverEntry -> Boolean
foreign import intersectionRatio :: IntersectionObserverEntry -> Number
foreign import target :: IntersectionObserverEntry -> Web.DOM.Element
