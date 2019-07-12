module Main (main) where

import qualified Control.Foldl as L
import Control.Foldl (Fold, FoldM)

import Data.Functor.Identity (Identity)
import Numeric.Natural (Natural)
import Test.QuickCheck (Gen, Arbitrary(..), (===))
import Test.Framework (defaultMain, testGroup, Test)
import Test.Framework.Providers.QuickCheck2 (testProperty)

import qualified Data.List as List

main :: IO ()
main = defaultMain tests

tests :: [Test]
tests =
    [ testGroup "Drop"
        [ testProperty "Pure" prop_drop
        , testProperty "Impure" prop_dropM
        ]
    ]

prop_drop n list =
    let folder = L.sum :: Fold Integer Integer
    in L.fold (L.drop n folder) list === L.fold folder (List.genericDrop n list)

prop_dropM n list =
    let folder = L.generalize L.sum :: FoldM Identity Integer Integer
    in L.foldM (L.dropM n folder) list === L.foldM folder (List.genericDrop n list)

instance Arbitrary Natural where
    arbitrary = fmap (fromInteger . abs) (arbitrary :: Gen Integer)
    shrink n = (map fromInteger . filter (>= 0)) (shrink (toInteger n))
