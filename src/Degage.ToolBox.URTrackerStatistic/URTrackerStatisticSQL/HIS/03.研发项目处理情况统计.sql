
------------------------����Ϊ"�з���Ŀ�������ͳ��"��----------


-----------------------------�������---------------begin-------------------
select
	a.ProblemID as ID,
	--bb.RecordID as RecordID,
	c.DisplayName ת����,
	d.DisplayName �ӵ���,
	b.DateCreated ת��ʱ��,
	isnull(g.TypeName,'����') ����,
	a.Float1 ������H,
	f.statename ת��״̬,
	e.statename Ŀǰ״̬,
	b.Title ת������,
	b.content AS ת������,
	a.Title AS ����,
	a.BigText1 AS ����		
from Pts_Problems a(nolock)
inner join Pts_Records b(nolock) on a.ProblemID=b.ProblemID  --and b.IsKeyRecord='1'  ---�ų����۵ļ�¼
inner join Accounts_Users c(nolock) on b.CreateUser=c.UserID --ת����
inner join Accounts_Users d(nolock) on b.AssignTo=d.UserID --and d.DeptID='1'  --ת����Ŀ�������� 
inner join pts_problemstate f(nolock) on b.StateID=f.ProblemStateID
left join Pts_ProblemType g(nolock) on a.ProblemTypeID=g.ProblemTypeID --����
inner join pts_problemstate e(nolock) on a.ProblemStateID=e.ProblemStateID
where  b.RecordID = 
	(SELECT min(g.RecordID) FROM Pts_Records g(NOLOCK) 
	inner join Pts_ProblemState h(nolock) on g.StateID=h.ProblemStateID  
	inner join Accounts_Users i(nolock) on g.CreateUser=i.UserID 
	WHERE a.ProblemID=g.ProblemID
	and h.StateName in ('����ɴ�����') 
	and i.DeptID in ('5','24','25')  ---�з�ת�� 
	)
	and a.ProjectID in ('47','48','49','50','53','57')
	and b.DateCreated >='2019-02-22 00:00:00'  AND b.DateCreated<'2019-03-01 00:00:00'
   order by a.ProblemID
   
-----------------------------�������--------------end-------------------
   


----------------��ֹ�����ģ�����ʣ�൥-------------begin--------------------------------

------ת��
select  
a.ProblemID as ID,
a.ProblemTypeID as TypeID,
c.DisplayName name,
f.DeptName dept
into #in
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
 AND g.DeptID in ('5','24','25')  --ת���з�
AND e.DateCreated  >='2019-03-01 00:00:00'
ORDER BY a.ProblemID;

------ת��
select  
a.ProblemID as ID,
a.ProblemTypeID as TypeID,
c.DisplayName name,
f.DeptName dept
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
 AND f.DeptID in ('5','24','25')  --�з�ת��
AND e.DateCreated  >='2019-03-01 00:00:00'
and not exists (Select top 1 1 from #in i where a.ProblemID=i.ID )---�ų���ʱ���ת���
ORDER BY a.ProblemID;

-------��ǰ
select distinct
a.ProblemID as ID,
a.ProblemTypeID as TypeID,
c.DisplayName name,
--b.statename ת��״̬,
f.DeptName dept
into #now
from Pts_Problems a 
inner join 	pts_problemstate j on  a.ProblemStateID=j.ProblemStateID
inner join 	Pts_Records e on a.ProblemID=e.ProblemID  and e.IsKeyRecord=1
inner join 	pts_problemstate b on e.StateID=b.ProblemStateID
inner join 	Accounts_Users  c on a.AssignedTo=c.UserID and c.DeptID in ('5','24','25')
inner join 	Accounts_Department f on  c.DeptID=f.DeptID
where  a.ProjectID in ('47','48','49','50','53','57')
and j.StateName not like '%�ر�%'
and not exists (Select top 1 1 from #in i where a.ProblemID=i.ID )---�ų�ת��

select name ��ǰ������,count(id) ������ from
(
select * from #out WHERE isnull(TypeID,'0') 
in ( '0','127','136','138','139','141','142','144','146','147','149','151','152','164','166','167','179') --����
union all
select * from #now WHERE isnull(TypeID,'0') 
in ( '0','127','136','138','139','141','142','144','146','147','149','151','152','164','166','167','179') --����
)a  group by name

select name ��ǰ������,count(id) ȱ�ݵ��� from
(
select * from #out WHERE TypeID in ( '135','137','140','143','145','148','150','163','165','178') --ȱ��
union all
select * from #now WHERE TypeID in ( '135','137','140','143','145','148','150','163','165','178') --ȱ��
)a  group by name



drop table #in
drop table #out
drop table #now


----------------��ֹ�����ģ�����ʣ�൥-----------end-----------------------------------  

--------------------------����24Сʱδȷ�ϻظ�--------------------begin---------
select 
    'ȷ��' as ��־,
    DATEDIFF(DAY,b.DateCreated,GETDATE())  ��ʱ,
    b.DateCreated ��ȷ��ʱ��,
   isnull(b.DateCreated,GETDATE()) �ѷ���ʱ��,
	a.ProblemID as ID,
	b.RecordID as RecordID,
	c.DisplayName ת����,
	d.DisplayName �ӵ���,
	b.DateCreated ת��ʱ��,
	f.statename ת��״̬,
	g.DisplayName ��ǰ������,
	e.statename ��ǰ״̬,
	b.Title ת������,
	b.content AS ת������,
	a.Title AS ����,
	a.BigText1 AS ����
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
	and d.DeptID in ('5','24','25') 
	and b.DateCreated>'2019-02-22 00:00:00'  
	and f.statename=e.statename  ---ת��״̬�뵱ǰ��״̬һ�£�˵��δ����
	--and DATEDIFF(hour,b.DateCreated,GETDATE())>48
	and DATEDIFF(DAY,b.DateCreated,GETDATE())>1
	and a.ProjectID in ('47','48','49','50','53','57')
	and g.DeptID in ('5','24','25')
union all
select
   '����' as ��־,
   DATEDIFF(DAY,bb.DateCreated,isnull(b.DateCreated,GETDATE())) ��ʱ,
   bb.DateCreated ��ȷ��ʱ��,
   isnull(b.DateCreated,GETDATE()) �ѷ���ʱ��,
	a.ProblemID as ID,
	b.RecordID as RecordID,
	c.DisplayName ת����,
	d.DisplayName �ӵ���,
	b.DateCreated ת��ʱ��,
	f.statename ת��״̬,
	g.DisplayName ��ǰ������,
	e.statename ��ǰ״̬,
	b.Title ת������,
	b.content AS ת������,
	a.Title AS ����,
	a.BigText1 AS ����
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
where 	 bb.DateCreated>'2019-02-22 00:00:00'  --ʱ�����
	and	bb.RecordID = 
	(SELECT max(g.RecordID) FROM Pts_Records g(NOLOCK), Pts_ProblemState h(nolock)  
	WHERE g.StateID=h.ProblemStateID AND h.StateName in ('��ȷ��') and a.ProblemID=g.ProblemID
	             )      
	and d.DeptID in ('5','24','25') 
	and (DATEDIFF(DAY,bb.DateCreated,isnull(b.DateCreated,GETDATE()))>1 or b.Title not like '%2018-%') --δ����ȡ��ǰʱ��Ա�
	and a.ProjectID in ('47','48','49','50','53','57')
	and g.DeptID in ('5','24','25')
	
--------------------------����24Сʱδ����ظ�--------------------end---------


------------------------��ʱ ͳ��-------------begin----------------------
--�����
SELECT * INTO #temp_Records
FROM Pts_Records a(nolock) 
WHERE a.DateCreated = (
	SELECT min(b.DateCreated) FROM Pts_Records b(NOLOCK), Pts_ProblemState c(nolock)  
	WHERE c.ProblemStateID=b.StateID AND c.StateName='����ɴ�����' and a.ProblemID=b.ProblemID ) 
and a.DateCreated >='2019-02-22 00:00:00' AND a.DateCreated<'2019-03-01 00:00:00'
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
and  a.ProjectID IN ('47','48','49','50','53','57')

select DATEDIFF(DAY,CONVERT(VARCHAR(10),a.Deadline,121),e.DateCreated) ��ʱ, 
d.name AS ��Ŀ����, 
a.ProblemID as ID,
a.CreateTime AS �ᵥʱ��, 
e.DateCreated as ����ʱ��,
(CONVERT(VARCHAR(10),a.Deadline,121)+ ' 23:59:59') ����,
c.DisplayName as ת����,
f.DeptName as ת�������ڲ���,
h.DisplayName as �ӵ���,
g.DeptName as �ӵ������ڲ���,
a.Title AS ����,
e.Title as ��¼����,
e.content as ��¼����,
t.StateName AS ״̬
  from Pts_Problems a 
  inner join Pts_Projects d on a.ProjectID=d.ProjectID
  inner join #temp_Records e on a.ProblemID=e.ProblemID
  inner join Accounts_Users  c on e.CreateUser=c.UserID
  inner join Accounts_Department f on c.DeptID=f.DeptID
  inner join Accounts_Users h on e.AssignTo=h.UserID
  inner join Accounts_Department g on h.DeptID=g.DeptID
  inner join Pts_ProblemState t on e.StateID=t.ProblemStateID
where  
 d.ProjectID IN ('47','48','49','50','53','57')
 AND c.DisplayName<>h.DisplayName
 AND DATEDIFF(DAY,CONVERT(VARCHAR(10),a.Deadline,121),e.DateCreated)>0
 AND e.DateCreated >='2019-02-22 00:00:00' AND e.DateCreated<'2019-03-01 00:00:00'
UNION ALL
select DATEDIFF(DAY,(CONVERT(VARCHAR(10),a.Deadline,121)),GETDATE()) ��ʱ,
d.name AS ��Ŀ����, 
a.ProblemID as ID,
a.CreateTime AS �ᵥʱ��, 
'' as ����ʱ��,
(CONVERT(VARCHAR(10),a.Deadline,121)+ ' 23:59:59') ����,
'' as ת����,
'' as ת�������ڲ���,
c.DisplayName as �ӵ���,
'' as �ӵ������ڲ���,
a.Title AS ����,
'' as ��¼����,
'' as ��¼����,
t.StateName AS ״̬
  from #temp_Problems a 
  inner join Pts_Projects d on  a.ProjectID=d.ProjectID
  inner join Pts_ProblemState t on a.ProblemStateID=t.ProblemStateID
  inner join Accounts_Users c on a.AssignedTo=c.UserID and c.DeptID='5'
where   
 DATEDIFF(DAY,GETDATE(),(CONVERT(VARCHAR(10),a.Deadline,121)))<0
 AND a.Deadline<'2019-03-01 00:00:00'


DROP TABLE #temp_Records;
DROP TABLE #temp_Problems;
----------------------��ʱ ͳ��---------------end---------------------




 
---------------------------------��ȷ��ͳ��-------------------------------------------------
select f.Name AS ��Ŀ����,a.ProblemID as ID,a.CreateTime AS �ᵥʱ��,e.DateCreated as ����ʱ��,
h.DisplayName as ת����,g.StateName as ת��״̬,c.DisplayName as �ӵ���,d.TypeName ����,
a.Title AS ����,e.Title as ��¼����,e.content as ��¼����,isnull(a.Text6,a.Text5) as BUG��ԴID,a.BigText2 as BUG��Դ����,
b.StateName AS ״̬ from pts_problems a 
inner join Pts_ProblemState b on a.ProblemStateID=b.ProblemStateID --��ǰ״̬
inner join Pts_Records e on a.ProblemID=e.ProblemID --ת����¼
inner join Accounts_Users c on e.AssignTo=c.UserID --�ӵ���
inner join Accounts_Users h on e.CreateUser=h.UserID --ת����
inner join Pts_ProblemType d on a.ProblemTypeID=d.ProblemTypeID --����
inner join Pts_Projects f on a.ProjectID=f.ProjectID --��Ŀ
inner join Pts_ProblemState g on e.StateID=g.ProblemStateID --ת��״̬
where  
e.StateID IN (SELECT f.ProblemStateID FROM Pts_ProblemState f (nolock) WHERE f.StateName='��ȷ��')
and e.DateCreated >= '2019-02-22 00:00:00' AND e.DateCreated <'2019-03-01 00:00:00'
and a.ProjectID in ('47','48','49','50','53','57')
and c.DeptID in ('5','24','25') 



-------------------------------������ ͳ��--------------------------------------
select d.name AS ��Ŀ����, 
a.ProblemID as ID,
a.CreateTime AS �ᵥʱ��, 
e.DateCreated as ����ʱ��,
c.DisplayName as ת����,
f.DeptName as ת�������ڲ���,
h.DisplayName as �ӵ���,
g.DeptName as �ӵ������ڲ���,
a.Title AS ����,
e.title ת������ ,
e.content ת������,
j.statename ״̬
  from Pts_Problems a 
  inner join Pts_Projects d on a.ProjectID=d.ProjectID
  inner join Pts_Records e on a.ProblemID=e.ProblemID
  inner join Accounts_Users  c on e.CreateUser=c.UserID
  inner join Accounts_Department f on c.DeptID=f.DeptID and f.DeptID  in ('5','24','25') 
  inner join Accounts_Users h on e.AssignTo=h.UserID
  inner join Accounts_Department g on h.DeptID=g.DeptID
  inner join pts_problemstate j on e.StateID=j.ProblemStateID AND j.StateName='������'
where 
a.ProjectID IN ('47','48','49','50','53','57')
and c.DisplayName<>h.DisplayName
AND e.DateCreated >= '2019-02-22 00:00:00' AND e.DateCreated <'2019-03-01 00:00:00'
ORDER BY a.ProblemID;


-----------------------------�ѱ�� ͳ��-------------------------------------------------

select d.name AS ��Ŀ����, 
a.ProblemID as ID,
a.CreateTime AS �ᵥʱ��, 
e.DateCreated as ����ʱ��,
c.DisplayName as ת����,
f.DeptName as ת�������ڲ���,
h.DisplayName as �ӵ���,
g.DeptName as �ӵ������ڲ���,
a.Title AS ����,
e.title ת������ ,
e.content ת������,
j.statename ״̬
  from Pts_Problems a 
  inner join Pts_Projects d on a.ProjectID=d.ProjectID
  inner join Pts_Records e on  a.ProblemID=e.ProblemID
  inner join Accounts_Users  c on e.CreateUser=c.UserID
  inner join Accounts_Department f on c.DeptID=f.DeptID
  inner join Accounts_Users h on e.AssignTo=h.UserID
  inner join Accounts_Department g on h.DeptID=g.DeptID and g.DeptID in ('5','24','25') 
  inner join pts_problemstate j on e.StateID=j.ProblemStateID AND j.StateName='�ѱ��'
where  
   a.ProjectID IN ('47','48','49','50','53','57')
AND c.DisplayName<>h.DisplayName
AND e.DateCreated>='2019-02-22 00:00:00' AND e.DateCreated<'2019-03-01 00:00:00'
ORDER BY a.ProblemID;



