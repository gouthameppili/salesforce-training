# Day 4 - Lightning Web Components (LWC)

## Objective

Learn the basics of Lightning Web Components and build the first user interface for the Placement Management System.

---

## Topics Covered

- Lightning Web Components (LWC)
- Component Structure
- HTML
- JavaScript
- Meta XML Configuration
- Data Binding
- Event Handling
- Conditional Rendering
- List Rendering
- Component Deployment

---

## Practical Work

Created a **Placement Management Dashboard** using Lightning Web Components.

Implemented the following features:

- Dashboard Title
- Welcome Message
- Dashboard Statistics
- Search Box
- Refresh Button
- Conditional Rendering
- List Rendering
- Display of Mock Job Data

Later connected the dashboard with Apex to display:

- Student Records
- Job Records

using the `@wire` decorator.

---

## Project Structure

LWC Component:

- placementHome.html
- placementHome.js
- placementHome.js-meta.xml

Apex Controller:

- DashboardController.cls

---

## Key Learnings

- Lightning Web Components are used to build modern Salesforce user interfaces.
- HTML defines the component layout.
- JavaScript handles the component logic and events.
- Meta XML controls where a component can be used.
- `@wire` is used to retrieve Salesforce data from Apex.
- Components can be reused across different Lightning pages.

---

## Outcome

Built the first version of the Placement Management Dashboard and learned how to create Lightning Web Components, handle user interactions, and display Salesforce data using Apex.