/*

Data cleaningin SQL Queries

*/
select *
from NashvilleHousing

-- Standardize date format

select SaleDate, convert(Date, SaleDate) As Date
from NashvilleHousing

alter table NashvilleHousing
add SaleDate2 Date

update NashvilleHousing
set SaleDate2 = convert(Date, SaleDate)

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Populate property address data

select *
from NashvilleHousing
where PropertyAddress is null
order by ParcelID

select a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ] -- rows are unique even if parcelid is the same
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Split PropertyAddress column into city, state, address

select PropertyAddress
from NashvilleHousing

select substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from NashvilleHousing

select substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address
from NashvilleHousing

alter table NashvilleHousing
add Address2 nvarchar(255),
	City nvarchar(50)

update NashvilleHousing
set City = substring(PropertyAddress, charindex(',', PropertyAddress) +1, LEN(PropertyAddress)),
	Address2 = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)



-- Split owner address into city, state, address

select parsename(replace(OwnerAddress, ',', '.'), 3),
parsename(replace(OwnerAddress, ',', '.'), 2),
parsename(replace(OwnerAddress, ',', '.'), 1)
from NashvilleHousing

alter table NashvilleHousing
add OwnerAddress2 nvarchar(255),
	OwnerCity nvarchar(50),
	OwnerState nvarchar(50)

update NashvilleHousing
set OwnerAddress2 = parsename(replace(OwnerAddress, ',', '.'), 3),
	OwnerCity = parsename(replace(OwnerAddress, ',', '.'), 2),
	OwnerState = parsename(replace(OwnerAddress, ',', '.'), 1)

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in 'Sold as Vacant' field

select distinct(SoldAsVacant) as distinct_values, Count(SoldAsVacant) as count
from NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
	, case when SoldAsVacant = 'Y' then 'Yes'
		   when SoldAsVacant = 'N' then 'No'
		   else SoldAsVacant
		   end
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end

----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

with RownumCTE as(
select *,
	row_number() over( 
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by UniqueID
					) row_num
from NashvilleHousing
)
select *
from RownumCTE
where row_num > 1

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete unused columns

select * 
from NashvilleHousing

select case when TaxDistrict is null then 'Null' else 'Not null' end as TaxDistrictStatus,
		count(*) as count
from NashvilleHousing
group by case when TaxDistrict is null then 'Null' else 'Not null' end

alter table NashvilleHousing
drop column TaxDistrict, OwnerAddress, PropertyAddress