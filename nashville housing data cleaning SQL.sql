

USE excelprojects
GO
---Populate property address data

select *
from [Nashville Housing ]
where PropertyAddress is Null
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull (a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing ] a
join [Nashville Housing ] b
 on a.ParcelID=b.ParcelID
 AND a.UniqueID<>b.UniqueID
 where a.PropertyAddress is null

 update a
 Set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
 from [Nashville Housing ] a
 Join [Nashville Housing ] b
 on a.ParcelID=b.ParcelID
 AND a.UniqueID<>b.UniqueID
 Where a.PropertyAddress is null

----breaking out address into individual columns(Address,City,State)

select PropertyAddress
from [Nashville Housing ]
--where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN( PropertyAddress)) as Address

From[Nashville Housing ];


Alter Table [Nashville Housing ]
ADD PropertySplitAddress Nvarchar(255);

Update [Nashville Housing ]
Set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

Alter Table [Nashville Housing ]
Add PropertySplitCity Nvarchar(255);

Update [Nashville Housing ]
Set PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN( PropertyAddress))

select*
from [Nashville Housing ];


select OwnerAddress
from [Nashville Housing ];


select
PARSENAME(REPLACE (OwnerAddress,',','.'),3)
,PARSENAME(REPLACE (OwnerAddress,',','.'),2)
,PARSENAME(REPLACE (OwnerAddress,',','.'),1)
FROM [Nashville Housing ];

Alter Table [Nashville Housing ]
ADD OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing ]
Set OwnerSplitAddress=PARSENAME(REPLACE (OwnerAddress,',','.'),3)

Alter Table [Nashville Housing ]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing ]
Set OwnerSplitCity=PARSENAME(REPLACE (OwnerAddress,',','.'),2)



Alter Table [Nashville Housing ]
Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing ]
Set OwnerSplitState=PARSENAME(REPLACE (OwnerAddress,',','.'),1)

select*
from [Nashville Housing ];


--check value in Soldasvacant field(0=No,1=Yes)	

select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From [Nashville Housing ]
GROUP by SoldAsVacant
Order by 2


--remove duplicates


WITH RowNUumCTE AS
(
select *,
    ROW_NUMBER() OVER (
    Partition by ParcelID,
                 SalePrice,
                 PropertyAddress,
                 SaleDate,
                 LegalReference
               order by UniqueID
                   ) AS row_num
From[Nashville Housing ]

)

Select*
FROM RowNumCTE
Where ROW_NUMBER>1
ORDER BY PropertyAddress;



--delete unused Columns


Select*
From [Nashville Housing ];

Alter table [dbo]. [Nashville Housing ]
Drop Column OwnerAddress,TaxDistrict,PropertyAddress;

Alter table [Nashville Housing]
DROP Column Saledate;
















