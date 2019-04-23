declare  @sdate  datetime
declare @edate  datetime
set @sdate='2019-03-15 00:00:00'--������
set @edate='2019-03-22 00:00:00'--������




--------------------------����24Сʱδȷ�ϻظ�--------------------begin---------
select 
	a.select1 as ҽԺ,
	a.ProblemID as ID,
	b.DateCreated ��ȷ��ʱ��,
	isnull(b.DateCreated,GETDATE()) �ѷ���ʱ��,
	c.DisplayName ת����,
	d.DisplayName �ӵ���,
	b.DateCreated ת��ʱ��,
	f.statename ת��״̬,
	g.DisplayName ��ǰ������,
	'�ظ���ʱ' as ��־,
	case when  (DATEDIFF(DAY,b.DateCreated,GETDATE())/7)>=1 
	then DATEDIFF(DAY,b.DateCreated,GETDATE())-(DATEDIFF(DAY,b.DateCreated,GETDATE())/7)*2
	when CONVERT(char(8),b.DateCreated,112)=CONVERT(char(8),@sdate,112)  then DATEDIFF(DAY,b.DateCreated,GETDATE())-2  
	else DATEDIFF(DAY,b.DateCreated,GETDATE()) end ��ʱ
from Pts_Problems a(nolock)
inner join Pts_Records b(nolock) on a.ProblemID=b.ProblemID 
inner join Accounts_Users c(nolock) on b.CreateUser=c.UserID
inner join Accounts_Users d(nolock) on b.AssignTo=d.UserID
inner join Accounts_Users g(nolock) on a.AssignedTo=g.UserID
inner join pts_problemstate e(nolock) on a.ProblemStateID=e.ProblemStateID
inner join pts_problemstate f(nolock) on b.StateID=f.ProblemStateID
where 
	b.RecordID = 
	(SELECT min(g.RecordID) FROM Pts_Records g(NOLOCK), Pts_ProblemState h(nolock)  
	WHERE g.StateID=h.ProblemStateID AND h.StateName in ('����ȷ��','��ȷ��') and a.ProblemID=g.ProblemID)
	and d.DeptID='22' 
	and b.DateCreated>@sdate
	and f.statename=e.statename  ---ת��״̬�뵱ǰ��״̬һ�£�˵��δ����
	--and DATEDIFF(hour,b.DateCreated,GETDATE())>48
	and DATEDIFF(DAY,b.DateCreated,GETDATE())>1
	and a.ProjectID in ('32','33','45','56','52')
	and g.DeptID='22'
union all
select
	a.select1 as ҽԺ,
	a.ProblemID as ID,
	bb.DateCreated ��ȷ��ʱ��,
	isnull(b.DateCreated,GETDATE()) �ѷ���ʱ��,
	c.DisplayName ת����,
	d.DisplayName �ӵ���,
	b.DateCreated ת��ʱ��,
	f.statename ת��״̬,
	g.DisplayName ��ǰ������,
	'�ظ���ʱ' as ��־,
	case when  (DATEDIFF(DAY,b.DateCreated,GETDATE())/7)>=1 
	then DATEDIFF(DAY,b.DateCreated,GETDATE())-(DATEDIFF(DAY,b.DateCreated,GETDATE())/7)*2
	when CONVERT(char(8),b.DateCreated,112)=CONVERT(char(8),@sdate,112) then DATEDIFF(DAY,b.DateCreated,GETDATE())-2  
	else DATEDIFF(DAY,b.DateCreated,GETDATE()) end ��ʱ
from Pts_Problems a(nolock)
left join Pts_Records b(nolock) on a.ProblemID=b.ProblemID 
                   and b.RecordID = 
	(SELECT min(g.RecordID) FROM Pts_Records g(NOLOCK), Pts_ProblemState h(nolock)  
	WHERE g.StateID=h.ProblemStateID AND h.StateName in ('�ѷ���') and a.ProblemID=g.ProblemID)
inner join Pts_Records bb(nolock) on a.ProblemID=bb.ProblemID 
inner join Accounts_Users c(nolock) on bb.CreateUser=c.UserID
inner join Accounts_Users d(nolock) on bb.AssignTo=d.UserID
inner join Accounts_Users g(nolock) on a.AssignedTo=g.UserID
inner join pts_problemstate e(nolock) on a.ProblemStateID=e.ProblemStateID
inner join pts_problemstate f(nolock) on bb.StateID=f.ProblemStateID
where 	 bb.DateCreated>@sdate --ʱ�����
	and	bb.RecordID = 
	(SELECT max(g.RecordID) FROM Pts_Records g(NOLOCK), Pts_ProblemState h(nolock)  
	WHERE g.StateID=h.ProblemStateID AND h.StateName in ('��ȷ��') and a.ProblemID=g.ProblemID
	             )      
	and (d.DeptID='22' or d.UserID in ('5','283')) -- ����ɽ\���
	and (DATEDIFF(DAY,bb.DateCreated,isnull(b.DateCreated,GETDATE()))>1 
	       or (b.Title not like '%2016-%'and b.Title not like '%2017-%')  ) --δ����ȡ��ǰʱ��Ա�
	and a.ProjectID in ('32','33','45','56','52')
	and g.DeptID='22'
	
--------------------------����24Сʱδ����ظ�--------------------end---------


------------------------��ʱ ͳ��-------------begin----------------------
--�����
SELECT * INTO #temp_Records
FROM Pts_Records a(nolock) 
WHERE a.DateCreated = (
	SELECT min(b.DateCreated) FROM Pts_Records b(NOLOCK), Pts_ProblemState c(nolock)  
	WHERE c.ProblemStateID=b.StateID AND c.StateName='����ɴ�����' and a.ProblemID=b.ProblemID ) 
and a.DateCreated >=@sdate  AND a.DateCreated<@edate
--δ���
SELECT * INTO #temp_Problems
FROM Pts_Problems a(nolock) 
WHERE a.ProblemID NOT in (
	SELECT b.ProblemID FROM Pts_Records b(NOLOCK), Pts_ProblemState c(nolock)  
	WHERE c.ProblemStateID=b.StateID AND c.StateName='����ɴ�����' GROUP BY b.ProblemID ) --δ���
AND a.ProblemStateID NOT IN (
	SELECT c.ProblemStateID FROM Pts_ProblemState c(NOLOCK) WHERE c.StateName LIKE '%�ر�%')  --�ǹر�
AND a.ProblemID in (
	SELECT b.ProblemID FROM Pts_Records b(NOLOCK), Pts_ProblemState c(nolock)  
	WHERE c.ProblemStateID=b.StateID AND c.StateName='�ѷ���' GROUP BY b.ProblemID )  --�ѷ���
and  a.ProjectID IN ('32','33','45','56','52')

select 
f.DeptName as ת�������ڲ���,
a.ProblemID as ID,
c.DisplayName as ת����,
d.name AS ��Ŀ����, 
a.select1 as ҽԺ,
'��ɳ�ʱ' as ���,
e.DateCreated as ����ʱ��,
(CONVERT(VARCHAR(10),a.Deadline,121)+ ' 23:59:59') ����,
DATEDIFF(DAY,CONVERT(VARCHAR(10),a.Deadline,121),e.DateCreated) ��ʱ
  from Pts_Problems a 
  inner join Pts_Projects d on a.ProjectID=d.ProjectID
  inner join #temp_Records e on a.ProblemID=e.ProblemID
  inner join Accounts_Users  c on e.CreateUser=c.UserID
  inner join Accounts_Department f on c.DeptID=f.DeptID
  inner join Accounts_Users h on e.AssignTo=h.UserID
  inner join Accounts_Department g on h.DeptID=g.DeptID
  inner join Pts_ProblemState t on e.StateID=t.ProblemStateID
where  
 d.ProjectID IN ('32','33','45','56','52')
 AND c.DisplayName<>h.DisplayName
 AND DATEDIFF(DAY,CONVERT(VARCHAR(10),a.Deadline,121),e.DateCreated)>0
 AND e.DateCreated >=@sdate  AND e.DateCreated<@edate
UNION ALL
select 
'' as ת�������ڲ���,
a.ProblemID as ID,
'' as ת����,
d.name AS ��Ŀ����, 
a.select1 as ҽԺ,
'��ɳ�ʱ' as ���,
'' as ����ʱ��,
(CONVERT(VARCHAR(10),a.Deadline,121)+ ' 23:59:59') ����,
DATEDIFF(DAY,(CONVERT(VARCHAR(10),a.Deadline,121)),GETDATE()) ��ʱ
  from #temp_Problems a 
  inner join Pts_Projects d on  a.ProjectID=d.ProjectID
  inner join Pts_ProblemState t on a.ProblemStateID=t.ProblemStateID
  inner join Accounts_Users c on a.AssignedTo=c.UserID 
  and (c.DeptID='22' or c.UserID in ('5','283')) -- ����ɽ\���
where   
 DATEDIFF(DAY,GETDATE(),(CONVERT(VARCHAR(10),a.Deadline,121)))<0
 AND a.Deadline<@edate


DROP TABLE #temp_Records;
DROP TABLE #temp_Problems;