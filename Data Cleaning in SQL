SELECT *
FROM NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

/* Convert the timestamp listed in the SaleDate column to a date.

The sale date in the "SaleDate" column is listed as a timestamp, although the hh:mm:ss part does not add any new information (it's always stated as 00:00:00.000). It will therefore be removed, and the timestamp will be replaced with the date in the yyyy-mm-dd format.*/

/*Adding a new column called SaleDateStandardized which will store the date.*/

ALTER TABLE NashvilleHousing
ADD SaleDateStandardized date;

/*Using the CAST function to convert the timestamp stored in the SaleDate column into a date and storing it in the SaleDateStandardized column.*/
UPDATE NashvilleHousing
SET SaleDateStandardized = CAST(SaleDate AS date);

--------------------------------------------------------------------------------------------------------------------------

/*Populate missing Property Address data*/

/*The Property Address data for certain rows (properties) are missing. However, it is observed that rows with the same ParcelID have the same PropertyAddress. Using this relationship, in scenarios where the Property  Address of a row is missing, it is populated with the Property Address of a row with which it shares the same ParcelID.*/

/*Performing a self-join on the NashvilleHousing table by joining rows with different UniqueIDs but the same ParcelIDs, and using the ISNULL function, to create a column to populate the Property Address value of rows that are missing it.*/

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--------------------------------------------------------------------------------------------------------------------------

/*Separating PropertyAddress column, which contains the Street Address and the City as a single string, into 2 separate columns which store them separately*/

SELECT *
FROM NashvilleHousing;

/*Extracting the Street Address and the City values from the PropertyAddress column and storing them in 2 new columns*/

SELECT
PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 ) AS StreetAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS CityAddress
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD StreetAddress nvarchar(255);

UPDATE NashvilleHousing
SET StreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 );

ALTER TABLE NashvilleHousing
ADD CityAddress nvarchar(255);

UPDATE NashvilleHousing
SET CityAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

--------------------------------------------------------------------------------------------------------------------------

/*Separating OwnerAddress column, which contains the Street Address, City, and State, as a single string, into 3 separate columns, which stores those values separately*/

/*Using the PARSENAME function to extract the Street Address, City, and State values from the OwnerAddress column*/
SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerStreetAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerCityAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerStateAddress
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerStreetAddress nvarchar(255);

ALTER TABLE NashvilleHousing
ADD OwnerCityAddress nvarchar(255);

ALTER TABLE NashvilleHousing
ADD OwnerStateAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);


UPDATE NashvilleHousing
SET OwnerCityAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);


UPDATE NashvilleHousing
SET OwnerStateAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

--------------------------------------------------------------------------------------------------------------------------

