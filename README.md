Small application, which solve total amount for accounts

Data model:
0.There is a hierarchy of accounts on the Org
0.ParentId field in the Account object indicates the parent in the hierarchy.
0.The hierarchy of accounts can include up to 6 levels inclusive.
0.An entry in the Opportunity object can be created for any account in the hierarchy.

Task:
0.Calculate the total amount for each account in the hierarchy. The amount must include:
    1.The amount of the Amount field on the Opportunity object for all records related to the Account. However, OpportunityStatus must be Closed/Won.
    1.The total Amount for accounts that are lower in the hierarchy.
0.Every week on Friday evening, the Total Amount on all accounts must be recalculated.
0.Write Unit tests for implementation with testing of the scenario in which we have all 6 levels of hierarchy.


