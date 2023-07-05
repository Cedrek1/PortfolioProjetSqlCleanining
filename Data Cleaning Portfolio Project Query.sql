/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProjet1.dbo.[NashvilleHousing ]

----------------------------------------------------------------------------------------------------------------------------------------


--Standardize Date Format


Select saledateconverted,  Convert(Date,SaleDate)
From PortfolioProjet1.dbo.[NashvilleHousing ]


Update [NashvilleHousing ]
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date not null;

Update [NashvilleHousing ]
SET saledateconverted = CONVERT(Date,SaleDate)


----------------------------------------------------------------------------------------------------------------------------------------

--Populate Property Address data

Select *
From PortfolioProjet1.dbo.[NashvilleHousing ]
--where PropertyAddress is null
order by ParcelID



Select a.PropertyAddress, b.ParcelID, a.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjet1.dbo.[NashvilleHousing ] a
Join PortfolioProjet1.dbo.[NashvilleHousing ] b
    ON a.ParcelID = b.ParcelID
    and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjet1.dbo.[NashvilleHousing ] a
Join PortfolioProjet1.dbo.[NashvilleHousing ] b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


----------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProjet1.dbo.[NashvilleHousing ]
--where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress,1, charindex(',' ,PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress,charindex(',' ,PropertyAddress )+1, LEN(PropertyAddress)) as address

From PortfolioProjet1.dbo.[NashvilleHousing ]

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update [NashvilleHousing ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, charindex(',' ,PropertyAddress)-1)



ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update [NashvilleHousing ]
SET PropertySplitCity = SUBSTRING(PropertyAddress,charindex(',' ,PropertyAddress )+1, LEN(PropertyAddress))




Select *
From PortfolioProjet1.dbo.[NashvilleHousing ]





Select OwnerAddress
From PortfolioProjet1.dbo.[NashvilleHousing ]


Select
PARSENAME (REPLACE(OwnerAddress, ',','.') ,3),
PARSENAME (REPLACE(OwnerAddress, ',','.') ,2),
PARSENAME (REPLACE(OwnerAddress, ',','.') ,1)
From PortfolioProjet1.dbo.[NashvilleHousing ]


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update [NashvilleHousing ]
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress, ',','.') ,3)




ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update [NashvilleHousing ]
SET OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress, ',','.') ,2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update [NashvilleHousing ]
SET OwnerSplitState = PARSENAME (REPLACE(OwnerAddress, ',','.') ,1)




Select *
From PortfolioProjet1.dbo.[NashvilleHousing ]


----------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProjet1.dbo.[NashvilleHousing ]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
,Case When  SoldAsVacant = 'Y' Then   'Yes'
      When  SoldAsVacant = 'N' Then   'No'
	  Else  SoldAsVacant
	 END
From PortfolioProjet1.dbo.[NashvilleHousing ]

Update [NashvilleHousing ] 
SET SoldAsVacant = Case When  SoldAsVacant = 'Y' Then   'Yes'
      When  SoldAsVacant = 'N' Then   'No'
	  Else  SoldAsVacant
	 END



----------------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates
With RowNumCTE AS(
Select *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				    UniqueID
					) row_num

From PortfolioProjet1.dbo.[NashvilleHousing ]

)

DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


----------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select *
From PortfolioProjet1.dbo.[NashvilleHousing ]


ALTER TABLE PortfolioProjet1.dbo.[NashvilleHousing ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProjet1.dbo.[NashvilleHousing ]
DROP COLUMN SaleDate