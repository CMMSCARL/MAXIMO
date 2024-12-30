declare @USERID varchar(24) = 'CHEND'   --'cmc719'    --RFO223 JWE719 LPE487
declare @WONUM varchar(24); set @WONUM = '%%'

declare @CURRENT int = 1;  --<-<-< 1 = currently active records, 0 = ALL related records
 
select top 100 mu.userID as 'USER', p.displayname as 'User Name', p.PersonID, p.Title, p.Department, p.supervisor as 'Supr ID', p2.displayname as 'Supervisor', mu.Status as 'U.Status', p.status as 'P.Status', mu.defsite  from maxuser mu left join person p on mu.personid = p.personid left join person p2 on p.supervisor = p2.personid where mu.userid like @USERID

select pre.wonum as 'MOC No', pre.SiteID, wo1.Location, wo1.ReportedBy as 'Entered', PRE.actionby as 'Assigned', 'Pre ' as 'Start', pre.STDACTNUM as 'Action#', std.Description, wo1.Status, completed as 'Comp', tri_notapplicable as 'N/A', tri_actdeferred as 'Deferred' 
from plusgmocprelist  pre inner join workorder wo1 on pre.wonum = wo1.wonum inner join PLUSGSTDACT std on pre.stdactnum = std.stdactnum left join plusgmoc moc on pre.wonum = moc.wonum and pre.siteid = moc.siteid 
where pre.actionby like @USERID and wo1.historyflag = 0 and pre.completed = 0 and pre.tri_notapplicable = 0 and pre.tri_actdeferred = 0 and completed = 0 and moc.wonum like @WONUM and wo1.historyflag = 0
union 
select pst.wonum as 'MOC No', pst.siteid, wo2.location, wo2.reportedby as 'Entered', pst.actionby as 'Assigned', 'Post' as 'Start', pst.STDACTNUM , std.description, wo2.Status, completed as 'Comp', tri_notapplicable as 'N/A' , 0
from plusgmocpostlist pst inner join workorder wo2 on pst.wonum = wo2.wonum inner join PLUSGSTDACT std on pst.stdactnum = std.stdactnum left join plusgmoc moc on pst.wonum = moc.wonum and pst.siteid = moc.siteid 
where pst.actionby like @USERID and wo2.historyflag = 0 and pst.completed = 0 and pst.tri_notapplicable = 0 and completed = 0 and moc.wonum like @WONUM and wo2.historyflag = 0 order by pre.wonum 


if @CURRENT = 1
	begin 
	select top 400 wfa.description as 'Active Workflow Assignments', wfa.AssignCode, wfa.OrigPerson, wfa.OwnerTable, wfa.OwnerID, wfa.AssignID, wfa.APP, wfa.ProcessName, wfa.RoleID, wfa.StartDate, wfa.DueDate
		, wfa.AssignStatus, pga.wonum, pga.Description 
	from wfassignment wfa 
		left join plusgact pga on wfa.ownerid = pga.workorderid 
	where wfa.assigncode like @USERID and wfa.assignstatus not in ('COMPLETE', 'INACTIVE', 'DEFAULT', 'FORWARDED') and wonum = @WONUM order by wfa.description end
else 
	begin 
		select top 400 wfa.description as 'ALL Workflow Assignments', wfa.AssignCode, wfa.OrigPerson, wfa.OwnerTable, wfa.OwnerID, wfa.AssignID, wfa.APP, wfa.ProcessName, wfa.RoleID
			, wfa.StartDate, wfa.DueDate, wfa.AssignStatus, pga.wonum, pga.Description 
		from wfassignment wfa left join plusgact pga on wfa.ownerid = pga.workorderid 
		where wfa.assigncode like @USERID and wfa.description like @WONUM
		order by startdate end
--		order by wfa.description end

if @CURRENT = 1
	begin select top 100 SiteID as 'Investigations', Location, ticketid as 'Inv#', Status, plusginvestlead, Owner, affectedperson, changeby, class, description, hasLD, ticketuid from problem p where class = 'Investigation' and historyflag = 0 and plusginvestlead like @USERID  and historyflag = 0 and status not in ('CLOSED', 'RESOLVED') end
else 
	begin select top 100 SiteID as 'Investigations', Location, ticketid as 'Inv#', Status, plusginvestlead, Owner, affectedperson, changeby, class, description, hasLD, ticketuid from problem p  where plusginvestlead like @USERID and class = 'Investigation'  end

if @CURRENT = 1
	begin  select top 100 SiteID as 'Incidents', Location, ticketid as 'Inc#', Status, plusginvestlead, Owner, affectedperson, changeby, class, description, hasLD, ticketuid from incident i where (owner like @USERID or PLUSGINVESTLEAD like @USERID) and class = 'INCIDENT' and historyflag = 0 and status not in ('CLOSED', 'RESOLVED') end
else 
	begin select top 100 SiteID as 'Incidents', Location, ticketid as 'Inc#', Status, plusginvestlead, Owner, affectedperson, changeby, class, description, hasLD, ticketuid from incident i where (owner like @USERID or PLUSGINVESTLEAD like @USERID) and class = 'INCIDENT'  end

if @CURRENT = 1 begin
	Select SiteID as 'Open WOs', Location, assetnum, WONum, Description, WOClass, Status, Owner, Lead from workorder  where (owner like @USERID or lead like @USERID) and status not in ('COMP', 'CLOSE', 'CAN') and woclass = 'WORKORDER'  	end
	else begin Select SiteID as 'All WOs', Location, assetnum, WONum, Description, WOClass, Status, Owner, Lead from workorder where (owner like @USERID or lead like @USERID ) and woclass = 'WORKORDER' end

select pre.wonum as 'MOC No', pre.SiteID, wo1.description + ' X|X ' + moc.plusgscope + ' X|X ' + moc.plusgjustification as 'Description/Scope/Justification'
	, wo1.ReportedBy, wo1.Location, wo1.Status, 'Pre' as 'Start', wo1.Status
	, COALESCE(PRE.actionby, pre.ACTIONBYGROUP) as 'Assigned'
	, pre.Comments, wl.description as 'WL Title', wl.createby as 'LogBy', completed as 'Comp', wo1.ChangeDate
	, REPLACE(df.urlname,'\\MAXDOCP01.Targa.com\D$\PRODDOCLINKS\DOCLINKS\', 'https://maximo.targaresources.com/' ) as 'Clickable'
from plusgmocprelist pre inner join workorder wo1 on pre.wonum = wo1.wonum
	inner join plusgmoc moc on pre.wonum = moc.wonum and pre.siteid = moc.siteid
	left join worklog wl on pre.siteid = wl.siteid and pre.wonum = wl.recordkey and wl.worklogid = (select top 1 worklogid from worklog where recordkey = pre.wonum order by CREATEDATE desc)
	left join doclinks dl on moc.workorderid = dl.ownerid and dl.ownertable = 'PLUSGMOC' 
	left join docinfo df on dl.docinfoid = df.docinfoid and (df.description like '%.xlsx' or df.description like '%.xlsm') and (df.description like '%load%' or df.description like '%attribute%')
where (pre.actionby like @USERID) and wo1.historyflag = 0 /*  Insert in fromt of ActionByGroup   pre.actionby like @USERID or   */
	and pre.completed = 0
	and pre.tri_notapplicable = 0 
	and pre.tri_actdeferred = 0  
	and completed = 0
	and moc.status not in ('MOCAPPR', 'CAN', 'CLOSE')
union
select pst.wonum as 'MOC No', pst.siteid, wo2.description + 'X|X' + moc.plusgscope + 'X|X' + moc.plusgjustification as 'Description/Scope/Justification'
	, wo2.reportedby, wo2.location, wo2.Status, 'Post' as 'Start', wo2.status, COALESCE(pst.actionby, pst.ACTIONBYGROUP) as 'Assigned', pst.comments, wl.description, wl.createby, completed, wo2.changedate
	, REPLACE(df.urlname,'\\MAXDOCP01.Targa.com\D$\PRODDOCLINKS\DOCLINKS\', 'https://maximo.targaresources.com/' ) as 'Clickable'
from plusgmocpostlist pst inner join workorder wo2 on pst.wonum = wo2.wonum
	inner join plusgmoc moc on pst.wonum = moc.wonum and pst.siteid = moc.siteid
	left join worklog wl on pst.siteid = wl.siteid and pst.wonum = wl.recordkey and wl.worklogid = (select top 1 worklogid from worklog where recordkey = pst.wonum order by CREATEDATE desc)
	left join doclinks dl on moc.workorderid = dl.ownerid and dl.ownertable = 'PLUSGMOC' 
	left join docinfo df on dl.docinfoid = df.docinfoid and (df.description like '%.xlsx' or df.description like '%.xlsm') and (df.description like '%load%' or df.description like '%attribute%')
where (pst.actionby like @USERID) and wo2.historyflag = 0   /* Insert in front of ActionByGroup  pst.actionby like @userid or   */
	and pst.completed = 0
	and pst.tri_notapplicable = 0 
	and completed = 0

	/*
if @CURRENT = 1 and @WONUM != ''
begin
	Select SiteID, Location, assetnum, WONum, Description, WOClass, Status, Owner, Lead 
	from workorder 
	where wonum = @WONUM and status not in ('COMP', 'CLOSE', 'CAN')
end
else
begin 
	Select SiteID, Location, assetnum, WONum, Description, WOClass, Status, Owner, Lead from workorder where wonum = @WONUM 
end
*/
--	select top 200 wfi.wfid as 'WFInstance', wfi.Originator, wfi.processname, wfi.revision, wfi.OwnerTable, wfi.OwnerID, wfi.StartTime, wfi.currtaskstarttime, case when wfi.ownertable = 'PLUSGMOC' then moc.wonum  when wfi.ownertable = 'PLUSGACT' then PGA.wonum when wfi.ownertable = 'PLUSGAUDIT' then PGAT.auditnum end as '#'  from wfinstance wfi left join plusgmoc moc on wfi.ownerid = moc.workorderid left join plusgact pga on wfi.ownerid = pga.workorderid left join PLUSGAUDIT pgat on wfi.ownerid = pgat.plusgauditid where wfi.wfid in (select top 400 wfid from wfassignment where assigncode like @USERID) and active = 1 order by wfi.ownerid desc

--	select assigncode as 'Asign Count', count(1) as 'Count' from wfassignment  where AssignStatus = 'ACTIVE'  group by assigncode

--	select wonum from workorder where woclass = 'MOC' and reportedby = 'CHE595' and historyflag = 0

