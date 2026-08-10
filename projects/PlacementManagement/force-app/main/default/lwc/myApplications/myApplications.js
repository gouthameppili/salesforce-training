import { LightningElement, wire } from 'lwc';

import getStudents from '@salesforce/apex/DashboardController.getStudents';
import getMyApplications from '@salesforce/apex/DashboardController.getMyApplications';

export default class MyApplications extends LightningElement {

    students = [];
    applications = [];

    selectedStudentId;

    isLoading = false;
    errorMessage = '';

    @wire(getStudents)
    wiredStudents({ data, error }) {

        if (data) {

            this.students = data;

        } else if (error) {

            console.error('Student Error:', error);

            this.errorMessage =
                'Unable to load students.';
        }
    }

    @wire(getMyApplications, {
        studentId: '$selectedStudentId'
    })
    wiredApplications({ data, error }) {

        if (!this.selectedStudentId) {

            this.applications = [];
            this.isLoading = false;

            return;
        }

        this.isLoading = true;

        if (data) {

            this.applications = data;

            this.errorMessage = '';
            this.isLoading = false;

            console.log(
                'Applications:',
                data
            );

        } else if (error) {

            console.error(
                'Application Error:',
                error
            );

            this.applications = [];

            this.errorMessage =
                error.body?.message ||
                'Unable to load applications.';

            this.isLoading = false;
        }
    }

    get studentOptions() {

        return this.students.map(student => {

            return {
                label: `${student.Name} - CGPA: ${student.CGPA__c}`,
                value: student.Id
            };

        });
    }

    get hasApplications() {

        return this.applications &&
               this.applications.length > 0;
    }

    handleStudentChange(event) {

        this.selectedStudentId =
            event.detail.value;
    }
}