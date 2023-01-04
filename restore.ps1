# First and Last Name - Student ID

Import-Module ActiveDirectory

# Create an Active Directory organizational unit (OU) named “finance.”
New-ADOrganizationalUnit -Name finance

# Import the financePersonnel.csv file into the finance OU
Import-Csv '.\Requirements2\financePersonnel.csv' | % {
    $firstName = $_.'First Name'
    $lastName = $_.'Last Name'
    $displayName = "$firstName $lastName"
    $postalCode = $_.'Postal Code'
    $officePhone = $_.'Office Phone'
    $mobilePhone = $_.'Mobile Phone'
    New-ADUser -Name $displayName -GivenName $firstName -Surname $lastName -DisplayName $displayName -PostalCode $postalCode -OfficePhone $officePhone -MobilePhone $mobilePhone -Path 'ou=finance,dc=consultingfirm,dc=com' -Enabled $true
}

# Create a new database on the Microsoft SQL server instance called “ClientDB.”
# Create a new table called “Client_A_Contacts” and add it to the new database.
# Insert the data from NewClientData.csv into the table.
$query = @"
CREATE DATABASE ClientDB;
USE ClientDB;
CREATE TABLE Client_A_Contacts (
    FirstName nvarchar(255),
    LastName nvarchar(255),
    DisplayName nvarchar(255),
    PostalCode nvarchar(255),
    OfficePhone nvarchar(255),
    MobilePhone nvarchar(255)
);
BULK INSERT Client_A_Contacts FROM '$($PWD)\Requirements2\NewClientData.csv' WITH (FIRSTROW=2, FORMAT='CSV', FIELDQUOTE='"', FIELDTERMINATOR=',', ROWTERMINATOR='\n');
"@
Invoke-Sqlcmd -ServerInstance .\SQLEXPRESS -Query $query

try {
    # Add code that might throw a System.OutOfMemoryException here
} catch [System.OutOfMemoryException] {
    Write-Warning "An out-of-memory exception occurred. Please ensure that you have sufficient memory available and try again."
}

# Export AD user information to AdResults.txt
Get-ADUser -Filter * -SearchBase "ou=finance,dc=consultingfirm,dc=com" -Properties DisplayName,PostalCode,OfficePhone,MobilePhone | Export-Csv '.\Requirements2\AdResults.txt' -NoTypeInformation

# Export SQL table data to SqlResults.txt
Invoke-Sqlcmd -Database ClientDB -ServerInstance .\SQLEXPRESS -Query 'SELECT * FROM dbo.Client_A_Contacts' | Export-Csv '.\Requirements2\SqlResults.txt' -NoTypeInformation
