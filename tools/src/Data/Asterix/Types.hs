{-# LANGUAGE DeriveGeneric #-}

-- Asterix data types.

module Data.Asterix.Types where

import           GHC.Generics (Generic)
import           Data.Ratio (Ratio)
import           Data.Text

type RegisterSize = Int
type PrimarySize = Int
type ExtensionSize = Int
type RepetitionSize = Int
type FractBits = Int

type Name = Text
type Title = Text
type UapName = Text
type Unit = Text

data Documentation = Documentation
    { docDefinition     :: Maybe Text
    , docDescription    :: Maybe Text
    , docRemark         :: Maybe Text
    } deriving (Generic, Eq, Show)

data Rule a
    = ContextFree a
    | Dependent [Name] [(Int, a)]
    deriving (Generic, Eq, Show)

data Edition = Edition
    { editionMajor :: Int
    , editionMinor :: Int
    } deriving (Generic, Eq, Show)

instance Ord Edition where
    compare (Edition a1 b1) (Edition a2 b2) =
        compare a1 a2 <> compare b1 b2

data Date = Date
    { dateYear  :: Integer
    , dateMonth :: Int
    , dateDay   :: Int
    } deriving (Generic, Eq, Show)

data Number
    = NumberZ Integer
    | NumberQ (Ratio Int)
    | NumberR Double
    deriving (Generic, Eq, Ord, Show)

data Constrain
    = EqualTo Number
    | NotEqualTo Number
    | GreaterThan Number
    | GreaterThanOrEqualTo Number
    | LessThan Number
    | LessThanOrEqualTo Number
    deriving (Generic, Eq, Ord, Show)

data Signed = Signed | Unsigned deriving (Generic, Eq, Show)

data StringType
    = StringAscii
    | StringICAO
    | StringOctal
    deriving (Generic, Eq, Show, Read)

newtype BdsAddr = BdsAddr Int
    deriving (Generic, Eq, Show, Read)

data BdsType
    = BdsWithAddress        -- 64 bit value (address is encoded with data)
    | BdsAt (Maybe BdsAddr) -- 56 bit value (address is maybe a priory known)
    deriving (Generic, Eq, Show, Read)

data Content
    = ContentRaw
    | ContentTable
        [(Int, Text)]
    | ContentString
        StringType
    | ContentInteger
        Signed
        [Constrain]
    | ContentQuantity
        Signed      -- unsigned/signed
        Number      -- scaling factor
        FractBits   -- number for fractional bits
        Unit        -- unit
        [Constrain]
    | ContentBds
        BdsType
    deriving (Generic, Eq, Show)

data Variation
    = Element RegisterSize (Rule Content)
    | Group [Item]
    | Extended PrimarySize ExtensionSize [Item]
    | Repetitive RepetitionSize Variation
    | Explicit
    | Compound (Maybe RegisterSize) [Maybe Item]
    deriving (Generic, Eq, Show)

data Item
    = Spare RegisterSize
    | Item Name Title Variation Documentation
    deriving (Generic, Eq, Show)

data Uap
    = Uap [Maybe Name]
    | Uaps [(UapName, [Maybe Name])]
    deriving (Generic, Eq, Show)

data Basic = Basic
    { basCategory   :: Int
    , basTitle      :: Text
    , basEdition    :: Edition
    , basDate       :: Date
    , basPreamble   :: Maybe Text
    , basCatalogue  :: [Item]
    , basUap        :: Uap
    } deriving (Generic, Eq, Show)

data Expansion = Expansion
    { expCategory   :: Int
    , expTitle      :: Text
    , expEdition    :: Edition
    , expDate       :: Date
    , expVariation  :: Variation
    } deriving (Generic, Eq, Show)

data Asterix
    = AsterixBasic Basic
    | AsterixExpansion Expansion
    deriving (Generic, Eq, Show)

