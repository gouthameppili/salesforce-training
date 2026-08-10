import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';

import getStudents from '@salesforce/apex/DashboardController.getStudents';
import getJobs from '@salesforce/apex/DashboardController.getJobs';
import submitApplication from '@salesforce/apex/DashboardController.submitApplication';

export default class EligibleJobs extends LightningElement {

    students = [];
    jobs = [];

    selectedStudentId;
    selectedJobId;

    applicationMessage = '';

    isLoading = false;
    isSaving = false;
    errorMessage = '';

    wiredJobsResult;

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

    @wire(getJobs, { studentId: '$selectedStudentId' })
    wiredJobs(result) {

        this.wiredJobsResult = result;

        if (!this.selectedStudentId) {

            this.jobs = [];
            this.isLoading = false;

            return;
        }

        this.isLoading = true;

        if (result.data) {

            this.jobs = result.data;
            this.errorMessage = '';
            this.isLoading = false;

        } else if (result.error) {

            console.error('Job Error:', result.error);

            this.jobs = [];

            this.errorMessage =
                result.error.body?.message ||
                'Unable to load eligible jobs.';

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

    get hasJobs() {

        return this.jobs &&
               this.jobs.length > 0;
    }

    handleStudentChange(event) {

        this.selectedStudentId =
            event.detail.value;

        this.applicationMessage = '';
        this.selectedJobId = '';

        console.log(
            'Selected Student:',
            this.selectedStudentId
        );
    }

    async handleApply(event) {

        const jobId = event.detail;

        this.selectedJobId = jobId;

        this.applicationMessage = '';

        if (!this.selectedStudentId) {

            this.applicationMessage =
                'Please select a student before applying.';

            return;
        }

        this.isSaving = true;

        try {

            const result =
                await submitApplication({

                    studentId:
                        this.selectedStudentId,

                    jobId:
                        jobId

                });

            this.applicationMessage = result;

            await refreshApex(
                this.wiredJobsResult
            );

        } catch (error) {

            console.error(
                'Application Error:',
                error
            );

            this.applicationMessage =
                error.body?.message ||
                'An error occurred while submitting the application.';

        } finally {

            this.isSaving = false;
        }
    }
}