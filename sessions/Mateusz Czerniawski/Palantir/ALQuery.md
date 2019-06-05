# Sample AL Queries

## AD Group Changes

```KQL
WECLogs_CL
| filter Date_t  > ago(10h)
| where Event_ID_d == 4728 or Event_ID_d == 4729 or Event_ID_d == 4732 or Event_ID_d == 4733 or Event_ID_d == 4735 or Event_ID_d == 4737 or Event_ID_d == 4745 or Event_ID_d == 4747 or Event_ID_d == 4750 or Event_ID_d == 4751 or Event_ID_d == 4752 or Event_ID_d == 4755 or Event_ID_d == 4756 or Event_ID_d == 4757 or Event_ID_d == 4760 or Event_ID_d == 4761 or Event_ID_d == 4762 or Event_ID_d == 4764
| sort by Date_t
| extend Title = 'ADGroupChanges'
| project Title, ObjectAffected_s , Who_s , MemberName_s, Date_t , EventAction_s , Event_ID_d , TimeGenerated
```

## AD Password Change

```KQL
WECLogs_CL
| filter Date_t > ago(10h)
| where Event_ID_d ==4723 or Event_ID_d == 4724
| sort by Date_t
| extend Title = 'ADPasswordChange'
| project Title, ObjectAffected_s , Who_s , Date_t , EventAction_s , Event_ID_d , TimeGenerated
```

## AD Computer Created, Changed

```KQL
WECLogs_CL 
| filter Date_t > ago(10h)
| where Event_ID_d ==4741 or Event_ID_d == 4742
| sort by Date_t 
| extend Title = 'ADComputerCreatedChanged'
| project Title, ObjectAffected_s , Who_s , Date_t , EventAction_s , Event_ID_d , TimeGenerated 
```

## ADGroupCreateDelete

```KQL
WECLogs_CL 
| filter Date_t > ago(10h)
| where Event_ID_d == 4727 or Event_ID_d == 4730 or Event_ID_d == 4731 or Event_ID_d == 4734 or Event_ID_d == 4744 or Event_ID_d == 4748 or Event_ID_d == 4749 or Event_ID_d == 4753 or Event_ID_d == 4754 or Event_ID_d == 4758 or Event_ID_d == 4759 or Event_ID_d == 4763
| sort by Date_t 
| extend Title = 'ADGroupCreateDelete'
| project Title, ObjectAffected_s , Who_s , Date_t , EventAction_s , Event_ID_d , TimeGenerated 
```

## ADUserAccountEnabledDisabled

```KQL
WECLogs_CL 
| filter Date_t > ago(10d)
| where Event_ID_d == 4722 or Event_ID_d == 4725
| sort by Date_t 
| extend Title = 'ADUserAccountEnabledDisabled'
| project Title, ObjectAffected_s , Who_s , Date_t , EventAction_s , Event_ID_d , TimeGenerated 
```

## ADUserLocked

```KQL
WECLogs_CL 
| filter Date_t > ago(10h)
| where Event_ID_d ==4740
| sort by Date_t 
| extend Title = 'ADUserLocked'
| project Title, ObjectAffected_s , Who_s , Date_t , EventAction_s , Event_ID_d , TimeGenerated 
```

## LogClearSecurity

```KQL
WECLogs_CL 
| filter Date_t > ago(10h)
| where Event_ID_d == 1102
| sort by Date_t 
| extend Title = 'LogClearSecurity'
| project Title, ObjectAffected_s , Who_s , Date_t , EventAction_s , Event_ID_d , TimeGenerated 
```

## LogClearSystem

```KQL
WECLogs_CL 
| filter Date_t > ago(10h)
| where Event_ID_d == 104
| sort by Date_t 
| extend Title = 'LogClearSystem'
| project Title, ObjectAffected_s , Who_s , Date_t , EventAction_s , Event_ID_d , TimeGenerated
```
