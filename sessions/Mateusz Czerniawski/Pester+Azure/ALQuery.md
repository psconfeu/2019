# Sample AL queries

## Compare results in time

```KQL
let TimeG = 30d;
let Passed = (
pChecksAD_CL
| where TimeGenerated  > ago(TimeG) and Passed_b == 'True'
| project Describe_s, Context_s ,
          Passed_bTrue=Passed_b  ,
          TimeGeneratedPassed = TimeGenerated ,
          Name_s , FailureMessage_s , Target_s
);
let Failed = (
pChecksAD_CL
   | where TimeGenerated  > ago(TimeG) and Passed_b == 'False'
   | project Describe_s, Context_s ,
            Passed_bFalse = Passed_b ,
            TimeGeneratedFalse = TimeGenerated,
            Name_s , FailureMessage_s , Target_s
);
Passed | join kind=inner Failed on Name_s
| extend HowLongAgoH = ( now() - TimeGeneratedPassed )/ 1h,
         HowLongAgoD = ( now() - TimeGeneratedPassed )/ 1d
| project Describe_s, Context_s ,  Name_s , FailureMessage_s ,Passed_bTrue , Passed_bFalse,
          Target_s, TimeGeneratedPassed, TimeGeneratedFalse,
          ChecksTimeDifference = TimeGeneratedPassed - TimeGeneratedFalse,
          HowLongAgoH, HowLongAgoD
| sort by HowLongAgoH asc
```

## Passed and Failed checks

```KQL
let TimeG = 30d;
let Passed = (
pChecksAD_CL
| where TimeGenerated  > ago(TimeG) and Passed_b == 'True'
| project Describe_s, Context_s ,
          Passed_bTrue=Passed_b  ,
          TimeGeneratedPassed = TimeGenerated ,
          Name_s , FailureMessage_s , Target_s
);
let Failed = (
pChecksAD_CL
   | where TimeGenerated  > ago(TimeG) and Passed_b == 'False'
   | project Describe_s, Context_s ,
            Passed_bFalse = Passed_b ,
            TimeGeneratedFalse = TimeGenerated,
            Name_s , FailureMessage_s , Target_s
);
Passed | join kind=inner Failed on Name_s
| extend HowLongAgoH = ( now() - TimeGeneratedPassed )/ 1h,
         HowLongAgoD = ( now() - TimeGeneratedPassed )/ 1d
| project Describe_s, Context_s ,  Name_s , FailureMessage_s ,Passed_bTrue , Passed_bFalse,
          Target_s, TimeGeneratedPassed, TimeGeneratedFalse,
          ChecksTimeDifference = TimeGeneratedPassed - TimeGeneratedFalse,
          HowLongAgoH, HowLongAgoD
| sort by HowLongAgoH asc
```

## Passed and failed stats

```KQL
pChecksAD_CL
| where TimeGenerated > ago(7d)
| summarize ChecksPassed = (count(Passed_b == 'True')),
         ChecksFailed = (count(Passed_b == 'False'))
         by Describe_s
| sort by ChecksFailed
```
