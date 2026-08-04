# Day 6 - SOQL, DML & Apex Controller Integration

## 🎯 Objective

Learn how Salesforce retrieves, validates, and stores business data using SOQL, DML, Apex Controllers, and Lightning Web Components.

---

## 📚 Concepts Learned

- SOQL (Salesforce Object Query Language)
- DML (Data Manipulation Language)
- Apex Controller
- @AuraEnabled
- @wire
- Data Retrieval from Salesforce
- Business Validation
- CRUD Operations
- Client-Server Architecture

---

## 🏗️ Architecture

Lightning Web Component

↓

DashboardController

↓

ApplicationService

↓

SOQL

↓

Salesforce Database

---

## 🛠️ Features Implemented

### DashboardController.cls

Created an Apex Controller to expose Salesforce data to Lightning Web Components.

Methods Implemented:

- getStudents()
- getJobs()

---

### Lightning Web Component

Connected LWC with Apex using:

- @wire
- @AuraEnabled(cacheable=true)

Displayed real-time:

- Student Records
- Job Records

instead of mock data.

---

### ApplicationService

Implemented business operations:

- Retrieve Student
- Retrieve Job
- Validate CGPA
- Check Application Deadline
- Prevent Duplicate Applications
- Create Application Record
- Update Application Status
- Return Meaningful Success/Error Messages

---

## 💻 Apex Concepts Practiced

### SOQL

- Retrieve Student records
- Retrieve Job records
- Retrieve existing Applications

### DML

- insert
- update

### Business Logic Flow

Retrieve Data

↓

Validate Business Rules

↓

Perform DML

↓

Return Response

---

## 🧠 Key Learnings

- SOQL is used to retrieve Salesforce data.
- DML is used to create and modify Salesforce records.
- LWC cannot directly access the database.
- Apex Controller acts as the bridge between LWC and Salesforce.
- Business validations should always happen before DML operations.
- Query only the fields required for the business requirement.

---

## 📂 Project Implementation

Relevant Files

- classes/DashboardController.cls
- classes/ApplicationService.cls
- lwc/placementHome/*
- objects/Application__c
- objects/Student__c
- objects/Job__c

---

## 🚀 Outcome

Successfully integrated Lightning Web Components with Apex Controllers to retrieve live Salesforce data using SOQL and implemented business operations using DML and Service Layer architecture.