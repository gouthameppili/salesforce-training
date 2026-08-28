import { LightningElement, wire } from 'lwc';

import getStudents from '@salesforce/apex/DashboardController.getStudents';
import getDashboardJobs from '@salesforce/apex/DashboardController.getDashboardJobs';
import getDashboardStats from '@salesforce/apex/DashboardController.getDashboardStats';

import { refreshApex } from '@salesforce/apex';

export default class PlacementHome extends LightningElement {

    students = [];
    jobs = [];

    companyCount = 0;
    jobCount = 0;
    applicationCount = 0;

    searchJob = '';

    studentsResult;
    jobsResult;
    statsResult;


    dashboardTitle = 'Placement Management Dashboard';

    welcomeMessage = 'Welcome Goutham 👋';


    /*
     * Get students from Salesforce.
     */
    @wire(getStudents)
    wiredStudents(result) {

        this.studentsResult = result;

        const { data, error } = result;

        if (data) {
            this.students = data;
        } else if (error) {
            console.error('Student loading error:', error);
        }
    }


    /*
     * Get dashboard jobs from Salesforce.
     */
    @wire(getDashboardJobs)
    wiredJobs(result) {

        this.jobsResult = result;

        const { data, error } = result;

        if (data) {
            this.jobs = data;
        } else if (error) {
            console.error('Job loading error:', error);
        }
    }


    /*
     * Get dashboard statistics from Salesforce.
     */
    @wire(getDashboardStats)
    wiredStats(result) {

        this.statsResult = result;

        const { data, error } = result;

        if (data) {

            this.companyCount = data.companyCount;
            this.jobCount = data.jobCount;
            this.applicationCount = data.applicationCount;

        } else if (error) {

            console.error('Dashboard statistics error:', error);
        }
    }


    /*
     * Filter jobs based on the search text.
     */
    get filteredJobs() {

        if (!this.searchJob) {
            return this.jobs;
        }

        const searchTerm = this.searchJob.toLowerCase();

        return this.jobs.filter(job => {

            const jobName = job.Name
                ? job.Name.toLowerCase()
                : '';

            const companyName = job.Company__c
                ? job.Company__c.toLowerCase()
                : '';

            return (
                jobName.includes(searchTerm) ||
                companyName.includes(searchTerm)
            );
        });
    }


    /*
     * Whether jobs are available.
     */
    get hasJobs() {
        return this.filteredJobs.length > 0;
    }


    /*
     * Refresh actual Salesforce data.
     */
    async handleRefresh() {

        try {

            await Promise.all([
                refreshApex(this.studentsResult),
                refreshApex(this.jobsResult),
                refreshApex(this.statsResult)
            ]);

        } catch (error) {

            console.error('Dashboard refresh error:', error);
        }
    }


    /*
     * Update search text.
     */
    handleSearch(event) {

        this.searchJob = event.target.value;
    }
}