---------����    �ѷ������汾�ţ�-------------
declare  @sdate  datetime
declare  @edate  datetime
set @sdate='2019-03-15 09:30:01'
set @edate='2019-03-22 09:30:00'
select  a.select1 as ҽԺ,a.Select2 ϵͳ����,a.ProblemID as ����,a.BigText1 AS ��������,k.TypeName  as   ����,convert(varchar(10),a.CreateTime,120) as  ����ʱ��,'��'  as   �Ƿ��޸�,a.Float1 as ������,'���' as ������,c.DisplayName as ������,e.DateCreated as ����ʱ��,'' as �汾��,e.content AS ��ע 
INTO #a
from Pts_Problems a ,Accounts_Users  c,Pts_Projects d,Pts_Records e,Accounts_Department f ,Accounts_Users h ,Accounts_Department g,pts_problemstate j, Pts_ProblemType k
where  
e.CreateUser=c.UserID
and e.StateID=j.ProblemStateID AND c.DeptID=f.DeptID
AND e.AssignTo=h.UserID AND h.DeptID=g.DeptID
AND a.ProjectID=d.ProjectID AND a.ProblemID=e.ProblemID
AND h.DisplayName<>'��ѩ��' AND c.DisplayName<>h.DisplayName
and a.ProblemTypeID=k.ProblemTypeID
and  j.statename in ('�ѷ������汾�ţ�','�ر�')and  d.name ='LIS.NET��Ŀ'
and  f.DeptName='��Ŀ��������'
AND e.DateCreated   >=@sdate and  e.DateCreated <=@edate
and a.select1 not IN ('���ڱ���ҽԺ','ɽ����̨ع諶�ҽԺ','����������ҽԺ') and a.Select2 like '����ϵͳ%'
ORDER BY e.DateCreated



select ProblemID,DisplayName ������,min(DateCreated)   �������
into #b from #a left join  Pts_Records  on  #a.����=Pts_Records.ProblemID
LEFT  JOIN  pts_problemstate ON StateID=ProblemStateID
LEFT JOIN  Accounts_Users ON Accounts_Users.UserID=CreateUser
where    StateName='����ɴ�����'
AND  Accounts_Users.DEPTID IN ('20','22')
group by  ProblemID,DisplayName 


select #a.ҽԺ,ϵͳ����,����,��������,����,����ʱ��,�Ƿ��޸�,������,������,�������,������,������,����ʱ��,�汾��,��ע from  #a,#b
where  #a.����=#b.ProblemID
order by  ����ʱ��


--drop  table  #a
--drop  table  #b
