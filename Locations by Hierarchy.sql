declare @TOP varchar(24) = 'NDA' 

select 1 "Lvl", LH.parent "Loc Parent", L.location, L.DESCRIPTION "Location Desc" from LOCATIONS L, LOCHIERARCHY LH
where L.SITEID = LH.SITEID and L.location = LH.location and L.SITEID = @TOP  and LH.parent is null
union
select 2 "Lvl", LH.parent "Loc Parent", L.location, L.DESCRIPTION "Location Desc" from LOCATIONS L, LOCHIERARCHY LH
where L.SITEID = LH.SITEID and L.location = LH.location and L.SITEID = @TOP  
  and LH.parent in (select location from lochierarchy where parent is null)
union
select 3 "Lvl", LH.parent "Loc Parent", L.location, L.DESCRIPTION "Location Desc" from LOCATIONS L, LOCHIERARCHY LH
where L.SITEID = LH.SITEID and L.location = LH.location and L.SITEID = @TOP  
  and LH.parent in (select location from lochierarchy where parent in (select location from LOCHIERARCHY where parent is null))
union
select 4 "Lvl", LH.parent "Loc Parent", L.location, L.DESCRIPTION "Location Desc" from LOCATIONS L, LOCHIERARCHY LH
where L.SITEID = LH.SITEID and L.location = LH.location and L.SITEID = @TOP  
  and LH.parent in (select location from LOCHIERARCHY where parent in 
    (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent is null)))
/*union
select 5 "Lvl", LH.parent "Loc Parent", L.location, L.DESCRIPTION "Location Desc" from LOCATIONS L, LOCHIERARCHY LH
where L.SITEID = LH.SITEID and L.location = LH.location and L.SITEID = @TOP  
  and LH.parent in (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
    (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent is null))))
union
select 6 "Lvl", LH.parent "Loc Parent", L.location, L.DESCRIPTION "Location Desc" from LOCATIONS L, LOCHIERARCHY LH
where L.SITEID = LH.SITEID and L.location = LH.location and L.SITEID = @TOP  
  and LH.parent in (select location from LOCHIERARCHY where parent in 
    (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
      (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent is null)))))
union
select 7 "Lvl", LH.parent "Loc Parent", L.location, L.DESCRIPTION "Location Desc" from LOCATIONS L, LOCHIERARCHY LH
where L.SITEID = LH.SITEID and L.location = LH.location and L.SITEID = @TOP  
  and LH.parent in (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
    (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
      (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent is null))))))
union
select 8 "Lvl", LH.parent "Loc Parent", L.location, L.DESCRIPTION "Location Desc" from LOCATIONS L, LOCHIERARCHY LH
where L.SITEID = LH.SITEID and L.location = LH.location and L.SITEID = @TOP  
  and LH.parent in (select location from LOCHIERARCHY where parent in 
    (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
      (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
        (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent is null)))))))
union
select 9 "Lvl", LH.parent "Loc Parent", L.location, L.DESCRIPTION "Location Desc" from LOCATIONS L, LOCHIERARCHY LH
where L.SITEID = LH.SITEID and L.location = LH.location and L.SITEID = @TOP  
  and LH.parent in (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
    (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
      (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
        (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent is null))))))))
union
select 10 "Lvl", LH.parent "Loc Parent", L.location, L.DESCRIPTION "Location Desc" from LOCATIONS L, LOCHIERARCHY LH
where L.SITEID = LH.SITEID and L.location = LH.location and L.SITEID = @TOP  
  and LH.parent in (select location from LOCHIERARCHY where parent in 
    (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
    (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
      (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent in 
        (select location from LOCHIERARCHY where parent in (select location from LOCHIERARCHY where parent is null)))))))))

*/




order by LH.parent, L.location
