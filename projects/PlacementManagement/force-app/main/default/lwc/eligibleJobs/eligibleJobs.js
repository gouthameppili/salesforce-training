import { LightningElement, wire } from 'lwc';
import getJobs from '@salesforce/apex/DashboardController.getJobs';
import submitApplication from '@salesforce/apex/DashboardController.submitApplication';

export default class EligibleJobs extends LightningElement {

    jobs;
    selectedJobId;

    applicationMessage;
    isApplying = false;

    connectedCallback() {
        console.log('Eligible Jobs component connected');
    }

    renderedCallback() {
        console.log('Eligible Jobs component rendered');
    }

    @wire(getJobs)
    wiredJobs({ data, error }) {

        if (data) {

            this.jobs = data;

            console.log('Jobs from Salesforce:', data);

        } else if (error) {

            console.error('Error loading jobs:', error);

        }

    }

    handleViewDetails(event) {

        this.selectedJobId = event.currentTarget.dataset.id;

        console.log('Selected Job Id:', this.selectedJobId);

    }

    async handleApply(event) {

        const jobId = event.detail;

        const studentId = 'a04hg000000Bs3VAAS';

        this.isApplying = true;
        this.applicationMessage = '';

        try {

            const result = await submitApplication({
                studentId: studentId,
                jobId: jobId
            });

            this.applicationMessage = result;

            console.log('Application Result:', result);

        } catch (error) {

            this.applicationMessage =
                'Something went wrong while submitting the application.';

            console.error('Application Error:', error);

        } finally {

            this.isApplying = false;

        }

    }

}