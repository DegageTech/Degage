 ------------------------����Ϊ"����֧�ִ������ͳ��"��--------------------
----------����URT������ʱ��----------------------------begin--------------------------------
---��ȡ�ѷ��䵥�ĵ��ź�ժҪ���ƻ����ʱ�䣩--
SELECT a.ProblemID,a.Title,a.DateCreated
INTO #temp_Records
FROM Pts_Records a(nolock)
inner join Pts_Problems d(nolock)  on a.ProblemID = d.ProblemID
WHERE a.DateCreated = (SELECT max(b.DateCreated)  ---ȡ���ʱ�䣬�����ѱ����
						FROM Pts_Records b(NOLOCK), 
						Pts_ProblemState c(nolock)  
						WHERE c.ProblemStateID=b.StateID 
						AND c.StateName='�ѷ���' 
						and a.ProblemID=b.ProblemID
						AND ISDATE(b.Title)=1 -- ���ڸ�ʽ
						 )
AND a.StateID in ('427','249','260','443','303','332','346','366','376','396','412','458') ---�ֱ��Ӧ�ġ��ѷ���״̬��
and d.ProjectID in ('19','38','39','41','44','47','48','50','51','53','55','57')
AND a.Title<>'----����ת��----'
and not exists 
(select top 1 1 from Pts_Records a where a.StateID in ('434','268','471','311','420','466') and a.ProblemID=d.ProblemID)  ---268ͬ����,�ų��ѱ��
and a.DateCreated >= convert(char(10),GETDATE()-1,120)

select a.ProblemID,
case when ISNUMERIC(LEFT(c.Title,1))=1 then CONVERT(varchar(10),LEFT(c.Title,10),21)
when ISNUMERIC(right(c.Title,1))=1 then CONVERT(varchar(10),RIGHT(c.Title,10),21)
ELSE null END  [endtime]
into #Pts_Problems
from Pts_Problems a(nolock)
inner join Pts_ProblemState b(nolock) on a.ProblemStateID = b.ProblemStateID and a.ProjectID = b.ProjectID
inner join #temp_Records c(nolock) on a.ProblemID = c.ProblemID 
where a.ProjectID in ('19','38','39','41','44','47','48','50','51','53','55','57')
AND c.Title<>'----����ת��----'

update pp set pp.Deadline = pp1.endtime  from Pts_Problems pp 
inner join #Pts_Problems pp1 on pp.ProblemID=pp1.ProblemID 
where  
convert(varchar(10),pp.Deadline,120) <> pp1.endtime
AND ISDATE(pp1.endtime)=1  --������ı�����ת��Ϊ����
AND CASE WHEN ISDATE(pp1.endtime)=1 THEN CAST(pp1.endtime AS DATETIME) ELSE GETDATE()-1 END >= convert(char(10),GETDATE(),120)--�ų��ƻ�ʱ��С�ڵ�ǰʱ���

drop table #Pts_Problems
drop table #temp_Records

-----------����URT������ʱ��-------------------------------end---------------------------------------


-----------------------------�������---------------begin-------------------
select
case when (c.DisplayName in ('�����','�ƹ���','��ӵǿ','����ְ','�����','л��÷','����')) then '��������EMR' else '��������HIS' end ����,
	a.ProblemID as ID,
	--bb.RecordID as RecordID,
	c.DisplayName ת����,
	d.DisplayName �ӵ���,
	b.DateCreated ת��ʱ��,
	g.TypeName ����,
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
inner join Accounts_Users d(nolock) on b.AssignTo=d.UserID and d.DeptID='1'  --ת����Ŀ�������� 
inner join pts_problemstate f(nolock) on b.StateID=f.ProblemStateID
inner join Pts_ProblemType g(nolock) on a.ProblemTypeID=g.ProblemTypeID --����
inner join pts_problemstate e(nolock) on a.ProblemStateID=e.ProblemStateID
where  b.RecordID = 
	(SELECT min(g.RecordID) FROM Pts_Records g(NOLOCK) 
	inner join Pts_ProblemState h(nolock) on g.StateID=h.ProblemStateID  
	inner join Accounts_Users i(nolock) on g.CreateUser=i.UserID 
	WHERE a.ProblemID=g.ProblemID
	and h.StateName in ('����ɴ�����','�������') 
	and (i.DeptID in ('2','25') or (i.DeptID in ('12') and DisplayName='������' ))  ---������ת��,���з�������ѩ�Ĵ���ĵ��Ӳ�������
	)
	and a.ProjectID in ('38','39','55','44','19','41','49','57')
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
 AND (g.DeptID=2     or (g.DeptID='12' and h.DisplayName='������')) --ת�뼼��
AND e.DateCreated  >='2019-02-22 00:00:00'
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
 AND (f.DeptID=2  or (f.DeptID=12 and c.DisplayName='������'))  --����ת��
AND e.DateCreated  >='2019-02-22 00:00:00'
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
inner join 	Accounts_Users  c on a.AssignedTo=c.UserID and   (c.DeptID='2' or (c.DeptID='12' and C.DisplayName='������'))
inner join 	Accounts_Department f on  c.DeptID=f.DeptID
where  a.ProjectID in ('38','39','55','44','19','41','49','57')
and j.StateName not like '%�ر�%'
and not exists (Select top 1 1 from #in i where a.ProblemID=i.ID )---�ų�ת��

select 
case when (name in ('�����','�ƹ���','��ӵǿ','����ְ','�����','л��÷','����')) then '��������EMR' else '��������HIS' end ����,
name ��ǰ������,count(id) ������ from
(
select * from #out WHERE TypeID in ('107','109','172','127','53','117','144') --����
union all
select * from #now WHERE TypeID in ('107','109','172','127','53','117','144') --����
)a  group by name

select 
case when (name in ('�����','�ƹ���','��ӵǿ','����ְ','�����','л��÷','����')) then '��������EMR' else '��������HIS' end ����,
name ��ǰ������,count(id) ȱ�ݵ��� from
(
select * from #out WHERE TypeID in ('106','108','171','126','52','116','143') --ȱ��
union all
select * from #now WHERE TypeID in ('106','108','171','126','52','116','143') --ȱ��
)a  group by name

drop table #in
drop table #out
drop table #now


----------------��ֹ�����ģ�����ʣ�൥-----------end-----------------------------------  


--------------------------����24Сʱδȷ�ϻظ�(����1)--------------------begin---------
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
	and (d.DeptID='2'  or (d.DeptID='12' and d.DisplayName='������'))
	and b.DateCreated>'2019-02-22 00:00:00'  
	and f.statename=e.statename  ---ת��״̬�뵱ǰ��״̬һ�£�˵��δ����
	--and DATEDIFF(hour,b.DateCreated,GETDATE())>48
	and DATEDIFF(DAY,b.DateCreated,GETDATE())>1
	and a.ProjectID in ('38','39','55','44','19','41','49','57')
	and (g.DeptID='2'or (g.DeptID='12' and g.DisplayName='������'))
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
	and (d.DeptID='2' or (d.DeptID='12' and d.DisplayName='������'))
	and (DATEDIFF(DAY,bb.DateCreated,isnull(b.DateCreated,GETDATE()))>1 or (b.Title not like '%2016-%' and b.Title not like '%2017-%')) --δ����ȡ��ǰʱ��Ա�
	and a.ProjectID in ('38','39','55','44','19','41','49','57')
	and (g.DeptID='2' or (g.DeptID='12' and d.DisplayName='������'))
	and DATEDIFF(DAY,bb.DateCreated,isnull(b.DateCreated,GETDATE()))<>0
--------------------------����24Сʱδ����ظ�--------------------end---------


------------------------��ʱ ͳ��(����2)-------------begin----------------------
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
and  a.ProjectID IN ('38','39','55','44','19','41','49','57')

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
 d.ProjectID IN ('38','39','55','44','19','41','49','57')
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
  inner join Accounts_Users c on a.AssignedTo=c.UserID --and c.DeptID='2'
where   
 DATEDIFF(DAY,GETDATE(),(CONVERT(VARCHAR(10),a.Deadline,121)))<0
 AND a.Deadline<'2019-03-01 00:00:00'
 and t.StateName not in ('����ȷ��','�������')


DROP TABLE #temp_Records;
DROP TABLE #temp_Problems;
----------------------��ʱ ͳ��---------------end---------------------


---------------------------------��ȷ�� ͳ��-------------------------------------------------
select f.Name AS ��Ŀ����,a.ProblemID as ID,a.CreateTime AS �ᵥʱ��,e.DateCreated as ����ʱ��,
h.DisplayName as ת����,g.StateName as ת��״̬,c.DisplayName as �ӵ���,d.TypeName ����,
a.Title AS ����,e.Title as ��¼����,e.content as ��¼����,b.StateName AS ״̬ 
from pts_problems a 
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
and a.ProjectID in ('38','39','55','41','49','19','44') 
and (c.DeptID='2' or (c.DeptID='12' and c.DisplayName='������'))


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
  inner join Accounts_Department f on c.DeptID=f.DeptID and (f.DeptID='2' or (f.DeptID='12' and c.DisplayName='������'))
  inner join Accounts_Users h on e.AssignTo=h.UserID
  inner join Accounts_Department g on h.DeptID=g.DeptID
  inner join pts_problemstate j on e.StateID=j.ProblemStateID AND j.StateName='������'
where 
a.ProjectID IN ('38','39','55','44','19','41','49','57')
and c.DisplayName<>h.DisplayName
AND e.DateCreated >= '2019-02-22 00:00:00' AND e.DateCreated <'2019-03-01 00:00:00'
--20171218GY
and e.RecordID=(SELECT max(g.RecordID) FROM Pts_Records g(NOLOCK) 
	inner join Pts_ProblemState h(nolock) on g.StateID=h.ProblemStateID  
	inner join Accounts_Users i(nolock) on g.CreateUser=i.UserID
	WHERE
    a.ProblemID=g.ProblemID 
	and h.StateName in ('������') 
	and (i.DeptID='2' or (i.DeptID='12' and i.DisplayName='������'))  ---����ת��������
	and g.DateCreated >= '2019-02-22 00:00:00' AND g.DateCreated <'2019-03-01 00:00:00'
	)      ---ȡ���ת���¼ 
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
  inner join Accounts_Department g on h.DeptID=g.DeptID and (g.DeptID='2' or (g.DeptID='12' and h.DisplayName='������'))
  inner join pts_problemstate j on e.StateID=j.ProblemStateID AND j.StateName='�ѱ��'
where  
   a.ProjectID IN ('38','39','55','44','19','41','49','57')
AND c.DisplayName<>h.DisplayName
AND e.DateCreated>='2019-02-22 00:00:00' AND e.DateCreated<'2019-03-01 00:00:00'
--20171218GY
and e.RecordID=(SELECT max(g.RecordID) FROM Pts_Records g(NOLOCK) 
	inner join Pts_ProblemState h(nolock) on g.StateID=h.ProblemStateID  
	inner join Accounts_Users i(nolock) on g.AssignTo=i.UserID
	WHERE
    a.ProblemID=g.ProblemID 
	and h.StateName in ('�ѱ��') 
	and (i.DeptID='2' or (i.DeptID='12' and i.DisplayName='������'))  ---�ѱ��
	and g.DateCreated >= '2019-02-22 00:00:00' AND g.DateCreated <'2019-03-01 00:00:00'
	)      ---ȡ���ת���¼ 
ORDER BY a.ProblemID;









---------ͳ�Ƽƻ�ʱ�䳬��������--------
select
   DATEDIFF(DAY,b.DateCreated,a.Deadline) ����,
   isnull(b.DateCreated,GETDATE()) ����ʱ��,
	a.ProblemID as ID,
	c.DisplayName ת����,
	d.DisplayName �ӵ���,
    a.Deadline ����ʱ��,
	f.statename ת��״̬,
	g.DisplayName ��ǰ������,
	e.statename ��ǰ״̬,
	b.Title ת������,
	b.content AS ת������,
	bb.Title AS ��˱���,
	bb.content AS �������,
	a.Title AS ����,
	a.BigText1 AS ����
from Pts_Problems a(nolock)
left join Pts_Records b(nolock) on a.ProblemID=b.ProblemID 
                   and b.RecordID = 
	(SELECT max(g.RecordID) FROM Pts_Records g(NOLOCK), Pts_ProblemState h(nolock)  
	WHERE g.StateID=h.ProblemStateID AND h.StateName in ('�ѷ���') 
	    and a.ProblemID=g.ProblemID
		AND ISDATE(g.Title)=1 -- ���ڸ�ʽ
		)
inner join Accounts_Users c(nolock) on b.CreateUser=c.UserID
inner join Accounts_Users d(nolock) on b.AssignTo=d.UserID and d.DeptID='2' 
inner join Accounts_Users g(nolock) on a.AssignedTo=g.UserID and g.DeptID='2'
inner join pts_problemstate e(nolock) on a.ProblemStateID=e.ProblemStateID
inner join pts_problemstate f(nolock) on b.StateID=f.ProblemStateID
left join Pts_Records bb(nolock) on a.ProblemID=bb.ProblemID 
                   and bb.RecordID = 
	(SELECT max(g.RecordID) FROM Pts_Records g(NOLOCK), Pts_ProblemState h(nolock)  
	WHERE g.StateID=h.ProblemStateID AND h.StateName in ('ʱ�����') 
	    and a.ProblemID=g.ProblemID
		)
where 	 b.DateCreated>'2019-02-22 00:00:00'  
	and (DATEDIFF(DAY,b.DateCreated, a.Deadline))>14
	--and (DATEDIFF(DAY,'2017-02-28',a.Deadline))>15 --2017-02-28��
	and a.ProjectID in ('38','39','55','44','19','41','49','57')
	
	

