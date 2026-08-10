import { LightningElement, wire } from 'lwc';
import {
    createRecord,
    getRecord,
    updateRecord,
    deleteRecord
} from 'lightning/uiRecordApi';

import STUDENT_OBJECT from '@salesforce/schema/Student__c';
import NAME_FIELD from '@salesforce/schema/Student__c.Name';
import CGPA_FIELD from '@salesforce/schema/Student__c.CGPA__c';

const FIELDS = [
    NAME_FIELD,
    CGPA_FIELD
];

export default class StudentProfile extends LightningElement {

    studentId = '';
    name = '';
    cgpa = '';
    message = '';

    @wire(getRecord, {
        recordId: '$studentId',
        fields: FIELDS
    })
    wiredStudent({ data, error }) {

        if (data) {

            this.name = data.fields.Name.value;
            this.cgpa = data.fields.CGPA__c.value;

            this.message = 'Student record loaded successfully.';

        } else if (error) {

            this.message =
                error.body?.message || 'Error loading student record.';
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
                error.body?.message || 'Error creating student.';
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
        fields[CGPA_FIELD.fieldApiName] = Number(this.cgpa);

        try {

            await updateRecord({
                fields: fields
            });

            this.message =
                'Student updated successfully.';

        } catch (error) {

            this.message =
                error.body?.message || 'Error updating student.';
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
            this.cgpa = '';

        } catch (error) {

            this.message =
                error.body?.message || 'Error deleting student.';
        }
    }
}