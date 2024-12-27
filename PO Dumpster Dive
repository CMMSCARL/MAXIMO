
declare @PONUM varchar(25) ; set @PONUM = 'TAR411425';               --<<<< enter PONUM here       , TAR407273
set @PONUM = upper(upper(ltrim(rtrim(@PONUM)))); 

declare @MAX integer; set @MAX = (select revisionnum from po where ponum = @PONUM and status in ('APPR', 'CLOSE')); if @MAX is null set @MAX = 0;
declare @WONUM varchar(12) = (select top 1 refwo from POLine where ponum = @PONUM and refwo is not null);
declare @SHOWPR  integer = 0;	 /*  0 hides the PR related information and 1 shows it   */
declare @MAXONLY integer = 1;	 /*  0 shows all revisions and 1 shows only the highest Rev# */
declare @ALLRECP integer = 0;	 /*  0 shows failures and 1 shows all receipts          */
declare @VENDOR  integer = 1;	 /*  0 hides the Vendor Info and 1 shows Vendor info    */
declare @MESSAGE integer = 1;	 /*  0 hides the Messages Info and 1 shows Messages info    */
declare @ASSET   integer = 0;	 /*  0 hides the Additional Asset / Location information and 1 shows that additional info  */


Select SiteID as 'WO Info', WONum, WOClass, Location, AssetNum, Description, Status, changeby, ChangeDate from workorder where wonum = @WONUM

if @ASSET = 1 begin select SiteID as 'LocInfo', Location, Description, Status from locations where location = (select location from workorder where wonum = @WONUM)
	select SiteID as 'AssetInfo', Location, AssetNum, Description, Status, StatusDate, ChangeBy from asset where assetnum = (select assetnum from workorder where wonum = @WONUM)
	select top 3 SiteID as 'Moves', AssetNum, TransType, fromloc, tositeid, toloc, datemoved, enterby from assettrans where assetnum = (select assetnum from workorder where wonum = @WONUM) end

select top 4 wos.WONum as 'WO Status', wos.Status, wos.ChangeBy, p.displayname, ps.displayname as 'Supr', wos.ChangeDate, wos.Memo, (case when wos.status = 'COMP' then wos.ChangeDate + 120 else NULL end ) as 'CloseDate' from wostatus wos left join person p on wos.changeby = p.personid  left join person ps on p.supervisor = ps.personid where wos.wonum = @WONUM order by wos.changedate desc


if @SHOWPR = 1 begin 
	select top 200 pr.PRNum as 'PR', pr.status, pr.StatusDate, pr.description, pr.requestedby /*as 'Requestor'*/, p.displayname as 'DisplayName', pr.tri_requestedby as 'Tri_Req', pr.tri_wonum as 'Refwo', pr.IssueDate, pr.vendor, pr.totalcost, pr.externalrefid as 'OFC REQ', pr.ChangeBy, pr.ChangeDate, pr.tri_justification as 'Justification', ld.ldtext as 'PR Interface Comments' 	
	from PR 
		left join longdescription ld on ld.ldkey = pr.prid and ld.ldownertable = 'PR' 
		left join person p on pr.requestedby = p.personid	
	where pr.prnum in (select top 100 prl.PRNum from poline pol left join prline prl on pol.ponum = prl.ponum and pol.polinenum = prl.polinenum where pol.ponum = @PONUM ) 	order by prnum 

	select top 200 PRNum as 'PRLine', prlinenum as 'Line', EnterBy, RequestedBy as 'Tri_Req', LineType, Description, ConditionCode as 'Cond Code', commodity, CommodityGroup as 'C Group', orderqty as 'QTY', orderunit as 'UoM', UnitCost, LineCost, receiptreqd as 'RcptReq', Location, AssetNum, RefWO, GLDebitAcct, ponum as 'OFC PO', polinenum as 'PO Line', Remark, inspectionrequired as 'InspReq' 
	from prline where prnum in (select top 100 prl.PRNum from poline pol left join prline prl on pol.ponum = prl.ponum and pol.polinenum = prl.polinenum where pol.ponum = @PONUM )  order by PRNum, prlinenum  end	

if @MAXONLY = 1
begin
	select top 200 PONum as 'PO Header MAX', revisionnum as 'Rev', Siteid, Status, Description, TotalCost, po.externalrefid, po.ChangeBy, po.ChangeDate, vendor, co.name, ld.ldtext, historyflag, Receipts
	from po left join longdescription ld on po.poid = ld.ldkey and ld.ldownertable = 'PO' and ld.ldownercol = 'REVCOMMENTS' left join companies co on po.vendor = co.company
	where po.ponum = @PONUM and historyflag = 0 order by po.ponum, po.revisionnum desc
	select top 10 ponum as 'PO Stat Max', Status, PONum, revisionnum as 'Rev', ChangeBy, ChangeDate, memo from postatus where ponum = @PONUM and revisionnum = @MAX order by ponum, revisionnum desc, changedate desc 
end
else begin select top 200 PONum as 'PO Header ALL', revisionnum as 'Rev', Siteid, Status, Description, TotalCost, po.externalrefid, po.ChangeBy, po.ChangeDate, vendor, co.name, ld.ldtext, historyflag, Receipts
	from po left join longdescription ld on po.poid = ld.ldkey and ld.ldownertable = 'PO' and ld.ldownercol = 'REVCOMMENTS' left join companies co on po.vendor = co.company
	where po.ponum = @PONUM  order by po.ponum, po.revisionnum desc
	select PONum as 'PO Stat All', Status, revisionnum as 'Rev', ChangeBy, ChangeDate, memo from postatus where ponum = @PONUM order by ponum, revisionnum desc, changedate desc 
end

if @VENDOR = 1  begin   Select ExternalRefID as 'Vendor Info', Company, Name, Address1 as 'Address', Address2 as 'City', Address3 as 'State', Address4 as 'Zip', ChangeDate, ChangeBy, Disabled as 'Disabled?' from companies c where c.company = (select top 1 vendor from po where ponum = @PONUM)  end

if @MESSAGE = 1 begin select mt.extmsgidfielddata as 'Message PO#', mt.meamsgid, mt.searchfielddata as 'Rev', mt.initialdatetime as 'Date', md.StatusDate, mt.meamsgid, md.Status as 'Status', md.errortext
from MAXINTMSGTRK mt inner join MAXINTMSGTRKDTL md on mt.meamsgid = md.meamsgid where mt.EXTMSGIDFIELDDATA = @PONUM order by md.statusdate desc, md.Status desc end

if @MAXONLY = 1
begin 
	select top 200 pol.PONum as 'POLine MAX R#', pol.revisionnum as 'Rev', pol.polinenum as 'Line', pol.RequestedBy as 'ReqBy', pol.LineType, pol.itemnum, pol.Description, pol.conditioncode, pol.OrderQTY, pol.orderunit as 'UoM'
		, pol.UnitCost, pol.LineCost, pol.receiptreqd as 'RcptReq', pol.COMMODITYGROUP as 'C.Group', pol.Commodity, POL.CONDITIONCODE as 'Cond Code', pol.storeloc as 'Storeroom', pol.Location, pol.AssetNum, pol.RefWO, pol.GLDebitAcct, pol.ReceivedQTY
		, cast(prl.PRNum as varchar(12)) + '_' + cast(prl.prlinenum as varchar(3)) as 'PR_Line'
		, (select sum(linecost) from matrectrans mtr where mtr.ponum = @PONUM and tri_processedstatus = 'SUCCESS') as 'MTR Total'
		, (select sum(linecost) from servrectrans mtr where mtr.ponum = @PONUM and tri_processedstatus = 'SUCCESS') as 'Serv Total'
		, case when pol.receiptscomplete = 0 then 'NOT' when pol.receiptscomplete = 1 then 'COMPLETE' end as 'CompFlag'
	from poline pol left join prline prl on pol.ponum = prl.ponum and pol.polinenum = prl.polinenum 
	where pol.ponum = @PONUM and revisionnum = @MAX 
end
else
begin
	select top 200 pol.PONum as 'POLine ALL R#', pol.revisionnum as 'Rev', pol.polinenum as 'Line', pol.RequestedBy as 'ReqBy', pol.LineType, pol.itemnum, pol.Description, pol.conditioncode, pol.OrderQTY, pol.orderunit as 'UoM'
		, pol.UnitCost, pol.LineCost, pol.receiptreqd as 'RcptReq', pol.COMMODITYGROUP as 'C.Group', pol.Commodity, POL.CONDITIONCODE as 'Cond Code', pol.storeloc as 'Storeroom', pol.Location, pol.AssetNum, pol.RefWO, pol.GLDebitAcct, pol.ReceivedQTY
		, cast(prl.PRNum as varchar(12)) + '_' + cast(prl.prlinenum as varchar(3)) as 'PR_Line'
		, (select sum(linecost) from matrectrans mtr where mtr.ponum = @PONUM and tri_processedstatus = 'SUCCESS') as 'MTR Total'
		, (select sum(linecost) from servrectrans mtr where mtr.ponum = @PONUM and tri_processedstatus = 'SUCCESS') as 'Serv Total'
		, case when pol.receiptscomplete = 0 then 'NOT' when pol.receiptscomplete = 1 then 'COMPLETE' end as 'CompFlag'
	from poline pol left join prline prl on pol.ponum = prl.ponum and pol.polinenum = prl.polinenum where pol.ponum = @PONUM  
	order by pol.ponum, revisionnum desc, pol.polinenum
end

if @ALLRECP = 0
begin 
	select top 400 PONum as 'MatRec', porevisionnum as 'Rv', polinenum as 'L#', RequestedBy as 'Requestor', EnterBy, LineType, itemnum, Description, issuetype, quantity as 'OrderQTY'
		, receivedunit as 'UoM', UnitCost, LineCost, Status, PackingSlipNum, GLDebitAcct, RefWO, matrectransid as 'TransID'
		, tri_processedstatus as 'ProcStatus', tri_processeddate as 'Processed', transdate, remark
	from matrectrans where ponum = @PONUM and tri_processedstatus != 'SUCCESS' 
	order by tri_processeddate

	select top 200 SiteID as 'ServRec', ponum, porevisionnum as 'Rv', polinenum as 'L#', linetype, ItemNum, description, issuetype, quantity, unitcost, linecost, enterby, refwo ,status, gldebitacct, receiptref
		, tri_processedstatus as 'IntStatus', tri_processeddate, servrectransid, transdate, remark
	from servrectrans where ponum in (select distinct top 200 ponum from prline where prnum in (select distinct top 200 PRNUM from prline where ponum = @PONUM)) and tri_processedstatus != 'SUCCESS'  
	order by tri_processeddate  
end
else
begin 
	select top 400 PONum as 'MatRec', porevisionnum as 'Rv', polinenum as 'L#', RequestedBy as 'Requestor', EnterBy, LineType, ItemNum, Description, issuetype, quantity as 'OrderQTY'
		, receivedunit as 'UoM', UnitCost, LineCost, Status, PackingSlipNum, GLDebitAcct, RefWO, matrectransid as 'TransID'
		, tri_processedstatus as 'ProcStatus', tri_processeddate as 'Processed', transdate, remark
	from matrectrans where ponum = @PONUM  
	order by tri_processeddate 

	select top 200 SiteID as 'ServRec', ponum, porevisionnum as 'Rv', polinenum as 'L#', linetype, description, issuetype, ItemNum, quantity, unitcost, linecost, enterby, refwo ,status, gldebitacct, receiptref
		, tri_processedstatus as 'IntStatus', tri_processeddate, servrectransid, enterdate, remark
	from servrectrans where ponum in (select distinct top 200 ponum from prline where prnum in (select distinct top 200 PRNUM from prline where ponum = @PONUM))  
	order by tri_processeddate  

end

/*
Select top 1000 PONum as 'MatUseTrans', Description, refwo as 'WONum', quantity as 'Quantity', unitCost as 'Each', issueunit as 'UoM', LineCost, ActualDate, PONum, porevisionnum as'Rev', POLineNum as 'POL#', actualcost as 'Actual', qtyrequested as 'Requested', qtyreturned as 'Returned', CurBal from 
matusetrans where ponum = @PONUM  
order by itemnum, ponum, porevisionnum desc, polinenum
*/

