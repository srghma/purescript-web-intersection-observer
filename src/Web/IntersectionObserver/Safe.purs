module Web.IntersectionObserver.Safe where

import Prelude

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as NonEmptyArray
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, null, toNullable)
import Effect (Effect)
import Effect.Uncurried as EFn
import Web.DOM as Web.DOM
import Web.DOM.Document as Web.DOM.Document
import Web.DOM.Element as Web.DOM.Element
import Web.IntersectionObserver.Entry.Unsafe (IntersectionObserverEntry)
import Web.IntersectionObserver.Margin (Margin, unsafeMargin)
import Web.IntersectionObserver.Percentage (Percentage, unsafePercentage)
import Web.IntersectionObserver.Unsafe (IntersectionObserver)
import Web.IntersectionObserver.Unsafe as Unsafe

-- from https://w3c.github.io/IntersectionObserver/#intersection-observer

data IntersectionObserverInitRoot
  = IntersectionObserverInitRoot_None
  | IntersectionObserverInitRoot_Element Web.DOM.Element
  | IntersectionObserverInitRoot_Document Web.DOM.Document

intersectionObserverInitRootToInternal :: IntersectionObserverInitRoot -> Nullable Web.DOM.Node
intersectionObserverInitRootToInternal IntersectionObserverInitRoot_None = null
intersectionObserverInitRootToInternal (IntersectionObserverInitRoot_Element element) = toNullable <<< Just <<< Web.DOM.Element.toNode $ element
intersectionObserverInitRootToInternal (IntersectionObserverInitRoot_Document document) = toNullable <<< Just <<< Web.DOM.Document.toNode $ document

type IntersectionObserverInit =
  { root :: IntersectionObserverInitRoot
  , rootMargin :: Margin
  , scrollMargin :: Margin
  , threshold :: NonEmptyArray Percentage
  , delay :: Int
  , trackVisibility :: Boolean
  }

defaultIntersectionObserverInit :: IntersectionObserverInit
defaultIntersectionObserverInit =
  { root: IntersectionObserverInitRoot_None
  , rootMargin: unsafeMargin "0px"
  , scrollMargin: unsafeMargin "0px"
  , threshold: NonEmptyArray.singleton $ unsafePercentage 0.0
  , delay: 0
  , trackVisibility: false
  }

type IntersectionObserverCallback = Array IntersectionObserverEntry -> IntersectionObserver -> Effect Unit

--                                  ^ ChatGPT says `Array IntersectionObserverEntry` can be empty

create :: IntersectionObserverCallback -> IntersectionObserverInit -> Effect IntersectionObserver
create callback options = EFn.runEffectFn2 Unsafe._create (EFn.mkEffectFn2 callback) (options { root = intersectionObserverInitRootToInternal options.root })

---------------------------- https://w3c.github.io/IntersectionObserver/#intersection-observer-interface

foreign import root :: IntersectionObserver -> Web.DOM.Node

foreign import rootMargin :: IntersectionObserver -> Margin
foreign import scrollMargin :: IntersectionObserver -> Margin

-- | ```js
-- | var obs = new IntersectionObserver(() => {}, { threshold: [] })
-- | //                                             ^ yes, for constuctor it is `threshold`, but for fields - `thresholds`!!
-- | console.log(obs.thresholds) -- we export it, NonEmptyArray
-- | > [0]
-- | console.log(obs.threshold) -- we dont export
-- | > undefined
foreign import thresholds :: IntersectionObserver -> NonEmptyArray Percentage

foreign import _observe :: EFn.EffectFn2 IntersectionObserver Web.DOM.Element Unit

observe :: IntersectionObserver -> Web.DOM.Element -> Effect Unit
observe = EFn.runEffectFn2 _observe

foreign import _unobserve :: EFn.EffectFn2 IntersectionObserver Web.DOM.Element Unit

unobserve :: IntersectionObserver -> Web.DOM.Element -> Effect Unit
unobserve = EFn.runEffectFn2 _unobserve

foreign import _disconnect :: EFn.EffectFn1 IntersectionObserver Unit

disconnect :: IntersectionObserver -> Effect Unit
disconnect = EFn.runEffectFn1 _disconnect

foreign import _takeRecords :: EFn.EffectFn1 IntersectionObserver (Array IntersectionObserverEntry)

takeRecords :: IntersectionObserver -> Effect (Array IntersectionObserverEntry)
takeRecords = EFn.runEffectFn1 _takeRecords
