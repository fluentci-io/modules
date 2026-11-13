module CI.Contract.CSV (parse) where

import Prelude
import Data.Array as Array
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits as CU
import Data.String.Common (trim)

data Mode = Plain | Quoted | Closed

-- A single CSV record. Quotes preserve literal commas and doubled quotes; no
-- shell parsing or expansion occurs. Blank optional lists become no arguments.
parse :: String -> Either String (Array String)
parse input
  | trim input == "" = Right []
  | otherwise = go Plain "" [] (CU.toCharArray input)
  where
  addEntry value values = if trim value == "" then Left "CSV entries must not be empty" else Right (Array.snoc values value)
  go mode value values chars = case Array.uncons chars of
    Nothing -> case mode of
      Quoted -> Left "Unterminated quoted CSV entry"
      Plain -> addEntry (trim value) values
      Closed -> addEntry value values
    Just { head: char, tail } -> case mode of
      Plain -> case char of
        ',' -> addEntry (trim value) values >>= \next -> go Plain "" next tail
        '"' -> if trim value == "" then go Quoted "" values tail else Left "Quote inside an unquoted CSV entry"
        _ -> go Plain (value <> CU.singleton char) values tail
      Quoted ->
        if char == '"' then
          case Array.uncons tail of
            Just { head: '"', tail: rest } -> go Quoted (value <> "\"") values rest
            _ -> go Closed value values tail
        else go Quoted (value <> CU.singleton char) values tail
      Closed -> if char == ',' then addEntry value values >>= \next -> go Plain "" next tail
        else if char == ' ' || char == '\t' then go Closed value values tail
        else Left "Expected a comma after a quoted CSV entry"
