select * from HouseNashville


--Standardize Date Format

select saledate,SaledateConverted
from HouseNashville

Update HouseNashville set
SaledateConverted = CONVERT(date,saledate)

Alter table HouseNashville
Add SaleDateConverted date

--Populate Property Address data

Select *
from HouseNashville
--where Propertyaddress is not null
order by parcelid

 select h.parcelid,h.propertyaddress,v.parcelid,v.propertyaddress,
 ISNULL(h.propertyaddress,v.propertyaddress)
 from HouseNashville h
 join HouseNashville v
 on h.uniqueid <> v.uniqueid
 and h.parcelid = v.parcelid
 where h.propertyaddress is null

 Update h
 set propertyaddress = ISNULL(h.propertyaddress,v.propertyaddress)
 from HouseNashville h
 join HouseNashville v
 on h.uniqueid <> v.uniqueid
 and h.parcelid = v.parcelid
 where h.propertyaddress is null

 --Breaking out address into individual Columns (Address, City , State)

 select propertyaddress 
 from HouseNashville

 Select SUBSTRING(propertyaddress,1,CHARINDEX(',',Propertyaddress) -1) as Address,
 SUBSTRING(propertyaddress,CHARINDEX(',',Propertyaddress) +1, LEN(Propertyaddress)) as Address
 from HouseNashville

 Update HouseNashville
 set propertySplitAddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',Propertyaddress) -1)
 
 Alter table HouseNashville
 Add propertySplitAddress Nvarchar(255)

 Alter table HouseNashville
 Add propertyCityAddress Nvarchar(255)

 Update  HouseNashville
 set propertyCityAddress = SUBSTRING(propertyaddress,CHARINDEX(',',Propertyaddress) +1, LEN(Propertyaddress))

 select Owneraddress from HouseNashville

 select PARSENAME(REPLACE(owneraddress,',','.'),3),
 PARSENAME(REPLACE(owneraddress,',','.'),2),
 PARSENAME(REPLACE(owneraddress,',','.'),1)
 from HouseNashville

 Alter table HouseNashville
 add OwnerSplitaddress nvarchar(255)

 Alter table HouseNashville
 add OwnerSplitCity nvarchar(255)

 Alter table HouseNashville
 add OwnerSplitState nvarchar(255)

 Update HouseNashville
 set OwnerSplitaddress = PARSENAME(REPLACE(owneraddress,',','.'),3)

 Update HouseNashville
 set OwnerSplitCity = PARSENAME(REPLACE(owneraddress,',','.'),2)

 Update HouseNashville
 set OwnerSplitState = PARSENAME(REPLACE(owneraddress,',','.'),1)

 --Change Y and N to Yes and No in "Solid as Vacant" field

 select distinct(SoldASVacant), Count(SoldASVacant)
 from HouseNashville
 group by SoldASVacant
 order by 2 


 Select SoldASVacant,
 Case when SoldASVacant = 'Y' Then 'Yes'
	  When SoldASVacant = 'N' Then 'No'
	  Else SoldASVacant 
 End
 from HouseNashville

 Update HouseNashville
 set SoldASVacant = 
 Case when SoldASVacant = 'Y' Then 'Yes'
	  When SoldASVacant = 'N' Then 'No'
	  Else SoldASVacant 
 End

 --Removing Duplicates 

with rownumbercte as (
 select *,
 ROW_NUMBER() over (
 partition by parcelid,
			propertyaddress,
			Saleprice,
			saledate,
			legalreference
			order by uniqueid
) row_num
from HouseNashville 
--order by uniqueid
)
select * 
from rownumbercte

--Delete unused Columns

Alter table Housenashville
drop column owneraddress,propertyaddress,taxdistrict

Alter table Housenashville
drop column saledate