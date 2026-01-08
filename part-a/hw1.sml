fun is_older(date1: int*int*int, date2: int*int*int) =
    ((#1 date1) < (#1 date2)) orelse 
    ((#1 date1) = (#1 date2) andalso (#2 date1) < (#2 date2)) orelse
    ((#1 date1) = (#1 date2) andalso (#2 date1) = (#2 date2) andalso (#3 date1) < (#3 date2));

fun number_in_month(dates: (int*int*int) list, month: int) =
    if null dates
    then 0
    else if (#2 (hd dates)) = month then 1 + number_in_month(tl dates, month)
         else number_in_month(tl dates, month);

fun number_in_months(dates: (int*int*int) list, months: int list) =
    if null months
    then 0
    else number_in_month(dates, (hd months)) + number_in_months(dates, (tl months));

fun dates_in_month(dates: (int*int*int) list, month: int) =
    if null dates
    then []
    else if (#2 (hd dates)) = month
         then (hd dates)::dates_in_month(tl dates, month)
         else dates_in_month(tl dates, month);

fun dates_in_months(dates: (int*int*int) list, months: int list) =
    if null months
    then []
    else dates_in_month(dates, (hd months)) @ dates_in_months(dates, (tl months)); 

fun get_nth(words: string list, n: int) =
    if n = 1
    then (hd words)
    else get_nth((tl words), n-1);

fun date_to_string(date: (int*int*int)) =
    let
      val months = [
        "January", "February", "March", "Apri", "May", "June",
        "July", "August", "September", "October", "November", "December"
      ]
  
      val day = Int.toString((#3 date))
      val month = get_nth(months, (#2 date))
      val year = Int.toString((#1 date))
    in
      month ^ " " ^ day ^ ", " ^ year
    end;

fun number_before_reaching_sum(n: int, numbers: int list) =
    let
      fun aux(prev, sum, numbers) =
          if (sum-(hd numbers)) <= 0
          then prev
          else aux((hd numbers), (sum-(hd numbers)), (tl numbers))
    in
       aux(0, n, numbers)
    end;

fun what_month(day: int) =
    let
        val days = [
          31, 28, 31, 30, 31, 30,
          31, 31, 30, 31, 30, 31
        ]
        
        fun aux(month, day, days) =
            if (day - (hd days)) <= 0
            then month
            else aux(month+1, (day - (hd days)), (tl days))
    in  
        aux(1, day, days)
    end;

fun month_range(day1, day2) =
    if (day1-day2) > 0
    then []
    else what_month(day1) :: month_range(day1+1, day2);

fun oldest(dates: (int*int*int) list) =
    let
        fun aux(oldest, dates) =
            if null dates
            then oldest
            else if is_older(oldest, (hd dates))
                 then aux(oldest, (tl dates))
                 else aux((hd dates), (tl dates))
    in
        if null dates
        then NONE
        else SOME(aux((hd dates), (tl dates)))
    end;
