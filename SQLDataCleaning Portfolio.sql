---Standardize Date Format.Dateformat is Datatime so I want to take only YYYY-MM-DD
SELECT Saledate, CONVERT(Date,Saledate)
FROM PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET Saledate = CONVERT(Date,Saledate)

---OR

ALTER TABLE NashvilleHousing
Add SaledateConverted Date

Update NashvilleHousing
SET SaledateConverted = Convert(Date,Saledate)

SELECT * FROM NashvilleHousing

--------Populate Porperty Address data

SELECT PropertyAddress 
FROM NashvilleHousing
Where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

SELECT * FROM NashvilleHousing


-----------Breaking out Address into individual Columns (Address, City, State)

SELECT *
FROM NashvilleHousing

-----ProperttyAddress

select PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address
from NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))


-----OwnerAddress

SELECT OwnerAddress FROM NashvilleHousing

SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3) as OwnerSplitAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as OwnerSplitState
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress varchar(255);
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity varchar(255);
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState varchar(255);
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


-------------- I will change Y and N to YES and No in "Sold as Vacant" field

SELECT Distinct SOLDASVACANT FROM NashvilleHousing

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END AS FixedSoldAsVacant
FROM NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing

---Removing Duplicates


WITH RowNumCTE as(
SELECT *, ROW_NUMBER() OVER (PARTITION BY 
		ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference 
		ORDER BY UniqueID ) as row_num 
FROM NashvilleHousing )
select * from RowNumCTE
Where row_num > 1  ---104 duplicated row..

-----
WITH RowNumCTE as(
SELECT *, ROW_NUMBER() OVER (PARTITION BY 
		ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference 
		ORDER BY UniqueID ) as row_num 
FROM NashvilleHousing )
DELETE from RowNumCTE
Where row_num > 1  ---104 rows deleted..


---DELETE Unused Columns
SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate





