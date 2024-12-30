/* This query will load the number of users for a given UI and calculate the % load for each server, and the load % where 50 users = 100% or Max load on a JVM server.  */

declare @SESSIONS int = 0;
declare @UCOUNT float = (select count(userid) as 'Total' from maxsession);

select ServerName, count(userid) as 'Users'
	, concat(round((cast(count(userid) as float) / @UCOUNT)*100,1),'%') as '% of Balancer' 
	, concat(round((cast(count(userid) as float) / 50.0)*100,1),'%') as 'Server Load (50)'
	, (SELECT CONVERT(datetime, GETDATE())) AS 'TIME' 
	from maxsession 
	group by servername 
union
	select 'Total', (@UCOUNT) as 'Total Users', '', '', getdate()
order by servername

Select top 100 ServerName, Active, AdminMode from SERVERSESSION order by ServerName

if @SESSIONS = 1 begin
select UserID as 'Sessions', DisplayName, ClientAddr, format(logindatetime, 'MM/dd HH:mm', 'en-US') as 'Login Time' , format(lastactivity, 'MM/dd HH:mm', 'en-US') as 'LastAccessed', ServerName, clientaddr
from MAXSESSION 
where userid = '%%'
order by LastAccessed 
end
