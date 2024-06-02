# mTest
Account Profit share
Add a custom 2 decimal place currency field to Account called "Total" and a custom 2 decimal place currency field to Contact called "Share".
Write a trigger call blue on  the Account called  that ensures that the "Total" amount on the Account is as equally divided as possible amongst the existing Contact child objects and stored in the "Share" Contact field whenever "Total" changes.
The "Total" field cannot be 0 or be set to null

So, for example, an existing Account has 5 child Contacts. The Account "Total" field is updated to the value of 100.00. Each Contact "Share" field should be updated by the trigger to the value 20.00.
It is important that the sum of the "Share" fields is exactly equal to the "Total" field including when, for example, there are only 3 Contact children.
For this exercise, you do not need to also write Contact triggers to handle child Contacts being added or deleted from the Account.
Also, supply a passing unit test class for this trigger
