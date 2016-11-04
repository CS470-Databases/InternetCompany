---
title: |
    CS 470

    Introduction to Database Management Systems

    Fall 2016

    Project Report

    Group 5

    Daniel McNary

    Isaac Jonas
---

Jack Taft

# **Milestone II**![](img/media/image07.png){width="7.447916666666667in" height="8.666666666666666in"}

## 

## 

## 

## 

## 

## 

## 

## 

## 

## 

## 

## 

## 

## 

## 

## 

  -- --
     
     
     
  -- --

## ER Diagram

## 

## Database Architecture

This project will utilize the traditional three-tier client-server
architecture. The database and web server will be stored on a single
virtual machine and connections can be instantiated via an appropriate
web client. Information should be collected via a user interface
(web-based) from employees of the company. The database should then
validate all fields to ensure continuity and proper compatibility.

<span id="_gjdgxs" class="anchor"></span>This project will be
implemented on a LAMP stack on Ubuntu Server 16.04. The database of
choice will be MySQL and the webserver of choice will be Apache with PHP
server side scripting. Users of the database will initialize a
connection via their web browser to the web server, which will then
allow certain queries to be made to the DBMS as appropriate.

![](img/media/image09.png){width="3.2604166666666665in"
height="3.15625in"}

## Data Dependencies

![](img/media/image08.jpg){width="6.955430883639545in"
height="5.961797900262467in"}![](img/media/image11.jpg){width="5.03125in"
height="1.4791666666666667in"}

![](img/media/image10.jpg){width="7.041666666666667in" height="5.25in"}

## DFD

![](img/media/image04.png){width="6.5in" height="4.4375in"}

## Front End Design Ideas

The front end of the database will consist of a webserver running PHP
scripts on the server to customize the HTML code for each pages. The
front end will consist of three major types of pages, detail/data entry,
reporting, and searching. The detail/data pages will show the most
pertinent details on a particular entity, such as a customer or
employee. This page will also allow the user to modify the entry details
and click save to update the database. These pages may include, Customer
Information, Employee Information, Ticket Information, etc. Any error
messages will be displayed at the top of the screen if there was a
problem saving the information. The reporting pages will display items
such as a list of current customers, a list of payments taken during a
specific time period, a list of invoices created by a particular
employee, among others. The last type of screen will allow employees to
query the database on some particular attribute, such as all customers
with last names beginning with the letter ‘X’. Other types of pages or
reporting may be added as appropriate.

## Relational Algebraic Statements

**Following are a list of multiple possible queries that may be made for
reporting or searching purposes: **

Display a list of all of the payments taken between Date1 and Date2:

$$\Pi_{PaymentDate,\ Username,\ ReferenceNumber,\ TotalReceived,\ EmployeeID}(\sigma_{PaymentDate \geq Date1\ AND\ PaymentDate \leq Date2}$$

Display a list of all of the new accounts created between Date1 and
Date2:

$$\Pi_{StartDate,\ Username,\ FirstName,\ LastName}(\sigma_{StartDate \geq Date1\ AND\ StartDate \leq Date2}(\text{Customer}))$$

Display a list of all of the open tickets owned by a particular
employee:

$$\Pi_{Category,\ Date,Problem,\ CustomerID}(\sigma_{Solved = False\ AND\ TicketOwnerID = 123}(\text{TICKET}))$$

Display all of the responses to a particular ticket:

$$\Pi_{EmployeeId,\ TicketID,\ Date,Time,\ Description}(\sigma_{TicketID = 123}$$

Display a list of all quotes created between Date1 and Date2:

$$\Pi_{InvoiceID,\ Customer,IDQuantity,\ LineItem,\ Subtotal,\ SalexTax,Total}(\sigma_{Date \geq Date1\ AND\ Date \leq Date2\ AND\ QuoteFlag = True}$$

Display a list of all unpaid invoices:

$$\Pi_{InvoiceID,Total,\ TotalReceived,\ First,Last,\ BillingAddress,Email,Username,\ Date}(\sigma_{TotalReceived < Total}$$

$$(\text{INVOICE}) \bowtie_{\text{InvoiceID}}(PAYMENT) \bowtie_{\text{CustomerID}}(CUSTOMER))$$

Display a list of all employees who work for a particular department:

$$\Pi_{EmployeeID,\ FirstName,LastName,\ SSN,DOB,Email,Address,PhoneNumber,Role,Salary}(\sigma_{DepartmentID = 123}(\text{Employee}))$$
