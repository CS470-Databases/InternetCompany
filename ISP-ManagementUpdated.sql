DROP SCHEMA ISP_MANAGEMENT;

CREATE SCHEMA ISP_MANAGEMENT;

CREATE TABLE ISP_MANAGEMENT.PAYMENT
(
	PaymentID		INT		NOT NULL,
	TotalReceived		DECIMAL(5,2)	NOT NULL,
	PaymentDate		DATE		NOT NULL,
	PaymentTime		TIME		NOT NULL,
	ReferenceNumber		CHAR(9),
	Pay_Overdue		DECIMAL(5,2),
	InvoiceID		INT		NOT NULL,
	EmployeeID		INT		NOT NULL
);

ALTER TABLE ISP_MANAGEMENT.PAYMENT
	ADD PRIMARY KEY (PaymentID);

CREATE TABLE ISP_MANAGEMENT.INVOICE
(
	InvoiceID		INT		NOT NULL,
	LineItem		CHAR(25),
	SalesTax		DECIMAL(5,2),
	InvoiceDate		DATE		NOT NULL,
	InvoiceTime		TIME		NOT NULL,
	Total			DECIMAL(5,2)	NOT NULL,
	SubTotal		DECIMAL(5,2)	NOT NULL,
	Quantity		INT		NOT NULL,
	QuoteFlag		BOOLEAN,
	Inv_Overdue		DECIMAL(5,2),
	CustomerID		INT		NOT NULL,
	EmployeeID		INT		NOT NULL
);

ALTER TABLE ISP_MANAGEMENT.INVOICE
	ADD PRIMARY KEY (InvoiceID);

ALTER TABLE ISP_MANAGEMENT.PAYMENT 
	ADD FOREIGN KEY (InvoiceID)
	REFERENCES ISP_MANAGEMENT.INVOICE(InvoiceID);

CREATE TABLE ISP_MANAGEMENT.PRODUCT
(
	ProductID		INT		NOT NULL,
	Prod_Name		VARCHAR(25)	NOT NULL,
	Prod_Price		DECIMAL(4,2)	NOT NULL,
	Prod_Type		VARCHAR(7)	NOT NULL,
	Prod_Description	VARCHAR(140),
	Prod_Quantity		INT		NOT NULL
);

ALTER TABLE ISP_MANAGEMENT.PRODUCT
	ADD PRIMARY KEY (ProductID);

CREATE TABLE ISP_MANAGEMENT.CUSTOMER
(
	CustomerID		INT		NOT NULL,
	Cust_FirstName		VARCHAR(20)	NOT NULL,
	Cust_LastName		VARCHAR(20)	NOT NULL,
	BillingAddress		VARCHAR(50)	NOT NULL,
	Cust_Email		VARCHAR(35),
	ReferralSource		VARCHAR(20),
	Username		VARCHAR(30)	NOT NULL,
	Password		VARCHAR(30)	NOT NULL,
	Cust_StartDate		DATE		NOT NULL,
	UNIQUE(Username)
);


ALTER TABLE ISP_MANAGEMENT.CUSTOMER 
	ADD PRIMARY KEY (CustomerID);

ALTER TABLE ISP_MANAGEMENT.INVOICE 
	ADD FOREIGN KEY (CustomerID)
	REFERENCES ISP_MANAGEMENT.CUSTOMER(CustomerID);

USE ISP_MANAGEMENT; 

CREATE TABLE ISP_MANAGEMENT.INVENTORY
(
	ItemID			INT		NOT NULL,
	ProductID		INT		NOT NULL,
	ShipmentID		INT		NOT NULL,
	VendorID		INT 		NOT NULL	
);

ALTER TABLE ISP_MANAGEMENT.INVENTORY
	ADD FOREIGN KEY (ProductID) 
	REFERENCES ISP_MANAGEMENT.PRODUCT (ProductID);

ALTER TABLE ISP_MANAGEMENT.INVENTORY
	ADD PRIMARY KEY (ItemID);

CREATE TABLE ISP_MANAGEMENT.EMPLOYEE
(
	EmployeeID		INT		NOT NULL,
	Emp_FirstName		VARCHAR(20)	NOT NULL,
	Emp_LastName		VARCHAR(20)	NOT NULL,
	SSN			CHAR(9)		NOT NULL,
	DOB			DATE,
	Emp_Email		VARCHAR(35),
	Emp_Address		VARCHAR(50),
	Emp_Phone		CHAR(10),
	Role			VARCHAR(50)	NOT NULL,
	Salary			INT		NOT NULL,
	Emp_StartDate		DATE		NOT NULL,
	Emp_EndDate		DATE,
	ManagerID		INT		NOT NULL,
	DepartmentID		INT		NOT NULL,
	UNIQUE(SSN)
);


ALTER TABLE ISP_MANAGEMENT.EMPLOYEE 
	ADD PRIMARY KEY (EmployeeID);

ALTER TABLE ISP_MANAGEMENT.EMPLOYEE 
	ADD FOREIGN KEY (ManagerID)
	REFERENCES ISP_MANAGEMENT.EMPLOYEE(EmployeeID);
	
ALTER TABLE ISP_MANAGEMENT.PAYMENT 
	ADD FOREIGN KEY (EmployeeID)
	REFERENCES ISP_MANAGEMENT.EMPLOYEE(EmployeeID);
	
ALTER TABLE ISP_MANAGEMENT.INVOICE 
	ADD FOREIGN KEY (EmployeeID)
	REFERENCES ISP_MANAGEMENT.EMPLOYEE(EmployeeID);

CREATE TABLE ISP_MANAGEMENT.TICKET
(
	TicketID		INT		NOT NULL,
	Category		VARCHAR(20),
	TicketDate		DATE		NOT NULL,
	TicketTime		TIME,
	Solved			BOOLEAN		NOT NULL,
	Problem			VARCHAR(140)	NOT NULL,
	CustomerID		INT		NOT NULL,
	TicketOwnerID		INT		NOT NULL
);


ALTER TABLE ISP_MANAGEMENT.TICKET
	ADD FOREIGN KEY (CustomerID) REFERENCES ISP_MANAGEMENT.CUSTOMER(CustomerID);

ALTER TABLE ISP_MANAGEMENT.TICKET
	ADD FOREIGN KEY (TicketOwnerID) REFERENCES EMPLOYEE(EmployeeID);

ALTER TABLE ISP_MANAGEMENT.TICKET
	ADD PRIMARY KEY (TicketID);

CREATE TABLE ISP_MANAGEMENT.DEPARTMENT
(
	DepartmentID		INT		NOT NULL,
	NumberOfEmployees	INT		NOT NULL,
	Dept_Name		VARCHAR(25)	NOT NULL,
	Dept_StartDate		DATE		NOT NULL,	
	ManagerID		INT		NOT NULL,
	UNIQUE(Dept_Name)
);

ALTER TABLE ISP_MANAGEMENT.DEPARTMENT
	ADD FOREIGN KEY (ManagerID) REFERENCES EMPLOYEE(ManagerID);

ALTER TABLE ISP_MANAGEMENT.DEPARTMENT 
	ADD PRIMARY KEY (DepartmentID);

ALTER TABLE ISP_MANAGEMENT.EMPLOYEE 
	ADD FOREIGN KEY (DepartmentID)
	REFERENCES ISP_MANAGEMENT.DEPARTMENT(DepartmentID);

CREATE TABLE ISP_MANAGEMENT.SERVICE_CALL
(
	ServiceCallID		INT		NOT NULL,
	Summary			VARCHAR(140)	NOT NULL,
	Scheduled_Date		DATE,
	Scheduled_Time		TIME,
	Install_Date		DATE,
	Install_Time		TIME,
	Completion_Date		DATE,
	Completion_Time		TIME,
	TicketID		INT 		NOT NULL,
	EmployeeID		INT		NOT NULL
);

ALTER TABLE ISP_MANAGEMENT.SERVICE_CALL 
	ADD FOREIGN KEY (TicketID) REFERENCES TICKET(TicketID);

ALTER TABLE ISP_MANAGEMENT.SERVICE_CALL 
	ADD FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID);

ALTER TABLE ISP_MANAGEMENT.SERVICE_CALL 
	ADD PRIMARY KEY (ServiceCallID);

CREATE TABLE ISP_MANAGEMENT.SHIPMENT
(
	ShipmentID			INT		NOT NULL,
	Ship_Price			DECIMAL(4,2)	NOT NULL,
	Actual_ArrivalDate		DATE		NOT NULL,
	Estimated_ArrivalDate		DATE,
	Charge				DECIMAL(4,2)	NOT NULL,
	ProductID			INT		NOT NULL,
	VendorID			INT		NOT NULL,
	FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID)
);

ALTER TABLE ISP_MANAGEMENT.SHIPMENT 
	ADD FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID);

ALTER TABLE ISP_MANAGEMENT.SHIPMENT 
	ADD PRIMARY KEY (ShipmentID);

ALTER TABLE ISP_MANAGEMENT.INVENTORY 
	ADD FOREIGN KEY (ShipmentID)
	REFERENCES ISP_MANAGEMENT.SHIPMENT(ShipmentID);
	
CREATE TABLE ISP_MANAGEMENT.VENDOR
(
	VendorID			INT		NOT NULL,
	Vend_Phone			CHAR(10),
	Vend_Email			VARCHAR(35),
	Vend_Address			VARCHAR(50),
	State_Province			VARCHAR(25),
	Country				VARCHAR(25),
	Vend_Name			VARCHAR(25)	NOT NULL
);

ALTER TABLE ISP_MANAGEMENT.VENDOR 
	ADD PRIMARY KEY (VendorID);

ALTER TABLE ISP_MANAGEMENT.INVENTORY 
	ADD FOREIGN KEY (VendorID)
	REFERENCES ISP_MANAGEMENT.VENDOR(VendorID);

ALTER TABLE ISP_MANAGEMENT.SHIPMENT 
	ADD FOREIGN KEY (VendorID)
	REFERENCES ISP_MANAGEMENT.VENDOR(VendorID);
	
CREATE TABLE ISP_MANAGEMENT.SERVICE
(
	ServiceID			INT		NOT NULL,
	Serv_Name			VARCHAR(25)	NOT NULL,
	MonthlyPrice			DECIMAL(3,2)	NOT NULL,
	Type_Category			VARCHAR(20),
	PRIMARY KEY (ServiceID)
);

CREATE TABLE ISP_MANAGEMENT.EQUIPMENT
(
	EquipmentID			INT		NOT NULL,
	TowerNode			VARCHAR(10),
	Manufacturer			VARCHAR(25)	NOT NULL,
	Model				VARCHAR(20)	NOT NULL,
	MAC_Address			CHAR(12)	NOT NULL,
	IP_Address			CHAR(15)	NOT NULL,
	Netmask				VARCHAR(15)	NOT NULL,
	Gateway				VARCHAR(15),
	DNSPrimary			VARCHAR(15)	NOT NULL,
	DNSSecondary			VARCHAR(15),
	ServiceID			INT		NOT NULL
);

ALTER TABLE ISP_MANAGEMENT.EQUIPMENT 
	ADD FOREIGN KEY (ServiceID) REFERENCES SERVICE(ServiceID);

ALTER TABLE ISP_MANAGEMENT.EQUIPMENT 
	ADD PRIMARY KEY (EquipmentID);

CREATE TABLE ISP_MANAGEMENT.TICKET_RESPONSE
(
	TicketResp_Date			DATE		NOT NULL,
	TicketResp_Time			TIME		NOT NULL,
	TicketResp_Description		VARCHAR(140)	NOT NULL,
	EmployeeID			INT		NOT NULL,
	TicketID			INT		NOT NULL
);


ALTER TABLE ISP_MANAGEMENT.TICKET_RESPONSE 
	ADD FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID);

ALTER TABLE ISP_MANAGEMENT.TICKET_RESPONSE 
	ADD FOREIGN KEY (TicketID) REFERENCES TICKET(TicketID);

ALTER TABLE ISP_MANAGEMENT.TICKET_RESPONSE 
	ADD PRIMARY KEY (EmployeeID, TicketID, TicketResp_Date, TicketResp_Time);

CREATE TABLE ISP_MANAGEMENT.PRODUCT_INVOICED
(
	InvoiceID			INT		NOT NULL,		
	ProductID			INT		NOT NULL
);

ALTER TABLE ISP_MANAGEMENT.PRODUCT_INVOICED 
	ADD FOREIGN KEY (InvoiceID) REFERENCES INVOICE(InvoiceID);

ALTER TABLE ISP_MANAGEMENT.PRODUCT_INVOICED 
	ADD FOREIGN KEY (ProductID) REFERENCES PRODUCT(ProductID);

ALTER TABLE ISP_MANAGEMENT.PRODUCT_INVOICED 
	ADD PRIMARY KEY (InvoiceID, ProductID);

CREATE TABLE ISP_MANAGEMENT.SERVICE_INVOICED
(
	InvoiceID			INT		NOT NULL,
	ServiceID			INT		NOT NULL
);

ALTER TABLE ISP_MANAGEMENT.SERVICE_INVOICED 
	ADD FOREIGN KEY (InvoiceID) REFERENCES INVOICE(InvoiceID);

ALTER TABLE ISP_MANAGEMENT.SERVICE_INVOICED 
	ADD FOREIGN KEY (ServiceID) REFERENCES SERVICE(ServiceID);

ALTER TABLE ISP_MANAGEMENT.SERVICE_INVOICED 
	ADD PRIMARY KEY (InvoiceID, ServiceID);

CREATE TABLE ISP_MANAGEMENT.CUSTOMER_PHONE
(
	CustomerID			INT		NOT NULL,
	Cust_Phone			CHAR(10)	NOT NULL
);

ALTER TABLE ISP_MANAGEMENT.CUSTOMER_PHONE 
	ADD FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID);

ALTER TABLE ISP_MANAGEMENT.CUSTOMER_PHONE 
	ADD PRIMARY KEY (CustomerID, Cust_Phone);

CREATE TABLE ISP_MANAGEMENT.DEPARTMENT_LOCATIONS
(
	DepartmentID			INT		NOT NULL,
	Dept_Location			VARCHAR(50)	NOT NULL
);

ALTER TABLE ISP_MANAGEMENT.DEPARTMENT_LOCATIONS
	ADD FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENT(DepartmentID);

ALTER TABLE ISP_MANAGEMENT.DEPARTMENT_LOCATIONS
	ADD PRIMARY KEY (DepartmentID, Dept_Location);

CREATE TABLE ISP_MANAGEMENT.APPLIED_TO
(
	PaymentID			INT		NOT NULL,
	InvoiceID			INT		NOT NULL,
	Pending_Charges			DECIMAL(5,2),
	PRIMARY KEY (PaymentID, InvoiceID)
);

ALTER TABLE ISP_MANAGEMENT.APPLIED_TO
	ADD FOREIGN KEY (PaymentID) REFERENCES PAYMENT(PaymentID);

ALTER TABLE ISP_MANAGEMENT.APPLIED_TO
	ADD FOREIGN KEY (InvoiceID) REFERENCES INVOICE(InvoiceID);
