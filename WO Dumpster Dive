
declare @WONUM varchar(250) ; set @WONUM = '    1793797        '; /*   Enter WO# here   */
set @wonum = ltrim(rtrim(@wonum));

select top 100 wo.SiteID as 'WOINFO 1', wo.parent, wo.WONum, wo.Description, wo.Status, wo.Location, wo.AssetNum, wo.WorkType as 'Type', wo.WOClass, wo.Route, wo.PMNum, wo.JPNum
	, wo.Owner, wo.Lead as 'Super' , wo.plusgprojectid as 'Project', wo.GLAccount
from workorder wo left join longdescription ld on wo.workorderid = ld.ldkey and ld.ldownertable = 'workorder' where wo.wonum = @WONUM order by wo.wonum 
select top 100 wo.SiteID as 'WOINFO 2', Owner, Lead, wo.Status, wo.StatusDate, wo.ReportedBy, wo.reportdate, wo.ChangeBy, wo.ChangeDate, wo.DIRISSUEMTLSTATUS as 'DirectIssue', workorderid, ld.ldtext from workorder wo left join longdescription ld on wo.workorderid = ld.ldkey and ld.ldownertable = 'workorder' where wo.wonum = @WONUM order by wo.wonum 

select top 100 wo.SiteID as 'ChildWO', wo.Parent, wo.WONum, wo.Description, wo.Status, wo.StatusDate as 'Date', wo.Location, wo.AssetNum, wo.ReportedBy, wo.reportdate, wo.ChangeBy, wo.ChangeDate, wo.route, wo.Owner, wo.Lead as 'Super'
	, wo.WorkType as 'Type', wo.WOClass, wo.plusgprojectid as 'Project', wo.PMNum, wo.JPNum, ld.ldtext
from workorder wo left join longdescription ld on wo.workorderid = ld.ldkey and ld.ldownertable = 'workorder'  where  parent = @WONUM and istask = 0


select top 100 WONum as 'STATUS', Status, ChangeBy, ChangeDate, Memo from wostatus where wonum = @WONUM order by wonum, changedate desc


select SiteID as 'LocInfo', Location, Description, Status from locations where location = (select location from workorder where wonum = @WONUM)
	select SiteID as 'AssetInfo', Location, AssetNum, Description, Status, StatusDate, ChangeBy from asset where assetnum = (select assetnum from workorder where wonum = @WONUM)
	select top 3 SiteID as 'Moves', AssetNum, TransType, fromloc, tositeid, toloc, datemoved, enterby from assettrans where assetnum = (select assetnum from workorder where wonum = @WONUM) 

if (select route from workorder where wonum = @WONUM) is not null 
begin
	select top 200 mal.route as 'MultiAsset', mal.routestop as 'Stop', mal.siteid, mal.Location, mal.Assetnum, mal.progress as 'Chkd', mal.inspformnum as 'Form', ir.resultnum, ir.revision as 'Rev', mal.comments, mal.tri_ldartype --INSPECTIONRESULT.RESULTNUM
	from MULTIASSETLOCCI mal left join INSPECTIONRESULT ir on mal.multiid = ir.referenceobjectid and mal.inspformnum = ir.inspformnum and mal.worksiteid = ir.siteid and ir.referenceobject = 'MULTIASSETLOCCI'  where mal.recordkey  = @WONUM 
	order by mal.routestop
	select top 200 rs.Route, rs.routestopid as 'Stop', rs.SiteID, a.location, rs.assetnum, a.description as 'Asset,Desc', rs.totalworkunits from route_stop rs left join asset a on rs.assetnum = a.assetnum and rs.siteid = a.siteid where route = (select top 1 route from workorder where wonum = @WONUM) order by rs.routestopid 
end

select top 100 SiteID as 'SCHED', Location, AssetNum, WONum, Description, estatapprlabhrs as 'EstLabor', ActLabHrs, estatapprmatcost as 'EstMatl', ActMatCost , SchedStart, ActStart, SchedFinish, ActFinish from workorder where wonum = @WONUM  order by wonum
select top 100 WONum as 'Planned Labor', Craft, quantity, laborhrs from wplabor where wonum = @WONUM
Select top 100 LaborCode, Craft, regularhrs as 'HRS', StartDateTime, FinishDateTime, TimerStatus, StartTime, StartDate, FinishTime, FinishDate, refwo as 'WO#', transtype as 'Type', Memo from labtrans where refwo = @WONUM  order by refwo
select top 20 dl.document as 'Attachments', di.Description, DI.URLType, dl.doctype, dl.printthrulink as 'Print', di.urlname from doclinks dl inner join docinfo di on dl.document = di.document where dl.ownertable = 'WORKORDER' and dl.ownerid in (select top 100 workorderid from workorder where wonum = @WONUM )

select top 1000 'WO# '+wonum as 'PlanMaterials', Description, ItemNum, itemqty as 'Qty',  unitcost as 'Ea', LineCost, requestnum as 'Req#', prlinenum as 'L#', requiredate, orderunit as 'UoM' , pr as 'PRNum'
from WPMATERIAL where wonum = @WONUM order by prnum, prlinenum--, itemnum

select wo.WONum as 'Inspection', wo.INSPFORMNUM as 'FormNum', fm.NAME, fm.revision as 'FM.Rev', fr.revision as 'FR.Rev'
	, fr.resultnum, fr.asset, fr.location, fr.status, fr.historyflag as 'COMP' 
from workorder wo 
	left join inspectionform fm on wo.INSPFORMNUM = fm.inspformnum and fm.status = 'ACTIVE' 
	left join inspectionresult fr on wo.wonum = fr.parent 
where wo.wonum = @WONUM 

select 1 as 'InspectionResult', * from inspectionresult where parent = '725810'

select top 200 PRNum as 'PR', status, description, requestedby as 'Requestor', tri_requestedby as 'Tri_Req', tri_createdfromwo as 'fromWO', IssueDate, vendor, totalcost, externalrefid as 'OFC REQ', ChangeBy, ChangeDate, tri_justification as 'Justification' 	from PR where prnum in (select distinct top 200 PRNUM from prline where refwo = @WONUM) order by prnum

select top 200 PONum as 'PO', Status, revisionnum as 'Rev', Description, TotalCost, Receipts from po 
	where ponum in (select distinct ponum from poline where refwo = @WONUM ) 
		and po.status = 'APPR'
	order by ponum, revisionnum desc

select issuetype as 'MatREC', ponum as 'PO#', porevisionnum as 'Rev#', polinenum as 'POL#', Description, IssueType, qtyrequested as 'Requested', Quantity, RejectQty, UnitCost, LineCost, fincntrlid as 'Project', actualdate
from matrectrans where refwo = @WONUM

select issuetype as 'MatUSE', ponum as 'PO#', porevisionnum as 'Rev#', polinenum as 'POL#', Description, IssueType, qtyrequested as 'Requested', quantity as 'Issued', qtyreturned as 'Returned', unitcost, linecost, fincntrlid as 'Project', actualdate
from matusetrans where refwo = @WONUM
