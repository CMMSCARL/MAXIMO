/* This should give the details for the PR# and the related records. */

declare @PRNUM varchar(25) ;  set @PRNUM = '108116';   --<<<---- Paste PR number here
set @PRNUM = ltrim(rtrim(@PRNUM));

declare @PONUM varchar(25) ;  set @PONUM = (select distinct top 1 ponum from prline where prnum = @PRNUM)
declare @VENDOR  integer = 1; /*  0 hides the Vendor Info and 1 shows Vendor info    */

select wo.wonum, wo.description, wo.status, wo.location, wo.assetnum, wo.status as 'WO', L.Status as 'Location', A.Status as 'Asset', wo.GLAccount
from workorder wo
	inner join locations l on wo.siteid = l.siteid and wo.location = l.location
	inner join Asset A on wo.siteid = a.siteid and wo.assetnum = a.assetnum
where wonum in (select top 1 refwo from prline where PRNUM = @PRNUM)

select wonum as 'WO Status', status, changedate, changeby, memo from wostatus where wonum in (select top 100 refwo from prline where prnum = @PRNUM)order by changedate desc offset 0 rows fetch next 8 rows only 

select pr.SiteID as 'PR', pr.PRNum as 'PR#', pr.status, pr.statusdate, pr.description, pr.requestedby as 'Requestor', pr.tri_requestedby as 'Tri_Req', pr.vendor, pr.shipto, pr.billto, pr.totalcost, pr.externalrefid as 'OFC REQ', pr.changeby, pr.changedate  	
from PR pr
where pr.prnum = @PRNUM

if @VENDOR = 1  begin   Select pr.SiteID as 'Vendor', pr.PrNum, pr.Description, c.Company as 'Code', c.name as 'Company Name', c.Address1 as 'Address', c.Address2 as 'City', c.Address3 as 'State', c.Address4 as 'Zip', c.Disabled as 'Disabled?' 
	, c.ExternalRefID as 'Vendor Info', c.ChangeDate, c.ChangeBy from pr pr left join companies c on pr.vendor = c.company where pr.prnum = @PRNUM end

select pr.SiteID as 'Attached', pr.PRNum as 'PR#', pr.description, REPLACE(df.urlname,'\\MAXDOCP01.Targa.com\D$\PRODDOCLINKS\DOCLINKS\', 'https://maximo.targaresources.com/' ) as 'Clickable'
from PR pr
	left join doclinks dl on pr.prid = dl.ownerid and dl.ownertable = 'PR' 
	left join docinfo df on dl.docinfoid = df.docinfoid and (df.description like '%.PDF' or df.description like '%.xlsx') --and (df.description like '%load%' or df.description like '%attribute%')
where pr.prnum = @PRNUM

select top 100 SiteID, PRNum, Status, ChangeBy, ChangeDate
from prstatus where prnum = @PRNUM order by changedate desc

select top 100 pr.PRNum as 'PR#', ld.ldtext as 'PR Interface Comments' from longdescription ld inner join pr on ld.ldkey = pr.prid where ld.ldownertable = 'PR' and ld.ldkey in (select prid from pr where prnum = @PRNUM)
select top 200 PRNum as 'PR#', status, StatusDate, description, requestedby as 'Requestor', tri_requestedby as 'Tri_Req', tri_createdfromwo as 'fromWO', IssueDate, vendor, totalcost, externalrefid as 'OFC REQ', ChangeBy, ChangeDate, tri_justification as 'Justification' from PR where prnum = @PRNUM 

select prl.PRNum as 'PRLine', prl.prlinenum as 'Line', prl.EnterBy, prl.RequestedBy as 'Tri_Req', prl.LineType, prl.Description, prl.conditioncode, prl.commodity, prl.storeloc, prl.orderqty as 'QTY'
	, prl.orderunit as 'UoM', prl.UnitCost, prl.LineCost, prl.LoadedCost, prl.receiptreqd as 'RcptReq', prl.ponum as 'PO#', prl.polinenum as 'POL##', prl.siteid, prl.Location, prl.AssetNum, prl.RefWO
	, prl.GLDebitAcct, wo.description, prl.ponum as 'OFC PO', prlineid , fc.projectid, fc.taskid, fc.disabled, fc.ischargeable, fc.enddate
from prline prl left join workorder wo on prl.refwo = wo.wonum and prl.siteid = wo.siteid
	left join fincntrl fc on prl.siteid = fc.siteid and prl.fincntrlid = fc.fincntrlid
where prl.prnum = @PRNUM order by prlinenum 

select pr.ShipTo, ad.Description, ad.address1, ad.address2, ad.address3, ad.address4 from pr inner join address ad on pr.shipto = ad.addresscode where PR.prnum = @PRNUM
