module Web.IntersectionObserver.Margin (Margin, mkMargin, unsafeMargin, unMargin) where

import Prelude
import CSS.Size (Size, sizeToString)
import Data.String (joinWith)
import Safe.Coerce (coerce)

newtype Margin = Margin String

derive instance Eq Margin
derive instance Ord Margin
derive newtype instance Show Margin

mkMargin :: forall a. Size a -> Size a -> Size a -> Size a -> Margin
mkMargin top right bottom left = Margin (joinWith " " (sizeToString <$> [ top, right, bottom, left ]))

unsafeMargin :: String -> Margin
unsafeMargin = coerce

unMargin :: Margin -> String
unMargin = coerce

-- TODO: to record?
-- toRecord :: Margin -> { top :: Size ?, ... }
