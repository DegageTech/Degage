


---02.����֧�ֶ����������ͳ��

	
-----------------------------���� ͳ��-----------------------------------------
SELECT distinct  * from (
SELECT distinct 

case when d.DisplayName in ('�����','�ƹ���','��ӵǿ','����ְ','��ѩ��') then '��������EMR' else '��������HIS' end ����,
  a.ProblemID as ����,
  d.DisplayName as   ��ǰ������,
  case when (isnull(a.Select2,'')<>'' )then a.Select2 else  p.name end ϵͳ,
  a.select1 �ͻ�,
  ''  ���,
 ''  ������� 
FROM Pts_Problems a(nolock) 
inner join Pts_Records b(nolock) on a.ProblemID=b.ProblemID
inner join pts_problemstate c(nolock) on b.StateID=c.ProblemStateID
inner join Accounts_Users d(nolock) on b.AssignTo=d.UserID
left join Pts_ProblemCatalogs p on a.ProblemCatalogID=p.ProblemCatalogID
WHERE 
a.ProjectID IN ('38','39','55','44','19','41','49','57')
and c.StateName='����' and b.DateCreated >='2019-02-22 00:00:00' ---���ܷ���
and (d.DeptID='2' or  d.DisplayName='������')
union all
SELECT distinct 
case when d.DisplayName in ('�����','�ƹ���','��ӵǿ','����ְ','��ѩ��') then '��������EMR' else '��������HIS' end ����,
  a.ProblemID as ����,
  d.DisplayName as   ��ǰ������,
  case when (isnull(a.Select2,'')<>'' )then a.Select2 else  p.name end ϵͳ,
  a.select1 �ͻ�,
  ''  ���,
 ''  ������� 
FROM Pts_Problems a(nolock) 
inner join Pts_Records b(nolock) on a.ProblemID=b.ProblemID 
inner join pts_problemstate c(nolock) on a.ProblemStateID=c.ProblemStateID 
inner join Accounts_Users d(nolock) on b.AssignTo=d.UserID and b.StateID='266'
left join Pts_ProblemCatalogs p on a.ProblemCatalogID=p.ProblemCatalogID
WHERE 
a.ProjectID IN ('38','39','55','44','19','41','49','57')
and c.StateName='����'   --������δ����
and (d.DeptID='2' or  d.DisplayName='������')
)a


----3.
SELECT distinct a.ProblemID,a.ProjectID,b.DateCreated,a.Title 
--INTO #Pts_Problems
FROM Pts_Problems a(nolock) 
left join Pts_Records b(nolock) on a.ProblemID=b.ProblemID
left join pts_problemstate c(nolock) on b.StateID=c.ProblemStateID
WHERE b.DateCreated >'2019-02-22 00:00:00' 
and c.StateName='����' AND a.ProjectID IN ('47','48','49','50','53','57')

---4


