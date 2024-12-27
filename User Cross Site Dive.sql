--	select * from person where displayname like '%WOODR%'


declare @USER varchar(12) = 'myz904' 
declare @WONUM varchar(24); set @WONUM = '%%'
declare @CITY varchar(24); set @CITY = (select city from person where personid = @USER)
declare @DEFSITE varchar(4) = (select mu.defsite from maxuser mu where mu.userid like @USER);  
declare @DefSiteGrp varchar(24) = (select top 1 groupname from maxgroup where groupname like '%' + @DEFSITE + '%')

declare @DETAILS varchar(1);	set @DETAILS	= 1	;	-->>>-- Setting to 1 will also show Qualificaitons, Work Orders, and Workflow Assignments
declare @NEAR varchar(1);	set @NEAR	= 1	;	-->>>-- Setting to 1 will also show Admins for this Default Site

select mu.userID as 'USER', mu.status as 'U.Status', p.PersonID, p.status as 'P.Status', p.displayname as 'User Name', p.Title, p.City, p.Department, mu.defsite , p.supervisor as 'Supr ID', p2.displayname as 'Supervisor' --, pa1.Ancestor as 'Dad', pa2.Ancestor as 'Grand', pa3.Ancestor as 'Creat'
from person p  left join maxuser mu on mu.personid = P.personid  Left join person p2 on p.supervisor =  p2.personid  --	left join personancestor pa1 on p.personid = pa1.personid and pa1.hierarchylevels = 1 left join personancestor pa2 on p.personid = pa2.personid and pa2.hierarchylevels = 2 left join personancestor pa3 on p.personid = pa3.personid and pa3.hierarchylevels = 3
where p.personid like @USER order by p.displayname

select  * from personancestor where personid = @USER order by hierarchylevels

select PersonID as 'Minions', DisplayName, Title, LocationSite, City, stateprovince from person where supervisor = @USER and status = 'ACTIVE'

Select gu.GroupName, sa.SiteID from groupuser gu left join siteauth sa on gu.groupname = sa.groupname where gu.userid like @USER --and gu.groupname not in ('MAXDEFLTREG', 'MAXEVERYONE', 'SG-APP-MAX-MAXACCESS')

Select LaborCode, Craft, case when DefaultCraft = 0 then 'NO' else 'YES' end as 'Def' from laborcraftrate where laborcode like @USER

select UserID as 'Sessions', DisplayName, ClientAddr, format(logindatetime, 'MM/dd HH:mm', 'en-US') as 'Login Time' from MAXSESSION where USERID = @USER

select top 6 UserID as 'Logins', AttemptDate, AttemptResult, ClientHost from LOGINTRACKING where USERID = @USER order by attemptdate desc

if @DETAILS = 1  
begin 
	select LaborCode as 'Quals', QualificationID, ValidationDate, ValidatedBy, EndDate from laborqual where laborcode = @USER 
	select top 100 Siteid as 'Work', Location, WONum, Description, AssetNum, Owner, Lead from workorder where owner = @USER and historyflag = 0 and status not in ('COMP')
	select top 400 wfa.description as 'Active Workflow Assignment', wfa.assigncode, wfa.OrigPerson, wfa.ownertable, wfa.ownerid, wfa.assignid, wfa.APP, wfa.ProcessName, wfa.RoleID, wfa.StartDate, wfa.DueDate, wfa.AssignStatus, pga.wonum, pga.description
		from wfassignment wfa left join plusgact pga on wfa.ownerid = pga.workorderid where wfa.assigncode = @USER and wfa.assignstatus not in ('COMPLETE', 'INACTIVE', 'DEFAULT', 'WREVIEW', 'FORWARDED') order by wfa.description

	select pre.wonum as 'MOC No', pre.SiteID, wo1.location, wo1.reportedby as 'Entered', PRE.actionby as 'Assigned', 'Pre ' as 'Start', pre.STDACTNUM as 'Std Action', std.description, wo1.reportedby, wo1.Status, completed as 'Comp', tri_notapplicable as 'N/A', tri_actdeferred as 'Deferred' 
	from plusgmocprelist  pre 
		inner join workorder wo1 on pre.wonum = wo1.wonum 
		inner join PLUSGSTDACT std on pre.stdactnum = std.stdactnum
		left join plusgmoc moc on pre.wonum = moc.wonum and pre.siteid = moc.siteid 
	where pre.actionby like @USER and wo1.historyflag = 0 and pre.completed = 0 and pre.tri_notapplicable = 0 and pre.tri_actdeferred = 0 and completed = 0 and moc.wonum like @WONUM and wo1.historyflag = 0
	union 
	select pst.wonum as 'MOC No', pst.siteid, wo2.location, wo2.reportedby as 'Entered', pst.actionby as 'Assigned', 'Post' as 'Start', pst.STDACTNUM as 'Std Action', std.description, wo2.reportedby, wo2.Status, completed as 'Comp', tri_notapplicable as 'N/A' , 0
	from plusgmocpostlist pst 
		inner join workorder wo2 on pst.wonum = wo2.wonum 
		inner join PLUSGSTDACT std on pst.stdactnum = std.stdactnum
		left join plusgmoc moc on pst.wonum = moc.wonum and pst.siteid = moc.siteid 
	where pst.actionby like @USER and wo2.historyflag = 0 and pst.completed = 0 and pst.tri_notapplicable = 0 and completed = 0 and moc.wonum like @WONUM and wo2.historyflag = 0 order by pre.wonum 

end

if @NEAR = 1 begin

	select top 150 gu.groupname as 'Neat FacSupr', p.displayname, gu.userID, mu.defsite, p.city 
	from groupuser gu 
		inner join maxuser mu on gu.userid = mu.userid inner join person p on mu.personid = p.personid 
	where gu.groupname like 'SG-APP-MAX-FACSUP' and mu.defsite = @DEFSITE and p.city = @CITY

	select top 150 gu.groupname as 'Near IncUsr', p.displayname, gu.userID, mu.defsite, p.city 
	from groupuser gu 
		inner join maxuser mu on gu.userid = mu.userid inner join person p on mu.personid = p.personid 
	where gu.groupname like 'SG-APP-MAX-INCUSER' and mu.defsite = @DEFSITE and p.city = @CITY
	select top 100 lcr.craft, p.displayname as 'Near Admins', p.personid, p.City, p.Title 
	from person p 
		inner join laborcraftrate lcr on p.personid = lcr.laborcode and lcr.craft in ('ADMIN', 'PLSC') and lcr.defaultcraft = 1
where p.city = @CITY 
end
