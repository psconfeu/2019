# Notes

## References

- https://www.youtube.com/watch?v=6bPByJX5euc Testing, Testing, 1...2...3: Using Pester for Infrastructure Validation by Brandon Olin
- https://github.com/ticketmaster/poshspec Infrastructure Testing DSL running in Pester
- https://devblackops.io/infrastructure-testing-with-pester-and-the-operation-validation-framework/ Infrastructure Testing with Pester and the Operation Validation Framework
- https://github.com/PowerShell/Operation-Validation-Framework Operation-Validation-Framework

## Sessions

| time | Title                                                            | Speaker                      | Comment                                            |
| ---- | ---------------------------------------------------------------- | ---------------------------- | -------------------------------------------------- |
|      | PowerShell in Azure Functions                                    | Joey Aiello, Tyler Leonhardt | Runing Interaktive IaC deployments                 |
|      | Pester + Azure (Monitor + Automation)                            | Mateusz Czerniawski          | Running Azure Monitoring and Test                  |
|      | Extend your PowerShell skills by creating Azure DevOps Extension | Stefan Stranger              | Modules to DevOps Extensions                       |
|      | OS image pipeline: Packer, PowerShell, DSC & Chocolatey          | Gael Colas                   | IaC, golden image creation                         |
|      | Automate hybrid and cloud environments using Azure Automation    | Jan Egil Ring                | Automation Account upload from modules using ci/cd |
|      | Azure PowerShell vs Azure CLI: Duel at the command line          | Aleksander Nikolic           | Managing azure at command line                     |

## Session Notes

### Testing:

Source: [DevOps Foundation](https://www.linkedin.com/learning/devops-foundations-infrastructure-as-code/testing-your-infrastructure?u=3322)

- Infrastructure as code
- From code to artifacts
- Testing your infrastructure
- Unit testing infrastructure
- Integration and security testing
- Unsave Integration and security testing

## Considerations:

- ARM Deployment limit 90 Minutes
- VS2017 maximum execution time of 60
- KeyVault & Storage Account Access from Build Agent
-

## Key Concepts

Source : [Concepts](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?toc=/azure/devops/pipelines/toc.json&bc=/azure/devops/boards/pipelines/breadcrumb/toc.json&view=vsts)

- Agent
- Artifact
- Build
- Continuous Delivery
- Continuous Integration
- Deployment target
- Job
- Pipeline
- Release
- Task
- Trigger

## Key Findings

DevOps Practices:

- Accelerate delivery
- Optimize resources
- Improve availability
- Increase application quality

Puppertlabs.com 2013 State of DevOps Report

- 30x faster ship code, 50% fewer failures
- Version Control
- Configuration Management
- Ticketing System
- Resource Monitoring
- Provisioning

## Gonvernance

Azure Governance - #1 - Overview
Governance - #2 - Organize your resources
Governance - #3 - Policy & Blueprints
Governance - #4 - Security Center

[Azure Scaffold](https://docs.microsoft.com/en-us/azure/architecture/cloud-adoption/appendix/azure-scaffold)

## CCOE

Defintion: source: (Cloud Management Report)[http://click.cloudcheckr.com/rs/222-ENM-584/images/Cloud_Management_Report_2017%20%283%29.pdf]

A Cloud Center of Excellence (CCoE) is a cross-functional team of people responsible for
developing and managing the cloud strategy, governance, and best practices that the rest of
the organization can leverage to transform the business using the cloud. The CCoE leads the
organization as a whole in cloud adoption, migration, and operations. It may also be called a
Cloud Competency Center, Cloud Capability Center, or Cloud Knowledge Center

in numbers .

The full potential of the cloud has not yet been realized:

- 94% of respondents face challenges in public cloud adoption
- 81% say they need to improve communication between departments
- Executives (43%) are more likely to report they are very confident in their cloud visibility than their staff (16%)
- 33% report that their business leadership have a strong understanding of the cloud

benefits:

- 83% of those with a CCoE say it is effective
- 96% would benefit from a CCoE
- Top benefits of a CCoE reported include reducing security risks (56%), reducing costs
  (50%), and improving ability to be agile and innovate (44%)

  Challanges:

  - meeting regulatory compliance
  - identify anomalies and trends
  - not confident security risk
  - visibility & spending

ccoe helps:

- reduce security
- reduce costs
- improve innovation and agile

in words .

- The full potential of the cloud has not yet been realized: 94 percent of respondents face challenges in public cloud adoption; 81 percent say they need to improve communication between departments; 43 percent of executives are more likely to report they are very confident in their cloud visibility than their staff (16 percent); and 33 percent report that their business leadership has a strong understanding of the cloud.
- Organizations adopting a CCoE for cloud leadership and vision: 47 percent have formed some kind of CCoE, and 63 percent have added new roles to deal with cloud adoption. Some organizations are held back from establishing CCoEs by a wide range of factors, such as the belief that their level of cloud usage doesn’t justify the effort, a general lack of priority, or a cloud adoption that moves too quickly to operationalize the process.
- Organizations benefit from a CCoE: 83 percent of those with a CCoE say it is effective; 96 percent believe they would benefit from a CCoE; the top reported benefits of a CCoE include reducing security risks (56 percent), reducing costs (50 percent), and improving the ability to be agile and innovative (44 percent).

3 steps source: [CCoE](https://medium.com/aws-enterprise-collection/how-to-create-a-cloud-center-of-excellence-in-your-enterprise-8ed3a97adcc6)

- Build the team,
- scope (and grow) the team’s responsibilities,
- and position it as a hub for best practices for the entire organization.

Source [ccoe](https://medium.com/aws-enterprise-collection/using-a-cloud-center-of-excellence-ccoe-to-transform-the-entire-enterprise-cc89d416e934)

- Step 1: Forming the Team
- Step 2: Deliver Some Quick Wins
- Step 3: Acquire Leadership Support
- Step 4: Build Reusable Patterns and Reference Architectures
- Step 5: Engage and Evangelize
- Step 6: Scale and Reorganize

## Maturity

- Level 3: Optimizing — Focus on process improvement
- Level 2: Quantitatively Managed — Process measured and controlled
- Level 1: Consistent — Automated processes applied across whole application lifecycle
- Level 0: Repeatable — Process documented and partly automated
- Level -1: Regressive — Processes unrepeatable, poorly controlled, and reactive
