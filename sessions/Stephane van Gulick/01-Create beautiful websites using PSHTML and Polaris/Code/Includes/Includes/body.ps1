h2 "List of services"
$Services = get-Service | select -First 3

ConvertTo-PSHTMLTable -Properties DisplayName,Status -Object $Services