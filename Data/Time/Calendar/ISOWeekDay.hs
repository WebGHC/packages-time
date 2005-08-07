{-# OPTIONS -Wall -Werror #-}

-- #hide
module Data.Time.Calendar.ISOWeekDay
	(
	-- * ISO 8601 Week calendar
	module Data.Time.Calendar.ISOWeekDay
	) where

import Data.Time.Calendar.YearDay
import Data.Time.Calendar.Days
import Data.Time.Calendar.Private

-- | convert to ISO 8601 Week format. First element of result is year, second week number (1-53), third day of week (1 for Monday to 7 for Sunday).
-- Note that "Week" years are not quite the same as Gregorian years, as the first day of the year is always a Monday.
-- The first week of a year is the first week to contain at least four days in the corresponding Gregorian year.
toISOWeekDay :: Date -> (Integer,Int,Int)
toISOWeekDay date@(ModJulianDay mjd) = (y1,fromInteger (w1 + 1),fromInteger (mod d 7) + 1) where
	(y0,yd) = toYearAndDay date
	d = mjd + 2
	foo :: Integer -> Integer
	foo y = bar (getModJulianDay (fromYearAndDay y 6))
	bar k = (div d 7) - (div k 7)
	w0 = bar (d - (toInteger yd) + 4)
	(y1,w1) = if w0 == -1
		then (y0 - 1,foo (y0 - 1))
		else if w0 == 52
		then if (foo (y0 + 1)) == 0
			then (y0 + 1,0)
			else (y0,w0)
		else (y0,w0)

-- | convert from ISO 8601 Week format. First argument is year, second week number (1-52 or 53), third day of week (1 for Monday to 7 for Sunday).
-- Invalid week and day values will be clipped to the correct range.
fromISOWeekDay :: Integer -> Int -> Int -> Date
fromISOWeekDay y w d = ModJulianDay (k - (mod k 7) + (toInteger (((clip 1 (if longYear then 53 else 52) w) * 7) + (clip 1 7 d))) - 10) where
		k = getModJulianDay (fromYearAndDay y 6)
		longYear = case toISOWeekDay (fromYearAndDay y 365) of
			(_,53,_) -> True
			_ -> False

-- | show in ISO 8601 Week format as yyyy-Www-dd (e.g. 
showISOWeekDay :: Date -> String
showISOWeekDay date = (show4 y) ++ "-W" ++ (show2 w) ++ "-" ++ (show d) where
	(y,w,d) = toISOWeekDay date
