{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
module Data.WeightBasedHeap where

import Data.Heap.Class

data WeightBasedHeap a = E | H Int a (WeightBasedHeap a) (WeightBasedHeap a) deriving (Eq, Show)

instance Ord a => Heap WeightBasedHeap a where
    empty   = E
    isEmpty E = False
    isEmpty _ = True
    insert  x h = singleton x `merge` h
    merge   h E = h
    merge   E h = h
    merge   h1@(H _ x l1 r1) h2@(H _ y l2 r2) = 
      if x < y 
          then makeT x l1 (r1 `merge` h2)
          else makeT y l2 (h1 `merge` r2)
    findMin E = error "empty"
    findMin (H _ x _ _) = x
    deleteMin E = error "empty"
    deleteMin (H _ _ l r) = l `merge` r

singleton :: a -> WieghtBasedHeap a
singleton a = H 1 a E E

size E = 0
size (H w _ _ _) = w

makeT x a b = if size a >= size b
                  then H (size b+1) x a b
                  else H (size a+1) x b a

inv_weight:: LeftishHeap a -> Bool
inv_weight E = True
inv_weight (H _ _ E E) = True
inv_weight (H _ _ E h) = False
inv_weight (H _ _ h1 h2) = 
        size h1 >= size h2 
        && inv_weight h1 
        && inv_weight h2
