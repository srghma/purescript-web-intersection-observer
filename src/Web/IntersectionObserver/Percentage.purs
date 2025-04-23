module Web.IntersectionObserver.Percentage (Percentage, mkPercentage, unsafePercentage, unPercentage) where

import Prelude

import Data.Maybe (Maybe(..))
import Safe.Coerce (coerce)

-- a number from 0.0 to 1.0
newtype Percentage = Percentage Number

derive instance Eq Percentage
derive instance Ord Percentage
derive newtype instance Show Percentage

-- Smart constructor
mkPercentage :: Number -> Maybe Percentage
mkPercentage n
  | n >= 0.0 && n <= 1.0 = Just (Percentage n)
  | otherwise = Nothing

unsafePercentage :: Number -> Percentage
unsafePercentage = coerce

-- Unwrap
unPercentage :: Percentage -> Number
unPercentage = coerce
