import { LightningElement, wire } from 'lwc';

import {
    createRecord,
    getRecord,
    updateRecord,
    deleteRecord
} from 'lightning/uiRecordApi';

import STUDENT_OBJECT from '@salesforce/schema/Student__c';

import NAME_FIELD from '@salesforce/schema/Student__c.Name';
import EMAIL_FIELD from '@salesforce/schema/Student__c.Email__c';
import BRANCH_FIELD from '@salesforce/schema/Student__c.Branch__c';
import CGPA_FIELD from '@salesforce/schema/Student__c.CGPA__c';

const FIELDS = [
    NAME_FIELD,
    EMAIL_FIELD,
    BRANCH_FIELD,
    CGPA_FIELD
];

export default class StudentProfile extends LightningElement {

    studentId = '';
    name = '';
    email = '';
    branch = '';
    cgpa = '';
    message = '';

    @wire(getRecord, {
        recordId: '$studentId',
        fields: FIELDS
    })
    wiredStudent({ data, error }) {

        if (data) {

            this.name = data.fields.Name.value;
            this.email = data.fields.Email__c.value;
            this.branch = data.fields.Branch__c.value;
            this.cgpa = data.fields.CGPA__c.value;

            this.message =
                'Student record loaded successfully.';

        } else if (error) {

            this.message =
                error.body?.message ||
                'Error loading student record.';
        }
    }

    handleChange(event) {

        const field = event.target.dataset.field;

        this[field] = event.target.value;
    }

    handleStudentIdChange(event) {

        this.studentId = event.target.value;

        this.message = '';
    }

    async handleCreate() {

        const fields = {};

        fields[NAME_FIELD.fieldApiName] = this.name;
        fields[EMAIL_FIELD.fieldApiName] = this.email;
        fields[BRANCH_FIELD.fieldApiName] = this.branch;
        fields[CGPA_FIELD.fieldApiName] = Number(this.cgpa);

        const recordInput = {
            apiName: STUDENT_OBJECT.objectApiName,
            fields: fields
        };

        try {

            const result = await createRecord(recordInput);

            this.studentId = result.id;

            this.message =
                'Student created successfully.';

        } catch (error) {

            this.message =
                error.body?.message ||
                'Error creating student.';
        }
    }

    async handleUpdate() {

        if (!this.studentId) {

            this.message =
                'Enter a Student Id first.';

            return;
        }

        const fields = {};

        fields.Id = this.studentId;
        fields[NAME_FIELD.fieldApiName] = this.name;
        fields[EMAIL_FIELD.fieldApiName] = this.email;
        fields[BRANCH_FIELD.fieldApiName] = this.branch;
        fields[CGPA_FIELD.fieldApiName] = Number(this.cgpa);

        try {

            await updateRecord({
                fields: fields
            });

            this.message =
                'Student updated successfully.';

        } catch (error) {

            this.message =
                error.body?.message ||
                'Error updating student.';
        }
    }

    async handleDelete() {

        if (!this.studentId) {

            this.message =
                'Enter a Student Id first.';

            return;
        }

        try {

            await deleteRecord(this.studentId);

            this.message =
                'Student deleted successfully.';

            this.studentId = '';
            this.name = '';
            this.email = '';
            this.branch = '';
            this.cgpa = '';

        } catch (error) {

            this.message =
                error.body?.message ||
                'Error deleting student.';
        }
    }
}