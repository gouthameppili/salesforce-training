# Day 2 - Apex Triggers & Governor Limits

## 🎯 Objective

Design and implement a bulkified Apex Trigger for a Placement Management System using Salesforce best practices.

---

## 📚 Concepts Learned

- Before Trigger vs After Trigger
- Trigger Context Variables
- Trigger Handler Pattern
- Governor Limits
- Bulkification
- Lists
- Sets
- Maps

---

## 🛠️ Business Scenario

Built an Application Trigger to automate the student application process.

Business Rules Implemented

✅ Student CGPA Validation

✅ Duplicate Application Prevention

✅ Last Date Validation

✅ Default Status = Applied

✅ Meaningful Error Messages

---

## 🧠 Architecture

ApplicationTrigger

↓

ApplicationTriggerHandler

---

## Bulkification

Used

- Set<Id>
- Map<Id, Student__c>
- Map<Id, Job__c>

to avoid SOQL inside loops.

---

## Testing

Verified:

- Successful Application
- Low CGPA
- Duplicate Application
- Application after Deadline

---

## 📸 Screenshots

- Successful Insert
- Failed Insert
- Trigger Code
- Debug Logs

---

## 💡 Key Learnings

- Always bulkify Apex.
- Never place SOQL inside loops.
- Keep triggers lightweight.
- Store business logic inside handler classes.

---

## 🚀 Outcome

Built a production-style Trigger following Salesforce best practices.