{-# LANGUAGE RecordWildCards #-}

module Components where

import Prelude hiding ((.), id)
import Linear.V2
import qualified SFML.Graphics as G
import Control.Monad
import Control.Parallel.Strategies
import Control.Wire
import Control.Monad.Trans.State
import Control.Monad.SFML
import Control.Monad.SFML.Graphics
import Control.Lens hiding (at)
import Control.Monad.Trans.Class (lift)
import qualified SFML.System as S
import qualified Data.IntMap.Strict as Map


import Types
import Particles
import Wires

--------------------------------------------------------------------------------
sprite :: G.Sprite -> Component
sprite = Component Renderable . Sprite

--------------------------------------------------------------------------------
text :: G.Text -> Component
text = Component Renderable . Text

--------------------------------------------------------------------------------
intSize :: Int -> Component
intSize = Component Size . SizeInt

--------------------------------------------------------------------------------
colour :: G.Color -> Component
colour = Component Colour . RenderColour

--------------------------------------------------------------------------------
blink :: NominalDiffTime -> NominalDiffTime -> Component
blink cooldown blinkTime =
  Component AffectRendering (MustRenderWire (blinkWire cooldown blinkTime))


--------------------------------------------------------------------------------
position :: Int -> Int -> Component
position x y = Component Position (PosInt (V2 x y))


--------------------------------------------------------------------------------
translationFromV2 :: V2 Int -> G.RenderStates
translationFromV2 (V2 x y) = G.renderStates {
  G.transform = G.translation (fromIntegral x) (fromIntegral y)
  }


--------------------------------------------------------------------------------
keyboard :: GameWire NominalDiffTime (V2 Int) -> Component
keyboard wire = Component Keyboard (PlKbWire wire)


--------------------------------------------------------------------------------
onEvents :: [EventType] -> Component
onEvents = Component EventListener . RelevantEvents


--------------------------------------------------------------------------------
eventQueue :: Component
eventQueue = Component EventHolder (Events Uninitialized)
