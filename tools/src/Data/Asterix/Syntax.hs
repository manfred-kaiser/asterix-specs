{-# LANGUAGE OverloadedStrings #-}

-- Asterix syntaxes.

module Data.Asterix.Syntax
where

import           Data.Asterix.Common
import qualified Data.Asterix.Syntax.Ast
import qualified Data.Asterix.Syntax.Json

-- | Syntax implementations.
syntaxes :: [(String, Syntax)]
syntaxes =
    [ ("ast", Data.Asterix.Syntax.Ast.syntax)
    , ("json", Data.Asterix.Syntax.Json.syntax)
    ]

availableEncoders :: [(String, String, Encoder)]
availableEncoders = do
    (shortName, syntax) <- syntaxes
    f <- maybe [] pure $ syntaxEncoder syntax
    return (shortName, syntaxDescription syntax, f)

availableDecoders :: [(String, String, Decoder)]
availableDecoders = do
    (shortName, syntax) <- syntaxes
    f <- maybe [] pure $ syntaxDecoder syntax
    return (shortName, syntaxDescription syntax, f)

availablePrettifiers :: [(String, String, Decoder, Encoder)]
availablePrettifiers = do
    (shortName, syntax) <- syntaxes
    case (syntaxDecoder syntax, syntaxEncoder syntax) of
        (Just decoder, Just encoder) -> return (shortName, syntaxDescription syntax, decoder, encoder)
        _ -> []

