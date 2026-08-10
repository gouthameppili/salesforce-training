# Day 9 - Asynchronous Apex

## Objective

Learn how to execute long-running operations in the background using Salesforce Asynchronous Apex and understand when to use different asynchronous processing techniques.

---

## Concepts Learned

- Synchronous vs Asynchronous Processing
- Queueable Apex
- QueueableContext
- Future Methods
- Queueable Chaining
- Batch Apex
- Apex Jobs
- Execute Anonymous

---

## Implementation

### Queueable Apex

Created `ApplicationPostProcessingJob` to perform background processing after an application is shortlisted.

Learned how to:

- Implement the `Queueable` interface
- Use `System.enqueueJob()`
- Monitor Queueable jobs from Apex Jobs

---

### Future Method

Created `NotificationService` with a `@future` method to simulate sending notifications asynchronously.

Compared Future Methods with Queueable Apex and understood when each approach is suitable.

---

### Queueable Chaining

Created `ExternalSyncJob` and chained it from `ApplicationPostProcessingJob` using `System.enqueueJob()`.

This demonstrated how one background job can start another after completing its work.

---

### Batch Apex

Created `CloseExpiredJobsBatch` using the `Database.Batchable` interface.

Implemented:

- `start()`
- `execute()`
- `finish()`

Executed the batch using Execute Anonymous and verified its execution through Apex Jobs.

---

## Files Added

- `ApplicationPostProcessingJob.cls`
- `NotificationService.cls`
- `ExternalSyncJob.cls`
- `CloseExpiredJobsBatch.cls`

---

## Key Learnings

- Not every task needs to finish before responding to the user.
- Queueable Apex is useful for background processing and supports job chaining.
- Future Methods provide a simple way to execute asynchronous tasks.
- Batch Apex is designed to process large volumes of records efficiently.
- Salesforce automatically manages the execution of asynchronous jobs after they are submitted.

---

## Outcome

Implemented different asynchronous Apex patterns in the Placement Management System and learned how Salesforce processes background jobs using Queueable Apex, Future Methods, Queueable Chaining, and Batch Apex.