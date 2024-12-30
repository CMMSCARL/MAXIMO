
declare @PROJ varchar(12); set @PROJ = '  114002   ';  --<<<< Enter Project # Here 
set @PROJ = ltrim(rtrim(@PROJ)); 
declare @FINCTRL int; set @FINCTRL = (select top 1 fincntrlid from fincntrl where projectid = @PROJ)
declare @RELATED integer; Set @RELATED = 0;

declare @LEN integer;
set @LEN = (select max(len(taskid)) from fincntrl where projectid = @PROJ) 
if @RELATED = 1
BEGIN
	select Siteid, Location, WONUM, Description, fincntrlid from workorder where fincntrlid = @PROJ
	Select SiteID, PONum, revisionnum as 'Rev', POLineNum, description, fincntrlid, refwo as 'WONum', assetnum, location from poline pol where fincntrlid = @PROJ
	Select SiteID, PRNUM, PRLineNum, description, fincntrlid, refwo as 'WONum', assetnum, location from prline prl where fincntrlid = @PROJ
END


select case 
	when fc.fcstatus in ('CLOSED', 'WAPPR') then 'Status'
	when (fc.enddate - fc.startdate  < 10 ) or (fc.enddate < getdate()) then 'Bad Dates' 
	when fc.ischargeable = 0 then 'Disabled'
	when fc.ischargeable = 0 and fc.tasklevel > 0 then 'Chargable?' 
	when fc.ischargeable = 0 then 'Disabled'
	else 'OKAY' end as 'Problem'
	, fc.siteid, fc.projectid as 'Project', fc.tasklevel as 'Level', fc.taskid as 'Task', fc.description, fc.ischargeable as 'Enabled', fc.fcstatus as 'Status'
	, fc.projecttype as 'Type', fc.tri_projecttype as 'Major', fc.sourcesysid as 'From', fc.startdate as 'Start', fc.enddate as 'End', ld.ldtext as 'Long Description'
	, fc.fincntrlid, fc.changedate, fc.changeby
from fincntrl fc 
	left join longdescription ld on fc.fincntrluid = ld.ldkey and ld.ldownertable = 'FINCNTRL'
where fc.projectid = @PROJ
order by fc.projectid, fc.tasklevel--, cast(taskid as int) 

--	select top 200 SiteID as 'Proj# WOs', Location, AssetNum, WONum, Description, Owner, Lead, Status, StatusDate from workorder where fincntrlid = @FINCTRL and istask = 0 and reportdate > getdate() -162
 
