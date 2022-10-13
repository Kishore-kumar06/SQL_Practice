CREATE DATABASE IF NOT EXISTS `lco_car_rentals` DEFAULT CHARACTER SET utf8 ;
USE `lco_car_rentals` ;

CREATE TABLE `customer` (
  `id` int(11) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `dob` date NOT NULL,
  `driver_license_number` varchar(12) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `customer` (`id`, `first_name`, `last_name`, `dob`, `driver_license_number`, `email`, `phone`) VALUES
(1, 'Kelby', 'Matterdace', '1974-05-22', 'V435899293', 'kmatterdace0@oracle.com', '181-441-7828'),
(2, 'Orion', 'De Hooge', '1992-08-07', 'Z140530509', 'odehooge1@quantcast.com', '948-294-5458'),
(3, 'Sheena', 'Macias', '1981-03-10', 'W045654959', 'smacias3@amazonaws.com', NULL),
(4, 'Irving', 'Packe', '1994-12-19', 'O232196823', 'ipacke4@cbc.ca', '157-815-8064'),
(5, 'Kass', 'Humphris', '1993-12-16', 'G055017319', 'khumphris5@xrea.com', '510-624-4189');

DELIMITER $$
CREATE TRIGGER `age_check` BEFORE INSERT ON `customer` FOR EACH ROW BEGIN
DECLARE age INT UNSIGNED;
SELECT TIMESTAMPDIFF(YEAR, new.dob, CURDATE()) INTO age FROM DUAL;
    IF (age < 21) THEN
    SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'customer age_check constraint on customer.dob failed';
    END IF;
END
$$
DELIMITER ;

CREATE TABLE `equipment` (
  `id` int(11)  NOT NULL,
  `name` varchar(45) NOT NULL,
  `equipment_type_id` int(11) UNSIGNED NOT NULL,
  `current_location_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `equipment` (`id`, `name`, `equipment_type_id`, `current_location_id`) VALUES
(1, 'Garmin GPS', 1, 5),
(2, 'Tomtom GPS', 1, 6),
(3, 'Tomtom GPS', 1, 7),
(4, 'Infant Child Seat', 3, 1),
(5, 'Child Seat', 3, 7),
(6, 'Booster Seat', 3, 1),
(7, 'Sirius XM Satellite Radio', 2, 5),
(8, 'Sirius XM Satellite Radio', 2, 6);

CREATE TABLE `equipment_type` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `rental_value` decimal(13,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `equipment_type` (`id`, `name`, `rental_value`) VALUES
(1, 'GPS', '14.99'),
(2, 'Satellite Radio', '7.99'),
(3, 'Child Safety Seats', '13.99');

CREATE TABLE `fuel_option` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `fuel_option` (`id`, `name`, `description`) VALUES
(1, 'Pre-pay', 'Customer pays in advance for a full tank of fuel, so they can return back with an empty tank of fuel, without the hassle of last minute stops and purchasing the fuel.'),
(2, 'Self-Service', 'Customer will get full tank of fuel with the rental car and must return it back with the full tank of fuel.'),
(3, 'Market', 'Customer gets the car with full tank of fuel but pays for fuel at market price based on fuel usage.  ');

CREATE TABLE `insurance` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `cost` decimal(13,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `insurance` (`id`, `name`, `cost`) VALUES
(1, 'Cover The Car (LDW)', '30.99'),
(2, 'Cover Myself (PAI)', '7.00'),
(3, 'Cover My Belongings (PEP)', '2.95'),
(4, 'Cover My Liability (ALI)', '16.50');

CREATE TABLE `location` (
  `id` int(11) NOT NULL,
  `street_address` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(2) NOT NULL,
  `zipcode` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `location` (`id`, `street_address`, `city`, `state`, `zipcode`) VALUES
(1, '1001 Henderson St', 'Fort Worth', 'TX', 76102),
(2, '300 Reunion Blvd', 'Dallas', 'TX', 75207),
(3, '5911 Blair Rd NW', 'Washington', 'DC', 20011),
(4, '9217 Airport Blvd', 'Los Angeles', 'CA', 90045),
(5, '310 E 64th St', 'New York', 'NY', 10021),
(6, '1011 Pike St', 'Seattle', 'WA', 98101),
(7, '5150 W 55th St', 'Chicago', 'IL', 60638);

CREATE TABLE `rental` (
  `id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `customer_id` int(11) UNSIGNED NOT NULL,
  `vehicle_type_id` int(11) UNSIGNED NOT NULL,
  `fuel_option_id` int(11) UNSIGNED NOT NULL,
  `pickup_location_id` int(11) UNSIGNED NOT NULL,
  `drop_off_location_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `rental` (`id`, `start_date`, `end_date`, `customer_id`, `vehicle_type_id`, `fuel_option_id`, `pickup_location_id`, `drop_off_location_id`) VALUES
(1, '2018-07-14', '2018-07-23', 1, 2, 1, 3, 5),
(2, '2018-07-10', '2018-07-12', 2, 1, 2, 1, 2),
(3, '2018-06-30', '2018-07-20', 3, 1, 3, 4, 6),
(4, '2018-06-10', '2018-07-02', 4, 4, 2, 2, 7),
(5, '2018-07-14', '2018-07-27', 5, 3, 3, 5, 3);

CREATE TABLE `rental_has_equipment_type` (
  `rental_id` int(11) UNSIGNED NOT NULL,
  `equipment_type_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `rental_has_equipment_type` (`rental_id`, `equipment_type_id`) VALUES
(1, 1),
(1, 2),
(3, 1),
(3, 2),
(4, 1),
(4, 3);

CREATE TABLE `rental_has_insurance` (
  `rental_id` int(11) UNSIGNED NOT NULL,
  `insurance_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `rental_has_insurance` (`rental_id`, `insurance_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4),
(3, 1),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(5, 1);

CREATE TABLE `rental_invoice` (
  `id` int(10) UNSIGNED NOT NULL,
  `car_rent` decimal(13,2) UNSIGNED NOT NULL,
  `equipment_rent_total` decimal(13,2) UNSIGNED DEFAULT NULL,
  `insurance_cost_total` decimal(13,2) UNSIGNED DEFAULT NULL,
  `tax_surcharges_and_fees` decimal(13,2) UNSIGNED NOT NULL,
  `total_amount_payable` decimal(13,2) UNSIGNED NOT NULL,
  `discount_amount` decimal(13,2) UNSIGNED DEFAULT NULL,
  `net_amount_payable` decimal(13,2) UNSIGNED NOT NULL,
  `rental_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `rental_invoice` (`id`, `car_rent`, `equipment_rent_total`, `insurance_cost_total`, `tax_surcharges_and_fees`, `total_amount_payable`, `discount_amount`, `net_amount_payable`, `rental_id`) VALUES
(1, '265.05', '206.82', '368.46', '73.99', '914.32', '79.52', '834.81', 1),
(2, '53.54', '0.00', '94.98', '23.22', '171.74', '0.00', '171.74', 2),
(3, '535.40', '459.60', '619.80', '169.98', '1784.78', '160.62', '1624.16', 3),
(4, '824.56', '637.56', '1263.68', '503.34', '3229.14', '274.37', '2981.77', 4),
(5, '452.53', '0.00', '402.87', '234.76', '1090.16', '135.76', '954.40', 5);

CREATE TABLE `vehicle` (
  `id` int(11) NOT NULL,
  `brand` varchar(45) NOT NULL,
  `model` varchar(45) NOT NULL,
  `model_year` year(4) NOT NULL,
  `mileage` int(9) NOT NULL,
  `color` varchar(45) NOT NULL,
  `vehicle_type_id` int(11) UNSIGNED NOT NULL,
  `current_location_id` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `vehicle` (`id`, `brand`, `model`, `model_year`, `mileage`, `color`, `vehicle_type_id`, `current_location_id`) VALUES
(1, 'Nissan', 'Versa', 2016, 65956, 'white', 1, 1),
(2, 'Mitsubishi', 'Mirage', 2017, 55864, 'light blue', 1, 6),
(3, 'Chevrolet', 'Cruze', 2017, 45796, 'dark gray', 2, 5),
(4, 'Hyundai', 'Elantra', 2018, 35479, 'black', 2, 1),
(5, 'Volkswagen', 'Jetta', 2019, 2032, 'light gray', 3, 3),
(6, 'Toyota', 'RAV4', 2018, 12566, 'white', 4, 7);

CREATE TABLE `vehicle_has_equiment` (
  `equipment_id` int(11) UNSIGNED NOT NULL,
  `vehicle_id` int(11) UNSIGNED NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `vehicle_has_equiment` (`equipment_id`, `vehicle_id`, `start_date`, `end_date`) VALUES
(1, 3, '2018-07-14', '2018-07-23'),
(2, 2, '2018-06-15', '2018-07-20'),
(3, 6, '2018-06-09', '2018-07-02'),
(5, 6, '2018-06-09', '2018-07-02'),
(7, 3, '2018-07-14', '2018-07-23'),
(8, 2, '2018-06-15', '2018-07-20');

CREATE TABLE `vehicle_type` (
  `id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `rental_value` decimal(13,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `vehicle_type` (`id`, `name`, `rental_value`) VALUES
(1, 'Economy', '26.77'),
(2, 'Intermediate', '29.45'),
(3, 'Standard', '34.81'),
(4, 'Economy SUV', '37.48');

ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`) ,
  ADD UNIQUE KEY `driver_license_number_UNIQUE` (`driver_license_number`),
  ADD UNIQUE KEY `email_UNIQUE` (`email`);
  
  ALTER TABLE `equipment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_equipment_equipment_type` (`equipment_type_id`),
  ADD KEY `fk_equipment_location` (`current_location_id`);
  
  ALTER TABLE `equipment_type`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `fuel_option`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `insurance`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `location`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `zipcode_UNIQUE` (`zipcode`);

ALTER TABLE `rental`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rental_customer_idx` (`customer_id`),
  ADD KEY `fk_rental_fuel_option_idx` (`fuel_option_id`),
  ADD KEY `fk_rental_pickup_location_idx` (`pickup_location_id`),
  ADD KEY `fk_rental_dropoff_location_idx` (`drop_off_location_id`),
  ADD KEY `fk_rental_vehicle_type_idx` (`vehicle_type_id`);

ALTER TABLE `rental_has_equipment_type`
  ADD PRIMARY KEY (`rental_id`,`equipment_type_id`),
  ADD KEY `fk_rental_has_equipment_type_equipment_type_idx` (`equipment_type_id`),
  ADD KEY `fk_rental_has_equipment_type_rental_idx` (`rental_id`);

ALTER TABLE `rental_has_insurance`
  ADD PRIMARY KEY (`rental_id`,`insurance_id`),
  ADD KEY `fk_rental_has_insurance_insurance_idx` (`insurance_id`),
  ADD KEY `fk_rental_has_insurance_rental_idx` (`rental_id`);

ALTER TABLE `rental_invoice`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_rental_invoice_rental_idx` (`rental_id`);

ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_vehicle_vehicle_type` (`vehicle_type_id`),
  ADD KEY `fk_vehicle_current_location` (`current_location_id`);

ALTER TABLE `vehicle_has_equiment`
  ADD PRIMARY KEY (`equipment_id`,`vehicle_id`),
  ADD KEY `fk_equipment_has_vehicle_vehicle_idx` (`vehicle_id`),
  ADD KEY `fk_equipment_has_vehicle_equipment_idx` (`equipment_id`);

ALTER TABLE `vehicle_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

ALTER TABLE `rental_invoice`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

ALTER TABLE `customer`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

ALTER TABLE `equipment`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

ALTER TABLE `equipment_type`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `fuel_option`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

ALTER TABLE `insurance`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

ALTER TABLE `location`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

ALTER TABLE `rental`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

ALTER TABLE `vehicle`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

ALTER TABLE `vehicle_type`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;


ALTER TABLE `equipment`
  ADD CONSTRAINT `fk_equipment_equipment_type` FOREIGN KEY (`equipment_type_id`) REFERENCES `equipment_type` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_equipment_location` FOREIGN KEY (`current_location_id`) REFERENCES `location` (`id`) ON UPDATE CASCADE;

ALTER TABLE `rental`
  ADD CONSTRAINT `fk_rental_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rental_dropoff_location` FOREIGN KEY (`drop_off_location_id`) REFERENCES `location` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rental_fuel_option` FOREIGN KEY (`fuel_option_id`) REFERENCES `fuel_option` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rental_pickup_location` FOREIGN KEY (`pickup_location_id`) REFERENCES `location` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rental_vehicle_type` FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicle_type` (`id`) ON UPDATE CASCADE;


ALTER TABLE `rental_has_equipment_type`
  ADD CONSTRAINT `fk_rental_has_equipment_type_equipment_type` FOREIGN KEY (`equipment_type_id`) REFERENCES `equipment_type` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rental_has_equipment_type_rental` FOREIGN KEY (`rental_id`) REFERENCES `rental` (`id`) ON UPDATE CASCADE;

ALTER TABLE `rental_has_insurance` 
  ADD CONSTRAINT `fk_rental_has_insurance_insurance` FOREIGN KEY (`insurance_id`) REFERENCES `insurance` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rental_has_insurance_rental` FOREIGN KEY (`rental_id`) REFERENCES `rental` (`id`) ON UPDATE CASCADE;

ALTER TABLE `rental_invoice`
  ADD CONSTRAINT `fk_rental_invoice_rental` FOREIGN KEY (`rental_id`) REFERENCES `rental` (`id`) ON UPDATE CASCADE;

ALTER TABLE `vehicle`
  ADD CONSTRAINT `fk_vehicle_current_location` FOREIGN KEY (`current_location_id`) REFERENCES `location` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_vehicle_vehicle_type` FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicle_type` (`id`) ON UPDATE CASCADE;


ALTER TABLE `vehicle_has_equiment`
  ADD CONSTRAINT `fk_equipment_has_vehicle_equipment` FOREIGN KEY (`equipment_id`) REFERENCES `equipment` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_equipment_has_vehicle_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicle` (`id`) ON UPDATE CASCADE;
COMMIT;

# for references
show tables;
select * from customer;
select * from equipment;
select * from equipment_type;
select * from fuel_option;
select * from insurance;
select * from location;
select * from rental;
select * from rental_has_equipment_type;
select * from rental_has_insurance;
select * from rental_invoice;
select * from vehicle;
select * from vehicle_has_equiment;
select * from vehicle_type;

# questions and answers
/* Q1) Insert the details of new customer?
First name : Nancy
Last Name: Perry
Dob : 1988-05-16
License Number: K59042656E
Email : nancy@gmail.com */ 
Insert into customer values(6,"Nancy","Perry","1988-05-16","K59042656E","nancy@gmail.ccom",NULL);

/* Q2) The new customer (inserted above) wants to rent a car from 2020-08-25 to 2020-08-30. More details are as follows:
Vehicle Type : Economy SUV
Fuel Option : Market
Pick Up location: 5150 W 55th St , Chicago, IL, zip- 60638
Drop Location: 9217 Airport Blvd, Los Angeles, CA, zip - 90045
*/
Insert into rental values(6,"2020-08-25","2020-08-30",(select id from customer where first_name = "Nancy" and last_name = "Perry"),(select id from vehicle_type where `name` = "Economy SUV"),
(select id from fuel_option where `name` = "Market"),(select id from location where id = 7),(select id from location where id = 4));

/*Q3) The customer with the driving license W045654959 changed his/her drop off location to 1001 Henderson St,  Fort Worth, TX, zip - 76102 
 and wants to extend the rental upto 4 more days. Update the record?
*/
update rental inner join location on location.id = rental.drop_off_location_id set drop_off_location_id = (select id from location where street_address = "1001 Henderson St") where rental.customer_id = 3 and rental.end_date = (end_date + 4);

# Q4) Fetch all rental details with their equipment type?
select rental.*,equipment_type.`name` from rental inner join rental_has_equipment_type on rental_has_equipment_type.rental_id = rental.id 
inner join equipment_type on equipment_type.id = rental_has_equipment_type.equipment_type_id;

# Q5) Fetch all details of vehicles?
select  vehicle.brand,vehicle.model,vehicle.model_year,vehicle.color,vehicle_type.`name`,vehicle_type.rental_value,vehicle_has_equiment.start_date,vehicle_has_equiment.end_date,equipment.`name` from vehicle left outer join vehicle_type on vehicle_type.id = vehicle.vehicle_type_id 
left outer join vehicle_has_equiment on vehicle_has_equiment.vehicle_id = vehicle.id left outer join equipment on equipment.id = vehicle_has_equiment. equipment_id;

# Q6) Get driving license of the customer with most rental insurances?
select customer.driver_license_number, count(customer.driver_license_number) as Most_rental_insurance from customer inner join rental on rental.customer_id = customer.id inner join rental_has_insurance on rental_has_insurance.rental_id = rental.id inner join insurance on insurance.id = rental_has_insurance.insurance_id where rental_has_insurance.insurance_id group by customer.driver_license_number order by count(customer.driver_license_number) desc limit 1;

/* Q7) Insert a new equipment type with following details?
Name : Mini TV
Rental Value : 8.99
*/
insert into equipment_type values(4,"Mini TV","8.99");

/*Q8) Insert a new equipment with following details?
Name : Garmin Mini TV
Equipment type : Mini TV
Current Location zip code : 60638
*/
insert into equipment values (9,"Garmin Mini TV",(select id from equipment_type where `name` = "Mini TV"),(select id from location where zipcode = 60638));

# Q9) Fetch rental invoice for customer (email: smacias3@amazonaws.com)?
select rental_invoice.*,customer.email from rental_invoice inner join rental on rental.id = rental_invoice.rental_id inner join customer on customer.id = rental.customer_id where customer.email = "smacias3@amazonaws.com"; ;

/*Q10) Insert the invoice for customer (driving license: ) with following details:-
Car Rent : 785.4
Equipment Rent : 114.65
Insurance Cost : 688.2
Tax : 26.2
Total: 1614.45
Discount : 213.25
Net Amount: 1401.2
*/
INSERT INTO `rental_invoice` (`id`, `car_rent`, `equipment_rent_total`, `insurance_cost_total`, `tax_surcharges_and_fees`, `total_amount_payable`, `discount_amount`, `net_amount_payable`, `rental_id`) VALUES
(6, '785.4', '114.65', '688.2', '26.2', '1614.45', '213.25', '1401.2', (select rental.id from rental inner join customer on customer.id=rental.customer_id where customer.driver_license_number = "K59042656E" ));

# Q11) Which rental has the most number of equipment?
select rental_id, count(rental_id) as number_of_equipment_type  from rental_has_equipment_type group by rental_id order by count(rental_id) desc limit 1;

# Q12) Get driving license of a customer with least number of rental licenses?
select customer.driver_license_number, count(customer.driver_license_number) as least_number_of_rental from customer inner join rental on rental.customer_id = customer.id group by customer.driver_license_number order by count(customer.driver_license_number);

/* Q13) Insert new location with following details.
Street address : 1460  Thomas Street
City : Burr Ridge , State : IL, Zip - 61257
*/
Insert into location values(8,"1460  Thomas Street","Burr Ridge","IL",61257);

/*Q14) Add the new vehicle with following details:-
Brand: Tata 
Model: Nexon
Model Year : 2020
Mileage: 17000
Color: Blue
Vehicle Type: Economy SUV 
Current Location Zip: 20011 
*/
Insert into vehicle values(7,"Tata","Nexon",2020,17000,"Blue",(select id from vehicle_type where `name` = "Economy SUV"),(select id from location where zipcode = "20011"));

# Q15) Insert new vehicle type Hatchback and rental value: 33.88?
insert into vehicle_type values(5,"Hatchback","33.88");

# Q16) Add new fuel option Pre-paid (refunded)?
insert into fuel_option values(4,"Pre-paid ","refunded");

# Q17) Assign the insurance : Cover My Belongings (PEP), Cover The Car (LDW) to the rental started on 25-08-2020 (created in Q2) by customer (Driving License:K59042656E)?
insert into rental_has_insurance values((select id from rental where start_date = "2020-08-25"),(select id from insurance where `name` = "Cover My Belongings (PEP)")),(
(select id from customer where  driver_license_number = "K59042656E"),(select id from insurance where `name` = "Cover The Car (LDW)"));

# Q18) Remove equipment_type :Satellite Radio from rental started on 2018-07-14 and ended on 2018-07-23?
 delete from rental_has_equipment_type where rental_id = (select id from rental where start_date = "2018-07-14" and end_date = "2018-07-23") and  equipment_type_id = (select id from equipment_type where `name` = "Satellite Radio");

# Q19) Update phone to 510-624-4188 of customer (Driving License: K59042656E)?
update customer set phone = "510-624-4188" where driver_license_number = "K59042656E";

# Q20) Increase the insurance cost of Cover The Car (LDW) by 5.65?
update insurance set cost = (cost + 5.65) where id = 1;

# Q21) Increase the rental value of all equipment types by 11.25?
update equipment_type set rental_value = (rental_value + 11.25);

# Q22) Increase the  cost of all rental insurances except Cover The Car (LDW) by twice the current cost?
update insurance set cost = (cost * 2) where `name` != "Cover The Car (LDW)";

# Q23) Fetch the maximum net amount of invoice generated?
select max(net_amount_payable) from rental_invoice;

# Q24) Update the dob of customer with driving license V435899293 to 1977-06-22?
update customer set dob = "1977-06-22" where driver_license_number = "V435899293";

/*Q25)  Insert new location with following details.
Street address : 468  Jett Lane
City : Gardena , State : CA, Zip - 90248 */
Insert into location values(9,"468  Jett Lane","Gardena","CA",90248);

/*Q26) The new customer (Driving license: W045654959) wants to rent a car from 2020-09-15 to 2020-10-02. More details are as follows: 
Vehicle Type : Hatchback
Fuel Option : Pre-paid (refunded)
Pick Up location:  468  Jett Lane , Gardena , CA, zip- 90248
Drop Location: 5911 Blair Rd NW, Washington, DC, zip - 20011
*/
Insert into rental values(7,"2020-09-15 ","2020-10-02",(select id from customer where driver_license_number = "W045654959"),(select id from vehicle_type where `name` = "Hatchback"),
(select id from fuel_option where `name` = "Pre-paid"),(select id from location where zipcode = 90248),(select id from location where zipcode = 20011));

# Q27) Replace the driving license of the customer (Driving License: G055017319) with new one K16046265?
update customer set driver_license_number = "K16046265" where driver_license_number = "G055017319";


# Q28) Calculated the total sum of all insurance costs of all rentals?
select sum(cost) as total_insurance_cost from rental_has_insurance inner join insurance on insurance.id = rental_has_insurance.insurance_id ;

# Q29) How much discount we gave to customers in total in the rental invoice?
select sum(discount_amount) as total_discount from rental_invoice;

# Q30) The Nissan Versa has been repainted to black. Update the record?
update vehicle set color = "black" where brand = "Nissan";
