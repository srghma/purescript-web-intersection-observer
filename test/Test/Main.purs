module Test.Main (main) where

import Prelude

import Data.Array.NonEmpty as NonEmptyArray
import Data.Maybe (maybe)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Exception (throw)
import Effect.Ref as Ref
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Mocha (runMocha)
import Web.HTML (window)
import Web.HTML.HTMLDocument (body)
import Web.HTML.HTMLElement as Web.HTML.HTMLElement
import Web.HTML.Window (document)
import Web.IntersectionObserver (IntersectionObserverInitRoot(..), create, defaultIntersectionObserverInit, isIntersecting, rootMargin, scrollMargin, takeRecords, thresholds, unMargin, unsafePercentage)

main :: Effect Unit
main = runMocha do
  describe "IntersectionObserver" do
    it "can be created with default options and doesn't call callback immediately" $ liftEffect do
      -- Create a Ref to track if the callback is called
      calledRef <- Ref.new false

      -- Try to get the body element
      el <- maybe (throw "Element 'body' not found") pure =<< (window >>= document >>= body)

      -- Define callback that sets the Ref to true if called
      let callback _entries _observer = Ref.write true calledRef

      -- Create the observer with the callback
      observer <- create callback (defaultIntersectionObserverInit { root = IntersectionObserverInitRoot_Element (Web.HTML.HTMLElement.toElement el) })

      -- Assertions
      unMargin (rootMargin observer) `shouldEqual` "0px 0px 0px 0px"
      unMargin (scrollMargin observer) `shouldEqual` "0px 0px 0px 0px"
      thresholds observer `shouldEqual` NonEmptyArray.singleton (unsafePercentage 0.0)

      -- Optionally: check that `takeRecords` also returns an empty array
      intersectionObserverEntries <- takeRecords observer
      (map isIntersecting intersectionObserverEntries) `shouldEqual` []

      -- Check if callback was called
      called <- Ref.read calledRef
      called `shouldEqual` false
