{-# OPTIONS -Wall -Werror #-}

-- | TAI and leap-second tables for converting to UTC: most people won't need this module.
module Data.Time.TAI
(
	-- TAI arithmetic
	AbsoluteTime,taiEpoch,addAbsoluteTime,diffAbsoluteTime,

	-- leap-second table type
	LeapSecondTable,

	-- conversion between UTC and TAI with table
	utcDayLength,utcToTAITime,taiToUTCTime
) where

import Data.Time.Calendar.Days
import Data.Time.Clock

-- | AbsoluteTime is TAI, time as measured by a clock.
newtype AbsoluteTime = MkAbsoluteTime DiffTime deriving (Eq,Ord)

-- | The epoch of TAI, which is 
taiEpoch :: AbsoluteTime
taiEpoch = MkAbsoluteTime 0

-- | addAbsoluteTime a b = a + b
addAbsoluteTime :: DiffTime -> AbsoluteTime -> AbsoluteTime
addAbsoluteTime t (MkAbsoluteTime a) = MkAbsoluteTime (a + t)

-- | diffAbsoluteTime a b = a - b
diffAbsoluteTime :: AbsoluteTime -> AbsoluteTime -> DiffTime
diffAbsoluteTime (MkAbsoluteTime a) (MkAbsoluteTime b) = a - b

-- | TAI - UTC during this day.
-- No table is provided, as any program compiled with it would become
-- out of date in six months.
type LeapSecondTable = Day -> Integer

utcDayLength :: LeapSecondTable -> Day -> DiffTime
utcDayLength table day = realToFrac (86400 + (table (addDays 1 day)) - (table day))

utcToTAITime :: LeapSecondTable -> UTCTime -> AbsoluteTime
utcToTAITime table (UTCTime day dtime) = MkAbsoluteTime
	((realToFrac ((toModifiedJulianDay day) * 86400 + (table day))) + dtime)

taiToUTCTime :: LeapSecondTable -> AbsoluteTime -> UTCTime
taiToUTCTime table (MkAbsoluteTime t) = undefined table t -- WRONG
