/*
cleaning data in sql
*/

---------------------------------------------------------------------------------------------------------
select *
from NashevilleHousing

----------------------------------------------------------------------------------------------------------
--stadardize date format
 select SaleDateConverted, CONVERT(date,SaleDate) 
 from NashevilleHousing

 UPDATE NashevilleHousing
 set SaleDate = CONVERT(date,SaleDate)

ALTER table NashevilleHousing
add SaleDateConverted date;

UPDATE NashevilleHousing
 set SaleDateConverted = CONVERT(date,SaleDate)

 ---------------------------------------------------------------------------------------------------------

 --populate property adrress data
  select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
  from NashevilleHousing a
  join NashevilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  update a
  set PropertyAddress = isnull( a.PropertyAddress,b.PropertyAddress)
  from NashevilleHousing a
  join NashevilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ] 

  ---------------------------------------------------------------------------------------------------------------------------------------------
  --Breaking down adress in to individual columuns (Adress,City,State)

  select 
  SUBSTRING(PropertyAddress, 1,CHARINDEX(',' ,PropertyAddress)-1) as Address
  ,SUBSTRING(PropertyAddress, CHARINDEX(',' ,PropertyAddress)+1,LEN(PropertyAddress)) as Address
   from NashevilleHousing  
  
  alter table NashevilleHousing 
  add PropertySpilitAddress nvarCHAR(255)

  UPDATE NashevilleHousing
 set PropertySpilitAddress= SUBSTRING(PropertyAddress, 1,CHARINDEX(',' ,PropertyAddress)-1) 

ALTER table NashevilleHousing
add  PropertySpilitCity nvarchar(255) 

UPDATE NashevilleHousing
 set PropertySpilitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' ,PropertyAddress)+1,LEN(PropertyAddress))
----------------------------------------------------------------------------------------------------------------------------------------------
--looking at owner address and Spilitting them
 
 select
 PARSENAME(replace(OwnerAddress,',','.'),3) ,
  PARSENAME(replace(OwnerAddress,',','.'),2), 
   PARSENAME(replace(OwnerAddress,',','.'),1)
 from NashevilleHousing 

  alter table NashevilleHousing 
  add OwnerSpilitAddress nvarCHAR(255)

  UPDATE NashevilleHousing
 set  OwnerSpilitAddress =  PARSENAME(replace(OwnerAddress,',','.'),3) index partiotn by id 

ALTER table NashevilleHousing
add  OwnerSpilitCity nvarchar(255)

UPDATE NashevilleHousing
 set OwnerSpilitCity  = PARSENAME(replace(OwnerAddress,',','.'),2)


 ALTER table NashevilleHousing
add  OwnerSpilitState nvarchar(255)

UPDATE NashevilleHousing
 set  OwnerSpilitState = PARSENAME(replace(OwnerAddress,',','.'),1)
-------------------------------------------------------------------------------------------------------------------------------------

 --Change Y and N to YES or NO in "Sold as Vaccant" field

 select distinct (SoldAsVacant), count (SoldAsVacant)
 from NashevilleHousing
 group by SoldAsVacant
 order by 2

 select SoldAsVacant 
  ,case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
 from NashevilleHousing
 
  update NashevilleHousing
 set SoldAsVacant  = case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
 from NashevilleHousing

 -------------------------------------------------------------------------------------------------------------------------------------------
 --Reomoving Duplicates
 WITH RowNumCTE as (
 select *,
 ROW_NUMBER() over (
 partition by ParcelID,
              PropertyAddress,
			  SaleDate,
			  SalePrice,
			  LegalReference
			  order by 
			  UniqueID
			  )  Row_num
  from NashevilleHousing
 
 )
  select *
  from RowNumCTE
  where Row_num > 1
  order by PropertyAdress
 

 ---------------------------------------------------------------------------------------------------------------------------------------  
     

 --Delete Unused Columns
	 
	 Alter table NashevilleHousing
	 drop column  PropertyAddress,OwnerAddress,TaxDistrict

	  Alter table NashevilleHousing
	 drop column  SaleDate

	 select *
	 from NashevilleHousing



 


 

