declare @sdate datetime
declare @edate datetime 
declare @sdate2 datetime
declare @edate2 datetime 
set @sdate='2019-03-15 17:30:01'
set @edate='2019-03-22 17:30:00'
set @sdate2='2019-03-01 00:00:01'
set @edate2='2019-03-22 23:59:59'
----------��Ա�б�-----------------
create  table #emp
(id int,
name varchar(20))
insert into #emp values ('1','�����')
insert into #emp values ('2','��׿��')
insert into #emp values ('3','������')
insert into #emp values ('4','������')
insert into #emp values ('5','�պ���')
insert into #emp values ('6','���˾�')
insert into #emp values ('7','��Ժ��')
insert into #emp values ('8','��־��')




-------����10h�ĵ�-------------
select  a.ProblemID as ID,d.name AS ��Ŀ����,a.select1 as ҽԺ,
c.DisplayName as ת����,
a.Title AS ����,a.BigText1 AS ����,
a.Float1 as ������H into #c10h
  from Pts_Problems a ,Accounts_Users  c,Pts_Projects d,Pts_Records e,Accounts_Department f ,Accounts_Users h ,
Accounts_Department g,pts_problemstate j
where  
 e.CreateUser=c.UserID
and e.StateID=j.ProblemStateID
AND c.DeptID=f.DeptID
AND e.AssignTo=h.UserID
AND h.DeptID=g.DeptID
AND a.ProjectID=d.ProjectID
 AND a.ProblemID=e.ProblemID
 AND h.DisplayName<>'��ѩ��'
 AND c.DisplayName<>h.DisplayName
 AND g.DeptID=1
 and a.Float1>10
 and  j.statename='����ɴ�����'
 and f.DeptName in ('����֧��һ��','��άһ��')
 --AND f.DeptID IN (1,2,4,5,9,10,11,12,13,14,15,16,17,18,19,20,21,22)
AND e.DateCreated  >=@sdate
and  e.DateCreated<=@edate
ORDER BY a.ProblemID;

----------�ѷ���-----------------

SELECT * 
INTO #temp_Records
FROM Pts_Records a(nolock) WHERE a.DateCreated = (SELECT min(b.DateCreated) FROM Pts_Records b(NOLOCK),
 Pts_ProblemState c(nolock)  WHERE c.ProblemStateID=b.StateID AND c.StateName='�ѷ���' 
 and a.ProblemID=b.ProblemID )
AND a.StateID IN (SELECT d.ProblemStateID FROM Pts_ProblemState d (nolock) 
WHERE d.StateName='�ѷ���') 
and a.DateCreated >=@sdate AND a.DateCreated <=@edate

select d.name AS ��Ŀ����, a.ProblemID as ID,a.CreateTime AS �ᵥʱ��, e.DateCreated as ����ʱ��,
c.DisplayName as ת����,f.DeptName as ת�������ڲ���,h.DisplayName as �ӵ���,i.TypeName ����,
g.DeptName as �ӵ������ڲ���,a.Title AS ����,e.Title as ��¼����,
e.content as ��¼����,t.StateName AS ״̬ 
into #yfp
from Pts_Problems a ,Accounts_Users  c,Pts_Projects d,#temp_Records e,Accounts_Department f ,
Accounts_Users h ,Accounts_Department g,Pts_ProblemState t,Pts_ProblemType i
where  
 e.CreateUser=c.UserID
AND c.DeptID=f.DeptID
AND e.AssignTo=h.UserID
AND h.DeptID=g.DeptID
AND a.ProjectID=d.ProjectID
 AND a.ProblemID=e.ProblemID
  AND a.OriginProjectID=i.ProjectID and a.ProblemTypeID=i.ProblemTypeID
 --AND c.DisplayName<>h.DisplayName
 AND d.ProjectID IN ('32','33','40','45','52','56')
 AND e.StateID=t.ProblemStateID
ORDER BY a.ProblemID;

------------------�����--------------------------
select    a.ProblemID as ID
,convert(varchar(10),a.CreateTime,120) AS �ᵥʱ��, 
e.DateCreated as ����ʱ��,c.DisplayName as ת����,
f.DeptName as ת�������ڲ���,
h.DisplayName as �ӵ���,g.DeptName as �ӵ������ڲ���,
a.select1 as ҽԺ,a.Title AS ����,a.BigText1 AS ����,
e.title AS ת������ ,e.content AS ת������,
d.name AS ��Ŀ����,j.statename AS ״̬,a.Float1 as ������H,
convert(varchar(10),a.Deadline,120) ���� into #wc1
from Pts_Problems a ,Accounts_Users  c,Pts_Projects d,
Pts_Records e,Accounts_Department f 
,Accounts_Users h ,
Accounts_Department g,pts_problemstate j
where  
 e.CreateUser=c.UserID
and e.StateID=j.ProblemStateID
AND c.DeptID=f.DeptID
AND e.AssignTo=h.UserID
AND h.DeptID=g.DeptID
AND a.ProjectID=d.ProjectID
 AND a.ProblemID=e.ProblemID
 AND h.DisplayName<>'��ѩ��'
 AND c.DisplayName<>h.DisplayName
 AND g.DeptID=1
 and  j.statename='����ɴ�����'
 and f.DeptName in ('����֧��һ��','��άһ��')
 AND f.DeptID IN (1,2,4,5,9,10,11,12,13,14,15,16,17,18,19,20,21,22)
AND e.DateCreated  >=@sdate
and  e.DateCreated<=@edate
ORDER BY a.ProblemID;

select distinct  ID ,ת����, isnull(������H,0) ������H into #wc2 from #wc1

--------------------------����һ��δ����������-----------------------------------
select  d.DeptName ����, c.DisplayName ��ǰ������,a.ProblemID ID,
convert(varchar(10),a.CreateTime,120) ����ʱ��,
a.Title ����,a.BigText1 ����,e.[Name] ϵͳ,
isnull(a.Select2,g.name) ģ��,a.Select1 ҽԺ,b.StateName ״̬,
convert(varchar(10),a.Deadline,120) ����,a.Float1 as ������H
  into #xq
  from Pts_Problems a
  left join  pts_problemstate b on a.ProblemStateID=b.ProblemStateID
  left join Accounts_Users  c on a.AssignedTo=c.UserID
  left join Accounts_Department d on  c.DeptID=d.DeptID
  left join Pts_Projects e on a.ProjectID=e.ProjectID
  left join Pts_ProblemCatalogs g(NOLOCK) ON a.ProblemCatalogID=g.ProblemCatalogID
where 
b.statename in('��ȷ��','�ѷ���','δͨ��','��ȷ������','�ѱ��')
AND d.DeptID IN ('22','20')
ORDER BY d.DeptName, c.DisplayName

------------������-------------------------------
select d.name AS ��Ŀ����, a.ProblemID as ID,a.CreateTime AS �ᵥʱ��, e.DateCreated as ����ʱ��,
c.DisplayName as ת����,f.DeptName as ת�������ڲ���,
h.DisplayName as �ӵ���,g.DeptName as �ӵ������ڲ���,
a.Title AS ����,e.title ת������ ,e.content ת������,j.statename ״̬ into #sqbg
from Pts_Problems a ,Accounts_Users  c,Pts_Projects d,Pts_Records e,
Accounts_Department f ,Accounts_Users h ,Accounts_Department g,pts_problemstate j
where  
e.CreateUser=c.UserID
and e.StateID=j.ProblemStateID
AND c.DeptID=f.DeptID
AND e.AssignTo=h.UserID
AND h.DeptID=g.DeptID
AND a.ProjectID=d.ProjectID
AND a.ProblemID=e.ProblemID
AND c.DisplayName<>h.DisplayName
AND a.ProjectID IN ('32','33','40','45','52','56')
AND j.StateName='������'
AND e.DateCreated  >=@sdate
and  e.DateCreated<=@edate
ORDER BY a.ProblemID;



-----------�ѱ��-------------------------------
select d.name AS ��Ŀ����, a.ProblemID as ID,a.CreateTime AS �ᵥʱ��, e.DateCreated as ����ʱ��,
c.DisplayName as ת����,f.DeptName as ת�������ڲ���,
h.DisplayName as �ӵ���,g.DeptName as �ӵ������ڲ���,
a.Title AS ����,e.title ת������ ,e.content ת������,j.statename ״̬ into #ybg
from Pts_Problems a ,Accounts_Users  c,Pts_Projects d,Pts_Records e,
Accounts_Department f ,Accounts_Users h ,Accounts_Department g,pts_problemstate j
where  
e.CreateUser=c.UserID
and e.StateID=j.ProblemStateID
AND c.DeptID=f.DeptID
AND e.AssignTo=h.UserID
AND h.DeptID=g.DeptID
AND a.ProjectID=d.ProjectID
AND a.ProblemID=e.ProblemID
AND c.DisplayName<>h.DisplayName
AND a.ProjectID IN ('32','33','40','45','52','56')
AND  j.StateName='�ѱ��'
AND e.DateCreated  >=@sdate
and  e.DateCreated<=@edate
ORDER BY a.ProblemID;



----------------�������--------------------------
select    a.ProblemID as ID
,convert(varchar(10),a.CreateTime,120) AS �ᵥʱ��, 
e.DateCreated as ����ʱ��,c.DisplayName as ת����,f.DeptName as ת�������ڲ���,
h.DisplayName as �ӵ���,g.DeptName as �ӵ������ڲ���,a.select1 as ҽԺ,a.Title AS ����,a.BigText1 AS ����,e.title 
AS ת������ ,e.content AS ת������,
d.name AS ��Ŀ����,j.statename AS ״̬,a.Float1 as ������H,
convert(varchar(10),a.Deadline,120) ���� into #ywc1
  from Pts_Problems a ,Accounts_Users  c,Pts_Projects d,Pts_Records e,Accounts_Department f ,Accounts_Users h ,
Accounts_Department g,pts_problemstate j
where  
 e.CreateUser=c.UserID
and e.StateID=j.ProblemStateID
AND c.DeptID=f.DeptID
AND e.AssignTo=h.UserID
AND h.DeptID=g.DeptID
AND a.ProjectID=d.ProjectID
 AND a.ProblemID=e.ProblemID
 AND h.DisplayName<>'��ѩ��'
 AND c.DisplayName<>h.DisplayName
 AND g.DeptID=1
 and  j.statename='����ɴ�����'
 and f.DeptName in ('����֧��һ��','��άһ��')
 AND f.DeptID IN (1,2,4,5,9,10,11,12,13,14,15,16,17,18,19,20,21,22)
AND e.DateCreated  >=@sdate2
and  e.DateCreated<=@edate2
ORDER BY a.ProblemID;

select distinct  ID ,ת����, isnull(������H,0) ������H into #ywc2 from #ywc1




----------�ѷ���-----------------
select #emp.id,name,COUNT(#yfp.ID)�ᵥ���� into #1 from #emp left join   #yfp
on  #emp.name=#yfp.�ӵ���
GROUP  BY name, #emp.id
----------�����-----------------
select #emp.id,name,count(#wc2.ID) ���,isnull(sum(������H),0)��ɹ�ʱ into #2  from #emp left join  #wc2
on  #emp.name=#wc2. ת����
GROUP  BY name, #emp.id
----------ʣ�൥-----------------
select #emp.id,#emp.name,COUNT(#xq.ID)ʣ�൥�� into #3  from  #emp
 left join  #xq
on  #emp.name=#xq. ��ǰ������
 group  by  #emp.name, #emp.id
 ----------������-----------------
select #emp.id,#emp.name,COUNT(#sqbg.ID)������ into #4  from  #emp
 left join  #sqbg
on  #emp.name=#sqbg. ת����
 group  by  #emp.name, #emp.id 
 ----------�ѱ��-----------------
 select #emp.id,#emp.name,COUNT(#ybg.ID)�ѱ�� into #5 from  #emp
 left join  #ybg
on  #emp.name=#ybg. �ӵ���
 group  by  #emp.name, #emp.id 
----------�������-----------------
select #emp.id,name,count(#ywc2.ID) �������,isnull(sum(������H),0)���¹�ʱ into #6 from #emp left join  #ywc2
on  #emp.name=#ywc2. ת����
GROUP  BY name, #emp.id




-----------------------------���� ͳ��-----------------------------------------
SELECT distinct b.DateCreated ,a.ProblemID,a.ProjectID,a.CreateTime,a.Title ,select1,Select2,a.ProblemCatalogID
INTO #Pts_Problems
FROM Pts_Problems a(nolock) 
left join Pts_Records b(nolock) on a.ProblemID=b.ProblemID
left join pts_problemstate c(nolock) on b.StateID=c.ProblemStateID
WHERE b.DateCreated >=@sdate 
and  b.DateCreated <=@edate 
and c.StateName='δͨ��' AND a.ProjectID IN ('32','33','45','56','52')

select 
'����һ��' ���� , 
a.ProblemID as ����,
h.DisplayName as ������ ,
--d.name AS ��Ŀ����, 
case when (isnull(a.Select2,'')<>'' )then a.Select2
         when (isnull(a.Select2,'')=''  and isnull(p.name,'')<>'')then p.name 
         when (isnull(a.Select2,'')=''  and isnull(p.name,'')='') then q.name else '' end ϵͳ,
    a.select1 �ͻ�,
' ' ���,
cast (e.title as varchar(500)) +'  '+cast (e.content as varchar(500))  �������
into #fg
  from #Pts_Problems a 
  inner join Pts_Projects d on a.ProjectID=d.ProjectID
  inner join Pts_Records e on a.ProblemID=e.ProblemID
  inner join Accounts_Users  c on e.CreateUser=c.UserID
  inner join Accounts_Department f on c.DeptID=f.DeptID
  inner join Accounts_Users h on e.AssignTo=h.UserID
  inner join Accounts_Department g on h.DeptID=g.DeptID
  inner join pts_problemstate j on e.StateID=j.ProblemStateID AND j.StateName='δͨ��'
  left join Pts_ProblemCatalogs p(nolock) on a.ProblemCatalogID=p.ProblemCatalogID
  left join Pts_Projects q on a.ProjectID=q.ProjectID

ORDER BY a.ProblemID;



