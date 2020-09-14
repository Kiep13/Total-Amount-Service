Small application, which solve total amount for accounts

Data model:
1.   There is a hierarchy of accounts on the Org
2.   ParentId field in the Account object indicates the parent in the hierarchy.
3.   The hierarchy of accounts can include up to 6 levels inclusive.
4.   An entry in the Opportunity object can be created for any account in the hierarchy.

Task:
1.   Calculate the total amount for each account in the hierarchy. The amount must include:
  * The amount of the Amount field on the Opportunity object for all records related to the Account. However, OpportunityStatus must be Closed/Won.
  * The total Amount for accounts that are lower in the hierarchy.
2.  Every week on Friday evening, the Total Amount on all accounts must be recalculated.
3.   Write Unit tests for implementation with testing of the scenario in which we have all 6 levels of hierarchy.


