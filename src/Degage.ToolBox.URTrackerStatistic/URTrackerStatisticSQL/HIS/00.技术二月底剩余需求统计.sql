


----------------�µ׼�����������ͳ��-------------begin--------------------------------
------ת��
select  
a.ProblemID as ID,
h.DisplayName
into #in
from Pts_Problems a 
inner join Pts_Records e on a.ProblemID=e.ProblemID and e.IsKeyRecord=1
inner join Accounts_Users  c on e.CreateUser=c.UserID  --ת����
inner join Accounts_Department f on c.DeptID=f.DeptID
inner join Accounts_Users h on e.AssignTo=h.UserID  --�ӵ���
inner join pts_problemstate i on e.StateID=i.ProblemStateID --���� 
inner join Accounts_Department g on h.DeptID=g.DeptID
inner join pts_problemstate j on a.ProblemStateID=j.ProblemStateID and j.StateName not like '%�ر�%'
inner join Pts_Projects d on a.ProjectID=d.ProjectID 
where 	e.RecordID = 
	(SELECT max(k.RecordID) FROM Pts_Records k(NOLOCK) 
	inner join Pts_ProblemState h(nolock) on k.StateID=h.ProblemStateID  
	inner join Accounts_Users i(nolock) on k.CreateUser=i.UserID
	WHERE
    a.ProblemID=k.ProblemID 
	AND h.StateName in ('��ȷ��','����ȷ��','��ȷ������','����','�ѷ���') 
	)      
 --c.DisplayName<>h.DisplayName
 AND (g.DeptID=2 or h.DisplayName='������' ) --ת�뼼��
--AND e.DateCreated  >='2018-02-26 00:00:00' ----�µ�ǰ����
AND e.DateCreated  >=cast(convert(varchar(7), getdate(), 121) + '-01' as datetime)-3 ----�µ�ǰ����
ORDER BY a.ProblemID;

------ת��
select  
a.ProblemID as ID
into #out
from Pts_Problems a 
inner join Pts_Records e on a.ProblemID=e.ProblemID and e.IsKeyRecord=1
inner join Accounts_Users  c on e.CreateUser=c.UserID  --ת����
inner join Accounts_Department f on c.DeptID=f.DeptID
inner join Accounts_Users h on e.AssignTo=h.UserID  --�ӵ���
inner join Accounts_Department g on h.DeptID=g.DeptID
inner join pts_problemstate j on a.ProblemStateID=j.ProblemStateID and j.StateName not like '%�ر�%'
inner join Pts_Projects d on a.ProjectID=d.ProjectID
where  
 c.DisplayName<>h.DisplayName
 AND (f.DeptID=2 or c.DisplayName='������')  --����ת��
--AND e.DateCreated  >='2018-03-01 00:00:00'  
AND e.DateCreated  >=cast(convert(varchar(7), getdate(), 121) + '-01' as datetime)
and not exists (Select top 1 1 from #in i where a.ProblemID=i.ID )---�ų���ʱ���ת���
ORDER BY a.ProblemID;

-------��ǰ
select distinct
a.ProblemID as ID
into #now
from Pts_Problems a 
inner join 	pts_problemstate j on  a.ProblemStateID=j.ProblemStateID
inner join 	Pts_Records e on a.ProblemID=e.ProblemID  and e.IsKeyRecord=1
inner join 	pts_problemstate b on e.StateID=b.ProblemStateID
inner join 	Accounts_Users  c on a.AssignedTo=c.UserID and (c.DeptID='2' or c.DisplayName='������')
inner join 	Accounts_Department f on  c.DeptID=f.DeptID
where  a.ProjectID in ('38','39','55','44','19','41','49')
and j.StateName not like '%�ر�%'
and not exists (Select top 1 1 from #in i where a.ProblemID=i.ID )---�ų�ת��

select * into #Pts_Problems from Pts_Problems where ProblemID in (
select * from #out 
union all
select * from #now 
)

select
	h.DisplayName ��ǰ������,
	COUNT(*)
from #Pts_Problems a(nolock)
inner join Accounts_Users h(nolock) on a.AssignedTo=h.UserID
inner join pts_problemstate e(nolock) on a.ProblemStateID=e.ProblemStateID
inner join pts_problemstate f(nolock) on a.ProblemStateID=f.ProblemStateID
group by h.DisplayName

select
   a.Deadline �ƻ����ʱ��,
	a.ProblemID as ����,
	h.DisplayName ��ǰ������,
	e.statename ��ǰ״̬,
	f.statename ת��״̬,
	a.Title AS ����,
	a.BigText1 AS ����
from #Pts_Problems a(nolock)
inner join Accounts_Users h(nolock) on a.AssignedTo=h.UserID
inner join pts_problemstate e(nolock) on a.ProblemStateID=e.ProblemStateID
inner join pts_problemstate f(nolock) on a.ProblemStateID=f.ProblemStateID


drop table #in
drop table #out
drop table #now
drop table #Pts_Problems

----------------�µ׼�����������ͳ��----------------end-----------------------------------  
 
 
--select * from pts_problems where AssignedTo='215'
 


